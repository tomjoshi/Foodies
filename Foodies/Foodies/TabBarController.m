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
	// Do any additional setup after loading the view.
    self.uiTabBarItemWidth = self.view.bounds.size.width/5;
    
    UIViewController *homeVC = self.viewControllers[0];
    FAKFontAwesome *homeIcon = [FAKFontAwesome homeIconWithSize:25];
    [homeIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    UIImage *homeIconImage = [homeIcon imageWithSize:CGSizeMake(25, 25)];
    homeVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Feed" image:homeIconImage tag:1];
    
    UIViewController *discoverVC = self.viewControllers[1];
    FAKFontAwesome *searchIcon = [FAKFontAwesome searchIconWithSize:25];
    [searchIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    UIImage *searchIconImage = [searchIcon imageWithSize:CGSizeMake(25, 25)];
    discoverVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Discover" image:searchIconImage tag:1];
    
    UIViewController *cameraVC = self.viewControllers[2];
    FAKFontAwesome *cameraIcon = [FAKFontAwesome cameraIconWithSize:25];
    [cameraIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    UIImage *cameraIconImage = [cameraIcon imageWithSize:CGSizeMake(25, 25)];
    cameraVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Camera" image:cameraIconImage tag:1];
    // add touch down inside action listener to start camera
    
    UIViewController *wantVC = self.viewControllers[3];
    FAKFontAwesome *starOIcon = [FAKFontAwesome starOIconWithSize:25];
    [starOIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    UIImage *starOIconImage = [starOIcon imageWithSize:CGSizeMake(25, 25)];
    wantVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Want" image:starOIconImage tag:1];
    
    UIViewController *profileVC = self.viewControllers[4];
    FAKFontAwesome *userIcon = [FAKFontAwesome userIconWithSize:25];
    [userIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    UIImage *userIconImage = [userIcon imageWithSize:CGSizeMake(25, 25)];
    profileVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Profile" image:userIconImage tag:1];
    
    
    
    // take over control of gestures over uitabbar
//    discoverVC.tabBarItem.enabled = NO;
//    homeVC.tabBarItem.enabled = NO;
//    cameraVC.tabBarItem.enabled = NO;
//    wantVC.tabBarItem.enabled = NO;
//    profileVC.tabBarItem.enabled = NO;
    
    
    self.touchDownCamera = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(takePhoto:)];
    self.touchDownCamera.minimumPressDuration = 0.5;
    [self.tabBar addGestureRecognizer:self.touchDownCamera];
    
    self.regularTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectViewController:)];
    [self.regularTap requireGestureRecognizerToFail:self.touchDownCamera];
    [self.tabBar addGestureRecognizer:self.regularTap];
    
//    self.arrayOfVCs = self.viewControllers;
    
    // load camera
    [self getCameraStarted];
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
                NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
                UIImage *image = [[UIImage alloc]initWithData:imageData];
                
                [self.cameraDelegate captureImageDidFinish:image];
//                //Set image to image preview
//                self.imagePreview.image = image;
//                self.imagePreview.alpha = 100.0f;
//                [UIView animateWithDuration:2.0f
//                                      delay:0
//                                    options:UIViewAnimationOptionCurveEaseIn
//                                 animations:^{
//                                     self.imagePreview.alpha = 0.0f;
//                                 }
//                                 completion:^(BOOL finished) {
//                                     self.imagePreview.alpha = 100.0f;
//                                 }];
//                
//                //Save to library
//                ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
//                [library writeImageToSavedPhotosAlbum:[image CGImage] orientation:(ALAssetOrientation)[image imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error)
//                 {
//                     
//                 }
//                 ];
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
    
    if (index == 2) {
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
    
    if ([self selectedViewController] == self.viewControllers[2] && index == 2) {
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
    UINavigationController *nav = (UINavigationController *)self.viewControllers[2];
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
