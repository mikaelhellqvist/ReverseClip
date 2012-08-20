// Please contact me if you use this code. Would be glad to know if it has helped you anything :)
// mikaelhellqvist@gmail.com
// Thanks,
// Mikael Hellqvist

#import "RCImageSequencer.h"
#import <CoreMedia/CoreMedia.h>
#import "RCToolbox.h"

#define FRAME_WIDTH 640
#define FRAME_HEIGHT 480
#define FRAMES_PER_SEC 25
#define FRAME_SCALE 600
#define OUTPUT_FILE_NAME @"imageSequence_reverse.mov"

@implementation RCImageSequencer

@synthesize imageGenerator;
@synthesize delegate = _delegate;

-(id) init {
    if((self = [super init])){
        
        incrementTime = (Float64)1/FRAMES_PER_SEC;
        fakeTimeElapsed = 0.0;
        
    }
    
    return self;
}

- (void)createImageSequenceWithAsset:(AVURLAsset *)asset toFileName:(NSString *)fileName {

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancel:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    currentFileName = [NSString stringWithString:fileName];
    
    [self createImageSequenceWithAsset:asset];
    
}

-(void) createImageSequenceWithAsset:(AVURLAsset*)asset {

    percentageDone = 0;
    fakeTimeElapsed = 0.0;
    imageSequence = [[NSMutableArray alloc] init];
    
    AVURLAsset *myAsset = asset;
    
    self.imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:myAsset];
    imageGenerator.maximumSize = CGSizeMake(FRAME_WIDTH, FRAME_HEIGHT);
    Float64 durationSeconds = CMTimeGetSeconds([myAsset duration]);
    
    Float64 clipTime = incrementTime;
    NSMutableArray *times = [[NSMutableArray alloc] init];
    
    while(clipTime < durationSeconds) {
    
        CMTime frameTime = CMTimeMakeWithSeconds(durationSeconds - clipTime, FRAME_SCALE);
        NSValue *frameTimeValue = [NSValue valueWithCMTime:frameTime];
        
        [times addObject:frameTimeValue];
        
        clipTime += incrementTime;
    };
    
    NSLog(@"Frames to capture, %i", [times count]);
    
    //imageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    [imageGenerator generateCGImagesAsynchronouslyForTimes:times
                                         completionHandler:^(CMTime requestedTime, CGImageRef image, CMTime actualTime,
                                                             AVAssetImageGeneratorResult result, NSError *error) {
                                             
                                             NSString *requestedTimeString = (__bridge NSString *)CMTimeCopyDescription(NULL, requestedTime);
                                             NSString *actualTimeString = (__bridge NSString *)CMTimeCopyDescription(NULL, actualTime);
   
                                             
                                             if (result == AVAssetImageGeneratorSucceeded) {
                                                 [imageSequence addObject:(__bridge id)image];
                                                 
                                                 percentageDone = ((Float32)[imageSequence count] / (Float32)[times count])*100;
                                                 if(delegate != nil)
                                                     if([delegate respondsToSelector:@selector(imageSequencerProgress:)])
                                                         [delegate imageSequencerProgress:percentageDone];
                                                 
                                                 NSLog(@"Percentage done: %f",percentageDone);
                                                 
                                                 if ([imageSequence count] == [times count]) {
                                                     [self startWritingTheSamples];
                                                 }
                                             }
                                             
                                             if (result == AVAssetImageGeneratorFailed) {
                                                 NSLog(@"Image Capture %i of %i Failed with error: %@", [imageSequence count], [times count],[error localizedFailureReason]);
                                             }
                                             if (result == AVAssetImageGeneratorCancelled) {
                                                 NSLog(@"Canceled");
                                             }
                                         }];
}

-(void)cancel:(NSNotification*)notification
{
    [imageGenerator cancelAllCGImageGeneration];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}

