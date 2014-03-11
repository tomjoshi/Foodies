//
//  Comment.m
//  Foodies
//
//  Created by Lucas Chwe on 3/7/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import "Comment.h"

@implementation Comment
- (Comment *)init
{
    self = [super init];
    if (self) {
        _commenter = [[Foodie alloc] init];
        _comment = @"It looks so good! Wow I want some too! This is a much longer comment. You should check out @ippudo";
    }
    return self;
}
@end
