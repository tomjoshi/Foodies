//
//  FSComment.h
//  Foodies
//
//  Created by Lucas Chwe on 4/11/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FSFoodPost;

@interface FSComment : NSManagedObject

@property (nonatomic, retain) NSString * commenterId;
@property (nonatomic, retain) NSString * commenterName;
@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSNumber * isCaption;
@property (nonatomic, retain) FSFoodPost *foodPost;

@end
