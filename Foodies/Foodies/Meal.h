//
//  Meal.h
//  Foodies
//
//  Created by Lucas Chwe on 3/28/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Venue.h"
#import "FoodPost.h"

@interface Meal : NSObject
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSSet *foodPosts;
@property (strong, nonatomic) Venue *venue;
@property (strong, nonatomic) NSNumber *score;

// properties missing: tips, wants, meal id


- (instancetype)initWithName:(NSString *)name FoodPost:(FoodPost *)foodPost Score:(NSNumber *)score andVenue:(Venue *)venue;
@end
