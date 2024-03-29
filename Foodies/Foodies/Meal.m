//
//  Meal.m
//  Foodies
//
//  Created by Lucas Chwe on 3/28/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import "Meal.h"

@implementation Meal

- (instancetype)initWithName:(NSString *)name FoodPost:(FoodPost *)foodPost Score:(NSNumber *)score mealId:(NSString *)mealId andVenue:(Venue *)venue
{
    self = [super init];
    if (self) {
        if (name) {
            _name = name;
        }
        if (foodPost) {
            _foodPosts = [NSSet setWithObject:foodPost];
        } else {
            _foodPosts = [[NSSet alloc] init];
        }
        if (score) {
            _score = score;
        }
        if (venue) {
            _venue = venue;
        }
        if (mealId) {
            _mealId = mealId;
        }
    }
    return self;
}

- (instancetype)init
{
    return [self initWithName:@"Lobster Roll" FoodPost:nil Score:nil mealId:nil andVenue:nil];
}

- (instancetype)initWithName:(NSString *)name andSPMealId:(NSString *)spMealId
{
    self = [self initWithName:name FoodPost:nil Score:nil mealId:nil andVenue:nil];
    self.spMealId = spMealId;
    return self;
}

@end
