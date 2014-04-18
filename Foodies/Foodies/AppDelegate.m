//
//  AppDelegate.m
//  Foodies
//
//  Created by Lucas Chwe on 2/24/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import "AppDelegate.h"
#import <Foursquare2.h>
#import <Parse/Parse.h>
#import "Constants.h"
#import "FoodiesDataStore.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Foursquare2 setupFoursquareWithClientId:FOURSQUARE_CLIENTID
                                      secret:FOURSQUARE_SECRET
                                 callbackURL:FOURSQUARE_CALLBACKURL];
    
    [Parse setApplicationId:PARSE_APPID
                  clientKey:PARSE_CLIENTKEY];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    [[FoodiesDataStore sharedInstance].managedObjectContext save:nil];
    [[FoodiesDataStore sharedInstance].privateManagedObjectContext performBlock:^{
        [[FoodiesDataStore sharedInstance].privateManagedObjectContext save:nil];
    }];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
