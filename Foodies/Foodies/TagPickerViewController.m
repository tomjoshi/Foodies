//
//  TagPickerViewController.m
//  Foodies
//
//  Created by Lucas Chwe on 3/29/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import "TagPickerViewController.h"
//#import "MealTag.h"
#import "Meal.h"
#include <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>
#import <AFNetworking.h>
#import "SinglePlatformSignature.h"
#import "UIColor+colorPallete.h"
#import <QuartzCore/QuartzCore.h>
#import <FontAwesomeKit.h>
#import "Constants.h"
#import "FSMealTag+Methods.h"
#import "FoodiesDataStore.h"

@interface TagPickerViewController () <UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate, MenuPopOverViewDelegate, UIGestureRecognizerDelegate>
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UISearchBar *tagSearch;
@property (strong, nonatomic) UISearchDisplayController *searchController;
@property (strong, nonatomic) UITableView *menuTable;
@property (strong, nonatomic) UILabel *instructionLabel;
@property (strong, nonatomic) NSMutableArray *mealsArray;
@property (strong, nonatomic) NSTimer *tableShrinkTimer;
@property (strong, nonatomic) UIButton *cancelTableButton;
@property (nonatomic) CGPoint newTagCoordinates;
@property (nonatomic) BOOL isCancelled;
@property (strong, nonatomic) UIPanGestureRecognizer *panTag;
@property (strong, nonatomic) UITapGestureRecognizer *tapOnImage;
@property (strong, nonatomic) FSMealTag *editableTag;
@property (strong, nonatomic) MenuPopOverView *editablePopOver;
@property (strong, nonatomic) NSMutableDictionary *popOversDict;

@end

