//
//  FSComment+Methods.m
//  Foodies
//
//  Created by Lucas Chwe on 4/18/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import "FSComment+Methods.h"

@implementation FSComment (Methods)
+ (FSComment *)initWithComment:(NSString *)comment commentDate:(NSDate *)commentDate commentId:(NSString *)commentId commenterId:(NSString *)commenterId commenterName:(NSString *)commenterName isCaption:(NSNumber *)isCaption inContext:(NSManagedObjectContext *)context
{
    
    FSComment *fsComment;
    
    // check if exists, if it does, it needs to be updated
    NSPredicate *filterId = [NSPredicate predicateWithFormat:@"commentId == %@",commentId];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"FSComment"];
    request.predicate = filterId;
    NSArray *resultsArray = [context executeFetchRequest:request error:nil];
    
    if ([resultsArray count] == 0) {;
        fsComment = [NSEntityDescription insertNewObjectForEntityForName:@"FSComment" inManagedObjectContext:context];
    } else {
        fsComment = (FSComment *)resultsArray[0];
    }
    
    if (comment) {
        fsComment.comment = comment;
    }
    if (commentDate) {
        fsComment.commentDate = commentDate;
    }
    if (commentId) {
        fsComment.commentId = commentId;
    }
    if (commenterId) {
        fsComment.commenterId = commenterId;
    }
    if (commenterName) {
        fsComment.commenterName = commenterName;
    }
    if (isCaption) {
        fsComment.isCaption = isCaption;
    }
    
    return fsComment;
}

@end
