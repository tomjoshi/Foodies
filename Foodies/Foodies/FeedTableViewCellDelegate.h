//
//  FeedTableViewCellDelegate.h
//  Foodies
//
//  Created by Lucas Chwe on 3/28/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FeedTableViewCellDelegate <NSObject>
- (void)reloadTable;
- (void)like:(NSIndexPath *)indexPath completionBlock:(void (^)(void))completionBlock;
- (void)showTags:(NSIndexPath *)indexPath;
- (void)hideTags:(NSIndexPath *)indexPath;
@end
