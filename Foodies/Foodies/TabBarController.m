//
//  TabBarController.m
//  Foodies
//
//  Created by Lucas Chwe on 2/28/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import "TabBarController.h"
#import <FontAwesomeKit.h>
#import <DBCameraViewController.h>
#import "CustomCamera.h"
#import "CameraViewController.h"
#import "LandingTableViewController.h"
#import "UIColor+colorPallete.h"
#import <Parse/Parse.h>
#import "Foodie.h"

@interface TabBarController () <DBCameraViewControllerDelegate, UITabBarControllerDelegate>
//@property (strong, nonatomic) NSArray *arrayOfVCs;
@property (strong, nonatomic) UILongPressGestureRecognizer *touchDownCamera;
@property (strong, nonatomic) UITapGestureRecognizer *regularTap;
@property (nonatomic) CGFloat uiTabBarItemWidth;
@property (strong, nonatomic) CustomCamera *camera;
@property (strong, nonatomic) DBCameraViewController *cameraVC;

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
    FAKFontAwesome *homeIcon = [FAKFontAwesome homeIconWithSize:30];
    [homeIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    UIImage *homeIconImage = [homeIcon imageWithSize:CGSizeMake(30, 30)];
    homeVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Feed" image:homeIconImage tag:1];
    
    UIViewController *cameraVC = self.viewControllers[1];
    FAKIonIcons *cameraIcon = [FAKIonIcons ios7CameraOutlineIconWithSize:30];
    [cameraIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    UIImage *cameraIconImage = [cameraIcon imageWithSize:CGSizeMake(30, 30)];
    cameraVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Camera" image:cameraIconImage tag:1];
    FAKIonIcons *cameraFullIcon = [FAKIonIcons ios7CameraIconWithSize:30];
    [cameraFullIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    UIImage *cameraFullIconImage = [cameraFullIcon imageWithSize:CGSizeMake(30, 30)];
    cameraVC.tabBarItem.selectedImage = cameraFullIconImage;
    
    UIViewController *profileVC = self.viewControllers[2];
    FAKIonIcons *userIcon = [FAKIonIcons ios7ContactOutlineIconWithSize:30];
    [userIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    UIImage *userIconImage = [userIcon imageWithSize:CGSizeMake(30, 30)];
    profileVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Profile" image:userIconImage tag:1];
    FAKIonIcons *userFullIcon = [FAKIonIcons ios7ContactIconWithSize:30];
    [userFullIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    UIImage *userFullIconImage = [userFullIcon imageWithSize:CGSizeMake(30, 30)];
    profileVC.tabBarItem.selectedImage = userFullIconImage;
    
    // set up special gesture for the camera shutter
    self.touchDownCamera = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(takePhoto:)];
    self.touchDownCamera.minimumPressDuration = 0.5;
    [self.tabBar addGestureRecognizer:self.touchDownCamera];
    
    self.regularTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectViewController:)];
    [self.regularTap requireGestureRecognizerToFail:self.touchDownCamera];
    [self.tabBar addGestureRecognizer:self.regularTap];
    
    // load camera
    [self getCameraStarted];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // check if user is logged in
    if ([PFUser currentUser] == nil) {
        LandingTableViewController *modalVC = [self.storyboard instantiateViewControllerWithIdentifier:@"logInController"];
        modalVC.delegate = self;
        [self presentViewController:modalVC animated:YES completion:nil];
    }
    
}

- (void)loggedIn
{
    [self setSelectedIndex:0];
}

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
    
    //make Preview Layer
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
}


-(void) captureStillImage
{
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void) openCamera
{
    self.camera = [CustomCamera initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.camera buildInterface];
    self.cameraVC = [[DBCameraViewController alloc] initWithDelegate:self cameraView:self.camera];
    [self.cameraVC setUseCameraSegue:NO];
    self.cameraVC.hidesBottomBarWhenPushed = NO;
    UINavigationController *nav = (UINavigationController *)self.selectedViewController;
    [nav setNavigationBarHidden:YES animated:YES];
    [nav pushViewController:self.cameraVC animated:NO];

}

#pragma mark - DBCameraViewControllerDelegate Methods

- (void) captureImageDidFinish:(UIImage *)image withMetadata:(NSDictionary *)metadata
{
    UINavigationController *nav = (UINavigationController *)self.viewControllers[1];
    CameraViewController *cameraTabVC = nav.viewControllers[0];
    cameraTabVC.imagePassed = image;
    [cameraTabVC clearPreviewImageAsset];
    [self.cameraVC.delegate dismissCamera];
}

- (void) dismissCamera
{
    UINavigationController *nav = (UINavigationController *)self.selectedViewController;
    [nav popToRootViewControllerAnimated:NO];
    [nav setNavigationBarHidden:NO animated:YES];
}


@end
