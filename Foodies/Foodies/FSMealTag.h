//
//  FSMealTag.h
//  Foodies
//
//  Created by Lucas Chwe on 4/11/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FSFoodPost;

@interface FSMealTag : NSManagedObject

@property (nonatomic, retain) NSNumber * coordinateX;
@property (nonatomic, retain) NSNumber * coordinateY;
@property (nonatomic, retain) NSNumber * isArrowUp;
@property (nonatomic, retain) NSString * mealName;
@property (nonatomic, retain) NSString * mealId;
@property (nonatomic, retain) FSFoodPost *foodPost;

@end
