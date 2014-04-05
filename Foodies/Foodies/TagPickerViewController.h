//
//  TagPickerViewController.h
//  Foodies
//
//  Created by Lucas Chwe on 3/29/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TagPickerDelegate.h"
#import "Venue.h"

@interface TagPickerViewController : UIViewController
@property (strong, nonatomic) UIImage *imageToTag;
@property (strong, nonatomic) Venue *mealsVenue;
@property (strong, nonatomic) id<TagPickerDelegate> delegate;
@property (strong, nonatomic) NSMutableArray *mealTags;
@end
