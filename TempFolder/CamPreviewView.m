//
//  CamPreviewView.m
//  Foodies
//
//  Created by Lucas Chwe on 2/24/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import "CamPreviewView.h"
#import <AVFoundation/AVFoundation.h>

@implementation CamPreviewView

+ (Class)layerClass
{
    return [AVCaptureVideoPreviewLayer class];
}

- (AVCaptureSession *)session
{
    return [(AVCaptureVideoPreviewLayer *)[self layer] session];
}

- (void)setSession:(AVCaptureSession *)session
{
    [(AVCaptureVideoPreviewLayer *)[self layer] setSession:session];
}

@end
