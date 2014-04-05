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
#import "MealTag.h"
#import "TagPickerViewController.h"
#import <Foursquare2.h>

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
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
        FAKIonIcons *locationIcon = [FAKIonIcons locationIconWithSize:25];
        [locationIcon addAttribute:NSForegroundColorAttributeName value:[UIColor foodiesColor]];
        UIImage *locationIconImage = [locationIcon imageWithSize:CGSizeMake(25, 25)];
        [self.locationCell.imageView setImage:locationIconImage];
        self.venue = venue;
        [self.tableView reloadData];
        
        
        [Foursquare2 venueGetMenu:venue.venueId callback:^(BOOL success, id result) {
            NSLog(@"%@", result);
        }];
        
        
        
    }
}

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
    
    FoodPost *newFoodPost = [[FoodPost alloc] initWithImage:croppedImage Author:[Foodie me] Caption:newComment atVenue:self.venue andMealTags:[NSSet setWithArray:self.mealTags]];
    [[FoodiesDataStore sharedInstance].tempPosts addObject:newFoodPost];
    
    NSSortDescriptor *sortByDate = [NSSortDescriptor sortDescriptorWithKey:@"postDate" ascending:NO];
    [FoodiesDataStore sharedInstance].tempPosts = [NSMutableArray arrayWithArray:[[FoodiesDataStore sharedInstance].tempPosts sortedArrayUsingDescriptors:@[sortByDate]]];
    [FoodiesDataStore sharedInstance].newPost = YES;
    [self.tabBarController setSelectedIndex:0];
    // need some kind of delegate method back to camera view so it resets.
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - VC Methods

- (void)toggleSelect:(UIButton *)sender
{
    if ([sender isSelected]) {
        [sender setSelected:NO];
    } else {
        [sender setSelected:YES];
    }
}


#pragma mark - UITableView Delegate Methods

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
            
            MealTag *mealTag = self.mealTags[indexPath.row-1];
            
            FAKIonIcons *emptyStar = [FAKIonIcons ios7StarOutlineIconWithSize:30];
            [emptyStar addAttribute:NSForegroundColorAttributeName value:[UIColor foodiesColor]];
            FAKIonIcons *fullStar = [FAKIonIcons ios7StarIconWithSize:30];
            [fullStar addAttribute:NSForegroundColorAttributeName value:[UIColor foodiesColor]];
            
            UIButton *testButton = [[UIButton alloc] initWithFrame:CGRectMake(cell.bounds.size.width-cell.frame.size.height , 0, cell.frame.size.height, cell.frame.size.height)];
//            UIButton *testButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.tagCell.textLabel.frame.origin.x, cell.frame.size.height)];
            [testButton setAttributedTitle:[emptyStar attributedString] forState:UIControlStateNormal];
            [testButton setAttributedTitle:[fullStar attributedString] forState:UIControlStateSelected];
            [testButton addTarget:self action:@selector(toggleSelect:) forControlEvents:UIControlEventTouchUpInside];
            
            UILabel *mealNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, cell.bounds.size.width-cell.frame.size.height-15, cell.bounds.size.height)];
            mealNameLabel.text = mealTag.meal.name;
            [cell addSubview:testButton];
            [cell addSubview:mealNameLabel];
            
            
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
        } else if ([self.mealTags count] > 0){
            NSString *mealLabel;
            if ([self.mealTags count] > 1) {
                mealLabel = @"Meals";
            } else {
                mealLabel = @"Meal";
            }
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%d %@",[self.mealTags count], mealLabel];
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


// Override to support editing the table view.
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
    int section = indexPath.section;
    
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
        TagPickerViewController *tagVC = [[TagPickerViewController alloc] init];
        ALAssetRepresentation *defaultRep = [self.assetPassed defaultRepresentation];
        tagVC.imageToTag = [UIImage imageWithCGImage:[defaultRep fullScreenImage] scale:[defaultRep scale] orientation:0];
        tagVC.mealsVenue = self.venue;
        tagVC.mealTags = self.mealTags;
        tagVC.delegate = self;
        
        UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:tagVC];
        [navC.navigationBar setTranslucent:NO];
        [self presentViewController:navC animated:YES completion:nil];
    }
}

@end
