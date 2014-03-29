//
//  MealTag.m
//  Foodies
//
//  Created by Lucas Chwe on 3/28/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import "MealTag.h"

@implementation MealTag
- (instancetype)init
{
    self = [super init];
    if (self) {
        _meal = [[Meal alloc] init];
        _coordinates = CGPointMake(0, 0);
    }
    return self;
}
@end
