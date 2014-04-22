//
//  SignUpViewController.m
//  Foodies
//
//  Created by Lucas Chwe on 3/26/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import "SignUpViewController.h"
#import "LogInTableViewCell.h"
#import <Parse/Parse.h>
#import "Foodie.h"

@interface SignUpViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (strong, nonatomic) UITextField *passwordField;
@property (strong, nonatomic) UITextField *emailField;

- (IBAction)signUpTapped:(id)sender;
- (IBAction)cancelTapped:(id)sender;
@end

@implementation SignUpViewController

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
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
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
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LogInTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"loginCell"];
    
    if (indexPath.row == 2) {
        cell.textField.secureTextEntry = YES;
        cell.textField.placeholder = @"Password";
        self.passwordField = cell.textField;
    } else if(indexPath.row == 1) {
        cell.textField.placeholder = @"Email";
        [cell.textField setKeyboardType:UIKeyboardTypeEmailAddress];
        self.emailField = cell.textField;
    }
    
    cell.textField.delegate = self;
    
    return cell;
}

#pragma mark - IBActions methods

- (IBAction)signUpTapped:(id)sender {
    
    LogInTableViewCell *cell1 = (LogInTableViewCell* )[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    LogInTableViewCell *cell2 = (LogInTableViewCell* )[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:2 inSection:0]];
    LogInTableViewCell *cell3 = (LogInTableViewCell* )[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];

    [Foodie signUpWithUsernameInBackground:cell1.textField.text password:cell2.textField.text email:cell3.textField.text success:^{
        // dismiss modalview
        [self.delegate didLoggedIn];
        [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    } failure:^(NSError *error) {
        NSString *errorString = [error userInfo][@"error"];
        NSLog(@"%@", errorString);
    }];
}

- (IBAction)cancelTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Keyboard methods

- (void)keyboardWillShow
{
    [self.mainScrollView setContentOffset:CGPointMake(0, 80) animated:YES];
}

- (void)keyboardWillHide
{
    [self.mainScrollView setContentOffset:CGPointZero animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:self.emailField]) {
        [self.passwordField becomeFirstResponder];
    } else if ([textField isEqual:self.passwordField]) {
        [textField resignFirstResponder];
    } else {
        [self.emailField becomeFirstResponder];
    }
    return YES;
}


@end
