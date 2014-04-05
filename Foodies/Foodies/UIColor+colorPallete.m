//
//  UIColor+colorPallete.m
//  Foodies
//
//  Created by Lucas Chwe on 3/27/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import "UIColor+colorPallete.h"

@implementation UIColor (colorPallete)
+ (UIColor *)foodiesColor
{
    return [UIColor colorWithRed:0.741 green:0.239 blue:0.267 alpha:1.0];
}

+ (UIColor *)lighterGrayColor
{
    return [UIColor colorWithRed:0.792 green:0.792 blue:0.792 alpha:1.0];
}

+ (UIColor *)semiTransparentWhiteColor
{
    return [UIColor colorWithRed:1 green:1 blue:1 alpha:.5];
}
@end
