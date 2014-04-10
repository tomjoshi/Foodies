//
//  Foodie.h
//  Foodies
//
//  Created by Lucas Chwe on 3/7/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Foodie : NSObject

- (NSString *)getName;
- (UIImage *)getThumb;
- (instancetype)init;
- (NSString *)getUserId;

+ (Foodie *)me;
+ (void)logOut;
+ (void)logInWithUsernameInBackground:(NSString *)username password:(NSString *)password success:(void (^)(void))successBlock failure:(void (^)(NSError *error))failureBlock;
+ (void)signUpWithUsernameInBackground:(NSString *)username password:(NSString *)password email:(NSString *)email success:(void (^)(void))successBlock failure:(void (^)(NSError *error))failureBlock;

@end
