//
//  Foodie.m
//  Foodies
//
//  Created by Lucas Chwe on 3/7/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import "Foodie.h"

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
    // pull out the user from nsdefaults and create a foodie object of this user
    return [[Foodie alloc] init];
}

@end
