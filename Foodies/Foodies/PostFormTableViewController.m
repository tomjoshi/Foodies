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
#import <FontAwesomeKit.h>
#import "UIColor+colorPallete.h"
#import "FSMealTag+Methods.h"
#import "TagPickerViewController.h"
#import <Foursquare2.h>
#import "FoodiesAPI.h"
#import "FSFoodPost.h"
#import "FeedTableViewController.h"
#import <MBProgressHUD.h>

@interface PostFormTableViewController () <LocationPickerDelegate, UITextViewDelegate, TagPickerDelegate>
@property (weak, nonatomic) IBOutlet UITableViewCell *locationCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *tagCell;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageThumb;
@property (weak, nonatomic) IBOutlet GCPlaceholderTextView *captionTextView;
@property (strong, nonatomic) Venue *venue;
@property (strong, nonatomic) NSMutableArray *mealTags;

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
    
    [self.imageThumb setImage:[UIImage imageWithCGImage:[self.assetPassed thumbnail]]];
    
    [[self tableView] registerClass:[UITableViewCell class] forCellReuseIdentifier:@"TagCell"];
    
    self.mealTags = [[NSMutableArray alloc] init];
    
    FAKIonIcons *locationIcon = [FAKIonIcons locationIconWithSize:25];
    [locationIcon addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor]];
    UIImage *locationIconImage = [locationIcon imageWithSize:CGSizeMake(25, 25)];
    [self.locationCell.imageView setImage:locationIconImage];
    NSLog(@"%f", self.locationCell.textLabel.frame.origin.x);
    
    FAKFontAwesome *tagIcon = [FAKFontAwesome tagIconWithSize:20];
    [tagIcon addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor]];
    UIImage *tagIconImage = [tagIcon imageWithSize:CGSizeMake(25, 25)];
    [self.tagCell.imageView setImage:tagIconImage];
    NSLog(@"%f", self.tagCell.textLabel.frame.origin.x);
    
    // style navbar title
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor foodiesColor];
    [titleLabel setText:@"Food Post"];
    [titleLabel setFont:[UIFont fontWithName:@"Avenir Book" size:20.0]];
    self.navigationItem.titleView = titleLabel;
    [titleLabel sizeToFit];
    
}

