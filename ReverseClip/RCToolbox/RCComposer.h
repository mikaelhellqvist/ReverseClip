// Please contact me if you use this code. Would be glad to know if it has helped you anything :)
// mikaelhellqvist@gmail.com
// Thanks,
// Mikael Hellqvist

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@interface RCComposer : NSObject

@property AVMutableComposition *composition;

/**
Add clip to a composition
@param urlAsset
 the @c AVURLAsset to the clip that should be added to the composition
 @param inSeconds
 @c Float64
 @param outSeconds
  @c Float64
 @param shouldBeReversed
 @c BOOL
 */
-(void) addToCompositionWithAsset:(AVURLAsset*)urlAsset
                        inSeconds:(Float64)inSec
                       outSeconds:(Float64)outSec
                 shouldBeReversed:(BOOL)shouldBeReversed;


@end