@implementation TagPickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    CGFloat screenWidth = self.view.frame.size.width;
    CGFloat screenHeight = self.view.frame.size.height;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.mealsArray = [[NSMutableArray alloc] init];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    
    NSString *urlQuery = [NSString stringWithFormat:@"http://matching-api.singleplatform.com/location-match?client=%@", SINGLEPLATFORM_CLIENTID];
    
    NSDictionary *params = @{
                                @"locations": @[@{@"foursquare_id": self.mealsVenue.foursquareId}],
                        @"matching_criteria": @"FOURSQUARE_ID"
                                };
    [manager POST:urlQuery parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"success");
        
        // get the menu now
        NSString *spId = responseObject[@"response"][0][@"spv2id"];
        
        // create url with signature key
        NSString *urlSignatureStuff = [SinglePlatformSignature generateApiSingatureForPath:[NSString stringWithFormat:@"/locations/%@/menu", spId] withParams:nil withCliendId:SINGLEPLATFORM_CLIENTID andApiSecret:SINGLEPLATFORM_APISECRET];
        NSString *urlQuery = [NSString stringWithFormat:@"http://api.singleplatform.co%@", urlSignatureStuff];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
        
        [manager GET:urlQuery parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            NSArray *menus = responseObject[@"menus"];
            if ([menus count] > 0) {
                NSLog(@"there is a menu");
                
                NSMutableArray *mealNames = [[NSMutableArray alloc] init];
                NSArray *entries = menus[0][@"entries"];
                for (NSDictionary *entry in entries) {
                    if ([entry[@"type"] isEqualToString:@"item"]) {
                        NSLog(@"%@", entry[@"title"]);
                        Meal *meal = [[Meal alloc] initWithName:entry[@"title"] andSPMealId:entry[@"id"]];
                        [mealNames addObject:meal];
                    }
                    
                }
                
                for (Meal *meal in mealNames) {
                    FSMealTag *menuTag = [FSMealTag initWithMealName:meal.name mealId:nil coordinateX:@0 coordinateY:@0 mealTagId:nil andArrowUp:nil inContext:[FoodiesDataStore sharedInstance].managedObjectContext];
                    menuTag.mealSPId = meal.spMealId;
                    [self.mealsArray addObject:menuTag];
                }
                [self.menuTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            NSLog(@"success menu");
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"fail menu");
        }];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"fail");
    }];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelTapped:)];
    
    // style navbar title
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor foodiesColor];
    [titleLabel setText:@"Tags"];
    [titleLabel setFont:[UIFont fontWithName:@"Avenir Book" size:20.0]];
    self.navigationItem.titleView = titleLabel;
    [titleLabel sizeToFit];
    
    // add table view
    self.menuTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
    [self.menuTable setUserInteractionEnabled:YES];
    [self.menuTable setAllowsSelection:YES];
    [self.menuTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    self.menuTable.delegate = self;
    self.menuTable.dataSource = self;
    [self.menuTable setScrollEnabled:NO];
    [self.menuTable setAlpha:0];
    [self.menuTable setBackgroundView:nil];
    [self.menuTable setOpaque:NO];
    [self.menuTable setBackgroundColor:[UIColor semiTransparentWhiteColor]];
    [self.view addSubview:self.menuTable];
    
    // add cancel button
    self.cancelTableButton = [[UIButton alloc] initWithFrame:CGRectMake((screenWidth-70)/2, screenHeight+70, 70, 70)];
    FAKIonIcons *cancelButton = [FAKIonIcons closeRoundIconWithSize:25];
    [cancelButton addAttribute:NSForegroundColorAttributeName value:[UIColor foodiesColor]];
    [self.cancelTableButton setAttributedTitle:[cancelButton attributedString] forState:UIControlStateNormal];
    [self.cancelTableButton addTarget:self action:@selector(dismissTable) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelTableButton setBackgroundColor:[UIColor semiTransparentWhiteColor]];
    [self.cancelTableButton.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [self.cancelTableButton.layer setBorderWidth:1];
    [self.cancelTableButton setEnabled:NO];
    [self.cancelTableButton setAlpha:0];
    self.cancelTableButton.layer.cornerRadius = self.cancelTableButton.frame.size.width/2;
    self.cancelTableButton.layer.masksToBounds = YES;
    [self.view addSubview:self.cancelTableButton];
    
    // add image
    self.imageView = [[UIImageView alloc] initWithImage:self.imageToTag];
    [self.imageView setContentMode:UIViewContentModeScaleAspectFill];
    [self.imageView setFrame:CGRectMake(0, 0, screenWidth, screenWidth)];
    [self.imageView setClipsToBounds:YES];
    [self.view addSubview:self.imageView];
    [self.view sendSubviewToBack:self.imageView];
    
    // show tags
    self.popOversDict = [[NSMutableDictionary alloc] init];
    [self checkTagCount];
    [self showTags];
    
    // add instructions label
    self.instructionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, screenWidth, screenWidth, screenHeight-screenWidth-64)];
    self.instructionLabel.text = @"Tap to tag meal";
    [self.instructionLabel setTextAlignment:NSTextAlignmentCenter];
    [self.instructionLabel setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.instructionLabel];
    
    // add search bar
    self.tagSearch = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.instructionLabel.frame.size.width, 44)];
    self.tagSearch.placeholder = @"Find or create a meal";
    self.tagSearch.delegate = self;
    [self.menuTable addSubview:self.tagSearch];
    self.menuTable.tableHeaderView = self.tagSearch;
    
    // add tap gesture
    self.tapOnImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    self.tapOnImage.delegate = self;
    [self.view addGestureRecognizer:self.tapOnImage];
    
    // add pan gesture
    self.panTag = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panPopOver:)];
    self.panTag.delaysTouchesBegan = NO;
    self.panTag.delaysTouchesEnded = NO;
    
    // require taponimage only to work if pan does not work
    [self.tapOnImage requireGestureRecognizerToFail:self.panTag];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - UISearchBarDelegate method

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.tagSearch resignFirstResponder];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    UITextField *searchBarTextField = nil;
    
    NSArray *views = ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0f) ? searchBar.subviews : [[searchBar.subviews objectAtIndex:0] subviews];
    
    for (UIView *subview in views)
    {
        if ([subview isKindOfClass:[UITextField class]])
        {
            searchBarTextField = (UITextField *)subview;
            break;
        }
    }
    searchBarTextField.enablesReturnKeyAutomatically = NO;
    [searchBarTextField setReturnKeyType:UIReturnKeyDefault];
    
}

