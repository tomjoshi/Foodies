//
//  TagPickerViewController.h
//  Foodies
//
//  Created by Lucas Chwe on 3/29/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Venue.h"

@interface TagPickerViewController : UIViewController
@property (strong, nonatomic) UIImage *imageToTag;
@property (strong, nonatomic) Venue *mealsVenue;
@end
