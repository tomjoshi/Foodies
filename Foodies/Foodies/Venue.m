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
    return [self initWithName:@"" venueId:@"" location:nil];
}

- (instancetype)initWithName:(NSString *)name venueId:(NSString *)venueId location:(Location *)location
{
    self = [super init];
    if (self) {
        _name = name;
        _venueId = venueId;
        _location = location;
    }
    return self;
}
@end
