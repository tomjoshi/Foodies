//
//  FoodiesDataStore.h
//  Foodies
//
//  Created by Lucas Chwe on 3/28/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface FoodiesDataStore : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectContext *privateManagedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@property (strong, nonatomic) NSMutableArray *tempPosts;
@property (strong, nonatomic) NSMutableDictionary *cachedPostImages;
@property (nonatomic) BOOL newPost;

+ (instancetype)sharedInstance;
- (instancetype)init;
@end
