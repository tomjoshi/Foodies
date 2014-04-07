//
//  TagPickerViewController.m
//  Foodies
//
//  Created by Lucas Chwe on 3/29/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import "TagPickerViewController.h"
#import "MealTag.h"
#import "Meal.h"
#include <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>
#import <AFNetworking.h>
#import "SinglePlatformSignature.h"
#import "UIColor+colorPallete.h"
#import <QuartzCore/QuartzCore.h>
#import <FontAwesomeKit.h>

@interface TagPickerViewController () <UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate, MenuPopOverViewDelegate, UIGestureRecognizerDelegate>
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UISearchBar *tagSearch;
@property (strong, nonatomic) UISearchDisplayController *searchController;
@property (strong, nonatomic) UITableView *menuTable;
//@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UILabel *instructionLabel;
@property (strong, nonatomic) NSMutableArray *mealsArray;
@property (strong, nonatomic) NSTimer *tableShrinkTimer;
@property (strong, nonatomic) UIButton *cancelTableButton;
@property (nonatomic) CGPoint newTagCoordinates;
@property (nonatomic) BOOL isCancelled;
@property (strong, nonatomic) UIPanGestureRecognizer *panTag;
@property (strong, nonatomic) UITapGestureRecognizer *tapOnImage;
@property (strong, nonatomic) MealTag *editableTag;

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
    
    NSString *urlQuery = [NSString stringWithFormat:@"http://matching-api.singleplatform.com/location-match?client=cmhe9zqp8qn1zwzu8ws6zczjl"];
    
    NSDictionary *params = @{
                                @"locations": @[@{@"foursquare_id": self.mealsVenue.venueId}],
                        @"matching_criteria": @"FOURSQUARE_ID"
                                };
    [manager POST:urlQuery parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"success");
        
        // get the menu now
        NSString *spId = responseObject[@"response"][0][@"spv2id"];
        
        // create url with signature key
        NSString *urlSignatureStuff = [SinglePlatformSignature generateApiSingatureForPath:[NSString stringWithFormat:@"/locations/%@/menu", spId] withParams:nil withCliendId:@"cmhe9zqp8qn1zwzu8ws6zczjl" andApiSecret:@"RwlSK-4Ug2OpjS8Pf6IzqyZpvX1xy-FVxCxR4B1yxeM"];
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
                        [mealNames addObject:entry[@"title"]];
                    }
                    
                }
                
                for (NSString *mealName in mealNames) {
                    [self.mealsArray addObject:[[MealTag alloc]initWithName:mealName andPoint:CGPointZero]];
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
    
//    [manager GET:urlQuery parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSLog(@"success");
//        
//        NSMutableArray *mealNames = [[NSMutableArray alloc] init];
//        NSArray *sections = responseObject[@"objects"][0][@"menus"][0][@"sections"];
//        
//        for (NSDictionary *section in sections) {
//            NSArray *subsections = section[@"subsections"];
//            for (NSDictionary *subsection in subsections) {
//                NSArray *contents = subsection[@"contents"];
//                for (NSDictionary *content in contents) {
//                    NSString *newName = content[@"name"];
//                    if (newName) {
//                        [mealNames addObject:newName];
//                    }
//                }
//            }
//        }
//
//        for (NSString *mealName in mealNames) {
//            [self.mealsArray addObject:[[MealTag alloc]initWithName:mealName andPoint:CGPointZero]];
//        }
//        [self.menuTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        NSLog(@"fail");
//    }];
    
    
//    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
//    [self.scrollView setContentSize:CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height+self.view.bounds.size.width)];
////    [self.scrollView setContentOffset:CGPointMake(<#CGFloat x#>, <#CGFloat y#>)]
//    [self.view addSubview:self.scrollView];
    
    
    // add nav buttons
    
//    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelTapped:)];
//    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.title = @"Tags";
    
//    self.navigationItem.titleView = self.tagSearch;
//    self.searchController = [[UISearchDisplayController alloc] initWithSearchBar:self.tagSearch contentsController:self];
//    [self setSearchController:self.searchController];
//    self.searchController.delegate = self;;
//    self.searchController.searchResultsDataSource = self;
//    self.searchController.searchResultsDelegate = self;
//    [self.view addSubview:self.searchController.searchResultsTableView];
//    [self.searchController.searchResultsTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
//    [self.searchDisplayController setActive:YES animated:YES];
    
    // add table view
    self.menuTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
//    [self.menuTable setBounces:NO];
//    [self.menuTable setContentInset:UIEdgeInsetsMake(screenWidth, 0, 0, 0)];
//    [self.menuTable setBackgroundColor:[UIColor clearColor]];
    [self.menuTable setUserInteractionEnabled:YES];
    [self.menuTable setAllowsSelection:YES];
    [self.menuTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    self.menuTable.delegate = self;
    self.menuTable.dataSource = self;
    [self.menuTable setScrollEnabled:NO];
//    [self.menuTable setContentOffset:CGPointMake(0, 44)];
    [self.menuTable setAlpha:0];
    [self.menuTable setBackgroundView:nil];
    [self.menuTable setOpaque:NO];
    [self.menuTable setBackgroundColor:[UIColor semiTransparentWhiteColor]];
//    [self.menuTable setBackgroundColor:[UIColor blackColor]];
//    [self.menuTable setContentInset:UIEdgeInsetsMake(44, 0, 0, 0)];
    [self.view addSubview:self.menuTable];
//    [self.view sendSubviewToBack:self.menuTable];
    
    // add cancel button
    self.cancelTableButton = [[UIButton alloc] initWithFrame:CGRectMake((screenWidth-70)/2, screenWidth+(screenHeight-screenWidth-64-70)/2, 70, 70)];
    FAKIonIcons *cancelButton = [FAKIonIcons closeRoundIconWithSize:25];
    [cancelButton addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    [self.cancelTableButton setAttributedTitle:[cancelButton attributedString] forState:UIControlStateNormal];
    [self.cancelTableButton addTarget:self action:@selector(dismissTable) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelTableButton setBackgroundColor:[UIColor grayColor]];
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
    [self showTags];
    
    // add instructions label
    self.instructionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, screenWidth, screenWidth, screenHeight-screenWidth-64)];
    self.instructionLabel.text = @"Tap on your meal";
    [self.instructionLabel setTextAlignment:NSTextAlignmentCenter];
    //    [self.instructionLabel setTextColor:[UIColor whiteColor]];
    [self.instructionLabel setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.instructionLabel];
    
    
    // hide table
//    [self.menuTable setAlpha:1];
    
    // add search bar
//    self.tagSearch = [[UISearchBar alloc] initWithFrame:CGRectMake(instructionLabel.frame.origin.x, instructionLabel.frame.origin.y, instructionLabel.frame.origin.x, 44)];
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
    
    for (MealTag *mealTag in self.mealTags) {
        for (UIButton *button in mealTag.popOver.buttons) {
            CGRect buttonFrame = [button.superview convertRect:button.frame toView:self.view];
            if (CGRectContainsPoint(buttonFrame, touchedPoint)) {
                [button sendActionsForControlEvents: UIControlEventTouchUpInside];
                return;
            }
        }
    }
    
    if (CGRectContainsPoint(self.imageView.frame, touchedPoint) && self.instructionLabel.alpha == 1) {
        NSLog(@"image was tapped");
//        [self.tagSearch setHidden:NO];
//        [self.tagSearch becomeFirstResponder];
        
        NSLog(@"x:%f, y:%f", touchedPoint.x, touchedPoint.y);
        
        // save coordinates of touch;
        self.newTagCoordinates = touchedPoint;
        
        // stop editing tag
        if (self.editableTag) {
            [self.editableTag stopTagEditable];
            self.editableTag.popOver.delegate = self;
            self.editableTag = nil;
            [self.view removeGestureRecognizer:self.panTag];
            return;
        }
        
        // make menuitems
        if (self.instructionLabel.alpha == 1) {
            [UIView animateWithDuration:.3 animations:^{
                [self.instructionLabel setAlpha:0];
                [self.menuTable setAlpha:1];
                [self.menuTable setScrollEnabled:YES];
                [self.cancelTableButton setAlpha:.8];
                [self.cancelTableButton setEnabled:YES];
            }];
        }
        
    } else if (self.menuTable.alpha == 1){
        touchedPoint = [sender locationInView:self.menuTable];

        NSIndexPath *rowIp = [self.menuTable indexPathForRowAtPoint:touchedPoint];
//        [self.menuTable selectRowAtIndexPath:rowIp animated:YES scrollPosition:UITableViewScrollPositionNone];
        if (rowIp != nil) {
            NSLog(@"%d", rowIp.row);
            [self tableView:self.menuTable didSelectRowAtIndexPath:rowIp];
        }
    }
    
//    [self.menuTable hitTest:touchedPoint withEvent:UIEventSubtypeNone];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
//        [self.instructionLabel setAlpha:1];
//        [self.menuTable setScrollEnabled:NO];
    [self.tagSearch resignFirstResponder];
//    if ([self.tagSearch.text isEqualToString:@""]) {
//        [self.menuTable setContentOffset:CGPointMake(0, 44) animated:YES];
//    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO];
    [[tableView cellForRowAtIndexPath:indexPath] setHighlighted:NO];
    MealTag *tagToAdd = self.mealsArray[indexPath.row];
    tagToAdd.coordinates = self.newTagCoordinates;
    if (![self.mealTags containsObject:tagToAdd]) {
        [self.mealTags addObject:tagToAdd];
    }
    [self dismissTable];
    [self showTags];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
//    if (![self.tagSearch isFirstResponder]) {
//        [self.tagSearch setText:@""];
//        self.isCancelled = YES;
//    }
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
//    if (self.isCancelled) {
//        return NO;
//        self.isCancelled = NO;
//    }
    return YES;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    MealTag *newMealTag = (MealTag *)self.mealsArray[indexPath.row];
    cell.textLabel.text = newMealTag.meal.name;
    cell.backgroundColor = [UIColor clearColor];
    [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
    [cell setUserInteractionEnabled:YES];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.mealsArray count];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    return YES;
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
//    [self.menuTable setContentOffset:CGPointZero animated:YES];
//    [self.menuTable setContentInset:UIEdgeInsetsMake(self.menuTable.contentInset.top, self.menuTable.contentInset.left, 216, self.menuTable.contentInset.top)]

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
        //        [self.menuTable setFrame:CGRectMake(0, self.view.frame.size.width, self.view.frame.size.width, self.view.frame.size.height- self.view.frame.size.width)];
        [self.menuTable setAlpha:0];
        [self.instructionLabel setAlpha:1];
        [self.cancelTableButton setAlpha:0];
        [self.cancelTableButton setEnabled:NO];
        [self.menuTable setScrollEnabled:NO];
        
        if ([self.mealTags count]>0) {
            [self setDoneButton];
        } else{
            [self unsetDoneButton];
        }
    } completion:^(BOOL finished) {
        [self.menuTable setContentOffset:CGPointZero];
        [self.tagSearch setText:@""];
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//        [self.imageView setCenter:CGPointMake(self.imageView.frame.size.width/2, self.menuTable.contentOffset.y +self.imageView.frame.size.height/2)];
    NSLog(@"%f", self.menuTable.contentOffset.y);

}

