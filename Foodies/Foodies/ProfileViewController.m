//
//  ProfileViewController.m
//  Foodies
//
//  Created by Lucas Chwe on 3/26/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import "ProfileViewController.h"
#import "LandingTableViewController.h"

@interface ProfileViewController ()
- (IBAction)logOutTapped:(id)sender;

@end

@implementation ProfileViewController

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

- (IBAction)logOutTapped:(id)sender {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:nil forKey:@"userId"];
    [defaults synchronize];
    
    
    LandingTableViewController *modalVC = [self.storyboard instantiateViewControllerWithIdentifier:@"logInController"];
    [self presentViewController:modalVC animated:YES completion:nil];
    
}
@end
