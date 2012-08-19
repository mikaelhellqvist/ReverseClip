
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface RCFileHandler : NSObject {
    
}


-(NSString*) pathToDocumentsDirectory;
-(AVURLAsset*) getAssetURLFromFileName:(NSString*)fileName;
-(AVURLAsset*)getAssetURLFromBundleWithFileName:(NSString*)fileName;

@end
