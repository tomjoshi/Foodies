//
//  TabBarController.h
//  Foodies
//
//  Created by Lucas Chwe on 2/28/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "CameraOutputDelegate.h"
#import "LandingViewControllerDelegate.h"

@interface TabBarController : UITabBarController <LandingViewControllerDelegate>
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;
@property (strong, nonatomic) AVCaptureSession *captureSession;
@property (strong, nonatomic) AVCaptureStillImageOutput *stillImageOutput;
@property (strong, nonatomic) id<CameraOutputDelegate> cameraDelegate;

@end
