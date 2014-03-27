//
//  SignUpViewController.m
//  Foodies
//
//  Created by Lucas Chwe on 3/26/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import "SignUpViewController.h"
#import "LogInTableViewCell.h"

@interface SignUpViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

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
    } else if(indexPath.row == 1) {
        cell.textField.placeholder = @"Email";
    }
    
    cell.textField.delegate = self;
    
    return cell;
}

- (IBAction)signUpTapped:(id)sender {
}

- (IBAction)cancelTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
