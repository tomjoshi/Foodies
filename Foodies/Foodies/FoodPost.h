//
//  FoodPost.h
//  Foodies
//
//  Created by Lucas Chwe on 3/7/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Foodie.h"
#import "Venue.h"
#import "Comment.h"
#import "Like.h"

@interface FoodPost : NSObject
@property (strong, nonatomic) Foodie *author;
@property (strong, nonatomic) Venue *venue;

- (instancetype)initWithImage:(UIImage *)image Author:(Foodie *)author Caption:(Comment *)caption atVenue:(Venue *)venue andMealTags:(NSSet *)mealTags;
- (UIImage *)getImage;
- (NSDate *)getDate;
- (NSString *)getFormattedTime;
- (instancetype)init;
- (NSNumber *)getNumberOfLikes;
- (NSArray *)getComments;
- (BOOL)isLiked;
- (void)addLike:(Like *)newLike;
- (void)addComment:(Comment *)newComment;
@end
