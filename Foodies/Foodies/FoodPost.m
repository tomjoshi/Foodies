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

@interface FoodPost()
@property (strong, nonatomic) UIImage *postImage;
@property (strong, nonatomic) NSDate *postDate;
@property (strong, nonatomic) NSMutableArray *likes;
@property (strong, nonatomic) NSMutableArray *comments;

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
        
    }
    return self;
}

- (NSDate *)getDate
{
    return self.postDate;
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
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    return [dateFormatter stringFromDate:self.postDate];
}

@end
