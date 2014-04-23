//
//  LocationPickerTableViewController.m
//  Foodies
//
//  Created by Lucas Chwe on 3/14/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import "LocationPickerTableViewController.h"
#import <Foursquare2.h>
#import <MBProgressHUD.h>
#import "Venue.h"
#import "Location.h"
#import <CoreLocation/CoreLocation.h>
#import <AFNetworking.h>
#import "UIColor+colorPallete.h"

@interface LocationPickerTableViewController () <UISearchBarDelegate, UISearchDisplayDelegate, CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *LocationSearchBar;
@property (strong, nonatomic) NSArray *arrayOfLocations;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation LocationPickerTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // style navbar title
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor foodiesColor];
    [titleLabel setText:@"Locations"];
    [titleLabel setFont:[UIFont fontWithName:@"Avenir Book" size:20.0]];
    self.navigationItem.titleView = titleLabel;
    [titleLabel sizeToFit];
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    if (self.latPassed && self.lngPassed) {
        NSLog(@"the passed latitude is %@ and longitude %@", self.latPassed, self.lngPassed);
        [self loadRestaurantsAtLatitude:self.latPassed andLongitude:self.lngPassed];
    } else {
        NSLog(@"no passed coordinates");
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.distanceFilter = kCLDistanceFilterNone;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        [self.locationManager startUpdatingLocation];
    }
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelTapped:)];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.arrayOfLocations count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"resultCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"resultCell"];
    }
    
    // Configure the cell...
    Venue *venueForCell;
    if ([self.arrayOfLocations count]>indexPath.row) {
        venueForCell = self.arrayOfLocations[indexPath.row];
    } else {
        venueForCell = [[Venue alloc] init];
    }
    cell.textLabel.text = venueForCell.name;
    cell.detailTextLabel.text = [venueForCell.location description];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.arrayOfLocations[indexPath.row]) {
        Venue *venueToPass = self.arrayOfLocations[indexPath.row];
        [self.delegate submitVenue:venueToPass];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - CLLocation Delegate Methods
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [self.locationManager stopUpdatingLocation];
    self.latPassed = @(newLocation.coordinate.latitude);
    self.lngPassed = @(newLocation.coordinate.longitude);
    [self loadRestaurantsAtLatitude:@(newLocation.coordinate.latitude) andLongitude:@(newLocation.coordinate.longitude)];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    UIAlertView *failedLocation = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to find your location" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [failedLocation show];
}

#pragma mark - UISearchBarDelegate methods

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [Foursquare2 venueSearchNearByLatitude:self.latPassed longitude:self.lngPassed query:searchBar.text limit:@(20) intent:intentBrowse radius:@10000 categoryId:@"4d4b7105d754a06374d81259" callback:^(BOOL success, id result) {
        [self.LocationSearchBar resignFirstResponder];
        [self getLocationsFromResult:result];
    }];
}

#pragma mark - VC methods

- (void)cancelTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loadRestaurantsAtLatitude:(NSNumber *)lat andLongitude:(NSNumber *)lng
{
    if (lat && lng) {
        
        [Foursquare2 venueSearchNearByLatitude:lat
                                     longitude:lng
                                         query:@""
                                         limit:@100
                                        intent:intentCheckin
                                        radius:@500
                                    categoryId:@"4d4b7105d754a06374d81259" //food category
                                      callback:^(BOOL success, id result)
         {
             [self getLocationsFromResult:result];
         }];
    }
}

- (void)getLocationsFromResult:(id)result
{
    if ([result isKindOfClass:[NSError class]]) {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        return;
    }
    
    NSArray *venues = result[@"response"][@"venues"];
    NSMutableArray *mutableVenues = [NSMutableArray new];
    for (NSDictionary *venueDict in venues)
    {
        NSDictionary *locationDictionary = venueDict[@"location"];
        Location *location = [[Location alloc] initWithlat:locationDictionary[@"lat"]
                                                       lng:locationDictionary[@"lng"]
                                                   address:locationDictionary[@"address"]
                                                      city:locationDictionary[@"city"]
                                                     state:locationDictionary[@"state"]
                                                postalCode:locationDictionary[@"postalCode"]
                                                   country:locationDictionary[@"country"]
                                               crossStreet:locationDictionary[@"crossStreet"]];
        
        Venue *venue = [[Venue alloc] initWithName:venueDict[@"name"]
                                      foursquareId:venueDict[@"id"]
                                          location:location];
        [mutableVenues addObject:venue];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        self.arrayOfLocations = mutableVenues;
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        [self.tableView reloadData];
        [self.searchDisplayController.searchResultsTableView reloadData];
    });
}
@end
