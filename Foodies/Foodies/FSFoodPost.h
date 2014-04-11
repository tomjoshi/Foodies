//
//  FSFoodPost.h
//  Foodies
//
//  Created by Lucas Chwe on 4/11/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FSComment, FSLike, FSMealTag;

@interface FSFoodPost : NSManagedObject

@property (nonatomic, retain) NSData * postImage;
@property (nonatomic, retain) NSDate * postDate;
@property (nonatomic, retain) NSString * postId;
@property (nonatomic, retain) NSString * authorName;
@property (nonatomic, retain) NSString * authorId;
@property (nonatomic, retain) NSData * authorThumb;
@property (nonatomic, retain) NSString * venueName;
@property (nonatomic, retain) NSString * venueId;
@property (nonatomic, retain) NSSet *likes;
@property (nonatomic, retain) NSSet *comments;
@property (nonatomic, retain) NSSet *mealTags;
@end

@interface FSFoodPost (CoreDataGeneratedAccessors)

- (void)addLikesObject:(FSLike *)value;
- (void)removeLikesObject:(FSLike *)value;
- (void)addLikes:(NSSet *)values;
- (void)removeLikes:(NSSet *)values;

- (void)addCommentsObject:(FSComment *)value;
- (void)removeCommentsObject:(FSComment *)value;
- (void)addComments:(NSSet *)values;
- (void)removeComments:(NSSet *)values;

- (void)addMealTagsObject:(FSMealTag *)value;
- (void)removeMealTagsObject:(FSMealTag *)value;
- (void)addMealTags:(NSSet *)values;
- (void)removeMealTags:(NSSet *)values;

@end
