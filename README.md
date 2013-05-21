# ReverseClip
##Contact
Please contact me if you use this code. Would be glad to know if it has helped you anything :)
mikaelhellqvist@gmail.com
Mikael Hellqvist

## What it does?
Takes a video asset and reverses it, puts it in a AVMutableComposition and exports it as a .mov file. 

The exported file becomes available in iTunes under File Sharing ( [iOS Device]/Apps/ReverseClip).

##How to implement?
Just copy the folder “RCToolbox” to your project.

Import the class “RCToolbox.h” in your class.

	    RCFileHandler *filehandler = [[RCToolbox sharedToolbox] fileHandler];
	    AVURLAsset *myAsset = [filehandler getAssetURLFromBundleWithFileName:@“[asset]”];
	    [self preExportForImageSequence:myAsset];

	 -(void) preExportForImageSequence:(AVURLAsset *)_asset
	  {
	 	    RCComposer *compositionTool = [[RCToolbox sharedToolbox] compositionTool];
	    [compositionTool addToCompositionWithAsset:(AVURLAsset*)_asset timeRangeSpeed:kTimeRangeSlowMotion inSeconds:0.0 outSeconds:2.0 isForImageSequence:YES speed:kTimeRangeSlowMotion];
	}

In this case you will probably use CMTimeZero for inSeconds and asset.duration for outSeconds.

##Tweak it
To change the width and height of the clip, change the constants in RCImageSequencer.m 

You might want to comment out  NSLog(@"Percentage done: %f",percentageDone); in the same class.

##How does it work?

![FlowChart](https://raw.github.com/mikaelhellqvist/ReverseClip/master/ReverseClip%20FlowChart.png)

The MIT License (MIT)

Copyright (c) 2013 Mikael Hellqvist

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.