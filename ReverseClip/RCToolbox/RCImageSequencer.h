// Please contact me if you use this code. Would be glad to know if it has helped you anything :)
// mikaelhellqvist@gmail.com
// Thanks,
// Mikael Hellqvist

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@protocol ImageSequencerDelegate <NSObject>
- (void)exportedImageSequenceToFileName:(NSString *)fileName;
- (void)imageSequencerProgress:(Float64)percentage;
@end

@interface RCImageSequencer : NSObject

@property (unsafe_unretained) id <ImageSequencerDelegate> delegate;

- (void)createImageSequenceWithAsset:(AVURLAsset*)urlAsset;

@end
