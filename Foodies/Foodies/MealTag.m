//
//  MealTag.m
//  Foodies
//
//  Created by Lucas Chwe on 3/28/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import "MealTag.h"
#import <FontAwesomeKit.h>
#import "UIColor+colorPallete.h"

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
        _isArrowUp = NO;
    }
    return self;
}

- (instancetype)initWithMeal:(Meal *)meal andPoint:(CGPoint)point
{
    self = [super init];
    if (self) {
        _meal = meal;
        _coordinates = point;
        _isArrowUp = NO;
    }
    return self;
}

- (void)showTagInView:(UIView *)view
{
    [self.popOver dismiss:YES];
    self.popOver = [[MenuPopOverView alloc] init];
    self.popOver.isArrowUp = self.isArrowUp;
    self.viewIn = view;
    [self.popOver presentPopoverFromRect:CGRectMake(self.coordinates.x, self.coordinates.y, 0, 0) inView:view withStrings:@[self.meal.name]];
}

- (void)makeTagEditable
{
    // make close icon
    FAKIonIcons *closeIcon = [FAKIonIcons closeCircledIconWithSize:18];
    [closeIcon addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor]];
    // make arrow up
    FAKIonIcons *arrowIcon;
    if (self.isArrowUp) {
        arrowIcon = [FAKIonIcons arrowDownBIconWithSize:18];
    } else {
        arrowIcon = [FAKIonIcons arrowUpBIconWithSize:18];
    }
    [arrowIcon addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor]];
    
    [self.popOver dismiss:NO];
    self.popOver = [[MenuPopOverView alloc] init];
    self.popOver.isArrowUp = self.isArrowUp;
    [self.popOver presentPopoverFromRect:CGRectMake(self.coordinates.x, self.coordinates.y, 0, 0) inView:self.viewIn withStrings:@[[arrowIcon attributedString],self.meal.name,[closeIcon attributedString]]];
}

- (void)stopTagEditable
{
    [self.popOver dismiss:NO];
    self.popOver = [[MenuPopOverView alloc] init];
    self.popOver.isArrowUp = self.isArrowUp;
    [self.popOver presentPopoverFromRect:CGRectMake(self.coordinates.x, self.coordinates.y, 0, 0) inView:self.viewIn withStrings:@[self.meal.name]];
}

- (void)toggleArrow
{
    if (self.isArrowUp) {
        self.isArrowUp = NO;
    } else {
        self.isArrowUp = YES;
    }
    [self makeTagEditable];
}
@end
