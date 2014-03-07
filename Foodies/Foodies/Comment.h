//
//  Comment.h
//  Foodies
//
//  Created by Lucas Chwe on 3/7/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Foodie.h"

@interface Comment : NSObject
@property (strong, nonatomic) Foodie *commenter;
@property (strong, nonatomic) NSString *comment;

- (Comment *)init;
@end
