//
//  Meal.m
//  Foodies
//
//  Created by Lucas Chwe on 3/28/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import "Meal.h"

@implementation Meal

- (instancetype)initWithName:(NSString *)name FoodPost:(FoodPost *)foodPost Score:(NSNumber *)score andVenue:(Venue *)venue
{
    self = [super init];
    if (self) {
        _name = name;
        _foodPosts = [NSSet setWithObject:foodPost];
        _score = score;
        _venue = venue;
    }
    return self;
}

@end
