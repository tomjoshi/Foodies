//
//  FSMealTag+Methods.m
//  Foodies
//
//  Created by Lucas Chwe on 4/16/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import "FSMealTag+Methods.h"
#import <FontAwesomeKit.h>

@implementation FSMealTag (Methods)

+ (FSMealTag *)initWithMealName:(NSString *)mealName mealId:(NSString *)mealId coordinateX:(NSNumber *)coordinateX coordinateY:(NSNumber *)coordinateY mealTagId:(NSString *)mealTagId andArrowUp:(NSNumber *)isArrowUp inContext:(NSManagedObjectContext *)context
{
    FSMealTag *fsMealTag;
    
    // check if exists, if it does, it needs to be updated
    NSPredicate *filterId = [NSPredicate predicateWithFormat:@"mealTagId == %@",mealTagId];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"FSMealTag"];
    request.predicate = filterId;
    NSArray *resultsArray = [context executeFetchRequest:request error:nil];
    
    if ([resultsArray count] == 0) {;
        fsMealTag = [NSEntityDescription insertNewObjectForEntityForName:@"FSMealTag" inManagedObjectContext:context];
    } else {
        fsMealTag = (FSMealTag *)resultsArray[0];
    }
    
    // set new properties
    if (mealId) {
        fsMealTag.mealId = mealId;
    }
    if (mealName) {
        fsMealTag.mealName = mealName;
    }
    if (coordinateX && coordinateY) {
        fsMealTag.coordinateX = coordinateX;
        fsMealTag.coordinateY = coordinateY;
    }
    if (mealTagId) {
        fsMealTag.mealTagId = mealTagId;
    }
    if (isArrowUp) {
        fsMealTag.isArrowUp = isArrowUp;
    }
    
    return fsMealTag;
}


- (MenuPopOverView *)showTagInView:(UIView *)view
{
//    [self.popOver dismiss:YES];
    MenuPopOverView *menuPopOver = [[MenuPopOverView alloc] init];
    menuPopOver.isArrowUp = [self.isArrowUp boolValue];
//    self.viewIn = view;
    [menuPopOver presentPopoverFromRect:CGRectMake([self.coordinateX floatValue], [self.coordinateY floatValue], 0, 0) inView:view withStrings:@[self.mealName]];
    return menuPopOver;
}

- (void)makeTagEditable:(MenuPopOverView *)popOver
{
    // make close icon
    FAKIonIcons *closeIcon = [FAKIonIcons closeCircledIconWithSize:18];
    [closeIcon addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor]];
    // make arrow up
    FAKIonIcons *arrowIcon;
    UIView *tempViewIn = [popOver superview];
    
    if ([self.isArrowUp boolValue]) {
        arrowIcon = [FAKIonIcons arrowDownBIconWithSize:18];
    } else {
        arrowIcon = [FAKIonIcons arrowUpBIconWithSize:18];
    }
    [arrowIcon addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor]];
    
    [popOver dismiss:NO];
    popOver = [[MenuPopOverView alloc] init];
    popOver.isArrowUp = [self.isArrowUp boolValue];
    [popOver presentPopoverFromRect:CGRectMake([self.coordinateX floatValue], [self.coordinateY floatValue], 0, 0) inView:tempViewIn withStrings:@[[arrowIcon attributedString],self.mealName,[closeIcon attributedString]]];
}

- (void)stopTagEditable:(MenuPopOverView *)popOver
{
    BOOL tempIsArrowUp = popOver.isArrowUp;
    UIView *tempViewIn = [popOver superview];
    
    [popOver dismiss:NO];
    popOver = [[MenuPopOverView alloc] init];
    popOver.isArrowUp = tempIsArrowUp;
    [popOver presentPopoverFromRect:CGRectMake([self.coordinateX floatValue], [self.coordinateY floatValue], 0, 0) inView:tempViewIn withStrings:@[self.mealName]];
}

- (void)toggleArrow:(MenuPopOverView *)popOver
{
    if ([self.isArrowUp boolValue]) {
        self.isArrowUp = @(NO);
    } else {
        self.isArrowUp = @(YES);
    }
    [self makeTagEditable:popOver];
}

@end
