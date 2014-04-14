//
//  LandingTableViewController.m
//  Foodies
//
//  Created by Lucas Chwe on 3/26/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import "LandingTableViewController.h"
#import "LogInTableViewCell.h"
#import <FBShimmeringView.h>
#import <Parse/Parse.h>
#import "SignUpViewController.h"
#import "Foodie.h"

@interface LandingTableViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet FBShimmeringView *shimmeringView;
@property (weak, nonatomic) IBOutlet UILabel *foodiesLabel;


- (IBAction)logInTapped:(id)sender;

@end

@implementation LandingTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.scrollView.delegate = self;
    
    [self.scrollView setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollTapped:)];
    tap.delegate = self;
    tap.numberOfTapsRequired = 1;
    [self.scrollView addGestureRecognizer:tap];
    
    // set up shimmering
    self.shimmeringView.contentView = self.foodiesLabel;
    self.shimmeringView.shimmering = YES;
    
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
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LogInTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"loginCell"];

    if (indexPath.row == 1) {
        cell.textField.secureTextEntry = YES;
        cell.textField.placeholder = @"Password";
    }
    
    cell.textField.delegate = self;
    
    return cell;
}

#pragma mark - UITextFieldDelegate Methods

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.scrollView setContentOffset:CGPointMake(0, 80) animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField.placeholder isEqualToString:@"Email"]) {
        LogInTableViewCell *cell = (LogInTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        [cell.textField becomeFirstResponder];
    } else {
        [self hideKeyboard];
        
        // press login
        [self logInTapped:nil];
    }
    return YES;
}

#pragma mark - VC methods

- (void)hideKeyboard
{
    
    LogInTableViewCell *cell1 = (LogInTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    LogInTableViewCell *cell2 = (LogInTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    if ([cell1.textField isFirstResponder]) {
        [cell1.textField resignFirstResponder];
    } else {
        [cell2.textField resignFirstResponder];
    }
    
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

#pragma mark - UIGestureRecognizerDelegate methods

- (void)scrollTapped:(UITapGestureRecognizer *)sender
{
    CGPoint location = [sender locationInView:self.scrollView];
    
    LogInTableViewCell *cell1 = (LogInTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    LogInTableViewCell *cell2 = (LogInTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    BOOL touchOnCell1 = CGRectContainsPoint(cell1.frame, location);
    BOOL touchOnCell2 = CGRectContainsPoint(cell2.frame, location);
    
    if (([cell1.textField isFirstResponder] || [cell2.textField isFirstResponder]) && (!touchOnCell1 || !touchOnCell2)) {
        [self hideKeyboard];
    }

}

#pragma mark - IBActions methods

- (IBAction)logInTapped:(id)sender {
    
    LogInTableViewCell *cell1 = (LogInTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    LogInTableViewCell *cell2 = (LogInTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    // verify format of email and password
    
    // if its all good then hide keyboard
    [self hideKeyboard];
    
    // make api call to receive user id
    
    // store user id in nsuserdefaults
    
    [Foodie logInWithUsernameInBackground:cell1.textField.text password:cell2.textField.text success:^{
        NSLog(@"logged in properly!");
        // dismiss modalview
        [self.delegate didLoggedIn];
        [self dismissViewControllerAnimated:YES completion:nil];
    } failure:^(NSError *error) {
        NSLog(@"failed to log in! with error: %@", error);
    }];
    
}

#pragma mark - Navigation method

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    SignUpViewController *segueVC = segue.destinationViewController;
    segueVC.delegate = self.delegate;
}

@end
