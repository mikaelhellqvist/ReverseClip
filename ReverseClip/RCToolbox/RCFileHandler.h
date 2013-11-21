// Please contact me if you use this code. Would be glad to know if it has helped you anything :)
// mikaelhellqvist@gmail.com
// Thanks,
// Mikael Hellqvist

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface RCFileHandler : NSObject

/**
 The Path to the documents directory
 @return NSString
 */
-(NSString*)pathToDocumentsDirectory;
/**
 Search in the documents directory for the provided fileName
 @param fileName
 The file name as a @c NSString
 @return
 AVURLAsset
 */
-(AVURLAsset*)getAssetURLFromFileName:(NSString*)fileName;
/**
 Search in the bundle for the provided fileName
 @param fileName
 The file name as a @c NSString
 @return
 AVURLAsset
 */
-(AVURLAsset*)getAssetURLFromBundleWithFileName:(NSString*)fileName;

@end
