//
//  FSLike+Methods.h
//  Foodies
//
//  Created by Lucas Chwe on 4/20/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import "FSLike.h"

@interface FSLike (Methods)
+ (FSLike *)likeWithLikeId:(NSString *)likeId
                  likeDate:(NSDate *)likeDate
                   likerId:(NSString *)likerId
                 likerName:(NSString *)likerName
                 inContext:(NSManagedObjectContext *)context;
@end
