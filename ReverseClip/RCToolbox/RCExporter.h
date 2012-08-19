

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
