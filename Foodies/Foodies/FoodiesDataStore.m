//
//  FoodiesDataStore.m
//  Foodies
//
//  Created by Lucas Chwe on 3/28/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import "FoodiesDataStore.h"
#import "FoodPost.h"

@implementation FoodiesDataStore


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.tempPosts = [NSMutableArray arrayWithArray:@[[[FoodPost alloc] init],[[FoodPost alloc] init],[[FoodPost alloc] init],[[FoodPost alloc] init],[[FoodPost alloc] init]]];
    }
    return self;
}

+ (instancetype)sharedInstance {
    static FoodiesDataStore *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[FoodiesDataStore alloc] init];
    });
    
    return _sharedInstance;
}

@end
