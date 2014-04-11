//
//  FoodPost.m
//  Foodies
//
//  Created by Lucas Chwe on 3/7/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import "FoodPost.h"
#import "Like.h"
#import "Comment.h"
#import "NSDate+PrettyTimestamp.h"
#import "MealTag.h"
#import "FoodiesAPI.h"


@interface FoodPost()
@property (strong, nonatomic) UIImage *postImage;
@property (strong, nonatomic) NSDate *postDate;
@property (strong, nonatomic) NSMutableArray *likes;
@property (strong, nonatomic) NSMutableArray *comments;
@property (strong, nonatomic) NSSet *mealTags;

@end


@implementation FoodPost

- (instancetype)init
{
    self = [super init];
    if (self) {
        _postImage = [UIImage imageNamed:@"ramenImage"];
        _postDate = [NSDate date];
        _author = [[Foodie alloc] init];
        _likes = [NSMutableArray arrayWithArray:@[[[Like alloc] init], [[Like alloc] init]]];
        _comments = [NSMutableArray arrayWithArray:@[[[Comment alloc] init],[[Comment alloc] init],[[Comment alloc] init]]];
        _venue = [[Venue alloc] initWithName:@"Ramen Palace" foursquareId:@"" location:nil];
        _mealTags = [[NSSet alloc] init];
        
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image Author:(Foodie *)author Caption:(Comment *)caption atVenue:(Venue *)venue andMealTags:(NSSet *)mealTags
{
    self = [super init];
    if (self) {
        _postImage = image;
        _postDate = [NSDate date];
        _author = author;
        _likes = [[NSMutableArray alloc] init];
        if (caption.commenter) {
            _comments = [NSMutableArray arrayWithArray:@[caption]];
        } else {
            _comments = [[NSMutableArray alloc] init];
        }
        _venue = venue;
        _mealTags = mealTags;
    }
    
    return self;
}

- (NSDate *)getDate
{
    return self.postDate;
}

- (void)setPostDate:(NSDate *)postDate
{
    _postDate = postDate;
}

- (UIImage *)getImage
{
    return self.postImage;
}

- (NSNumber *)getNumberOfLikes
{
    return @([self.likes count]);
}

- (NSArray *)getComments
{
    return self.comments;
}

- (BOOL)isLiked
{
    if ([self.likes count] > 0) {
        return YES;
    }
    return NO;
}

- (NSString *)getFormattedTime
{
    return [self.postDate prettyTimestampSinceNow];
}

- (void)addLike:(Like *)newLike
{
    [self.likes addObject:newLike];
}

- (void)addComment:(Comment *)newComment
{
    [self.comments addObject:newComment];
}

- (NSSet *)getTags
{
    return self.mealTags;
}

@end
