//
//  Location.h
//  FourSquare
//
//  Created by Lucas Chwe on 2/25/14.
//  Copyright (c) 2014 Flatiron School. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Location : NSObject
@property (nonatomic, strong)NSNumber *lat;
@property (nonatomic, strong)NSNumber *lng;
@property (nonatomic,strong)NSString *address;
@property (nonatomic,strong) NSString *city;
@property (nonatomic,strong) NSString *state;
@property (nonatomic,strong) NSString *postalCode;
@property (nonatomic,strong) NSString *country;
@property (nonatomic,strong)NSString *crossStreet;


- (instancetype)initWithlat:(NSNumber *)lat
                        lng:(NSNumber *)lng
                    address:(NSString *)address
                       city:(NSString *)city
                      state:(NSString *)state
                 postalCode:(NSString *)postalCode
                    country:(NSString *)country
                crossStreet:(NSString *)crossStreet;
- (NSString *)description;
@end
