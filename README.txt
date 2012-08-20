# ReverseClip
## What it does?
Takes a video asset and reverses it, puts it in a AVMutableComposition and exports it as a .mov file. 

The exported file becomes available in iTunes under File Sharing ( [iOS Device/Apps/ReverseClip).

##How to implement?
Just copy the folder “RCToolbox” to your project.

Import the class “RCToolbox.h” in your class.

	    RCFileHandler *filehandler = [[RCToolbox sharedToolbox] fileHandler];
	    AVURLAsset *myAsset = [filehandler getAssetURLFromBundleWithFileName:@“[name of your asset]”];
	    [self preExportForImageSequence:myAsset];
	    
   

	 -(void) preExportForImageSequence:(AVURLAsset *)_asset {
	    
	    RCComposer *compositionTool = [[RCToolbox sharedToolbox] compositionTool];
	    [compositionTool addToCompositionWithAsset:(AVURLAsset*)_asset timeRangeSpeed:kTimeRangeSlowMotion inSeconds:0.0 outSeconds:2.0 isForImageSequence:YES speed:kTimeRangeSlowMotion];
	    
	}

##How does it work?

![Flowchart](file://localhost/Users/mikaelht/Desktop/ReverseClip%20FlowChart.png)