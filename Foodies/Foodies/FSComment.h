//
//  FSComment.h
//  Foodies
//
//  Created by Lucas Chwe on 4/22/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface FSComment : NSManagedObject

@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSString * commenterId;
@property (nonatomic, retain) NSString * commenterName;
@property (nonatomic, retain) NSNumber * isCaption;
@property (nonatomic, retain) NSDate * commentDate;
@property (nonatomic, retain) NSString * commentId;

@end
