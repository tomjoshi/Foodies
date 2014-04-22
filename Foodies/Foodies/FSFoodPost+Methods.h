//
//  FSFoodPost+Methods.h
//  Foodies
//
//  Created by Lucas Chwe on 4/11/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import "FSFoodPost.h"
#import "Foodie.h"
#import "Venue.h"
#import "MealTag.h"

@interface FSFoodPost (Methods)

- (UIImage *)getImage;
- (UIImage *)getAuthorThumb;
- (NSDate *)getDate;
- (NSString *)getFormattedTime;
- (NSNumber *)getNumberOfLikes;
- (NSArray *)getComments;
- (BOOL)isLiked;
- (NSSet *)getTags;\

+ (FSFoodPost *)initWithDictionary:(NSDictionary *)foodPostDict inContext:(NSManagedObjectContext *)context;
+ (FSFoodPost *)initWithPostImage:(NSData *)postImage
                         PostDate:(NSDate *)postDate
                           PostId:(NSString *)postId
                       AuthorName:(NSString *)authorName
                         AuthorId:(NSString *)authorId
                      AuthorThumb:(NSData *)authorThumb
                        VenueName:(NSString *)venueName
                          VenueId:(NSString *)venueId
                         Comments:(NSArray *)commentsArray
                            Likes:(NSArray *)likesArray
                      andMealTags:(NSArray *)mealTagsArray
                        inContext:(NSManagedObjectContext *)context;

@end