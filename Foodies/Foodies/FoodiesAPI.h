//
//  FoodiesAPI.h
//  Foodies
//
//  Created by Lucas Chwe on 4/10/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "FoodPost.h"

@interface FoodiesAPI : NSObject
// FoodPost related
+ (void)postFoodPost:(FoodPost *)newFoodPost inContext:(NSManagedObjectContext *)context;
+ (void)fetchFoodPostsInManagedObjectContext:(NSManagedObjectContext *)context;

// Foodie related
+ (void)signUpWithUsernameInBackground:(NSString *)username password:(NSString *)password email:(NSString *)email success:(void (^)(void))successBlock failure:(void (^)(NSError *error))failureBlock;
+ (void)logInWithUsernameInBackground:(NSString *)username password:(NSString *)password success:(void (^)(void))successBlock failure:(void (^)(NSError *error))failureBlock;
@end
