//
//  FSMealTag+Methods.m
//  Foodies
//
//  Created by Lucas Chwe on 4/16/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import "FSMealTag+Methods.h"

@implementation FSMealTag (Methods)

+ (FSMealTag *)initWithMealName:(NSString *)mealName mealId:(NSString *)mealId coordinateX:(NSNumber *)coordinateX coordinateY:(NSNumber *)coordinateY andArrowUp:(NSNumber *)isArrowUp inContext:(NSManagedObjectContext *)context
{
    FSMealTag *fsMealTag = [NSEntityDescription insertNewObjectForEntityForName:@"FSMealTag" inManagedObjectContext:context];
    
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
    if (isArrowUp) {
        fsMealTag.isArrowUp = isArrowUp;
    }
    
    [context save:nil];
    return fsMealTag;
}
@end
