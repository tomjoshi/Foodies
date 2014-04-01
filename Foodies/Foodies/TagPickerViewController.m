//
//  TagPickerViewController.m
//  Foodies
//
//  Created by Lucas Chwe on 3/29/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import "TagPickerViewController.h"
#import "MealTag.h"

@interface TagPickerViewController () <UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate>
@property (strong, nonatomic) NSMutableArray *mealTags;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UISearchBar *tagSearch;
@property (strong, nonatomic) UISearchDisplayController *searchController;
@property (strong, nonatomic) UITableView *menuTable;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UILabel *instructionLabel;
@property (strong, nonatomic) NSArray *mealsArray;
@property (nonatomic) BOOL isCancelled;

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
    self.mealsArray = @[[[MealTag alloc] init],[[MealTag alloc] init],[[MealTag alloc] init]];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.scrollView setContentSize:CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height+self.view.bounds.size.width)];
//    [self.scrollView setContentOffset:CGPointMake(<#CGFloat x#>, <#CGFloat y#>)]
    [self.view addSubview:self.scrollView];
    
    
    // add nav buttons
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneTapped:)];
//    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelTapped:)];
//    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.title = @"Meals";
    
    
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
    self.menuTable = [[UITableView alloc]initWithFrame:CGRectMake(0, screenWidth, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
//    [self.menuTable setBounces:NO];
//    [self.menuTable setContentInset:UIEdgeInsetsMake(screenWidth, 0, 0, 0)];
//    [self.menuTable setBackgroundColor:[UIColor clearColor]];
    [self.menuTable setUserInteractionEnabled:YES];
    [self.menuTable setAllowsSelection:YES];
    self.menuTable.delegate = self;
    self.menuTable.dataSource = self;
    [self.menuTable setScrollEnabled:NO];
    [self.menuTable setContentOffset:CGPointMake(0, 44)];
//    [self.menuTable setContentInset:UIEdgeInsetsMake(44, 0, 0, 0)];
    [self.view addSubview:self.menuTable];
//    [self.view sendSubviewToBack:self.menuTable];
    
    
    // add image
    self.imageView = [[UIImageView alloc] initWithImage:self.imageToTag];
    [self.imageView setContentMode:UIViewContentModeScaleAspectFill];
    [self.imageView setFrame:CGRectMake(0, 0, screenWidth, screenWidth)];
    [self.imageView setClipsToBounds:YES];
    [self.view addSubview:self.imageView];
    [self.view sendSubviewToBack:self.imageView];
    
    
    // add instructions label
    self.instructionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, screenWidth, screenWidth, screenHeight-screenWidth-64)];
    self.instructionLabel.text = @"Tap to tag meal";
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
    UITapGestureRecognizer *tapOnImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    [self.view addGestureRecognizer:tapOnImage];
    
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
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancelTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)singleTap:(UITapGestureRecognizer *)sender
{
    CGPoint touchedPoint = [sender locationInView:self.view];
    if (CGRectContainsPoint(self.imageView.frame, touchedPoint) && self.instructionLabel.alpha == 1) {
        NSLog(@"image was tapped");
//        [self.tagSearch setHidden:NO];
//        [self.tagSearch becomeFirstResponder];
        
        NSLog(@"x:%f, y:%f", touchedPoint.x, touchedPoint.y);
        
        // make menuitems
        if (self.instructionLabel.alpha == 1) {
            [UIView animateWithDuration:.3 animations:^{
                [self.instructionLabel setAlpha:0];
                [self.menuTable setScrollEnabled:YES];
            }];
        }
        
    } else if (self.menuTable.frame.origin.y == 0 || (self.menuTable.frame.origin.y != 0 && !CGRectContainsPoint(self.imageView.frame, touchedPoint))){
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
    if ([self.tagSearch.text isEqualToString:@""]) {
        [self.menuTable setContentOffset:CGPointMake(0, 44) animated:YES];
    }
    [UIView animateWithDuration:.3 animations:^{
        [self.menuTable setFrame:CGRectMake(0, self.view.frame.size.width, self.view.frame.size.width, self.view.frame.size.height- self.view.frame.size.width)];
//        [self.instructionLabel setAlpha:1];
//        [self.menuTable setScrollEnabled:NO];
        [self.tagSearch resignFirstResponder];
    } completion:^(BOOL finished) {
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tagSearch resignFirstResponder];
    [self.tagSearch setText:@""];
    
    [UIView animateWithDuration:.3 animations:^{
        [self.menuTable setFrame:CGRectMake(0, self.view.frame.size.width, self.view.frame.size.width, self.view.frame.size.height- self.view.frame.size.width)];
        [self.menuTable setContentOffset:CGPointMake(0, 44)];
        [self.instructionLabel setAlpha:1];
        [self.menuTable setScrollEnabled:NO];
    }];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    if (![self.tagSearch isFirstResponder]) {
        [self.tagSearch setText:@""];
        self.isCancelled = YES;
    }
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    if (self.isCancelled) {
        return NO;
        self.isCancelled = NO;
    }
    return YES;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    MealTag *newMealTag = (MealTag *)self.mealsArray[indexPath.row];
    cell.textLabel.text = newMealTag.meal.name;
//    cell.backgroundColor = [UIColor whiteColor];
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
    [UIView animateWithDuration:.3 animations:^{
        [self.menuTable setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)];
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//        [self.imageView setCenter:CGPointMake(self.imageView.frame.size.width/2, self.menuTable.contentOffset.y +self.imageView.frame.size.height/2)];
    NSLog(@"%f", self.menuTable.contentOffset.y);

}


@end
