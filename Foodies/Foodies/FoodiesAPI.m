//
//  FoodiesAPI.m
//  Foodies
//
//  Created by Lucas Chwe on 4/10/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import "FoodiesAPI.h"
#import "Foodie.h"

@implementation FoodiesAPI
+ (void)postFoodPost:(FoodPost *)newFoodPost
{
    PFObject *foodPostToPost = [PFObject objectWithClassName:@"FoodPost"];
    
    // post image first as file
    NSString *imageName = [NSString stringWithFormat:@"%@-%f.png", [newFoodPost.author getUserId], [[newFoodPost getDate] timeIntervalSince1970]];
    PFFile *imageFile = [PFFile fileWithName:imageName data:UIImagePNGRepresentation([newFoodPost getImage])];
    
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSLog(@"image was saved");
            
            // set image for post
            [foodPostToPost setObject:imageFile forKey:@"postImage"];
            
            // set date for post
            [foodPostToPost setObject:[newFoodPost getDate] forKey:@"postDate"];
            
            // set likes for post
            
            // set comments for post
            
            // set mealTags for post
            
            // Set the access control list to current user for security purposes
            foodPostToPost.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
            
            // relate author to post
            PFUser *user = [PFUser currentUser];
            PFRelation *userRelation = [foodPostToPost relationForKey:@"author"];
            [userRelation addObject:user];
            
            // relate venue to post
            
            
            [foodPostToPost saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    NSLog(@"%@", foodPostToPost.objectId);
                    // most likely add a block here
                } else {
                    // add failure block
                }
            }];
        }
    }];
}

+ (void)logInWithUsernameInBackground:(NSString *)username password:(NSString *)password success:(void (^)(void))successBlock failure:(void (^)(NSError *))failureBlock
{
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
        if (user) {
            successBlock();
        } else {
            failureBlock(error);
        }
    }];
}

+ (void)signUpWithUsernameInBackground:(NSString *)username password:(NSString *)password email:(NSString *)email success:(void (^)(void))successBlock failure:(void (^)(NSError *))failureBlock
{
    PFUser *user = [PFUser user];
    
    user.username = username;
    user.password = password;
    user.email = email;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Hooray! Let them use the app now.
            NSLog(@"signed up no problem!");
            successBlock();
        } else {
            failureBlock(error);
        }
    }];
}
@end
