//
//  FSFoodPost+Methods.m
//  Foodies
//
//  Created by Lucas Chwe on 4/11/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import "FSFoodPost+Methods.h"
#import "NSDate+PrettyTimestamp.h"
#import "FoodiesDataStore.h"
#import "FSComment+Methods.h"
#import "FSLike+Methods.h"
#import "FSMealTag+Methods.h"

@implementation FSFoodPost (Methods)

+ (FSFoodPost *)initWithDictionary:(NSDictionary *)foodPostDict inContext:(NSManagedObjectContext *)context
{
    return [FSFoodPost initWithPostImage:foodPostDict[@"postImage"] PostDate:foodPostDict[@"postDate"] PostId:foodPostDict[@"postId"] AuthorName:foodPostDict[@"authorName"] AuthorId:foodPostDict[@"authorId"] AuthorThumb:foodPostDict[@"authorThumb"] VenueName:foodPostDict[@"venueName"] VenueId:foodPostDict[@"venueId"] Comments:foodPostDict[@"comments"] Likes:foodPostDict[@"likes"] andMealTags:foodPostDict[@"mealTags"] inContext:context];
}

+ (FSFoodPost *)initWithPostImage:(NSData *)postImage PostDate:(NSDate *)postDate PostId:(NSString *)postId AuthorName:(NSString *)authorName AuthorId:(NSString *)authorId AuthorThumb:(NSData *)authorThumb VenueName:(NSString *)venueName VenueId:(NSString *)venueId Comments:(NSArray *)commentsArray Likes:(NSArray *)likesArray andMealTags:(NSArray *)mealTagsArray inContext:(NSManagedObjectContext *)context
{
    FSFoodPost *fsFoodPost;
    
    // check if exists, if it does, it needs to be updated
    NSPredicate *filterPostId = [NSPredicate predicateWithFormat:@"postId == %@",postId];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"FSFoodPost"];
    request.predicate = filterPostId;
    NSArray *resultsArray = [context executeFetchRequest:request error:nil];
    
    if ([resultsArray count] == 0) {;
        fsFoodPost = [NSEntityDescription insertNewObjectForEntityForName:@"FSFoodPost" inManagedObjectContext:context];
    } else {
        fsFoodPost = (FSFoodPost *)resultsArray[0];
    }
    
    // set new properties
    if (postImage) {
        fsFoodPost.postImage = postImage;
    }
    if (postDate) {
        fsFoodPost.postDate = postDate;
    }
    if (postId) {
        fsFoodPost.postId = postId;
    }
    if (authorName) {
        fsFoodPost.authorName = authorName;
    }
    if (authorId) {
        fsFoodPost.authorId = authorId;
    }
    if (authorThumb) {
        fsFoodPost.authorThumb = authorThumb;
    }
    if (venueName) {
        fsFoodPost.venueName = venueName;
    }
    if (venueId) {
        fsFoodPost.venueId = venueId;
    }
    if ([commentsArray count]>0) {
        // insert comment entities
        for (NSDictionary *comment in commentsArray) {
            if ([[comment allKeys] count] > 0) {
                FSComment *fsComment = [FSComment initWithComment:comment[@"comment"] commentDate:comment[@"commentDate"] commentId:comment[@"commentId"] commenterId:comment[@"commenterId"] commenterName:comment[@"commenterName"] isCaption:comment[@"isCaption"] inContext:context];
                [fsFoodPost addCommentsObject:fsComment];
                
            }
        }
    }
    if ([likesArray count]>0) {
        // insert likes entities
        for (NSDictionary *like in likesArray) {
            FSLike *fsLike = [FSLike likeWithLikeId:like[@"likeId"] likeDate:like[@"likeDate"] likerId:like[@"likerId"] likerName:like[@"likerName"] inContext:context];
            [fsFoodPost addLikesObject:fsLike];
        }
    }
    if ([mealTagsArray count]>0) {
        // insert mealtags entities
        for (NSDictionary *mealTag in mealTagsArray) {
            FSMealTag *fsMealTag = [FSMealTag initWithMealName:mealTag[@"mealName"] mealId:mealTag[@"mealId"] coordinateX:mealTag[@"coordinateX"] coordinateY:mealTag[@"coordinateY"] mealTagId:mealTag[@"mealTagId"] andArrowUp:mealTag[@"isArrowUp"] inContext:context];
            [fsFoodPost addMealTagsObject:fsMealTag];
        }
    }
    
    [context save:nil];
    return fsFoodPost;
    
}

- (UIImage *)getImage
{
    UIImage *postImage;
    if ([FoodiesDataStore sharedInstance].cachedPostImages[self.postId]) {
        postImage = [FoodiesDataStore sharedInstance].cachedPostImages[self.postId];
    } else {
        if (self.postImage) {
            [FoodiesDataStore sharedInstance].cachedPostImages[self.postId] = [UIImage imageWithData:self.postImage];
        }
    }
    return postImage;
}

- (UIImage *)getAuthorThumb
{
    return [UIImage imageWithData:self.authorThumb];
}

- (NSDate *)getDate
{
    return self.postDate;
}


- (NSNumber *)getNumberOfLikes
{
    return @([self.likes count]);
}

- (NSArray *)getComments
{
    // gotta add some kind of chronological sorting, so i need to add nsdate property
    return [self.comments allObjects];
}

- (BOOL)isLiked
{
    if ([self.likes count] > 0) {
        return YES;
    }
    return NO;
}

- (NSString *)getFormattedTime
{
    return [self.postDate prettyTimestampSinceNow];
}

- (NSSet *)getTags
{
    return self.mealTags;
}

- (void)addFSCommentsObject:(FSComment *)newComment
{
    NSMutableSet *tempSet = [NSMutableSet setWithSet:self.comments];
    [tempSet addObject:newComment];
    self.comments = tempSet;
}

@end
