// Please contact me if you use this code. Would be glad to know if it has helped you anything :)
// mikaelhellqvist@gmail.com
// Thanks,
// Mikael Hellqvist


#import "RCToolbox.h"

@implementation RCToolbox

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
        _exporterTool = [[RCExporter alloc]init];
        _imageSequencerTool = [[RCImageSequencer alloc]init];
        _compositionTool = [[RCComposer alloc]init];
        _fileHandler = [[RCFileHandler alloc]init];
    }
    return self;
}

@end
