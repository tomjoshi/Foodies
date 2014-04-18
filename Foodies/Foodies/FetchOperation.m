//
//  FetchOperation.m
//  Foodies
//
//  Created by Lucas Chwe on 4/17/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import "FetchOperation.h"
#import "FoodiesAPI.h"
#import "FoodiesDataStore.h"

@implementation FetchOperation

- (void)main
{
    NSManagedObjectContext *localMOC = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSConfinementConcurrencyType];
    FoodiesDataStore *dataStore = [FoodiesDataStore sharedInstance];
    localMOC.parentContext = dataStore.managedObjectContext;
    [FoodiesAPI fetchFoodPostsInManagedObjectContext:localMOC];
}
@end
