//
//  FeedTableViewController.m
//  Foodies
//
//  Created by Lucas Chwe on 3/3/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import "FeedTableViewController.h"
#import "FeedTableViewCell.h"

@interface FeedTableViewController ()

- (FoodPost *)getPostToShowAtIndexPath:(NSIndexPath *)indexPath;

@end

@implementation FeedTableViewController

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
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
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"feedCell";
    FeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    // i need to pass what goes into the cell. Like a FeedImage object or image id to pull from database.
    // but for now lets just init the foodpost here
    FoodPost *postToShow = [self getPostToShowAtIndexPath:indexPath];
    [cell configureWithFoodPost:postToShow];
    
    return cell;
}

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"feedCell"];
    FoodPost *postToShow = [self getPostToShowAtIndexPath:indexPath];
    [cell configureWithFoodPost:postToShow];
    
    return cell.contentView.bounds.size.height+40;
}

- (FoodPost *)getPostToShowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[FoodPost alloc] init];
}

@end
