//
//  FSMealTag+Methods.m
//  Foodies
//
//  Created by Lucas Chwe on 4/16/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import "FSMealTag+Methods.h"

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
@end
