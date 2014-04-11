//
//  FSFoodPost+Methods.h
//  Foodies
//
//  Created by Lucas Chwe on 4/11/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import "FSFoodPost.h"

@interface FSFoodPost (Methods)

- (UIImage *)getImage;
- (UIImage *)getAuthorThumb;
- (NSDate *)getDate;
- (NSString *)getFormattedTime;
- (NSNumber *)getNumberOfLikes;
- (NSArray *)getComments;
- (BOOL)isLiked;
- (void)addLike:(FSLike *)newLike;
- (void)addComment:(FSComment *)newComment;
- (NSSet *)getTags;

@end
