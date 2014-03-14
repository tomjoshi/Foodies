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

@interface LocationPickerTableViewController () <UISearchBarDelegate, UISearchDisplayDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *LocationSearchBar;
@property (strong, nonatomic) NSArray *arrayOfLocations;

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
    if (self.latPassed && self.lngPassed) {
        [self loadRestaurantsAtLatitude:self.latPassed andLongitude:self.lngPassed];
    } else {
        NSLog(@"no numbers!");
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Controller Methods

- (void)loadRestaurantsAtLatitude:(NSNumber *)lat andLongitude:(NSNumber *)lng
{
    [MBProgressHUD showHUDAddedTo:self.tabBarController.view animated:YES];
    
    [Foursquare2 venueSearchNearByLatitude:lat
                                 longitude:lng
                                     query:@""
                                     limit:@100
                                    intent:intentBrowse
                                    radius:@500
                                categoryId:@"4d4b7105d754a06374d81259" //food category
                                  callback:^(BOOL success, id result)
     {
         
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
                                                venueId:venueDict[@"id"]
                                               location:location];
             [mutableVenues addObject:venue];
         }
         self.arrayOfLocations = mutableVenues;
         [MBProgressHUD hideHUDForView:self.tabBarController.view animated:YES];
         [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
     }];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"resultCell" forIndexPath:indexPath];
 
    // Configure the cell...
    Venue *venueForCell = self.arrayOfLocations[indexPath.row];
    cell.textLabel.text = venueForCell.name;
    cell.detailTextLabel.text = venueForCell.location.description;
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
