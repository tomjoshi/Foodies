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
    for (UIView *view in self.contentView.subviews) {
        if (!(view == self.authorLabel || view == self.timeLabel)) {
            [view removeFromSuperview];
        }
    }
    
    UIImage *postImage = [foodPost getImage];
    NSString *postFormattedTime = [foodPost getFormattedTime];
    NSString *postAuthor = [foodPost.author getName];
    NSNumber *numberOfLikes = [foodPost getNumberOfLikes];
    BOOL isLiked = [foodPost isLiked];
    NSArray *comments = [foodPost getComments];
    //    UIImage *authorThumb = [foodPost.author getThumb];
    
    // setup variables
    CGFloat cellWidth = self.bounds.size.width;
    CGFloat iconWidth = 10;
    CGFloat sidePadding = 5;
    CGFloat likesAndCommentsViewTopPadding = 7;
    CGFloat commentsTopPadding = 0;
    CGFloat heartIconTopPadding = 0;
    CGFloat commentIconTopPadding = 0;
    CGFloat buttonTopPadding = 5;
    CGFloat buttonSidePadding = 5;
    CGFloat commentTopPadding = 1;
    NSArray *keys = [[NSArray alloc] initWithObjects:(id)kCTForegroundColorAttributeName,(id)kCTUnderlineStyleAttributeName, (id)kCTFontAttributeName, nil];
    NSArray *objects = [[NSArray alloc] initWithObjects:[UIColor blueColor],[NSNumber numberWithInt:kCTUnderlineStyleNone], [UIFont fontWithName:@"HelveticaNeue" size:14],nil];
    NSDictionary *linkAttributes = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
    
    // set author label
    [self.authorLabel setFrame:CGRectMake(sidePadding, 0, cellWidth-70-2*sidePadding, 40)];
    self.authorLabel.text = postAuthor;
    
    // set time label
    [self.timeLabel setFrame:CGRectMake(cellWidth-70+sidePadding, 0, 70-2*sidePadding, 40)];
    self.timeLabel.text = postFormattedTime;
    
    // set image
    UIImageView *postImageView = [[UIImageView alloc] initWithImage:postImage];
    [postImageView setFrame:CGRectMake(0, 40, cellWidth, cellWidth)];
    postImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:postImageView];
    
    // set a subview for likes and comments
    UIView *likeAndCommentContent = [[UIView alloc] initWithFrame:CGRectMake(0, cellWidth+40+likesAndCommentsViewTopPadding, cellWidth, 0)];
    
    // set likes
    CGFloat yPos = 0;
    if (isLiked) {
        // set heart icon
        FAKFontAwesome *heartIcon = [FAKFontAwesome heartIconWithSize:iconWidth];
        [heartIcon addAttribute:NSForegroundColorAttributeName value:[UIColor redColor]];
        UILabel *heartIconLabel = [[UILabel alloc] initWithFrame:CGRectMake(sidePadding, yPos+heartIconTopPadding, iconWidth, iconWidth)];
        [heartIconLabel setAttributedText:[heartIcon attributedString]];
        [likeAndCommentContent addSubview:heartIconLabel];
        
        // set number of likes
        TTTAttributedLabel *likesLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(iconWidth+sidePadding*2, yPos, cellWidth-iconWidth-3*sidePadding, 0)];
        [likesLabel setFont:self.authorLabel.font];
        likesLabel.linkAttributes = linkAttributes;
        likesLabel.text = [NSString stringWithFormat:@"%@ likes", numberOfLikes];
        likesLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
        likesLabel.delegate = self;
        [likesLabel addLinkToURL:[NSURL URLWithString:@"http://github.com"] withRange:NSMakeRange(0, [likesLabel.text length])];
        [likesLabel sizeToFit];
        [likeAndCommentContent addSubview:likesLabel];
        
        
        // update yPos
        yPos = likesLabel.bounds.size.height;
    }
    
    // add commentsTopPadding to yPos
    yPos += commentsTopPadding;
    
    // set comment icon if needed
    if ([comments count] > 0) {
        FAKFontAwesome *commentIcon = [FAKFontAwesome commentIconWithSize:10];
        [commentIcon addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor]];
        UILabel *commentIconLabel = [[UILabel alloc] initWithFrame:CGRectMake(sidePadding, yPos+commentIconTopPadding, iconWidth, iconWidth)];
        [commentIconLabel setAttributedText:[commentIcon attributedString]];
        [likeAndCommentContent addSubview:commentIconLabel];
    }
    
    // set comment index
    NSInteger commentIndex = 0;
    
    while (commentIndex < [comments count]) {
        
        // set one comment
        Comment *commentForLabel = comments[commentIndex];
        TTTAttributedLabel *commentLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(iconWidth+2*sidePadding, yPos, cellWidth-iconWidth-3*sidePadding, 21)];
        [commentLabel setFont:self.authorLabel.font];
        commentLabel.numberOfLines = 0;
        commentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        commentLabel.linkAttributes = linkAttributes;
        commentLabel.text = [NSString stringWithFormat:@"%@ %@", [commentForLabel.commenter getName], commentForLabel.comment];
        
        // making the link
        commentLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
        commentLabel.delegate = self;
        [commentLabel addLinkToURL:[NSURL URLWithString:@"http://github.com"] withRange:NSMakeRange(0, [[commentForLabel.commenter getName] length])];
        
        [commentLabel sizeToFit];
        
        // add 1 more point to the height so the bold text fits.
        [commentLabel setFrame:CGRectMake(commentLabel.frame.origin.x, commentLabel.frame.origin.y, commentLabel.frame.size.width, commentLabel.frame.size.height+1)];
        
        [likeAndCommentContent addSubview:commentLabel];
        
        // update yPos
        yPos += commentLabel.bounds.size.height + commentTopPadding;
        
        // update commentIndex
        commentIndex += 1;
    }
    
    // update yPos
    yPos -= commentTopPadding;
    
    // set like button
    [self.likeButton setFrame:CGRectMake(sidePadding, yPos + buttonTopPadding, self.likeButton.frame.size.width, self.likeButton.frame.size.height)];
    UIButton *likeButton = self.likeButton;
    [likeButton removeFromSuperview];
    [likeAndCommentContent addSubview:likeButton];
    
    // set comment button
    [self.commentButton setFrame:CGRectMake(sidePadding+self.likeButton.frame.size.width+buttonSidePadding, yPos + buttonTopPadding,  self.commentButton.frame.size.width, self.commentButton.frame.size.height)];
    UIButton *commentButton = self.commentButton;
    [commentButton setTitle:@"Comment" forState:UIControlStateNormal];
    [commentButton removeFromSuperview];
    [likeAndCommentContent addSubview:commentButton];
    
    // set more button
    [self.moreButton setFrame:CGRectMake(cellWidth-self.moreButton.frame.size.width-sidePadding, yPos + buttonTopPadding, self.moreButton.frame.size.width, self.moreButton.frame.size.height)];
    UIButton *moreButton = self.moreButton;
    [moreButton setTitle:@"..." forState:UIControlStateNormal];
    [moreButton removeFromSuperview];
    [likeAndCommentContent addSubview:moreButton];
    
    // add like and comment subview
    [likeAndCommentContent resizeToFitSubviews];
    [self.contentView addSubview:likeAndCommentContent];
    
    // resize content view
    [self.contentView resizeToFitSubviews];

    

}


@end
