// Please contact me if you use this code. Would be glad to know if it has helped you anything :)
// mikaelhellqvist@gmail.com
// Thanks,
// Mikael Hellqvist

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

#import "Enums.h"

@interface RCComposer : NSObject {

    AVMutableComposition *composition;
    AVMutableCompositionTrack *compositionVideoTrack;
    
}

@property (nonatomic, retain) AVMutableComposition *composition;

-(void) addToCompositionWithAsset:(AVURLAsset*)_asset 
                   timeRangeSpeed:(int)speed
                        inSeconds:(Float64)inSec
                       outSeconds:(Float64)outSec
               isForImageSequence:(BOOL)isTempForImageSequence
                            speed:(int)_speed;

@end
