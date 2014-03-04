//
//  TabBarController.m
//  Foodies
//
//  Created by Lucas Chwe on 2/28/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import "TabBarController.h"
#import <FontAwesomeKit.h>
#import <DBCameraViewController.h>

@interface TabBarController () <DBCameraViewControllerDelegate, UITabBarControllerDelegate>
@property (strong, nonatomic) NSArray *arrayOfVCs;
@property (strong, nonatomic) UILongPressGestureRecognizer *touchDownCamera;
@property (strong, nonatomic) UITapGestureRecognizer *regularTap;

@end

@implementation TabBarController


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
    
    UIViewController *homeVC = self.viewControllers[0];
    FAKFontAwesome *homeIcon = [FAKFontAwesome homeIconWithSize:25];
    [homeIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    UIImage *homeIconImage = [homeIcon imageWithSize:CGSizeMake(25, 25)];
    homeVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Feed" image:homeIconImage tag:1];
    
    UIViewController *discoverVC = self.viewControllers[1];
    FAKFontAwesome *searchIcon = [FAKFontAwesome searchIconWithSize:25];
    [searchIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    UIImage *searchIconImage = [searchIcon imageWithSize:CGSizeMake(25, 25)];
    discoverVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Discover" image:searchIconImage tag:1];
    
    UIViewController *cameraVC = self.viewControllers[2];
    FAKFontAwesome *cameraIcon = [FAKFontAwesome cameraIconWithSize:25];
    [cameraIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    UIImage *cameraIconImage = [cameraIcon imageWithSize:CGSizeMake(25, 25)];
    cameraVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Camera" image:cameraIconImage tag:1];
    // add touch down inside action listener to start camera
    
    UIViewController *wantVC = self.viewControllers[3];
    FAKFontAwesome *starOIcon = [FAKFontAwesome starOIconWithSize:25];
    [starOIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    UIImage *starOIconImage = [starOIcon imageWithSize:CGSizeMake(25, 25)];
    wantVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Want" image:starOIconImage tag:1];
    
    UIViewController *profileVC = self.viewControllers[4];
    FAKFontAwesome *userIcon = [FAKFontAwesome userIconWithSize:25];
    [userIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    UIImage *userIconImage = [userIcon imageWithSize:CGSizeMake(25, 25)];
    profileVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Profile" image:userIconImage tag:1];
    
    
    
    // take over control of gestures over uitabbar
//    discoverVC.tabBarItem.enabled = NO;
//    homeVC.tabBarItem.enabled = NO;
//    cameraVC.tabBarItem.enabled = NO;
//    wantVC.tabBarItem.enabled = NO;
//    profileVC.tabBarItem.enabled = NO;
    
    
    self.touchDownCamera = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(takePhoto:)];
    [self.tabBar addGestureRecognizer:self.touchDownCamera];
    
    self.regularTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectViewController:)];
    [self.regularTap requireGestureRecognizerToFail:self.touchDownCamera];
    [self.tabBar addGestureRecognizer:self.regularTap];
    
    self.arrayOfVCs = self.viewControllers;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)takePhoto:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        NSLog(@"long press ended");
        //        [self setViewControllers:self.arrayOfVCs animated:NO];
        UINavigationController *nav = (UINavigationController *)self.selectedViewController;
        [nav popToRootViewControllerAnimated:NO];
    } else {
        NSLog(@"long press started");
        [self openCamera];
    }
    
}

- (void)selectViewController:(UITapGestureRecognizer *)sender
{
    NSLog(@"normal tap");
    NSLog(@"%f %f", [sender locationInView:self.tabBar].x, [sender locationInView:self.tabBar].y);
    
    [self setSelectedIndex:3];
    
}

- (void) openCamera
{
    DBCameraViewController *cameraVC = [DBCameraViewController initWithDelegate:self];
    cameraVC.hidesBottomBarWhenPushed = NO;

    
    UINavigationController *nav = (UINavigationController *)self.selectedViewController;
    [nav setNavigationBarHidden:YES animated:NO];
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.selectedViewController];
//    [nav setNavigationBarHidden:YES];
//    nav.hidesBottomBarWhenPushed = NO;
    
    [nav pushViewController:cameraVC animated:NO];
    //nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    [self presentViewController:nav animated:YES completion:nil];
//    [self.navigationController pushViewController:nav animated:YES];
//    [self setViewControllers:@[nav] animated:YES];
}




@end
