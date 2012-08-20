// Please contact me if you use this code. Would be glad to know if it has helped you anything :)
// mikaelhellqvist@gmail.com
// Thanks,
// Mikael Hellqvist


#import "RCToolbox.h"

@implementation RCToolbox


@synthesize exporterTool;
@synthesize imageSequencerTool;
@synthesize compositionTool;
@synthesize imageSequenceCompositionTool;

@synthesize fileHandler;

+ (RCToolbox *) sharedToolbox
{
    static RCToolbox *sharedToolbox = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedToolbox = [[RCToolbox alloc] init];
    });
    return sharedToolbox;
}

-(id) init {
    if((self = [super init])){
        self.exporterTool = [[RCExporter alloc]init];
        self.imageSequencerTool = [[RCImageSequencer alloc]init];
        self.compositionTool = [[RCComposer alloc]init];
        
        self.fileHandler = [[RCFileHandler alloc]init];
    }
    return self;
}

@end