#pragma mark - Navigation method

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqual:@"locationSegue"]) {
        if ([self.captionTextView isFirstResponder]) {
            [self.captionTextView resignFirstResponder];
        }
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

#pragma mark - LocationPickerDelegate method

- (void)submitVenue:(Venue *)venue
{
    if (venue) {
        self.locationLabel.text = venue.name;
        FAKIonIcons *locationIcon = [FAKIonIcons locationIconWithSize:25];
        [locationIcon addAttribute:NSForegroundColorAttributeName value:[UIColor foodiesColor]];
        UIImage *locationIconImage = [locationIcon imageWithSize:CGSizeMake(25, 25)];
        [self.locationCell.imageView setImage:locationIconImage];
        self.venue = venue;
        [self.tableView reloadData];
        
        // testing foursquare api for menu
//        [Foursquare2 venueGetMenu:venue.foursquareId callback:^(BOOL success, id result) {
//            NSLog(@"%@", result);
//        }];
        
        
        
    }
}

#pragma mark - TagPickerDelegate method

- (void)submitTags:(NSArray *)tags
{
    if ([tags count] > 0) {
        self.mealTags = [NSMutableArray arrayWithArray:tags];
        
        FAKFontAwesome *tagIcon = [FAKFontAwesome tagIconWithSize:20];
        [tagIcon addAttribute:NSForegroundColorAttributeName value:[UIColor foodiesColor]];
        UIImage *tagIconImage = [tagIcon imageWithSize:CGSizeMake(25, 25)];
        [self.tagCell.imageView setImage:tagIconImage];
        
        [self.tableView reloadData];
    } else {
        self.mealTags = [[NSMutableArray alloc] init];
        FAKFontAwesome *tagIcon = [FAKFontAwesome tagIconWithSize:20];
        [tagIcon addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor]];
        UIImage *tagIconImage = [tagIcon imageWithSize:CGSizeMake(25, 25)];
        [self.tagCell.imageView setImage:tagIconImage];
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
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    UIImage *newImage = [UIImage imageWithCGImage:[[self.assetPassed defaultRepresentation] fullScreenImage] ];
    
    // ghetto hackjob cropping
    double x = (newImage.size.width - newImage.size.width) / 2.0;
    double y = (newImage.size.height - newImage.size.width) / 2.0;
    CGRect cropRect = CGRectMake(x, y, newImage.size.width, newImage.size.width);
    CGImageRef imageRef = CGImageCreateWithImageInRect([newImage CGImage], cropRect);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    
    // reduce size of image to 640x640, due to file size issues
    CGSize newSize = CGSizeMake(640,640);
    UIGraphicsBeginImageContext(newSize);
    [croppedImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* compressedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // setting comment
    Comment *newComment = [[Comment alloc] init];
    newComment.commenter = nil;
    if (![self.captionTextView.text isEqual:@""]) {
        newComment.commenter = [Foodie me];
        newComment.comment = self.captionTextView.text;
    }
    
    // how i originally created the foodpost class object
    FoodPost *newFoodPost = [[FoodPost alloc] initWithImage:compressedImage Author:[Foodie me] Caption:newComment atVenue:self.venue andMealTags:[NSSet setWithArray:self.mealTags]];
    
    // save in api
    [FoodiesAPI postFoodPost:newFoodPost inContext:[FoodiesDataStore sharedInstance].managedObjectContext completion:^{
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        
        // redirect to feed
        [self.tabBarController setSelectedIndex:0];
        UINavigationController *homeNav = self.tabBarController.viewControllers[0];
        FeedTableViewController *homeVC = homeNav.viewControllers[0];
        [homeVC refreshPulled:nil];
        [homeVC.tableView setContentOffset:CGPointZero animated:YES];
        
        // reset the current view controller
        [self.delegate didSharePost];
        [self.navigationController popViewControllerAnimated:NO];
    }];
}

#pragma mark - VC methods

- (void)toggleSelect:(UIButton *)sender
{
    if ([sender isSelected]) {
        [sender setSelected:NO];
    } else {
        [sender setSelected:YES];
    }
}


#pragma mark - UITableView delegate and datasource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (indexPath.section == 2 && indexPath.row >= 1) {
        static NSString *CellIdentifier = @"TagCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
    } else{
        cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    
    if (indexPath.section == 2) {
        if (indexPath.row >= 1) {
            
            FSMealTag *mealTag = self.mealTags[indexPath.row-1];
            
            UILabel *mealNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, cell.bounds.size.width-15, cell.bounds.size.height)];
            mealNameLabel.text = mealTag.mealName;
            [cell addSubview:mealNameLabel];
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
        } else if ([self.mealTags count] > 0){
            NSString *mealLabel;
            if ([self.mealTags count] > 1) {
                mealLabel = @"Meals";
            } else {
                mealLabel = @"Meal";
            }
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%lu %@",(unsigned long)[self.mealTags count], mealLabel];
        } else {
            cell.detailTextLabel.text = @"";
            FAKFontAwesome *tagIcon = [FAKFontAwesome tagIconWithSize:20];
            [tagIcon addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor]];
            UIImage *tagIconImage = [tagIcon imageWithSize:CGSizeMake(25, 25)];
            [self.tagCell.imageView setImage:tagIconImage];
        }
        
        if (!self.venue) {
            [cell setHidden:YES];
        } else {
            [cell setHidden:NO];
        }
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2) {
        return [self.mealTags count]+1;
    }
    return  [super tableView:tableView numberOfRowsInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = indexPath.section;
    
    // if dynamic section make all rows the same height as row 0
    if (section == 2) {
        if (!self.venue) {
            return 0;
        }
        return [super tableView:tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
    } else {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.mealTags removeObjectAtIndex:indexPath.row-1];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView reloadData];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2 && indexPath.row >= 1) {
        return YES;
    }
    return NO;
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    
    // if dynamic section make all rows the same indentation level as row 0
    if (section == 2) {
        return [super tableView:tableView indentationLevelForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
    } else {
        return [super tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[tableView cellForRowAtIndexPath:indexPath] setHighlighted:NO];
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO];
    
    if (indexPath.section == 2 && indexPath.row == 0) {
        if ([self.captionTextView isFirstResponder]) {
            [self.captionTextView resignFirstResponder];
        }
        
        TagPickerViewController *tagVC = [[TagPickerViewController alloc] init];
        ALAssetRepresentation *defaultRep = [self.assetPassed defaultRepresentation];
        tagVC.imageToTag = [UIImage imageWithCGImage:[defaultRep fullScreenImage] scale:[defaultRep scale] orientation:0];
        tagVC.mealsVenue = self.venue;
        tagVC.mealTags = [[NSMutableArray alloc] initWithArray:[self.mealTags copy]];
        tagVC.delegate = self;
        
        UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:tagVC];
        [navC.navigationBar setTranslucent:NO];
        [self presentViewController:navC animated:YES completion:nil];
    }
}

@end
