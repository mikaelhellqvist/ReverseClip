// Please contact me if you use this code. Would be glad to know if it has helped you anything :)
// mikaelhellqvist@gmail.com
// Thanks,
// Mikael Hellqvist

#import "RCComposer.h"
#import "RCToolbox.h"

@implementation RCComposer

@synthesize composition = _composition;

-(id) init {
    if((self = [super init])){
        self.composition = [[AVMutableComposition alloc] init];
        [self emptyComposition];
    }
    return self;
}

- (void) emptyComposition {
    
    for (AVCompositionTrack *track in self.composition.tracks) {
        [self.composition removeTrack:track];
    }
    
     compositionVideoTrack = [self.composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];

}


// FIXME: Fix the inSeconds and outSeconds
-(void) addToCompositionWithAsset:(AVURLAsset*)_asset 
                   timeRangeSpeed:(int)speed
                        inSeconds:(Float64)inSec
                       outSeconds:(Float64)outSec
               isForImageSequence:(BOOL)isTempForImageSequence
                            speed:(int)_speed{
    
    
    NSError *editError = nil;
    AVURLAsset* sourceAsset = _asset;
        
    Float64 inSeconds = inSec;
    Float64 outSeconds = outSec;
    
    CMTime inTime = CMTimeMakeWithSeconds(inSeconds, 600);
    CMTime outTime = CMTimeMakeWithSeconds(outSeconds, 600);
    CMTime duration = CMTimeSubtract(outTime, inTime);
    CMTimeRange editRange = CMTimeRangeMake(inTime, duration);
    
    AVAssetTrack *clipVideoTrack = [[sourceAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]; ///***
    
    CGSize videoSize = [clipVideoTrack naturalSize];
    self.composition.naturalSize = videoSize;

    [compositionVideoTrack insertTimeRange:editRange ofTrack:clipVideoTrack atTime:self.composition.duration error:&editError];
    
    CMTime scaleOutTime;
    
    switch (speed) {
        
        case kTimeRangeNormal:
            scaleOutTime = CMTimeMakeWithSeconds(outSeconds, 600);       
            break;

        case kTimeRangeSlowMotion:
            scaleOutTime = CMTimeMakeWithSeconds(outSeconds*2, 600);
            break;
            
        case kTimeRangeSpeedUp:
            scaleOutTime = CMTimeMakeWithSeconds(outSeconds/2, 600);
            break;
            
    }
    
    if (!editError) {
        CMTimeGetSeconds (self.composition.duration);

        NSLog(@"SourceAsset Duration: %f",CMTimeGetSeconds([sourceAsset duration]));
        NSLog(@"Composition Duration: %f",CMTimeGetSeconds(self.composition.duration));
        
        if (isTempForImageSequence) {
            
            RCExporter *exporterTool = [[RCToolbox sharedToolbox] exporterTool];
            [exporterTool exportCompositionWithAsset:(AVURLAsset*)self.composition exportName:@"imageSequence_normal.mov" isForImageSequence:isTempForImageSequence];
        }
        
    }
    
}


@end
