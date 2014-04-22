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
#import "UIColor+colorPallete.h"
#import <QuartzCore/QuartzCore.h>
#import "Like.h"
#import <SMCalloutView.h>
#import <WEPopoverController.h>
#import "MenuPopOverView.h"
#import "MealTag.h"
#import "FoodiesDataStore.h"
#import "FSLike+Methods.h"
#import "FSComment.h"
#import "FoodiesAPI.h"

@interface FeedTableViewCell () <MenuPopOverViewDelegate>
@property (strong, nonatomic) UIView *likesAndCommentsView;
@property (nonatomic) BOOL tagsAreVisible;
@property (strong, nonatomic) UIImage *image;

@end
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

- (void)configureWithFoodPost:(FSFoodPost *)foodPost
{
    for (UIView *view in self.contentView.subviews) {
        if (!(view == self.authorLabel || view == self.timeLabel || view == self.venueLabel)) {
            [view removeFromSuperview];
        }
    }
    
    // cache current foodPost and retrieve needed properties
    self.foodPostInCell = foodPost;
    UIImage *postImage = [foodPost getImage];
    NSString *postFormattedTime = [foodPost getFormattedTime];
    NSString *postAuthor = foodPost.authorName;
    NSString *postVenueName = foodPost.venueName;
    NSNumber *numberOfLikes = [foodPost getNumberOfLikes];
    UIImage *authorThumb = [foodPost getAuthorThumb];
    BOOL isLiked = [foodPost isLiked];
    NSArray *comments = [foodPost getComments];
//    NSArray *comments = @[];
    
    // setup variables
    CGFloat cellWidth = self.bounds.size.width;
    CGFloat labelHeight = 25;
    CGFloat profileRadius = 15;
    CGFloat timeLabelWidth = 80;
    CGFloat iconWidth = 10;
    CGFloat sidePadding = 8;
    CGFloat iconSidePadding = 6;
    CGFloat likesAndCommentsViewTopPadding = 5;
    CGFloat commentsTopPadding = 1;
    CGFloat heartIconTopPadding = 4;
    CGFloat commentIconTopPadding = 4;
    CGFloat buttonTopPadding = 8;
    CGFloat buttonSidePadding = 5;
    CGFloat buttonRadius = 2;
    CGFloat commentTopPadding = 1;
    NSArray *keys = [[NSArray alloc] initWithObjects:(id)kCTForegroundColorAttributeName,(id)kCTUnderlineStyleAttributeName, nil];
    NSArray *objects = [[NSArray alloc] initWithObjects:[UIColor foodiesColor],[NSNumber numberWithInt:kCTUnderlineStyleNone],nil];
    NSDictionary *linkAttributes = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
    
    // set profile image
    UIImageView *profileImageView = [[UIImageView alloc] initWithImage:authorThumb];
    [profileImageView setFrame:CGRectMake(sidePadding, (labelHeight*2-profileRadius*2)/2, profileRadius*2, profileRadius*2)];
    profileImageView.contentMode = UIViewContentModeScaleAspectFill;
    profileImageView.layer.cornerRadius = profileRadius;
    profileImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:profileImageView];
    
    // set author label
    [self.authorLabel setFrame:CGRectMake(2*sidePadding+profileRadius*2, 0, cellWidth-timeLabelWidth-3*sidePadding+profileRadius*2, labelHeight)];
    self.authorLabel.linkAttributes = linkAttributes;
    self.authorLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentBottom;
    self.authorLabel.text = postAuthor;
    self.authorLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    self.authorLabel.delegate = self;
    [self.authorLabel addLinkToURL:[NSURL URLWithString:@"http://github.com"] withRange:NSMakeRange(0, [self.authorLabel.text length])];
    
    // set time label
    [self.timeLabel setFrame:CGRectMake(cellWidth-timeLabelWidth-sidePadding, 0, timeLabelWidth, labelHeight)];
    self.timeLabel.text = postFormattedTime;
    self.timeLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentBottom;
    
    // set location label
    [self.venueLabel setFrame:CGRectMake(2*sidePadding+profileRadius*2, labelHeight, cellWidth-3*sidePadding-profileRadius*2, labelHeight)];
    self.venueLabel.linkAttributes = linkAttributes;
    self.venueLabel.text = postVenueName;
    self.venueLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;
    self.venueLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    self.venueLabel.delegate = self;
    [self.venueLabel addLinkToURL:[NSURL URLWithString:@"http://github.com"] withRange:NSMakeRange(0, [self.venueLabel.text length])];
    
    // set image
    UIImageView *postImageView = [[UIImageView alloc] initWithImage:postImage];
    self.postImageView = postImageView;
    [postImageView setFrame:CGRectMake(0, 2*labelHeight, cellWidth, cellWidth)];
    postImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:postImageView];
    
    // add single tap gesture recognizer
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showTags)];
    singleTap.numberOfTapsRequired = 1;
    [postImageView addGestureRecognizer:singleTap];
    
    // add double tap gesture recognizer
    UITapGestureRecognizer *doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likePost)];
    doubleTapGestureRecognizer.numberOfTapsRequired = 2;
    [postImageView addGestureRecognizer:doubleTapGestureRecognizer];
    
    // this is wrong but it works for now
    [self addGestureRecognizer:doubleTapGestureRecognizer];
    [self addGestureRecognizer:singleTap];
    
    // require double tap to fail for single tap to work
    [singleTap requireGestureRecognizerToFail:doubleTapGestureRecognizer];

    
    // set a subview for likes and comments
    UIView *likeAndCommentContent = [[UIView alloc] initWithFrame:CGRectMake(0, cellWidth+2*labelHeight+likesAndCommentsViewTopPadding, cellWidth, 0)];
    self.likesAndCommentsView = likeAndCommentContent;
    
    // set likes
    CGFloat yPos = 0;
    if (isLiked) {
        // set heart icon
        FAKFontAwesome *heartIcon = [FAKFontAwesome heartIconWithSize:iconWidth];
        [heartIcon addAttribute:NSForegroundColorAttributeName value:[UIColor lighterGrayColor]];
        UILabel *heartIconLabel = [[UILabel alloc] initWithFrame:CGRectMake(sidePadding, yPos+heartIconTopPadding, iconWidth, iconWidth)];
        [heartIconLabel setAttributedText:[heartIcon attributedString]];
        [likeAndCommentContent addSubview:heartIconLabel];
        
        // set number of likes
        self.likesLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(iconWidth+sidePadding+iconSidePadding, yPos, cellWidth-(iconWidth+2*sidePadding+iconSidePadding), 0)];
        TTTAttributedLabel *likesLabel = self.likesLabel;
        [likesLabel setFont:self.authorLabel.font];
        likesLabel.linkAttributes = linkAttributes;
        if ([numberOfLikes integerValue] == 1) {
            likesLabel.text = [NSString stringWithFormat:@"%@ like", numberOfLikes];
        } else {
            likesLabel.text = [NSString stringWithFormat:@"%@ likes", numberOfLikes];
        }
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
        [commentIcon addAttribute:NSForegroundColorAttributeName value:[UIColor lighterGrayColor]];
        UILabel *commentIconLabel = [[UILabel alloc] initWithFrame:CGRectMake(sidePadding, yPos+commentIconTopPadding, iconWidth, iconWidth)];
        [commentIconLabel setAttributedText:[commentIcon attributedString]];
        [likeAndCommentContent addSubview:commentIconLabel];
    }
    
    // set comment index
    NSInteger commentIndex = 0;
    
    while (commentIndex < [comments count]) {
        
        // set one comment
        FSComment *commentForLabel = comments[commentIndex];
        TTTAttributedLabel *commentLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(iconWidth+sidePadding+iconSidePadding, yPos, cellWidth-(iconWidth+2*sidePadding+iconSidePadding), 0)];
        [commentLabel setFont:self.authorLabel.font];
        commentLabel.numberOfLines = 0;
        commentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        commentLabel.linkAttributes = linkAttributes;
        commentLabel.text = [NSString stringWithFormat:@"%@ %@", [commentForLabel commenterName], commentForLabel.comment];
        
        // making the link
        commentLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
        commentLabel.delegate = self;
        [commentLabel addLinkToURL:[NSURL URLWithString:@"http://github.com"] withRange:NSMakeRange(0, [[commentForLabel commenterName] length])];
        
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
    [likeButton addTarget:self action:@selector(likePost) forControlEvents:UIControlEventTouchUpInside];
    likeButton.layer.cornerRadius = buttonRadius;
    likeButton.clipsToBounds = YES;
    [likeButton removeFromSuperview];
    [likeAndCommentContent addSubview:likeButton];
    
    // set comment button
    [self.commentButton setFrame:CGRectMake(sidePadding+self.likeButton.frame.size.width+buttonSidePadding, yPos + buttonTopPadding,  self.commentButton.frame.size.width, self.commentButton.frame.size.height)];
    UIButton *commentButton = self.commentButton;
    [commentButton addTarget:self action:@selector(commentPost) forControlEvents:UIControlEventTouchUpInside];
    commentButton.layer.cornerRadius = buttonRadius;
    commentButton.clipsToBounds = YES;
    [commentButton removeFromSuperview];
    [likeAndCommentContent addSubview:commentButton];
    
    // set more button
    [self.moreButton setFrame:CGRectMake(cellWidth-self.moreButton.frame.size.width-sidePadding, yPos + buttonTopPadding, self.moreButton.frame.size.width, self.moreButton.frame.size.height)];
    UIButton *moreButton = self.moreButton;
    moreButton.layer.cornerRadius = buttonRadius;
    moreButton.clipsToBounds = YES;
    [moreButton removeFromSuperview];
    [likeAndCommentContent addSubview:moreButton];
    
    // add like and comment subview
    [likeAndCommentContent resizeToFitSubviews];
    [self.contentView addSubview:likeAndCommentContent];
    
    // resize content view
    [self.contentView resizeToFitSubviews];

}

#pragma mark - Cell methods

- (void)likePost
{
    NSLog(@"isliked");
    
    [self.delegate like:self.indexPath completionBlock:^{
        [FoodiesAPI likeFoodPost:self.foodPostInCell withLikerName:[PFUser currentUser].username andLikerId:[Foodie getUserId] inContext:[FoodiesDataStore sharedInstance].managedObjectContext];
    }];
    
}

- (void)commentPost
{
    NSLog(@"wantstocomment");
    // push a comment view controller (or tableviewcontroller may be better)
}

//it should be "toggleTags", rather than "showTags", but oh well.
- (void)showTags
{
    // if tags are already showings, then hide them
    if (!self.tagsAreVisible && [[self.foodPostInCell getTags] count] > 0) {
        [self.delegate showTags:self.indexPath];
        self.tagsAreVisible = YES;
    } else if (self.tagsAreVisible) {
        [self.delegate hideTags:self.indexPath];
        self.tagsAreVisible = NO;
    }
}


@end
