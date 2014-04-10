//
//  Venue.m
//  FourSquare
//
//  Created by Lucas Chwe on 2/25/14.
//  Copyright (c) 2014 Flatiron School. All rights reserved.
//

#import "Venue.h"

@implementation Venue

- init
{
    return [self initWithName:@"" foursquareId:@"" location:nil];
}

- (instancetype)initWithName:(NSString *)name foursquareId:(NSString *)foursquareId location:(Location *)location
{
    self = [super init];
    if (self) {
        _name = name;
        _foursquareId = foursquareId;
        _location = location;
    }
    return self;
}

- (NSString *)getName
{
    return self.name;
}
@end
