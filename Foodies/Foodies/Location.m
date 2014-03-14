//
//  Location.m
//  FourSquare
//
//  Created by Lucas Chwe on 2/25/14.
//  Copyright (c) 2014 Flatiron School. All rights reserved.
//

#import "Location.h"

@implementation Location

- (id)init
{
    return [self initWithlat:@0 lng:@0 address:@"" city:@"" state:@"" postalCode:@"" country:@"" crossStreet:@""];
}

-(instancetype)initWithlat:(NSNumber *)lat lng:(NSNumber *)lng address:(NSString *)address city:(NSString *)city state:(NSString *)state postalCode:(NSString *)postalCode country:(NSString *)country crossStreet:(NSString *)crossStreet {
    self = [super init];
    if (self) {
        _lat = lat;
        _lng = lng;
        _address = address;
        _city = city;
        _state = state;
        _postalCode = postalCode;
        _country = country;
        _crossStreet = crossStreet;
    }
    return self;
}

- (NSString *)description
{
    return self.address;
}
@end
