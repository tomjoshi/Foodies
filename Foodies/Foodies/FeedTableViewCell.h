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
#import "FeedTableViewCellDelegate.h"
#import "FSFoodPost+Methods.h"

@interface FeedTableViewCell : UITableViewCell <TTTAttributedLabelDelegate>
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *authorLabel;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *timeLabel;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *venueLabel;
@property (strong, nonatomic) TTTAttributedLabel *likesLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@property (strong, nonatomic) FSFoodPost *foodPostInCell;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) UIImageView *postImageView;
@property (nonatomic) BOOL tagsAreVisible;

@property (strong, nonatomic) id <FeedTableViewCellDelegate> delegate;

- (void)configureWithFoodPost: (FSFoodPost *)foodPost;

@end
