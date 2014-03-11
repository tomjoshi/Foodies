//
//  Like.h
//  Foodies
//
//  Created by Lucas Chwe on 3/7/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Foodie.h"

@interface Like : NSObject
@property (strong, nonatomic) Foodie *liker;
@property (strong, nonatomic) NSDate *date;

- (Like *)init;
@end
