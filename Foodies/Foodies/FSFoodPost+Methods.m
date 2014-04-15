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
#import "FSComment.h"
#import "FSLike.h"
#import "FSMealTag.h"

@implementation FSFoodPost (Methods)

- (FSFoodPost *)initWithPostImage:(UIImage *)postImage PostDate:(NSDate *)postDate PostId:(NSString *)postId AuthorName:(NSString *)authorName AuthorId:(NSString *)authorId AuthorThumb:(UIImage *)authorThumb VenueName:(NSString *)venueName VenueId:(NSString *)venueId Comments:(NSArray *)commentsArray Likes:(NSArray *)likesArray andMealTags:(NSArray *)mealTagsArray inContext:(NSManagedObjectContext *)context
{
    FSFoodPost *fsFoodPost;
    
    // check if exists, if it does, it needs to be updated
    NSPredicate *filterPostId = [NSPredicate predicateWithFormat:@"postId == %@",postId];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"FSFoodPost"];
    request.predicate = filterPostId;
    NSArray *resultsArray = [context executeFetchRequest:request error:nil];
    if ([resultsArray count] == 0) {
        fsFoodPost = [NSEntityDescription insertNewObjectForEntityForName:@"FSFoodPost" inManagedObjectContext:context];
    } else {
        fsFoodPost = (FSFoodPost *)resultsArray[0];
    }
    
    // set new properties
    if (postImage) {
        fsFoodPost.postImage = UIImagePNGRepresentation(postImage);
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
        fsFoodPost.authorThumb = UIImagePNGRepresentation(authorThumb);
    }
    if (venueName) {
        fsFoodPost.venueName = venueName;
    }
    if (venueId) {
        fsFoodPost.venueId = venueId;
    }
    if ([commentsArray count]>0) {
        // insert comment entities
    }
    if ([likesArray count]>0) {
        // insert likes entities
    }
    if ([mealTagsArray count]>0) {
        // insert mealtags entities
    }
    return fsFoodPost;
    
}

- (UIImage *)getImage
{
    UIImage *postImage;
    if ([FoodiesDataStore sharedInstance].cachedPostImages[self.postId]) {
        postImage = [FoodiesDataStore sharedInstance].cachedPostImages[self.postId];
    } else {
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [queue addOperationWithBlock:^{
            [FoodiesDataStore sharedInstance].cachedPostImages[self.postId] = [UIImage imageWithData:self.postImage];
        }];
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

- (void)addLike:(FSLike *)newLike
{
    [self addLikesObject:newLike];
}

- (void)addComment:(FSComment *)newComment
{
    [self addCommentsObject:newComment];
}

- (NSSet *)getTags
{
    return self.mealTags;
}


@end
