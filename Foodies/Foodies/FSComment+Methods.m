//
//  FSComment+Methods.m
//  Foodies
//
//  Created by Lucas Chwe on 4/18/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import "FSComment+Methods.h"

@implementation FSComment (Methods)
+ (FSComment *)initWithComment:(NSString *)comment commentDate:(NSDate *)commentDate commenterId:(NSString *)commenterId commenterName:(NSString *)commenterName isCaption:(NSNumber *)isCaption inContext:(NSManagedObjectContext *)context
{
    FSComment *fsComment = [NSEntityDescription insertNewObjectForEntityForName:@"FSComment" inManagedObjectContext:context];
    
    if (comment) {
        fsComment.comment = comment;
    }
    if (commentDate) {
        fsComment.commentDate = commentDate;
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
