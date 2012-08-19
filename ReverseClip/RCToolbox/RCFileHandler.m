

#import "RCFileHandler.h"


@implementation RCFileHandler

-(id) init {
    if((self = [super init])){
        
    }
    return self;
}

-(NSString*) pathToDocumentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

- (AVURLAsset*)getAssetURLFromFileName:(NSString*)fileName {
    NSString *filePath = [[self pathToDocumentsDirectory] stringByAppendingPathComponent:fileName];
    NSURL* sourceMovieURL = [NSURL fileURLWithPath:filePath];
    AVURLAsset* asset = [AVURLAsset URLAssetWithURL:sourceMovieURL options:nil];
    
    return asset;
}

- (AVURLAsset*)getAssetURLFromBundleWithFileName:(NSString*)fileName {
    NSString *sourceMoviePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"MOV"];
    NSURL *sourceMovieURL = [NSURL fileURLWithPath:sourceMoviePath];
    
    AVURLAsset *sourceAsset	= [AVURLAsset URLAssetWithURL:sourceMovieURL options:nil];
    return sourceAsset;
    
}

@end
