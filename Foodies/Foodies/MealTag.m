//
//  MealTag.m
//  Foodies
//
//  Created by Lucas Chwe on 3/28/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import "MealTag.h"
#import <FontAwesomeKit.h>

@interface MealTag()
@property (strong, nonatomic) UIView *viewIn;

@end

@implementation MealTag
- (instancetype)init
{
    self = [super init];
    if (self) {
        _meal = [[Meal alloc] init];
        _coordinates = CGPointMake(0, 0);
    }
    return self;
}

- (instancetype)initWithName:(NSString *)name andPoint:(CGPoint)point
{
    self = [super init];
    if (self) {
        _meal = [[Meal alloc] initWithName:name FoodPost:nil Score:nil mealId:nil andVenue:nil];
        _coordinates = point;
    }
    return self;
}

- (void)showTagInView:(UIView *)view
{
    [self.popOver dismiss:YES];
    self.popOver = [[MenuPopOverView alloc] init];
    self.viewIn = view;
    [self.popOver presentPopoverFromRect:CGRectMake(self.coordinates.x, self.coordinates.y, 0, 0) inView:view withStrings:@[self.meal.name]];
}

- (void)makeTagEditable
{
    // make close icon
    FAKIonIcons *closeIcon = [FAKIonIcons closeCircledIconWithSize:18];
    [closeIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    [self.popOver dismiss:NO];
    self.popOver = [[MenuPopOverView alloc] init];
    [self.popOver presentPopoverFromRect:CGRectMake(self.coordinates.x, self.coordinates.y, 0, 0) inView:self.viewIn withStrings:@[self.meal.name,[closeIcon attributedString]]];
}

- (void)stopTagEditable
{
    [self.popOver dismiss:NO];
    self.popOver = [[MenuPopOverView alloc] init];
    [self.popOver presentPopoverFromRect:CGRectMake(self.coordinates.x, self.coordinates.y, 0, 0) inView:self.viewIn withStrings:@[self.meal.name]];
}

@end
