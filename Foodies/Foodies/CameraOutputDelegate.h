//
//  CameraOutputDelegate.h
//  Foodies
//
//  Created by Lucas Chwe on 3/21/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CameraOutputDelegate <NSObject>
- (void) captureImageDidFinish:(UIImage *)image;
- (void)shutterAnimation;
@end
