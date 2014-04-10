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
    NSString *imageName = [NSString stringWithFormat:@"%@-%f.png", [newFoodPost.author getUserId], [[NSDate date] timeIntervalSince1970]];
    PFFile *imageFile = [PFFile fileWithName:imageName data:UIImagePNGRepresentation([newFoodPost getImage])];
    
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSLog(@"image was saved");
            PFUser *user = [PFUser currentUser];
            
            // set image for post
            [foodPostToPost setObject:imageFile forKey:@"postImage"];
            
            // set likes for post
            [foodPostToPost setObject:@[] forKey:@"likes"];
            
            // set comments for post
            if ([[newFoodPost getComments] count] == 1) {
                Comment *caption = (Comment *)[newFoodPost getComments][0];
                PFObject *pfCaption = [PFObject objectWithClassName:@"comment"];
                
                // make it a caption
                [pfCaption setObject:@(YES) forKey:@"isCaption"];
                
                // set the comment text
                [pfCaption setObject:caption.comment forKey:@"comment"];
                
                // relate author to his own caption
                PFRelation *userRelation = [pfCaption relationForKey:@"commenter"];
                [userRelation addObject:user];
                
                [foodPostToPost setObject:@[pfCaption] forKey:@"comments"];
            } else {
                [foodPostToPost setObject:@[] forKey:@"comments"];
            }
            
            // set mealTags for post
            
            // Set the access control list to current user for security purposes
            foodPostToPost.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
            
            // relate author to post
            PFRelation *userRelation = [foodPostToPost relationForKey:@"author"];
            [userRelation addObject:user];
            
            // relate venue to post
            [FoodiesAPI pfObjectForVenue:newFoodPost.venue completion:^(PFObject *pfVenue) {
                // in the case that the user did not select a venue
                if (pfVenue) {
                    PFRelation *venueRelation = [foodPostToPost relationForKey:@"venue"];
                    [venueRelation addObject:pfVenue];
                }
                
                [foodPostToPost saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error) {
                        NSLog(@"%@", foodPostToPost.objectId);
                        // retrieve objectId for postId
                        [newFoodPost setPostId:foodPostToPost.objectId];
                        NSLog(@"%@", foodPostToPost.createdAt);
                        // retrieve createdAt for postDate
                        [newFoodPost setPostDate:foodPostToPost.createdAt];
                        
                        // most likely add a block here
                    } else {
                        // add failure block
                    }
                }];
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

+ (void)pfObjectForVenue:(Venue *)venue completion:(void (^)(PFObject *pfVenue))completionBlock
{
    if (venue) {
        PFQuery *query = [PFQuery queryWithClassName:@"Venue"];
        [query whereKey:@"foursquareId" equalTo:venue.foursquareId];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if ([objects count] == 1) {
                NSLog(@"venue was found");
                PFObject *foundVenue = objects[0];
                completionBlock(foundVenue);
            } else {
                NSLog(@"venue was not found");
                PFObject *newVenue = [PFObject objectWithClassName:@"Venue"];
                [newVenue setObject:venue.name forKey:@"name"];
                [newVenue setObject:venue.foursquareId forKey:@"foursquareId"];
                // make pfobject for location
                PFObject *locationForNewVenue = [PFObject objectWithClassName:@"Location"];
                [locationForNewVenue setObject:venue.location.lat forKey:@"lat"];
                [locationForNewVenue setObject:venue.location.lng forKey:@"lng"];
                [locationForNewVenue setObject:venue.location.address forKey:@"address"];
                [locationForNewVenue setObject:venue.location.city forKey:@"city"];
                [locationForNewVenue setObject:venue.location.state forKey:@"state"];
                [locationForNewVenue setObject:venue.location.postalCode forKey:@"postalCode"];
                [locationForNewVenue setObject:venue.location.country forKey:@"country"];
                [locationForNewVenue setObject:venue.location.crossStreet forKey:@"crossStreet"];
                [newVenue setObject:locationForNewVenue forKey:@"location"];
                
                [newVenue saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error) {
                        completionBlock(newVenue);
                    }
                }];
            }
        }];
    } else {
        completionBlock(nil);
    }
    

}



@end