- (void)setDoneButton
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneTapped:)];
}

- (void)unsetDoneButton
{
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)showTags
{
    for (MealTag *mealTag in self.mealTags) {
        [mealTag showTagInView:self.imageView];
        mealTag.popOver.delegate = self;
    }
}

- (void)popoverView:(MenuPopOverView *)popoverView didSelectItemAtIndex:(NSInteger)index
{
    if (index == 0) {
        NSLog(@"clicked on food");
        
        for (MealTag *mealTag in self.mealTags) {
            if ([mealTag.popOver isEqual:popoverView]) {
                if (![self.editableTag isEqual:mealTag]) {
                    if (self.editableTag) {
                        // if something was being edited, stop it
                        [self.editableTag stopTagEditable];
                        self.editableTag.popOver.delegate = self;
                    }
                    [mealTag makeTagEditable];
                    self.editableTag = mealTag;
                    mealTag.popOver.delegate = self;
                    if (![self.view.gestureRecognizers containsObject:self.panTag]) {
                        [self.view addGestureRecognizer:self.panTag];
                    }
                } else {
                    // if an editable tag was pressed, stop it
                    [mealTag stopTagEditable];
                    mealTag.popOver.delegate = self;
                    self.editableTag = nil;
                    [self.view removeGestureRecognizer:self.panTag];
                }
            }
        }
    } else if (index == 1) {
        NSLog(@"clicked on close icon");
        for (MealTag *mealTag in self.mealTags) {
            if ([mealTag.popOver isEqual:popoverView]) {
                [self.mealTags removeObject:mealTag];
                break;
            }
        }
        [popoverView dismiss:YES];
    }
}

- (void)panPopOver:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:self.imageView];
    MenuPopOverView *popOver = self.editableTag.popOver;
    self.editableTag.coordinates = CGPointMake(popOver.pointCoordinates.x + translation.x, popOver.pointCoordinates.y + translation.y);
    [popOver setupLayout:CGRectMake(self.editableTag.coordinates.x, self.editableTag.coordinates.y, 0, 0) inView:self.imageView];
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.imageView];
}


@end
