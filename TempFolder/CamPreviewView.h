//
//  CamPreviewView.h
//  Foodies
//
//  Created by Lucas Chwe on 2/24/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AVCaptureSession;

@interface CamPreviewView : UIView
@property (nonatomic) AVCaptureSession *session;
@end
