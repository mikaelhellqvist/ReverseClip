

#import <Foundation/Foundation.h>
#import "RCExporter.h"
#import "RCImageSequencer.h"
#import "RCComposer.h"

#import "RCFileHandler.h"

@interface RCToolbox : NSObject {

    RCExporter *exporterTool;
    RCImageSequencer *imageSequencerTool;
    RCComposer *compositionTool;
 
    RCFileHandler *fileHandler;
}


@property(nonatomic,retain) RCExporter *exporterTool;
@property(nonatomic,retain) RCImageSequencer *imageSequencerTool;
@property(nonatomic,retain) RCComposer *compositionTool;
@property(nonatomic,retain) RCComposer *imageSequenceCompositionTool;

@property(nonatomic,retain) RCFileHandler *fileHandler;

+ (RCToolbox *)sharedToolbox;

@end
