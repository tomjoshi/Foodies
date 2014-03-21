//
//  Venue.h
//  FourSquare
//
//  Created by Lucas Chwe on 2/25/14.
//  Copyright (c) 2014 Flatiron School. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Location.h"

@interface Venue : NSObject
@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSString *venueId;
@property (nonatomic,strong)Location *location;

- (instancetype)initWithName:(NSString *)name
                     venueId:(NSString *)venueId
                    location:(Location *)location;
- (NSString *)getName;
@end
