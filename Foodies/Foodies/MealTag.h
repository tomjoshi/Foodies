//
//  MealTag.h
//  Foodies
//
//  Created by Lucas Chwe on 3/28/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Meal.h"
#import "MenuPopOverView.h"

@interface MealTag : NSObject
@property (nonatomic) CGPoint coordinates;
@property (strong, nonatomic) Meal *meal;
@property (strong, nonatomic) MenuPopOverView *popOver;


- (instancetype)initWithName:(NSString*)name andPoint:(CGPoint)point;
- (void)showTagInView:(UIView *)view;
- (void)makeTagEditable;
- (void)stopTagEditable;
@end