//
//  FeedTableViewCell.h
//  Foodies
//
//  Created by Lucas Chwe on 3/7/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoodPost.h"

@interface FeedTableViewCell : UITableViewCell

- (void)configureWithFoodPost: (FoodPost *)foodPost;

@end
