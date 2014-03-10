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
    if (!self.authorLabel) {
        UILabel *authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cellWidth-70, 40)];
        [self.contentView addSubview:authorLabel];
    }
    [self.authorLabel setFrame:CGRectMake(0, 0, cellWidth-70, 40)];
    self.authorLabel.text = postAuthor;
    
    // set time label
    if (!self.timeLabel) {
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(cellWidth-70, 0, 70, 40)];
        [self.contentView addSubview:timeLabel];
    }
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
        // set likes icon
        FAKFontAwesome *heartIcon = [FAKFontAwesome heartIconWithSize:15];
        [heartIcon addAttribute:NSForegroundColorAttributeName value:[UIColor redColor]];
        UILabel *heartIconLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, yPos, 20, 20)];
        heartIconLabel.attributedText = [heartIcon attributedString];
        [heartIconLabel setTextAlignment:NSTextAlignmentCenter];
        [likeAndCommentContent addSubview:heartIconLabel];
        
        // set likes label
        if (!self.likeLabel) {
            UILabel *likeLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, yPos, cellWidth-25, 21)];
            [likeAndCommentContent addSubview:likeLabel];
        }
        [self.likeLabel setFrame:CGRectMake(25, yPos, cellWidth-25, 21)];
        self.likeLabel.text = [NSString stringWithFormat:@"%@ likes", numberOfLikes];
        [self.likeLabel removeFromSuperview];
        [likeAndCommentContent addSubview:self.likeLabel];

        // update yPos
        yPos = 21;
    }
    
    
    // set comments
    NSInteger commentIndex = 0;
    UILabel *commentLabel;
    
    if ([comments count] > 0) {
        // set comment icon
        FAKFontAwesome *commentIcon = [FAKFontAwesome commentIconWithSize:15];
        [commentIcon addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor]];
        UILabel *commentIconLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, yPos, 20, 20)];
        commentIconLabel.attributedText = [commentIcon attributedString];
        [commentIconLabel setTextAlignment:NSTextAlignmentCenter];
        [likeAndCommentContent addSubview:commentIconLabel];
        
        // reset comment label
        if (!self.commentLabel) {
            commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, yPos, cellWidth-25, 21)];
            commentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        }
        self.commentLabel.text = @"";
        [self.commentLabel setFrame:CGRectMake(25, yPos, cellWidth-25, 21)];
        self.commentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    
    while (commentIndex < [comments count]) {
        Comment *commentForLabel = comments[commentIndex];
        self.commentLabel.text = [self.commentLabel.text stringByAppendingString:[NSString stringWithFormat:@"%@ says \"%@\"\n", [commentForLabel.commenter getName], commentForLabel.comment]];
        commentLabel.text = [commentLabel.text stringByAppendingString:[NSString stringWithFormat:@"%@ says \"%@\"\n", [commentForLabel.commenter getName], commentForLabel.comment]];
        // update commentIndex
        commentIndex += 1;
    }
    
    // add to likeandcomment view
    [self.commentLabel sizeToFit];
    [commentLabel sizeToFit];
    [likeAndCommentContent addSubview:commentLabel];
    [self.commentLabel removeFromSuperview];
    [likeAndCommentContent addSubview:self.commentLabel];
    [likeAndCommentContent resizeToFitSubviews];
    
    // update yPos
    yPos = likeAndCommentContent.frame.size.height;
    
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
