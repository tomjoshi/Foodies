//
//  TagPickerViewController.m
//  Foodies
//
//  Created by Lucas Chwe on 3/29/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import "TagPickerViewController.h"
#import "MealTag.h"

@interface TagPickerViewController ()
@property (strong, nonatomic) NSMutableArray *mealTags;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UISearchBar *tagSearch;

- (IBAction)doneTapped:(id)sender;
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
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    self.imageView = [[UIImageView alloc] initWithImage:self.imageToTag];
    [self.imageView setContentMode:UIViewContentModeScaleAspectFill];
    [self.imageView setFrame:CGRectMake(0, 0, screenWidth, screenWidth)];
    [self.imageView setClipsToBounds:YES];
    [self.view addSubview:self.imageView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneTapped:)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];

    UITapGestureRecognizer *tapOnImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    [self.view addGestureRecognizer:tapOnImage];
    
    
    self.tagSearch = [[UISearchBar alloc] init];
    self.tagSearch.placeholder = @"Find or create a meal";
    [self.tagSearch setHidden:YES];
    self.navigationItem.titleView = self.tagSearch;
    
    UILabel *instructionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, screenWidth, screenWidth, screenHeight-screenWidth-64)];
    instructionLabel.text = @"Tap to tag meal";
    [instructionLabel setTextAlignment:NSTextAlignmentCenter];
    [instructionLabel setTextColor:[UIColor whiteColor]];
    [self.view addSubview:instructionLabel];
    
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

- (void)singleTap:(UITapGestureRecognizer *)sender
{
    if (CGRectContainsPoint(self.imageView.frame,[sender locationInView:self.view])) {
        NSLog(@"image was tapped");
        [self.tagSearch setHidden:NO];
        [self.tagSearch becomeFirstResponder];
    }
}

@end
