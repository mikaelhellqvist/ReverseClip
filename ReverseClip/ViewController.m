//
//  ViewController.m
//  ReverseClip
//
//  Created by Mikael Hellqvist on 2012-08-19.
//  Copyright (c) 2012 Mikael Hellqvist. All rights reserved.
//

#import "ViewController.h"
#import "RCToolbox.h"

#define EXPORT_NAME @"Exported.mov"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Calls to the tools

- (void) exportFinishedMovie {
    
    RCExporter *exporterTool = [[RCToolbox sharedToolbox] exporterTool];
    RCComposer *compositionTool = [[RCToolbox sharedToolbox] compositionTool];
    [exporterTool exportCompositionWithAsset:(AVURLAsset*)compositionTool.composition exportName:EXPORT_NAME isForImageSequence:NO];
    
}

-(void) preExportForImageSequence:(AVURLAsset *)_asset {
    
    RCComposer *compositionTool = [[RCToolbox sharedToolbox] compositionTool];
    [compositionTool addToCompositionWithAsset:(AVURLAsset*)_asset timeRangeSpeed:kTimeRangeSlowMotion inSeconds:0.0 outSeconds:2.0 isForImageSequence:YES speed:kTimeRangeSlowMotion];
    
}

-(void) sendToCompositionWithAsset:(AVAsset *)_asset {
    
    RCComposer *compositionTool = [[RCToolbox sharedToolbox] compositionTool];
    [compositionTool addToCompositionWithAsset:(AVURLAsset*)_asset timeRangeSpeed:kTimeRangeNormal inSeconds:0.0 outSeconds:2.0 isForImageSequence:NO speed:kTimeRangeSlowMotion];
    
}


-(void) createReverseClip {
    RCFileHandler *filehandler = [[RCToolbox sharedToolbox] fileHandler];
    AVURLAsset *myAsset = [filehandler getAssetURLFromBundleWithFileName:@"IMG_2262"];
    [self preExportForImageSequence:myAsset];
    
    /*
     ImageSequencer *imageSequencerTool = [[Toolbox sharedToolbox] imageSequencerTool];
     [imageSequencerTool createImageSequenceWithAsset:myAsset];
     */
}


#pragma mark - Buttons

- (IBAction)startButtonPressed:(id)sender {
    [self createReverseClip];
}
@end

