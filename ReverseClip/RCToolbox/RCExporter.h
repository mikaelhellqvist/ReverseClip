// Please contact me if you use this code. Would be glad to know if it has helped you anything :)
// mikaelhellqvist@gmail.com
// Thanks,
// Mikael Hellqvist

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface RCExporter : NSObject {

    NSString *currentFileExportName;
}

-(void)exportCompositionWithAsset:(AVURLAsset*)_asset 
                       exportName:(NSString*)exportFileName
               isForImageSequence:(BOOL)isTempForImageSequence;

-(void) exportDone: (NSObject*) userInfo;

@end
