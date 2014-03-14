//
//  ALAsset+Date.m
//  Foodies
//
//  Created by Lucas Chwe on 3/14/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import "ALAsset+Date.h"

@implementation ALAsset (Date)

- (NSDate *) date
{
    return [self valueForProperty:ALAssetPropertyDate];
}
@end
