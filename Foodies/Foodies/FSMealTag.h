//
//  FSMealTag.h
//  Foodies
//
//  Created by Lucas Chwe on 4/22/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface FSMealTag : NSManagedObject

@property (nonatomic, retain) NSNumber * coordinateX;
@property (nonatomic, retain) NSNumber * coordinateY;
@property (nonatomic, retain) NSNumber * isArrowUp;
@property (nonatomic, retain) NSString * mealId;
@property (nonatomic, retain) NSString * mealName;
@property (nonatomic, retain) NSString * mealTagId;
@property (nonatomic, retain) NSString * mealSPId;

@end
