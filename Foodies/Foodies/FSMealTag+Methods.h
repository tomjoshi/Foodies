//
//  FSMealTag+Methods.h
//  Foodies
//
//  Created by Lucas Chwe on 4/16/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import "FSMealTag.h"

@interface FSMealTag (Methods)
+ (FSMealTag *)initWithMealName:(NSString *)mealName
                         mealId:(NSString *)mealId
                    coordinateX:(NSNumber *)coordinateX
                    coordinateY:(NSNumber *)coordinateY
                      mealTagId:(NSString *)mealTagId
                     andArrowUp:(NSNumber *)isArrowUp
                      inContext:(NSManagedObjectContext *)context;
@end