#pragma mark - Table view methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO];
    [[tableView cellForRowAtIndexPath:indexPath] setHighlighted:NO];
    FSMealTag *tagToAdd = self.mealsArray[indexPath.row];
    tagToAdd.coordinateX = @(self.newTagCoordinates.x);
    tagToAdd.coordinateY = @(self.newTagCoordinates.y);
    if (![self.mealTags containsObject:tagToAdd]) {
        [self.mealTags addObject:tagToAdd];
    }
    [self dismissTable];
    [self showTags];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    FSMealTag *newMealTag = (FSMealTag *)self.mealsArray[indexPath.row];
    cell.textLabel.text = newMealTag.mealName;
    cell.backgroundColor = [UIColor clearColor];
    [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
    [cell setUserInteractionEnabled:YES];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.mealsArray count];
}

#pragma mark - MenuPopOverViewDelegate method

- (void)popoverView:(MenuPopOverView *)popoverView didSelectItemAtIndex:(NSInteger)index
{
    FSMealTag *mealTag;
    for (FSMealTag *tempMealTag in self.mealTags) {
        if ([self.popOversDict[tempMealTag.mealName] isEqual:popoverView]) {
            mealTag = tempMealTag;
        }
    }
    
    if ([[popoverView buttons] count]>2) {
        index = (index-1);
        if (index<0) {
            index = 2;
        }
    }
    
    if (index == 0) {
        NSLog(@"clicked on food");
        
        if (![self.editableTag isEqual:mealTag]) {
            if (self.editableTag) {
                // if something was being edited, stop it
                MenuPopOverView *popOver = [self.editableTag stopTagEditable:self.editablePopOver];
                popOver.delegate = self;
                self.popOversDict[self.editableTag.mealName] = popOver;
            }
            MenuPopOverView *popOver =[mealTag makeTagEditable:popoverView];
            self.editableTag = mealTag;
            self.editablePopOver = popOver;
            self.popOversDict[self.editableTag.mealName] = popOver;
            popOver.delegate = self;
            if (![self.view.gestureRecognizers containsObject:self.panTag]) {
                [self.view addGestureRecognizer:self.panTag];
            }
        } else {
            // if an editable tag was pressed, stop it
            self.editableTag = nil;
            self.editablePopOver = nil;
            MenuPopOverView *popOver = [mealTag stopTagEditable:popoverView];
            self.popOversDict[mealTag.mealName] = popOver;
            popOver.delegate = self;
            [self.view removeGestureRecognizer:self.panTag];
        }
        
    } else if (index == 1) {
        NSLog(@"clicked on close icon");
        [self.mealTags removeObject:mealTag];
        self.editableTag = nil;
        self.editablePopOver = nil;
        [self checkTagCount];
        [popoverView dismiss:YES];
        popoverView = nil;
        
    } else if (index == 2) {
        NSLog(@"clicked on arrow icon");
        MenuPopOverView *popOver = [self.editableTag toggleArrow:popoverView];
        self.popOversDict[mealTag.mealName] = popOver;
        self.editablePopOver = popOver;
        popOver.delegate = self;
        if (![self.view.gestureRecognizers containsObject:self.panTag]) {
            [self.view addGestureRecognizer:self.panTag];
        }
    }
}

#pragma mark - VC methods

