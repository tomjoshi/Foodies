//
//  LocationPickerTableViewController.h
//  Foodies
//
//  Created by Lucas Chwe on 3/14/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationPickerDelegate.h"

@interface LocationPickerTableViewController : UITableViewController
@property (strong, nonatomic) id<LocationPickerDelegate> delegate;
@property (strong, nonatomic) NSNumber *latPassed;
@property (strong, nonatomic) NSNumber *lngPassed;

@end
