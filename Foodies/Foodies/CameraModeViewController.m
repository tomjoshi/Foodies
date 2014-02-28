//
//  CameraModeViewController.m
//  Foodies
//
//  Created by Lucas Chwe on 2/28/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import "CameraModeViewController.h"
#import "CustomCamera.h"
#import <DBCameraViewController.h>

@interface CameraModeViewController () <DBCameraViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)cameraTapped:(id)sender;
@end

@implementation CameraModeViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) openCamera:(id)sender
{
    [self presentViewController:[DBCameraViewController initWithDelegate:self] animated:YES completion:nil];
}

//Use your captured image

#pragma mark - DBCameraViewControllerDelegate

- (void) captureImageDidFinish:(UIImage *)image
{
    [self.imageView setImage:image];
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void) openCameraWithoutSegue
{
    DBCameraViewController *cameraController = [DBCameraViewController initWithDelegate:self];
    [cameraController setUseCameraSegue:NO];
    cameraController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:cameraController];
    [nav setNavigationBarHidden:YES];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void) openCustomCamera:(id)sender
{
    CustomCamera *camera = [CustomCamera initWithFrame:[[UIScreen mainScreen] bounds]];
    [camera buildInterface];
    
    DBCameraViewController *cameraController = [[DBCameraViewController alloc] initWithDelegate:self cameraView:camera];
    [cameraController setUseCameraSegue:NO];
    cameraController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:cameraController animated:YES completion:nil];
}

#pragma mark - IBAction Methods

- (IBAction)cameraTapped:(id)sender {
    [self openCustomCamera:nil];
}
@end
