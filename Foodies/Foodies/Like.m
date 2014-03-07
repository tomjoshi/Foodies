//
//  Like.m
//  Foodies
//
//  Created by Lucas Chwe on 3/7/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import "Like.h"

@implementation Like


- (Like *)init
{
    self = [super init];
    if (self) {
        _liker = [[Foodie alloc] init];
        _date = [[NSDate alloc] init];
    }
    return self;
}
@end