-(void) startWritingTheSamples {
    
    [self startRecording];
    
    int added = 0;
    for (id image in imageSequence){
        [self writeSample:(CGImageRef)image];
        added++;
        percentageDone = .8f + .2f * ((Float32)added / (Float32)[imageSequence count]);
    }
    
    [self stopRecording];
    
}

-(void) writeSample: (CGImageRef)image {
    
    if (assetWriterInput.readyForMoreMediaData) {
        
		// prepare the pixel buffer
		CVPixelBufferRef pixelBuffer = NULL;
		CFDataRef imageData = CGDataProviderCopyData(CGImageGetDataProvider(image));

		CVPixelBufferCreateWithBytes(kCFAllocatorDefault,
                                     FRAME_WIDTH,
                                     FRAME_HEIGHT,
                                     kCVPixelFormatType_32BGRA,
                                     (void*)CFDataGetBytePtr(imageData),
                                     CGImageGetBytesPerRow(image),
                                     NULL,
                                     NULL,
                                     NULL,
                                     &pixelBuffer);
        
		// calculate the time
		CFTimeInterval elapsedTime = fakeTimeElapsed;
		CMTime presentationTime =  CMTimeMake (elapsedTime * FRAME_SCALE, FRAME_SCALE);

		// write the sample
		BOOL appended = [assetWriterPixelBufferAdaptor appendPixelBuffer:pixelBuffer withPresentationTime:presentationTime];
        
        CFRelease(imageData);
        CVPixelBufferRelease(pixelBuffer);
        
        fakeTimeElapsed += incrementTime;
		if (appended) {
            [delegate imageSequencerProgress:percentageDone];
		}
	}
}


// Asset recorder
-(void) startRecording {
    RCFileHandler *fileHandler = [[RCToolbox sharedToolbox] fileHandler];
    
    currentFileName = !currentFileName ? OUTPUT_FILE_NAME : currentFileName;
	NSString *moviePath = [[fileHandler pathToDocumentsDirectory] stringByAppendingPathComponent:currentFileName];
	if ([[NSFileManager defaultManager] fileExistsAtPath:moviePath]) {
		[[NSFileManager defaultManager] removeItemAtPath:moviePath error:nil];
	}
	
    
	NSURL *movieURL = [NSURL fileURLWithPath:moviePath];
	NSError *movieError = nil;

	assetWriter = [[AVAssetWriter alloc] initWithURL:movieURL
                                            fileType: AVFileTypeQuickTimeMovie
                                               error: &movieError];
	NSDictionary *assetWriterInputSettings = [NSDictionary dictionaryWithObjectsAndKeys:
											  AVVideoCodecH264, AVVideoCodecKey,
											  [NSNumber numberWithInt:FRAME_WIDTH], AVVideoWidthKey,
											  [NSNumber numberWithInt:FRAME_HEIGHT], AVVideoHeightKey,
											  nil];
	assetWriterInput = [AVAssetWriterInput assetWriterInputWithMediaType: AVMediaTypeVideo
														  outputSettings:assetWriterInputSettings];
	assetWriterInput.expectsMediaDataInRealTime = YES;
	[assetWriter addInput:assetWriterInput];
	

	assetWriterPixelBufferAdaptor = [[AVAssetWriterInputPixelBufferAdaptor  alloc]
									 initWithAssetWriterInput:assetWriterInput
									 sourcePixelBufferAttributes:nil];
	[assetWriter startWriting];
	
	firstFrameWallClockTime = CFAbsoluteTimeGetCurrent();
	[assetWriter startSessionAtSourceTime: CMTimeMake(0, FRAME_SCALE)];
	
}

-(void) stopRecording {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
	[assetWriter finishWriting];
    
    assetWriter = nil;
    imageSequence = nil;
    
    if(delegate && [delegate respondsToSelector:@selector(exportedImageSequenceToFileName:)]) {
        [delegate imageSequencerProgress:1.0f];
        [delegate exportedImageSequenceToFileName:currentFileName];
    }
    
    currentFileName = nil;

}

@end
