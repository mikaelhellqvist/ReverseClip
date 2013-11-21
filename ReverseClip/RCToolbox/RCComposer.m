// Please contact me if you use this code. Would be glad to know if it has helped you anything :)
// mikaelhellqvist@gmail.com
// Thanks,
// Mikael Hellqvist

#import "RCComposer.h"
#import "RCToolbox.h"

@interface RCComposer ()

@property AVMutableCompositionTrack *compositionVideoTrack;
@end

@implementation RCComposer

- (id)init
{
    self = [super init];
    if (self) {
        _composition = [[AVMutableComposition alloc] init];
        [self emptyComposition];
    }
    return self;
}

- (void) emptyComposition
{
    for (AVCompositionTrack *track in self.composition.tracks) {
        [self.composition removeTrack:track];
    }
     _compositionVideoTrack = [self.composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
}

-(void) addToCompositionWithAsset:(AVURLAsset*)urlAsset
                        inSeconds:(Float64)inSec
                       outSeconds:(Float64)outSec
               shouldBeReversed:(BOOL)shouldBeReversed
{
    
    NSError *editError = nil;
    AVURLAsset* sourceAsset = urlAsset;
        
    Float64 inSeconds = inSec;
    Float64 outSeconds = outSec;
    
    CMTime inTime = CMTimeMakeWithSeconds(inSeconds, 600);
    CMTime outTime = CMTimeMakeWithSeconds(outSeconds, 600);
    CMTime duration = CMTimeSubtract(outTime, inTime);
    CMTimeRange editRange = CMTimeRangeMake(inTime, duration);
    
    AVAssetTrack *clipVideoTrack = [[sourceAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    
    CGSize videoSize = [clipVideoTrack naturalSize];
    self.composition.naturalSize = videoSize;

    [_compositionVideoTrack insertTimeRange:editRange ofTrack:clipVideoTrack atTime:self.composition.duration error:&editError];
    
    if (!editError) {
        CMTimeGetSeconds (self.composition.duration);

        if (shouldBeReversed) {
            RCExporter *exporterTool = [[RCToolbox sharedToolbox] exporterTool];
            [exporterTool exportCompositionWithAsset:(AVURLAsset*)self.composition exportName:@"imageSequence_normal.mov" shouldBeReversed:shouldBeReversed];
        }
    }
}


@end