- (void)doneTapped:(id)sender
{
    [self.delegate submitTags:self.mealTags];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancelTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)singleTap:(UITapGestureRecognizer *)sender
{
    CGPoint touchedPoint = [sender locationInView:self.view];
    
    if (self.instructionLabel.alpha == 1) {
        for (MenuPopOverView *popOver in [self.popOversDict allValues]) {
            for (UIButton *button in popOver.buttons) {
                CGRect buttonFrame = [button.superview convertRect:button.frame toView:self.view];
                if (CGRectContainsPoint(buttonFrame, touchedPoint)) {
                    [button sendActionsForControlEvents:UIControlEventTouchUpInside];
                    return;
                }
            }
        }
    }
    
    if (CGRectContainsPoint(self.imageView.frame, touchedPoint) && self.instructionLabel.alpha == 1) {
        NSLog(@"image was tapped");
        NSLog(@"x:%f, y:%f", touchedPoint.x, touchedPoint.y);
        
        // save coordinates of touch;
        self.newTagCoordinates = touchedPoint;
        
        // stop editing tag
        if (self.editableTag) {
            MenuPopOverView *popOver = [self.editableTag stopTagEditable:self.editablePopOver];
            self.popOversDict[self.editableTag.mealName] = popOver;
            popOver.delegate = self;
            self.editableTag = nil;
            self.editablePopOver = nil;
            [self.view removeGestureRecognizer:self.panTag];
            return;
        }
        
        // make menuitems
        if (self.instructionLabel.alpha == 1) {
            [UIView animateWithDuration:.3 animations:^{
                [self.instructionLabel setAlpha:0];
                [self.menuTable setAlpha:1];
                [self.menuTable setScrollEnabled:YES];
                [self.cancelTableButton setAlpha:1];
                [self.cancelTableButton setEnabled:YES];
                [self.cancelTableButton setFrame:CGRectMake((self.view.frame.size.width-70)/2, self.view.frame.size.width+(self.view.frame.size.height-self.view.frame.size.width-70)/2, 70, 70)];
                
            }];
        }
        
    } else if (self.instructionLabel.alpha == 1) {
        // stop editing tag
        if (self.editableTag) {
            MenuPopOverView *popOver = [self.editableTag stopTagEditable:self.editablePopOver];
            self.popOversDict[self.editableTag.mealName] = popOver;
            popOver.delegate = self;
            self.editableTag = nil;
            self.editablePopOver = nil;
            [self.view removeGestureRecognizer:self.panTag];
        }
    } else if (self.menuTable.alpha == 1){
        touchedPoint = [sender locationInView:self.menuTable];
        NSIndexPath *rowIp = [self.menuTable indexPathForRowAtPoint:touchedPoint];
        if (rowIp != nil) {
            NSLog(@"%d", rowIp.row);
            [self tableView:self.menuTable didSelectRowAtIndexPath:rowIp];
        }
    }
}

- (void)checkTagCount
{
    if ([self.mealTags count]>0) {
        [self setDoneButton];
        self.instructionLabel.text = @"Select tag to edit";
    } else{
        [self unsetDoneButton];
        self.instructionLabel.text = @"Tap to tag meal";
    }
}

- (void)setDoneButton
{
    if (!self.navigationItem.rightBarButtonItem) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneTapped:)];
    }
}

- (void)unsetDoneButton
{
    self.navigationItem.rightBarButtonItem = nil;
}


- (void)showTags
{
//    for (MenuPopOverView *popOver in [self.popOversDict allValues]) {
//        [popOver dismiss:NO];
//    }
    for (UIView *view in self.imageView.subviews) {
        [view removeFromSuperview];
    }
    
    for (FSMealTag *mealTag in self.mealTags) {
        MenuPopOverView *popOver = [mealTag showTagInView:self.imageView];
        self.popOversDict[mealTag.mealName] = popOver;
        popOver.delegate = self;
    }
}

- (void)panPopOver:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:self.imageView];
    MenuPopOverView *popOver = self.editablePopOver;
    CGPoint newCoordinates = CGPointMake(popOver.pointCoordinates.x + translation.x, popOver.pointCoordinates.y + translation.y);
    self.editableTag.coordinateX = @(newCoordinates.x);
    self.editableTag.coordinateY = @(newCoordinates.y);
    [popOver setupLayout:CGRectMake(newCoordinates.x, newCoordinates.y, 0, 0) inView:self.imageView];
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.imageView];
}

- (void)keyboardDidShow
{
    [self.menuTable setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-216)];
}

- (void)keyboardWillHide
{
    [self.menuTable setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
}

- (void)dismissTable
{
    [self.tagSearch resignFirstResponder];
    
    [UIView animateWithDuration:.3 animations:^{
        [self.menuTable setAlpha:0];
        [self.instructionLabel setAlpha:1];
        [self.cancelTableButton setAlpha:0];
        [self.cancelTableButton setEnabled:NO];
        [self.menuTable setScrollEnabled:NO];
        [self.cancelTableButton setFrame:CGRectMake((self.view.frame.size.width-70)/2, self.view.frame.size.height + 70, 70, 70)];
        
        [self checkTagCount];
        
    } completion:^(BOOL finished) {
        [self.menuTable setContentOffset:CGPointZero];
        [self.tagSearch setText:@""];
    }];
}


@end
