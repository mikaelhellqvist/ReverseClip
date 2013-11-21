// Please contact me if you use this code. Would be glad to know if it has helped you anything :)
// mikaelhellqvist@gmail.com
// Thanks,
// Mikael Hellqvist

#import "RCImageSequencer.h"
#import <CoreMedia/CoreMedia.h>
#import "RCToolbox.h"

#define FRAME_WIDTH 640
#define FRAME_HEIGHT 360
#define FRAMES_PER_SEC 25
#define FRAME_SCALE 600

@interface RCImageSequencer ()
@property AVAssetImageGenerator *imageGenerator;
@property AVAssetWriter *assetWriter;
@property AVAssetWriterInput *assetWriterInput;
@property AVAssetWriterInputPixelBufferAdaptor *assetWriterPixelBufferAdaptor;
@property CFAbsoluteTime firstFrameWallClockTime;
@property BOOL firstImageSent;
@property float percentageDone;
@property NSMutableArray *imageSequence;
@property Float64 fakeTimeElapsed;
@property Float64 incrementTime;
@property NSString *currentFileName;
@end

@implementation RCImageSequencer

- (id)init
{
    self = [super init];
    if (self) {
        _incrementTime = (Float64)1/FRAMES_PER_SEC;
        _fakeTimeElapsed = 0.0;
    }
    return self;
}

-(void) createImageSequenceWithAsset:(AVURLAsset*)urlAsset {

    _percentageDone = 0;
    _fakeTimeElapsed = 0.0;
    _imageSequence = [[NSMutableArray alloc] init];
    
    AVURLAsset *myAsset = urlAsset;
    
    self.imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:myAsset];
    _imageGenerator.maximumSize = CGSizeMake(FRAME_WIDTH, FRAME_HEIGHT);
    Float64 durationSeconds = CMTimeGetSeconds([myAsset duration]);
    
    Float64 clipTime = _incrementTime;
    NSMutableArray *times = [[NSMutableArray alloc] init];
    
    while(clipTime < durationSeconds) {
        CMTime frameTime = CMTimeMakeWithSeconds(durationSeconds - clipTime, FRAME_SCALE);
        NSValue *frameTimeValue = [NSValue valueWithCMTime:frameTime];
        
        [times addObject:frameTimeValue];
        
        clipTime += _incrementTime;
    };

    [_imageGenerator generateCGImagesAsynchronouslyForTimes:times
                                         completionHandler:^(CMTime requestedTime, CGImageRef image, CMTime actualTime,
                                                             AVAssetImageGeneratorResult result, NSError *error) {
                                             
                                             if (result == AVAssetImageGeneratorSucceeded) {
                                                 [_imageSequence addObject:(__bridge id)image];
                                                 
                                                 _percentageDone = ((Float32)[_imageSequence count] / (Float32)[times count])*100;

                                                 if([_delegate respondsToSelector:@selector(imageSequencerProgress:)]){
                                                     [_delegate imageSequencerProgress:_percentageDone];
                                                 }

                                                 if ([_imageSequence count] == [times count]) {
                                                     [self startWritingTheSamples];
                                                 }
                                             }
                                             
                                             if (result == AVAssetImageGeneratorFailed) {
                                                 NSLog(@"Image Capture %i of %i Failed with error: %@", [_imageSequence count], [times count],[error localizedFailureReason]);
                                             }
                                             if (result == AVAssetImageGeneratorCancelled) {
                                                 NSLog(@"Canceled");
                                             }
                                         }];
}

-(void)cancel:(NSNotification*)notification
{
    [_imageGenerator cancelAllCGImageGeneration];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}

-(void) startWritingTheSamples {
    
    [self startRecording];
    
    int added = 0;
    for (id image in _imageSequence){
        [self writeSample:(CGImageRef)image];
        added++;
        _percentageDone = .8f + .2f * ((Float32)added / (Float32)[_imageSequence count]);
    }
    
    [self stopRecording];
    
}

-(void) writeSample: (CGImageRef)image {
    
    if (_assetWriterInput.readyForMoreMediaData) {
        
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
		CFTimeInterval elapsedTime = _fakeTimeElapsed;
		CMTime presentationTime =  CMTimeMake (elapsedTime * FRAME_SCALE, FRAME_SCALE);

		// write the sample
		BOOL appended = [_assetWriterPixelBufferAdaptor appendPixelBuffer:pixelBuffer withPresentationTime:presentationTime];
        
        CFRelease(imageData);
        CVPixelBufferRelease(pixelBuffer);
        
        _fakeTimeElapsed += _incrementTime;
		if (appended) {
            [_delegate imageSequencerProgress:_percentageDone];
		}
	}
}


// Asset recorder
-(void) startRecording {
    RCFileHandler *fileHandler = [[RCToolbox sharedToolbox] fileHandler];
    
    _currentFileName = !_currentFileName ? k_exportedSequenceName : _currentFileName;
	NSString *moviePath = [[fileHandler pathToDocumentsDirectory] stringByAppendingPathComponent:_currentFileName];
	if ([[NSFileManager defaultManager] fileExistsAtPath:moviePath]) {
		[[NSFileManager defaultManager] removeItemAtPath:moviePath error:nil];
	}
	
    
	NSURL *movieURL = [NSURL fileURLWithPath:moviePath];
	NSError *movieError = nil;

	_assetWriter = [[AVAssetWriter alloc] initWithURL:movieURL
                                            fileType: AVFileTypeQuickTimeMovie
                                               error: &movieError];
    
	NSDictionary *assetWriterInputSettings = [NSDictionary dictionaryWithObjectsAndKeys:
											  AVVideoCodecH264, AVVideoCodecKey,
											  [NSNumber numberWithInt:FRAME_WIDTH], AVVideoWidthKey,
											  [NSNumber numberWithInt:FRAME_HEIGHT], AVVideoHeightKey,
											  nil];
    
	_assetWriterInput = [AVAssetWriterInput assetWriterInputWithMediaType: AVMediaTypeVideo outputSettings:assetWriterInputSettings];
	_assetWriterInput.expectsMediaDataInRealTime = YES;
	[_assetWriter addInput:_assetWriterInput];

	_assetWriterPixelBufferAdaptor = [[AVAssetWriterInputPixelBufferAdaptor alloc] initWithAssetWriterInput:_assetWriterInput sourcePixelBufferAttributes:nil];
	[_assetWriter startWriting];
	
	_firstFrameWallClockTime = CFAbsoluteTimeGetCurrent();
	[_assetWriter startSessionAtSourceTime: CMTimeMake(0, FRAME_SCALE)];
	
}

-(void) stopRecording {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
	[_assetWriter finishWriting];
    
    _assetWriter = nil;
    _imageSequence = nil;
    
    if(_delegate && [_delegate respondsToSelector:@selector(exportedImageSequenceToFileName:)]) {
        [_delegate imageSequencerProgress:1.0f];
        [_delegate exportedImageSequenceToFileName:_currentFileName];
    }
    
    _currentFileName = nil;
}

@end
