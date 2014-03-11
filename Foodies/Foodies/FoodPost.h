//
//  FoodPost.h
//  Foodies
//
//  Created by Lucas Chwe on 3/7/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Foodie.h"

@interface FoodPost : NSObject
@property (strong, nonatomic) Foodie *author;

- (UIImage *)getImage;
- (NSDate *)getDate;
- (NSString *)getFormattedTime;
- (instancetype)init;
- (NSNumber *)getNumberOfLikes;
- (NSArray *)getComments;
- (BOOL)isLiked;
@end
