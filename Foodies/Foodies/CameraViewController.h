//
//  CameraViewController.h
//  Foodies
//
//  Created by Lucas Chwe on 2/25/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface CameraViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property BOOL newMedia;
@property (strong, nonatomic) UIImage *imagePassed;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;

- (void)clearPreviewImageAsset;
- (IBAction)cancelTapped:(id)sender;
@end
