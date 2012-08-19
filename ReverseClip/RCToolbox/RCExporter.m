
#import "RCExporter.h"
#import "RCToolbox.h"

@implementation RCExporter

-(id) init {
    if((self = [super init])){
        
    }
    return self;
}

-(void)exportCompositionWithAsset:(AVURLAsset*)_asset 
                       exportName:(NSString*)exportFileName
               isForImageSequence:(BOOL)isTempForImageSequence{
    
    currentFileExportName = exportFileName;
    
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:_asset presetName:AVAssetExportPresetMediumQuality];
    //    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:composition presetName:AVAssetExportPresetPassthrough];
    
	NSLog (@"can export: %@", exportSession.supportedFileTypes);
    
	NSArray *dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectoryPath = [dirs objectAtIndex:0];
	NSString *exportPath = [documentsDirectoryPath stringByAppendingPathComponent:exportFileName];
    
	[[NSFileManager defaultManager] removeItemAtPath:exportPath error:nil];
	NSURL *exportURL = [NSURL fileURLWithPath:exportPath];
    
	exportSession.outputURL = exportURL;
	exportSession.outputFileType = AVFileTypeQuickTimeMovie;//@"com.apple.quicktime-movie";
    
	[exportSession exportAsynchronouslyWithCompletionHandler:^{
		NSLog (@"i is in your block, exportin. status is %d",
			   exportSession.status);
		switch (exportSession.status) {
			case AVAssetExportSessionStatusFailed:
			case AVAssetExportSessionStatusCompleted: {
				[self performSelectorOnMainThread:@selector (exportDone:)
									   withObject:nil
									waitUntilDone:NO];
                
                if (isTempForImageSequence) {
                    RCImageSequencer *imageSequencerTool = [[RCToolbox sharedToolbox] imageSequencerTool];
                    [imageSequencerTool createImageSequenceWithAsset:(AVURLAsset*)_asset];
                }
				break;
			}
		};
	}];
}

-(void) exportDone: (NSObject*) userInfo {
    NSLog(@"Movie is exported");
 
    RCFileHandler *fileHandler = [[RCToolbox sharedToolbox] fileHandler];
    [fileHandler getAssetURLFromFileName:currentFileExportName];
}



@end
