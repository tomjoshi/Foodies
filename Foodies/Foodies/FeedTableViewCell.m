//
//  FeedTableViewCell.m
//  Foodies
//
//  Created by Lucas Chwe on 3/7/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import "FeedTableViewCell.h"
#import "UIView+ResizeToFitSubviews.h"
#import "Comment.h"
#import "Foodie.h"
#import <TTTAttributedLabel.h>

@implementation FeedTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureWithFoodPost:(FoodPost *)foodPost
{
    UIImage *postImage = [foodPost getImage];
    NSDate *postDate = [foodPost getDate];
    NSString *postAuthor = [foodPost.author getName];
    NSNumber *numberOfLikes = [foodPost getNumberOfLikes];
    BOOL isLiked = [foodPost isLiked];
    NSArray *comments = [foodPost getComments];
    CGFloat cellWidth = self.bounds.size.width;
//    UIImage *authorThumb = [foodPost.author getThumb];
    
    // set author label
    UILabel *authorNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cellWidth-70, 40)];
    authorNameLabel.text = postAuthor;
    [self.contentView addSubview:authorNameLabel];
    
    // set time label
    UILabel *dateCreatedLabel = [[UILabel alloc] initWithFrame:CGRectMake(cellWidth-70, 0, 70, 40)];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    dateCreatedLabel.text = [dateFormatter stringFromDate:postDate];
    [self.contentView addSubview:dateCreatedLabel];
    
    // set image
    UIImageView *postImageView = [[UIImageView alloc] initWithImage:postImage];
    [postImageView setFrame:CGRectMake(0, 40, cellWidth, cellWidth)];
    [self.contentView addSubview:postImageView];
    
    // set a subview for likes and comments
    UIView *likeAndCommentContent = [[UIView alloc] initWithFrame:CGRectMake(0, cellWidth+40, cellWidth, 0)];
    
    // set likes
    CGFloat yPos = 0;
    if (isLiked) {
        UILabel *likesLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, yPos, cellWidth, 21)];
        likesLabel.text = [NSString stringWithFormat:@"%@ likes", numberOfLikes];
        [likeAndCommentContent addSubview:likesLabel];
        yPos = 21;
    }
    
    // set comments
    NSInteger commentIndex = 0;
    while (commentIndex < [comments count]) {
        TTTAttributedLabel *commentLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(0, yPos, cellWidth, 21)];
        
        Comment *commentForLabel = comments[commentIndex];
        NSString *fullComment = [NSString stringWithFormat:@"%@ says \"%@\"", [commentForLabel.commenter getName], commentForLabel.comment];

        [commentLabel setText:fullComment afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
            NSInteger nameLenght = [[commentForLabel.commenter getName] length];
            
            
            
        }]
        
        
        
        
        
        
        
        
        
        
        
        
        [likeAndCommentContent addSubview:commentLabel];
        yPos += 21; // ideally is "+ commentLabel height"
        commentIndex += 1;
    }
    
    // set like, comment and more buttons
    UIButton *likeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, yPos, 50, 30)];
    [likeButton setTitle:@"Like" forState:UIControlStateNormal];
    [likeButton setBackgroundColor:[UIColor grayColor]];
    [likeAndCommentContent addSubview:likeButton];
    UIButton *commentButton = [[UIButton alloc] initWithFrame:CGRectMake(60, yPos, 100, 30)];
    [commentButton setTitle:@"Comment" forState:UIControlStateNormal];
    [commentButton setBackgroundColor:[UIColor grayColor]];
    [likeAndCommentContent addSubview:commentButton];
    UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(cellWidth-30, yPos, 30, 30)];
    [moreButton setTitle:@"..." forState:UIControlStateNormal];
    [moreButton setBackgroundColor:[UIColor grayColor]];
    [likeAndCommentContent addSubview:moreButton];
    
    // add like and comment subview
    [likeAndCommentContent resizeToFitSubviews];
    [self.contentView addSubview:likeAndCommentContent];
    
    // resize content view
    [self.contentView resizeToFitSubviews];

    

}


@end
