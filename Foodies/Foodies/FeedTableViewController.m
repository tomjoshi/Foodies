//
//  FeedTableViewController.m
//  Foodies
//
//  Created by Lucas Chwe on 3/3/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import "FeedTableViewController.h"
#import "FeedTableViewCell.h"
#import <GTScrollNavigationBar.h>
#import "UIColor+colorPallete.h"
#import "FoodiesDataStore.h"
#import "FeedTableViewCellDelegate.h"
#import <FontAwesomeKit.h>

@interface FeedTableViewController () <FeedTableViewCellDelegate>

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
    
    self.navigationController.scrollNavigationBar.scrollView = self.tableView;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor foodiesColor];
    [label setFont:[UIFont fontWithName:@"Avenir Book" size:20.0]];
    self.navigationItem.titleView = label;
    label.text = NSLocalizedString(@"Foodies", @"");
    [label sizeToFit];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if ([FoodiesDataStore sharedInstance].newPost) {
        [self.tableView setContentOffset:CGPointZero];
        [self.tableView reloadData];
        [FoodiesDataStore sharedInstance].newPost = NO;
    }
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
    return [[FoodiesDataStore sharedInstance].tempPosts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"feedCell";
    FeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    // i need to pass what goes into the cell. Like a FeedImage object or image id to pull from database.
    // but for now lets just init the foodpost here
    FoodPost *postToShow = [self getPostToShowAtIndexPath:indexPath];
    cell.indexPath = indexPath;
    [cell configureWithFoodPost:postToShow];
    cell.delegate = self;
    
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
    return [FoodiesDataStore sharedInstance].tempPosts[indexPath.row];
}

- (void)reloadTable
{
    [self.tableView reloadData];
}

- (void)like:(NSIndexPath *)indexPath
{
    
    // add like animation
    FAKIonIcons *heartIcon = [FAKIonIcons heartIconWithSize:150];
    [heartIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    UIImage *heartIconImage = [heartIcon imageWithSize:CGSizeMake(150, 150)];
    UIImageView *heartImageView = [[UIImageView alloc] initWithImage:heartIconImage];
    [heartImageView setContentMode:UIViewContentModeCenter];
    
    FeedTableViewCell *cell = (FeedTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    [heartImageView setFrame:cell.postImageView.bounds];
    [heartImageView setAlpha:0];
    [cell.postImageView addSubview:heartImageView];
    [UIView animateWithDuration:.1 animations:^{
        [heartImageView setAlpha:1];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.3 delay:.3 options:UIViewAnimationOptionCurveEaseIn animations:^{
            [heartImageView setAlpha:0];
        } completion:^(BOOL finished) {
            [heartImageView removeFromSuperview];
        }];
    }];
}
@end
