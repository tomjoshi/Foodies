//
//  FoodiesAPI.m
//  Foodies
//
//  Created by Lucas Chwe on 4/10/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import "FoodiesAPI.h"
#import "FSFoodPost+Methods.h"
#import "FSLike+Methods.h"
#import "FSMealTag+Methods.h"

@implementation FoodiesAPI

+ (void)postFoodPost:(FoodPost *)newFoodPost inContext:(NSManagedObjectContext *)context completion:(void (^)(void))completionBlock
{
    PFObject *foodPostToPost = [PFObject objectWithClassName:@"FoodPost"];
    
    // post image first as file
    NSString *imageName = [NSString stringWithFormat:@"%@-%f.png", [Foodie getUserId], [[NSDate date] timeIntervalSince1970]];
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
                PFObject *pfCaption = [PFObject objectWithClassName:@"Comment"];
                
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
            
            // Set the access control list to current user for security purposes
            foodPostToPost.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
            [foodPostToPost.ACL setPublicReadAccess:YES];
            [foodPostToPost.ACL setPublicWriteAccess:YES];
            
            // relate author to post
            PFRelation *userRelation = [foodPostToPost relationForKey:@"author"];
            [userRelation addObject:user];
            
            // get the PFObject of the venue
            [FoodiesAPI pfObjectForVenue:newFoodPost.venue completion:^(PFObject *pfVenue) {
                // in the case that the user did not select a venue
                if (pfVenue) {
                    // relate venue to post
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
                        
                        // set mealTags for post
                        if ([[newFoodPost getTags] count] > 0) {
                            for (FSMealTag *mealTag in [newFoodPost getTags]) {
                                PFObject *pfMealTag = [PFObject objectWithClassName:@"MealTag"];
                                // set the coordinates
                                [pfMealTag setObject:@[mealTag.coordinateX, mealTag.coordinateY] forKey:@"coordinates"];
                                // set if arrow is up
                                [pfMealTag setObject:@([mealTag.isArrowUp boolValue]) forKey:@"isArrowUp"];
                                
                                Meal *tempMeal = [[Meal alloc] initWithName:mealTag.mealName FoodPost:newFoodPost Score:nil mealId:nil andVenue:newFoodPost.venue];
                                tempMeal.spMealId = mealTag.mealSPId;
                                
                                // set meal
                                [FoodiesAPI pfObjectForMeal:tempMeal atPFVenue:pfVenue completion:^(PFObject *pfMeal) {
                                    [pfMealTag setObject:pfMeal forKey:@"meal"];
                                    mealTag.mealId = pfMeal.objectId;
                                    [foodPostToPost addObject:pfMealTag forKey:@"mealTags"];
                                    PFRelation *foodPostRelation = [pfMeal relationForKey:@"foodPosts"];
                                    [foodPostRelation addObject:foodPostToPost];
                                    [PFObject saveAllInBackground:@[pfMeal, foodPostToPost]block:^(BOOL succeeded, NSError *error) {
                                        NSArray *postedMealTags = [foodPostToPost objectForKey:@"mealTags"];
                                        if ([postedMealTags count] == [[[newFoodPost getTags] allObjects] count]) {
                                            completionBlock();
                                        }
                                    }];
                                }];
                            }
                        } else {
                            completionBlock();
                        }
                    } else {
                        // add failure block here if needed
                    }
                }];
            }];
        }
    }];
}

