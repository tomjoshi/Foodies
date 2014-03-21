//
//  FeedTableViewCell.h
//  Foodies
//
//  Created by Lucas Chwe on 3/7/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoodPost.h"
#import <TTTAttributedLabel.h>

@interface FeedTableViewCell : UITableViewCell <TTTAttributedLabelDelegate>
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *authorLabel;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *timeLabel;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *venueLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;

- (void)configureWithFoodPost: (FoodPost *)foodPost;

@end
