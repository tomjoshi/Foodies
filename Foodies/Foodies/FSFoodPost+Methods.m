//
//  FSFoodPost+Methods.m
//  Foodies
//
//  Created by Lucas Chwe on 4/11/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import "FSFoodPost+Methods.h"
#import "NSDate+PrettyTimestamp.h"

@implementation FSFoodPost (Methods)

- (UIImage *)getImage
{
    return [UIImage imageWithData:self.postImage];
}

- (UIImage *)getAuthorThumb
{
    return [UIImage imageWithData:self.authorThumb];
}

- (NSDate *)getDate
{
    return self.postDate;
}


- (NSNumber *)getNumberOfLikes
{
    return @([self.likes count]);
}

- (NSArray *)getComments
{
    // gotta add some kind of chronological sorting, so i need to add nsdate property
    return [self.comments allObjects];
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

- (void)addLike:(FSLike *)newLike
{
    [self addLikesObject:newLike];
}

- (void)addComment:(FSComment *)newComment
{
    [self addCommentsObject:newComment];
}

- (NSSet *)getTags
{
    return self.mealTags;
}


@end