+ (void)fetchFoodPostsInManagedObjectContext:(NSManagedObjectContext *)context
{
    PFQuery *query = [PFQuery queryWithClassName:@"FoodPost"];
    [query setLimit:20];
    [query addDescendingOrder:@"createdAt"];
    [query includeKey:@"comments"];
    [query includeKey:@"likes"];
    [query includeKey:@"mealTags"];
    [query includeKey:@"mealTags.meal"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *pfFoodPost in objects) {
                NSMutableDictionary *foodPostToAdd = [[NSMutableDictionary alloc] init];
                
                [foodPostToAdd setObject:pfFoodPost.objectId forKey:@"postId"];
                [foodPostToAdd setObject:pfFoodPost.createdAt forKey:@"postDate"];
                
                PFFile *postImageFile = [pfFoodPost objectForKey:@"postImage"];
                [postImageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    if (!error) {
                        // save postImage data
                        [foodPostToAdd setObject:data forKey:@"postImage"];
                        
                        // get venue info
                        PFRelation *venueRelation = (PFRelation *)pfFoodPost[@"venue"];
                        [[venueRelation query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                            if ([objects count] > 0) {
                                PFObject *venue = objects[0];
                                [foodPostToAdd setObject:[venue objectForKey:@"name"] forKey:@"venueName"];
                                [foodPostToAdd setObject:venue.objectId forKey:@"venueId"];
                                [FSFoodPost initWithDictionary:foodPostToAdd inContext:context];
                            }
                        }];
                        
                        // get mealtags
                        if ([pfFoodPost[@"mealTags"] count] > 0) {
                            NSMutableArray *mealTags = [[NSMutableArray alloc] init];
                            for (PFObject *mealTag in pfFoodPost[@"mealTags"]) {
                                NSMutableDictionary *mealTagToAdd = [[NSMutableDictionary alloc] init];
                                [mealTagToAdd setObject:[mealTag objectForKey:@"isArrowUp"] forKey:@"isArrowUp"];
                                [mealTagToAdd setObject:[mealTag objectForKey:@"coordinates"][0] forKey:@"coordinateX"];
                                [mealTagToAdd setObject:[mealTag objectForKey:@"coordinates"][1] forKey:@"coordinateY"];
                                [mealTagToAdd setObject:mealTag.objectId forKey:@"mealTagId"];
                                PFObject *pfMeal = [mealTag objectForKey:@"meal"];
                                
                                [mealTagToAdd setObject:[pfMeal objectForKey:@"name"] forKey:@"mealName"];
                                [mealTagToAdd setObject:pfMeal.objectId forKey:@"mealId"];
                                
                                // add mealtag to mealtags array
                                [mealTags addObject:mealTagToAdd];
                            }
                            [foodPostToAdd setObject:mealTags forKey:@"mealTags"];
                        }
                        
                        // get comments
                        if ([pfFoodPost[@"comments"] count] > 0) {
                            NSMutableArray *comments = [[NSMutableArray alloc] init];
                            for (PFObject *comment in pfFoodPost[@"comments"]) {
                                NSMutableDictionary *commentToAdd = [[NSMutableDictionary alloc] init];
                                
                                PFRelation *commenterRelation = (PFRelation *)comment[@"commenter"];
                                 [[commenterRelation query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                                    if (!error) {
                                        PFUser *commenter = objects[0];
                                        [commentToAdd setObject:[commenter objectForKey:@"username"] forKey:@"commenterName"];
                                        [commentToAdd setObject:commenter.objectId forKey:@"commenterId"];
                                        [commentToAdd setObject:comment.createdAt forKey:@"commentDate"];
                                        [commentToAdd setObject:[comment objectForKey:@"comment"] forKey:@"comment"];
                                        [commentToAdd setObject:[comment objectForKey:@"isCaption"] forKey:@"isCaption"];
                                        [commentToAdd setObject:comment.objectId forKey:@"commentId"];
                                        [FSFoodPost initWithDictionary:foodPostToAdd inContext:context];
                                        
                                        // add comment to comments array
                                        [comments addObject:commentToAdd];
                                    }
                                }];
                        
                            }
                            [foodPostToAdd setObject:comments forKey:@"comments"];
                        }
                        
                        // get likes
                        if ([pfFoodPost[@"likes"] count] > 0) {
                            NSMutableArray *likes = [[NSMutableArray alloc] init];
                            for (PFObject *like in pfFoodPost[@"likes"]) {
                                NSMutableDictionary *likeToAdd = [[NSMutableDictionary alloc] init];
                                
                                [likeToAdd setObject:[like objectForKey:@"likerName"] forKey:@"likerName"];
                                [likeToAdd setObject:[like objectForKey:@"likerId"] forKey:@"likerId"];
                                [likeToAdd setObject:like.objectId forKey:@"likeId"];
                                [likeToAdd setObject:like.createdAt forKey:@"likeDate"];
                                
                                // add like to likes array
                                [likes addObject:likeToAdd];
                            }
                            [foodPostToAdd setObject:likes forKey:@"likes"];
                        }
                        
                        // get author info
                        PFRelation *authorRelation = (PFRelation *)pfFoodPost[@"author"];
                        [[authorRelation query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                            PFUser *author = objects[0];
                            [foodPostToAdd setObject:[author objectForKey:@"username"] forKey:@"authorName"];
                            [foodPostToAdd setObject:author.objectId forKey:@"authorId"];
                            
                            
                            PFFile *authorThumb = [author objectForKey:@"thumb"];
                            [authorThumb getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                                if (!error) {
                                    [foodPostToAdd setObject:data forKey:@"authorThumb"];
                                    [FSFoodPost initWithDictionary:foodPostToAdd inContext:context];
                                }
                            }];
                        }];
                        
                        // get author thumb. i need to set up author thumbnails first
                        //                        PFFile *authorThumbFile = [author objectForKey:@"thumb"]
                        
                        // ideally insert entity here. let the category method take care of that. since it can be updated if it exists in coredata already.
                        // compare with foodpostid, which is the objectid
                        
                        [FSFoodPost initWithDictionary:foodPostToAdd inContext:context];
                    }
                }];
            }
        }
    }];
}

