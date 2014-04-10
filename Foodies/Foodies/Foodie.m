//
//  Foodie.m
//  Foodies
//
//  Created by Lucas Chwe on 3/7/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import "Foodie.h"
#import <Parse/Parse.h>
#import "FoodiesAPI.h"

@interface Foodie()
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) UIImage *profileImage;
@end

@implementation Foodie

- (instancetype)init
{
    self = [super init];
    if (self) {
        _profileImage = [UIImage imageNamed:@"profilepic"];
        _name = @"Lucas Chwe";
    }
    return self;
}

- (NSString *)getName
{
    return self.name;
}

- (UIImage *)getThumb
{
    UIImage *foodieThumb = self.profileImage;
    //do some thumb resizing
    
    return foodieThumb;
}

- (NSString *)getUserId
{
    PFUser *me = [PFUser currentUser];
    return me.objectId;
}

+ (Foodie *)me
{
    // maybe have a currentUser property instead of having to call PFUser
    PFUser *pfUser = [PFUser currentUser];
    if (pfUser) {
        // pull out the user from nsdefaults and create a foodie object of this user
        return [[Foodie alloc] init];
    }
    return nil;
}

+ (void)logOut
{
    // maybe make the currentUser be nil?
    [PFUser logOut];
}

+ (void)logInWithUsernameInBackground:(NSString *)username password:(NSString *)password success:(void (^)(void))successBlock failure:(void (^)(NSError *))failureBlock
{
    [FoodiesAPI logInWithUsernameInBackground:username
                                     password:password
                                      success:^{
                                          successBlock();
                                      }
                                      failure:^(NSError *error) {
                                          failureBlock(error);
                                      }];
}

+ (void)signUpWithUsernameInBackground:(NSString *)username password:(NSString *)password email:(NSString *)email success:(void (^)(void))successBlock failure:(void (^)(NSError *))failureBlock
{
    [FoodiesAPI signUpWithUsernameInBackground:username
                                      password:password
                                         email:email
                                       success:^{
                                           successBlock();
                                       }
                                       failure:^(NSError *error) {
                                           failureBlock(error);
                                       }];
}

@end
