

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@protocol ImageSequencerDelegate <NSObject>

- (void)exportedImageSequenceToFileName:(NSString *)fileName;
- (void)imageSequencerProgress:(Float64)percentage;

@end

@interface RCImageSequencer : NSObject {
    
    AVAssetImageGenerator *imageGenerator;
    AVAssetWriter *assetWriter;
	AVAssetWriterInput *assetWriterInput;
	AVAssetWriterInputPixelBufferAdaptor *assetWriterPixelBufferAdaptor;
    CFAbsoluteTime firstFrameWallClockTime;
    BOOL firstImageSent;
    float percentageDone;
    
    NSMutableArray *imageSequence;
    Float64 fakeTimeElapsed;
    Float64 incrementTime;
    
    id <ImageSequencerDelegate> delegate;
    
    NSString *currentFileName;
    
}

@property (unsafe_unretained) id <ImageSequencerDelegate> delegate;

@property (retain) AVAssetImageGenerator *imageGenerator;

// Sequence //
- (void)createImageSequenceWithAsset:(AVURLAsset*)_asset;
- (void)createImageSequenceWithAsset:(AVURLAsset *)asset toFileName:(NSString *)fileName;
- (void)startWritingTheSamples;
- (void)writeSample:(CGImageRef)image;
- (void)startRecording;
- (void)stopRecording;
-(void)cancel:(NSNotification*)notification;

@end
