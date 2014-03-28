//
//  FoodiesDataStore.h
//  Foodies
//
//  Created by Lucas Chwe on 3/28/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FoodiesDataStore : NSObject
@property (strong, nonatomic) NSMutableArray *tempPosts;
@property (nonatomic) BOOL newPost;

+ (instancetype)sharedInstance;
- (instancetype)init;
@end
