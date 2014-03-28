//
//  PostFormTableViewController.m
//  Foodies
//
//  Created by Lucas Chwe on 3/14/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import "PostFormTableViewController.h"
#import "LocationPickerTableViewController.h"
#import "LocationPickerDelegate.h"
#import "FoodPost.h"
#import "FoodiesDataStore.h"
#import <GCPlaceholderTextView.h>
#import "FoodiesDataStore.h"

@interface PostFormTableViewController () <LocationPickerDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageThumb;
@property (weak, nonatomic) IBOutlet GCPlaceholderTextView *captionTextView;
@property (strong, nonatomic) Venue *venue;
@property (strong, nonatomic) NSSet *mealTags;

- (IBAction)sharePressed:(id)sender;
@end

@implementation PostFormTableViewController

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
    
    self.captionTextView.placeholder = @"Write a caption...";
    self.captionTextView.delegate = self;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.imageThumb setImage:[UIImage imageWithCGImage:[self.assetPassed thumbnail]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqual:@"locationSegue"]) {
        UINavigationController *segueNC = segue.destinationViewController;
        LocationPickerTableViewController *segueVC = segueNC.viewControllers[0];
        segueVC.delegate = self;
        segueVC.latPassed = [self.assetPassed defaultRepresentation].metadata[@"{GPS}"][@"Latitude"];
        segueVC.lngPassed = [self.assetPassed defaultRepresentation].metadata[@"{GPS}"][@"Longitude"];
        if ([[self.assetPassed defaultRepresentation].metadata[@"{GPS}"][@"LatitudeRef"] isEqualToString:@"S"]) {
            segueVC.latPassed = @(-[segueVC.latPassed floatValue]);
        }
        if ([[self.assetPassed defaultRepresentation].metadata[@"{GPS}"][@"LongitudeRef"] isEqualToString:@"W"]) {
            segueVC.lngPassed = @(-[segueVC.lngPassed floatValue]);
        }
    }
}

- (void)submitVenue:(Venue *)venue
{
    if (venue) {
        self.locationLabel.text = venue.name;
        self.venue = venue;
    }
}





#pragma mark - TextView Delegate Methods

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        // Return FALSE so that the final '\n' character doesn't get added
        return NO;
    }
    // For any other character return TRUE so that the text gets added to the view
    return YES;
}


#pragma mark - IBAction Methods

- (IBAction)sharePressed:(id)sender {
    UIImage *newImage = [UIImage imageWithCGImage:[[self.assetPassed defaultRepresentation] fullScreenImage] ];
    
    // ghetto hackjob cropping
    double x = (newImage.size.width - newImage.size.width) / 2.0;
    double y = (newImage.size.height - newImage.size.width) / 2.0;
    CGRect cropRect = CGRectMake(x, y, newImage.size.width, newImage.size.width);
    CGImageRef imageRef = CGImageCreateWithImageInRect([newImage CGImage], cropRect);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    
    
    // setting comment
    Comment *newComment = [[Comment alloc] init];
    newComment.commenter = nil;
    if (![self.captionTextView.text isEqual:@""]) {
        newComment.commenter = [Foodie me];
        newComment.comment = self.captionTextView.text;
    }
    
    FoodPost *newFoodPost = [[FoodPost alloc] initWithImage:croppedImage Author:[Foodie me] Caption:newComment atVenue:self.venue andMealTags:self.mealTags];
    [[FoodiesDataStore sharedInstance].tempPosts addObject:newFoodPost];
    
    NSSortDescriptor *sortByDate = [NSSortDescriptor sortDescriptorWithKey:@"postDate" ascending:NO];
    [FoodiesDataStore sharedInstance].tempPosts = [NSMutableArray arrayWithArray:[[FoodiesDataStore sharedInstance].tempPosts sortedArrayUsingDescriptors:@[sortByDate]]];
    [FoodiesDataStore sharedInstance].newPost = YES;
    [self.tabBarController setSelectedIndex:0];
    // need some kind of delegate method back to camera view so it resets.
    [self.navigationController popViewControllerAnimated:NO];
}
@end
