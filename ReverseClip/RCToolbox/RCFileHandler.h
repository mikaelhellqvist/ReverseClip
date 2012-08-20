// Please contact me if you use this code. Would be glad to know if it has helped you anything :)
// mikaelhellqvist@gmail.com
// Thanks,
// Mikael Hellqvist

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface RCFileHandler : NSObject {
    
}


-(NSString*) pathToDocumentsDirectory;
-(AVURLAsset*) getAssetURLFromFileName:(NSString*)fileName;
-(AVURLAsset*)getAssetURLFromBundleWithFileName:(NSString*)fileName;

@end