+ (void)logInWithUsernameInBackground:(NSString *)username password:(NSString *)password success:(void (^)(void))successBlock failure:(void (^)(NSError *))failureBlock
{
    [PFUser logInWithUsernameInBackground:[username lowercaseString] password:password block:^(PFUser *user, NSError *error) {
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
    
    user.username = [username lowercaseString];
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

+ (void)pfObjectForMeal:(Meal *)meal atPFVenue:(PFObject *)pfVenue completion:(void (^)(PFObject *pfMeal))completionBlock
{
    if (meal) {
        PFQuery *query = [PFQuery queryWithClassName:@"Meal"];
        [query whereKey:@"spMealId" equalTo:meal.spMealId];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if ([objects count] == 1) {
                NSLog(@"meal was found");
                PFObject *foundMeal = objects[0];
                completionBlock(foundMeal);
            } else {
                NSLog(@"meal was not found");
                PFObject *newMeal = [PFObject objectWithClassName:@"Meal"];
                [newMeal setObject:meal.name forKey:@"name"];
                [newMeal setObject:meal.spMealId forKey:@"spMealId"];
                PFRelation *venueRelation = [newMeal relationForKey:@"venue"];
                [venueRelation addObject:pfVenue];
                
                [newMeal saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error) {
                        completionBlock(newMeal);
                    }
                }];
            }
        }];
    } else {
        completionBlock(nil);
    }
}

+ (void)likeFoodPost:(FSFoodPost *)foodPost withLikerName:(NSString *)likerName andLikerId:(NSString *)likerId inContext:(NSManagedObjectContext *)context
{
    PFQuery *query = [PFQuery queryWithClassName:@"FoodPost"];
    [query whereKey:@"objectId" equalTo:foodPost.postId];
    [query includeKey:@"likes"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([objects count] == 1) {
            PFObject *foundFoodPost = objects[0];
            
            for (PFObject *like in [foundFoodPost objectForKey:@"likes"]) {
                if ([[like objectForKey:@"likerId"] isEqualToString:likerId]) {
                    return;
                }
            }
            
            PFObject *pfLike = [PFObject objectWithClassName:@"Like"];
            
            [pfLike setObject:likerName forKey:@"likerName"];
            [pfLike setObject:likerId forKey:@"likerId"];
            
            [pfLike saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    [foundFoodPost addObject:pfLike forKey:@"likes"];
                    [foundFoodPost saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        FSLike *newLike = [FSLike likeWithLikeId:pfLike.objectId likeDate:pfLike.createdAt likerId:likerId likerName:likerName inContext:context];
                        [foodPost addLikesObject:newLike];
                        [context save:nil];
                    }];
                }
            }];
        } else {
            // foodpost to like was not found
            NSLog(@"food post was not found to be liked");
        }
    }];

}
@end
