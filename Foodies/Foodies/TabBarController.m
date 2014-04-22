//
//  TabBarController.m
//  Foodies
//
//  Created by Lucas Chwe on 2/28/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import "TabBarController.h"
#import <FontAwesomeKit.h>
#import "CameraViewController.h"
#import "LandingTableViewController.h"
#import "UIColor+colorPallete.h"
#import <Parse/Parse.h>
#import "Foodie.h"
#import "FetchOperation.h"

@interface TabBarController () <UITabBarControllerDelegate>
@property (strong, nonatomic) UILongPressGestureRecognizer *touchDownCamera;
@property (strong, nonatomic) UITapGestureRecognizer *regularTap;
@property (nonatomic) CGFloat uiTabBarItemWidth;

@end

@implementation TabBarController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.uiTabBarItemWidth = self.view.bounds.size.width/3;
    [self.tabBar setSelectedImageTintColor:[UIColor foodiesColor]];
    
    // prepare tabs
    UIViewController *homeVC = self.viewControllers[0];
    FAKIonIcons *homeIcon = [FAKIonIcons personStalkerIconWithSize:30];
    [homeIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    UIImage *homeIconImage = [homeIcon imageWithSize:CGSizeMake(30, 30)];
    homeVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Foodies" image:homeIconImage tag:0];
    
    UINavigationController *postVC = self.viewControllers[1];
    FAKIonIcons *postIcon = [FAKIonIcons cameraIconWithSize:30];
    [postIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    UIImage *postIconImage = [postIcon imageWithSize:CGSizeMake(30, 30)];
    postVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Post" image:postIconImage tag:1];
    
    UIViewController *profileVC = self.viewControllers[2];
    FAKIonIcons *userIcon = [FAKIonIcons personIconWithSize:30];
    [userIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    UIImage *userIconImage = [userIcon imageWithSize:CGSizeMake(30, 30)];
    profileVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Me" image:userIconImage tag:2];
    
    // set up special gesture for the camera shutter
    self.touchDownCamera = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(takePhoto:)];
    self.touchDownCamera.minimumPressDuration = 0.5;
    [self.tabBar addGestureRecognizer:self.touchDownCamera];
    
    self.regularTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectViewController:)];
    [self.regularTap requireGestureRecognizerToFail:self.touchDownCamera];
    [self.tabBar addGestureRecognizer:self.regularTap];
    
    // load camera
    [self getCameraStarted];
    
    // load album
    CameraViewController *cameraViewController = postVC.viewControllers[0];
    [cameraViewController loadAlbum];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // check if user is logged in
    if ([PFUser currentUser] == nil) {
        // launch log in view if user is not logged in
        LandingTableViewController *modalVC = [self.storyboard instantiateViewControllerWithIdentifier:@"logInController"];
        modalVC.delegate = self;
        [self presentViewController:modalVC animated:NO completion:nil];
    } else {
        // load and fetch data
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        FetchOperation *fetchOp = [[FetchOperation alloc] init];
        [queue addOperation:fetchOp];
    }
    
}

#pragma mark - LandingViewControllerDelegate method

- (void)didLoggedIn
{
    [self setSelectedIndex:0];
}

#pragma mark - Camera functionality methods

- (void)getCameraStarted
{
    //Capture Session
    self.captureSession = [[AVCaptureSession alloc]init];
    self.captureSession.sessionPreset = AVCaptureSessionPresetPhoto;
    
    //Add device
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //Input
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    
    if (!input)
    {
        NSLog(@"No Input");
    }
    
    [self.captureSession addInput:input];
    
    //Output
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *stillImageOutputSettings = [[NSDictionary alloc]initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
    [self.stillImageOutput setOutputSettings:stillImageOutputSettings];
    [self.captureSession addOutput:self.stillImageOutput];
    [self.captureSession startRunning];
    
    //make Preview Layer
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    
}


- (void)captureStillImage
{
    // check that the camera is ready to take a picture, if its not pop the nav to its rootviewcontroller
    UINavigationController *navC = self.viewControllers[1];
    CameraViewController *rootVC = navC.viewControllers[0];
    if (![[navC topViewController] isEqual:rootVC] || rootVC.navigationItem.leftBarButtonItem || (rootVC.mainScrollView.contentOffset.y > 0)) {
        [navC popToRootViewControllerAnimated:YES];
        [rootVC.mainScrollView setContentOffset:CGPointZero animated:YES];
        [rootVC cancelTapped:nil];
        return;
    }
    
    AVCaptureConnection *stillImageConnection = [self.stillImageOutput.connections objectAtIndex:0];
    if([stillImageConnection isVideoOrientationSupported])
    {
        [stillImageConnection setVideoOrientation:AVCaptureVideoOrientationPortrait];
        
        
        [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:stillImageConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
            if(imageDataSampleBuffer !=NULL)
            {
                [self.cameraDelegate shutterAnimation];
                
                NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
                UIImage *image = [[UIImage alloc]initWithData:imageData];
                
                [self.cameraDelegate captureImageDidFinish:image];
            }
            else
            {
                NSLog(@"Error capturing still image");
            }
        }];
    }
}

- (void)takePhoto:(UILongPressGestureRecognizer *)sender
{
    CGFloat touchX = [sender locationInView:self.tabBar].x;
    NSInteger index = floor(touchX/self.uiTabBarItemWidth);
    
    if (index == 1) {
        if (sender.state == UIGestureRecognizerStateEnded) {
            NSLog(@"long press ended");
            [self captureStillImage];
        } else {
            NSLog(@"long press started");
        }
    }
}

#pragma mark - Tab methods

- (void)selectViewController:(UITapGestureRecognizer *)sender
{
    CGFloat touchX = [sender locationInView:self.tabBar].x;
    NSInteger index = floor(touchX/self.uiTabBarItemWidth);
    
    if ([self selectedViewController] == self.viewControllers[1] && index == 1) {
        [self captureStillImage];
    } else {
        [self setSelectedIndex:index];
    }
}

@end
