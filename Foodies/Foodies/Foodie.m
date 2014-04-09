//
//  Foodie.m
//  Foodies
//
//  Created by Lucas Chwe on 3/7/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import "Foodie.h"
#import <Parse/Parse.h>

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

+ (Foodie *)me
{
    PFUser *pfUser = [PFUser currentUser];
    if (pfUser) {
        // pull out the user from nsdefaults and create a foodie object of this user
        return [[Foodie alloc] init];
    }
    return nil;
}

+ (void)logOut
{
    [PFUser logOut];
}

+ (void)logInWithUsernameInBackground:(NSString *)username password:(NSString *)password success:(void (^)(void))successBlock failure:(void (^)(NSError *))failureBlock
{
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
        if (user) {
            successBlock();
        } else {
            failureBlock(error);
        }
    }];
}

+ (void)signUpWithUsernameInBackground:(NSString *)username password:(NSString *)password email:(NSString *)email success:(void (^)(void))successBlock failure:(void (^)(NSError *))failureBlock
{
    PFUser *user = [PFUser user];
    
    user.username = username;
    user.password = password;
    user.email = email;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Hooray! Let them use the app now.
            NSLog(@"signed up no problem!");
            successBlock();
        } else {
            failureBlock(error);
        }
    }];
}

@end
