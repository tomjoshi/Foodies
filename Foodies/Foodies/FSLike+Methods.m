//
//  FSLike+Methods.m
//  Foodies
//
//  Created by Lucas Chwe on 4/20/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import "FSLike+Methods.h"

@implementation FSLike (Methods)
+ (FSLike *)likeWithLikeId:(NSString *)likeId likeDate:(NSDate *)likeDate likerId:(NSString *)likerId likerName:(NSString *)likerName inContext:(NSManagedObjectContext *)context
{
    
    FSLike *fsLike;
    
    // check if exists, if it does, it needs to be updated
    NSPredicate *filterId = [NSPredicate predicateWithFormat:@"likeId == %@",likeId];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"FSLike"];
    request.predicate = filterId;
    NSArray *resultsArray = [context executeFetchRequest:request error:nil];
    
    if ([resultsArray count] == 0) {;
        fsLike = [NSEntityDescription insertNewObjectForEntityForName:@"FSLike" inManagedObjectContext:context];
    } else {
        fsLike = (FSLike *)resultsArray[0];
    }
    
    if (likeId) {
        fsLike.likeId = likeId;
    }
    if (likeDate) {
        fsLike.likeDate = likeDate;
    }
    if (likerId) {
        fsLike.likerId = likerId;
    }
    if (likerName) {
        fsLike.likerName = likerName;
    }
    
    return fsLike;
}
@end
