//
//  ViewController.m
//  ReverseClip
//
//  Created by Mikael Hellqvist on 2012-08-19.
//  Copyright (c) 2012 Mikael Hellqvist. All rights reserved.
//

#import "ViewController.h"

#import "RCToolbox.h"
#import "RCConstants.h"
@interface ViewController ()

@end

@implementation ViewController

#pragma mark - UI
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(movieIsExported)
                                                 name:@"ExportedMovieNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(imageSequenceIsExported)
                                                 name:@"ExportedImageSequenceNotification"
                                               object:nil];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Actions
- (IBAction)startButtonPressed:(id)sender {
    [self createReverseClip];
}

#pragma mark - Reverse clip
-(void) createReverseClip
{
    RCFileHandler *filehandler = [[RCToolbox sharedToolbox] fileHandler];
    AVURLAsset *urlAsset = [filehandler getAssetURLFromBundleWithFileName:@"IMG_2262"];
    [self exportReversedClip:urlAsset];
}

-(void) exportReversedClip:(AVURLAsset *)urlAsset
{
    Float64 assetDuration = CMTimeGetSeconds(urlAsset.duration);
    RCComposer *compositionTool = [[RCToolbox sharedToolbox] compositionTool];
    [compositionTool addToCompositionWithAsset:(AVURLAsset*)urlAsset inSeconds:0.0 outSeconds:assetDuration shouldBeReversed:YES];
}

#pragma mark - Notifications
-(void)movieIsExported
{
    RCFileHandler *fileHandler = [[RCToolbox sharedToolbox] fileHandler];
    AVURLAsset *urlAsset = [fileHandler getAssetURLFromFileName:k_exportedClipName];
    NSLog(@"The movie has been exported. \n URLAsset:%@",urlAsset);
}

-(void)imageSequenceIsExported
{
    RCFileHandler *fileHandler = [[RCToolbox sharedToolbox] fileHandler];
    AVURLAsset *urlAsset = [fileHandler getAssetURLFromFileName:k_exportedSequenceName];
    NSLog(@"The image sequence has been exported. \n URLAsset:%@",urlAsset);
}

@end

