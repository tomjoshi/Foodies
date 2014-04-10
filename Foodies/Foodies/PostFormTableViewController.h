//
//  PostFormTableViewController.h
//  Foodies
//
//  Created by Lucas Chwe on 3/14/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "PostFormViewControllerDelegate.h"

@interface PostFormTableViewController : UITableViewController
@property (strong, nonatomic) ALAsset *assetPassed;
@property (strong, nonatomic) id<PostFormViewControllerDelegate> delegate;
@end
