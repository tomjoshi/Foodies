//
//  LandingTableViewController.h
//  Foodies
//
//  Created by Lucas Chwe on 3/26/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LandingViewControllerDelegate.h"

@interface LandingTableViewController : UIViewController
@property (strong, nonatomic) id<LandingViewControllerDelegate> delegate;
@end
