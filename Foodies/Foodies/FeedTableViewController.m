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
#import "MealTag.h"
#import "FSFoodPost+Methods.h"
#import "FoodiesAPI.h"

@interface FeedTableViewController () <FeedTableViewCellDelegate, MenuPopOverViewDelegate, NSFetchedResultsControllerDelegate>

- (FSFoodPost *)getPostToShowAtIndexPath:(NSIndexPath *)indexPath;

- (IBAction)refreshTapped:(id)sender;
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
    
    [FoodiesDataStore sharedInstance].fetchedResultsController.delegate = self;
    
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
    // Return the number of rows in the section
    return [[[[FoodiesDataStore sharedInstance].fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"feedCell";
    FeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    // i need to pass what goes into the cell. Like a FeedImage object or image id to pull from database.
    // but for now lets just init the foodpost here
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"feedCell"];
    FSFoodPost *postToShow = [self getPostToShowAtIndexPath:indexPath];
    [cell configureWithFoodPost:postToShow];
    
    return cell.contentView.bounds.size.height+40;
}

- (FSFoodPost *)getPostToShowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[FoodiesDataStore sharedInstance].fetchedResultsController objectAtIndexPath:indexPath];
}


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    FeedTableViewCell *cellToConfigure = (FeedTableViewCell *)cell;
    FSFoodPost *postToShow = [self getPostToShowAtIndexPath:indexPath];
    cellToConfigure.indexPath = indexPath;
    [cellToConfigure configureWithFoodPost:postToShow];
    cellToConfigure.delegate = self;
}

- (IBAction)refreshTapped:(UIButton *)sender {
    // make the api call to fetch latest posts
    [FoodiesAPI fetchFoodPostsInManagedObjectContext:[FoodiesDataStore sharedInstance].managedObjectContext];
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

- (void)showTags:(NSIndexPath *)indexPath
{
    FeedTableViewCell *cell = (FeedTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    for (MealTag *mealTag in [cell.foodPostInCell getTags]) {
        [mealTag showTagInView: cell.postImageView];
        mealTag.popOver.delegate = self;
    }
    
}

- (void)hideTags:(NSIndexPath *)indexPath
{
    FeedTableViewCell *cell = (FeedTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    for (MealTag *mealTag in [cell.foodPostInCell getTags]) {
        [mealTag.popOver dismiss:YES];
    }
    
}

# pragma mark - NSFetchedResultsController Delegate Methods

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath]
                    atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}
@end
