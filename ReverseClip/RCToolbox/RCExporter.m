// Please contact me if you use this code. Would be glad to know if it has helped you anything :)
// mikaelhellqvist@gmail.com
// Thanks,
// Mikael Hellqvist

#import "RCExporter.h"
#import "RCToolbox.h"

@implementation RCExporter

-(void)exportCompositionWithAsset:(AVURLAsset*)urlAsset exportName:(NSString*)exportFileName shouldBeReversed:(BOOL)shouldBeReversed
{
    currentFileExportName = exportFileName;
    
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:urlAsset presetName:AVAssetExportPresetMediumQuality];
    
	NSArray *dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectoryPath = [dirs objectAtIndex:0];
	NSString *exportPath = [documentsDirectoryPath stringByAppendingPathComponent:exportFileName];
    
	[[NSFileManager defaultManager] removeItemAtPath:exportPath error:nil];
	NSURL *exportURL = [NSURL fileURLWithPath:exportPath];
    
	exportSession.outputURL = exportURL;
	exportSession.outputFileType = AVFileTypeQuickTimeMovie;
    
	[exportSession exportAsynchronouslyWithCompletionHandler:^{
		NSLog (@"i is in your block, exportin. status is %d",exportSession.status);
        
		switch (exportSession.status) {
			case AVAssetExportSessionStatusFailed:
                NSLog(@"Export failed");
			case AVAssetExportSessionStatusCompleted: {
				[self performSelectorOnMainThread:@selector(exportDone:)
									   withObject:nil
									waitUntilDone:NO];
                
                if (shouldBeReversed) {
                    RCImageSequencer *imageSequencerTool = [[RCToolbox sharedToolbox] imageSequencerTool];
                    [imageSequencerTool setDelegate:(id)self];
                    [imageSequencerTool createImageSequenceWithAsset:(AVURLAsset*)urlAsset];
                }
				break;
			}
		};
	}];
}

-(void) exportDone:(NSObject*)userInfo {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ExportedMovieNotification" object:self];
}

-(void)imageSequencerProgress:(Float64)percentage
{
    NSLog(@"percentage %f",percentage);
}

-(void)exportedImageSequenceToFileName:(NSString*)fileName
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ExportedImageSequenceNotification" object:self];
    NSLog(@"Exported image sequence to %@",fileName);
}

@end
