//
//  FSComment+Methods.h
//  Foodies
//
//  Created by Lucas Chwe on 4/18/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import "FSComment.h"

@interface FSComment (Methods)
+ (FSComment *)initWithComment:(NSString *)comment
                   commentDate:(NSDate *)commentDate
                     commentId:(NSString *)commentId
                   commenterId:(NSString *)commenterId
                 commenterName:(NSString *)commenterName
                     isCaption:(NSNumber *)isCaption
                     inContext:(NSManagedObjectContext *)context;

@end
