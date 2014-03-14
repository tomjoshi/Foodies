//
//  LocationPickerDelegate.h
//  Foodies
//
//  Created by Lucas Chwe on 3/14/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Venue.h"

@protocol LocationPickerDelegate <NSObject>
- (void)submitVenue:(Venue *)venue;
@end
