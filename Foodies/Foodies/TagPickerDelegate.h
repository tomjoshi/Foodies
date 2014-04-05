//
//  TagPickerDelegate.h
//  Foodies
//
//  Created by Lucas Chwe on 4/5/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TagPickerDelegate <NSObject>
- (void)submitTags:(NSArray *)tags;
@end
