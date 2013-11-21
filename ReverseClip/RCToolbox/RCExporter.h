// Please contact me if you use this code. Would be glad to know if it has helped you anything :)
// mikaelhellqvist@gmail.com
// Thanks,
// Mikael Hellqvist

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

#import "RCImageSequencer.h"

@interface RCExporter : NSObject<ImageSequencerDelegate> {
    NSString *currentFileExportName;
}

-(void)exportCompositionWithAsset:(AVURLAsset*)urlAsset
                       exportName:(NSString*)exportFileName
               shouldBeReversed:(BOOL)shouldBeReversed;

@end
