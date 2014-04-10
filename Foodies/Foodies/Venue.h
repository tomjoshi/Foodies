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
@property (nonatomic,strong)NSString *foursquareId;
@property (nonatomic,strong)Location *location;
@property (nonatomic,strong)NSString *venueId;

// properties missing: meals

- (instancetype)initWithName:(NSString *)name
                foursquareId:(NSString *)foursquareId
                    location:(Location *)location;
- (NSString *)getName;
@end
