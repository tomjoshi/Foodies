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
#import <FontAwesomeKit.h>

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
    NSString *postFormattedTime = [foodPost getFormattedTime];
    NSString *postAuthor = [foodPost.author getName];
    NSNumber *numberOfLikes = [foodPost getNumberOfLikes];
    BOOL isLiked = [foodPost isLiked];
    NSArray *comments = [foodPost getComments];
    CGFloat cellWidth = self.bounds.size.width;
//    UIImage *authorThumb = [foodPost.author getThumb];
    
    // set author label
    [self.authorLabel setFrame:CGRectMake(0, 0, cellWidth-70, 40)];
    self.authorLabel.text = postAuthor;
    
    // set time label
    [self.timeLabel setFrame:CGRectMake(cellWidth-70, 0, 70, 40)];
    self.timeLabel.text = postFormattedTime;
    
    // set image
    UIImageView *postImageView = [[UIImageView alloc] initWithImage:postImage];
    [postImageView setFrame:CGRectMake(0, 40, cellWidth, cellWidth)];
    postImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:postImageView];
    
    // set a subview for likes and comments
    UIView *likeAndCommentContent = [[UIView alloc] initWithFrame:CGRectMake(0, cellWidth+40, cellWidth, 0)];
    
    // set likes
    CGFloat yPos = 0;
    if (isLiked) {
        // set heart icon
        FAKFontAwesome *heartIcon = [FAKFontAwesome heartIconWithSize:10];
        [heartIcon addAttribute:NSForegroundColorAttributeName value:[UIColor redColor]];
        UILabel *heartIconLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, yPos, 25, 21)];
        [heartIconLabel setAttributedText:[heartIcon attributedString]];
        [heartIconLabel setTextAlignment:NSTextAlignmentCenter];
        [likeAndCommentContent addSubview:heartIconLabel];
        
        // set number of likes
        UILabel *likesLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, yPos, cellWidth-25, 21)];
        likesLabel.text = [NSString stringWithFormat:@"%@ likes", numberOfLikes];
        [likesLabel setFont:self.authorLabel.font];
        [likeAndCommentContent addSubview:likesLabel];
        yPos = 21;
    }
    
    
    // set comment icon if needed
    if ([comments count] > 0) {
        FAKFontAwesome *commentIcon = [FAKFontAwesome commentIconWithSize:10];
        [commentIcon addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor]];
        UILabel *commentIconLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, yPos, 25, 21)];
        [commentIconLabel setAttributedText:[commentIcon attributedString]];
        [commentIconLabel setTextAlignment:NSTextAlignmentCenter];
        [likeAndCommentContent addSubview:commentIconLabel];
    }
    
    // set comments
    NSInteger commentIndex = 0;
    UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, yPos, cellWidth-25, 21)];
    commentLabel.text = @"";
    commentLabel.numberOfLines = 0;
    while (commentIndex < [comments count]) {
        Comment *commentForLabel = comments[commentIndex];
        commentLabel.text = [commentLabel.text stringByAppendingString:[NSString stringWithFormat:@"%@ says \"%@\"\n", [commentForLabel.commenter getName], commentForLabel.comment]];
        commentIndex += 1;
    }
    [commentLabel setFont:self.authorLabel.font];
    [commentLabel sizeToFit];
    [likeAndCommentContent addSubview:commentLabel];
    
    // update yPos
    yPos += commentLabel.bounds.size.height;
    
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
