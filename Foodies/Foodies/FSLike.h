//
//  FSLike.h
//  Foodies
//
//  Created by Lucas Chwe on 4/22/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface FSLike : NSManagedObject

@property (nonatomic, retain) NSDate * likeDate;
@property (nonatomic, retain) NSString * likerId;
@property (nonatomic, retain) NSString * likerName;
@property (nonatomic, retain) NSString * likeId;

@end
