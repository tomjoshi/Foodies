//
//  FirstViewController.m
//  Foodies
//
//  Created by Lucas Chwe on 2/24/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import "FirstViewController.h"
#import <FontAwesomeKit.h>
#import "MenuPopOverView.h"
#import <FontAwesomeKit.h>

@interface FirstViewController () <MenuPopOverViewDelegate>
@property (strong, nonatomic) MenuPopOverView *popOver;
@property (nonatomic) CGRect popOverInitialRect;
@property (strong, nonatomic) UIImageView *foodImage;
@property (strong, nonatomic) UIPanGestureRecognizer *pan;

@end

@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.}
    
    self.popOver = [[MenuPopOverView alloc] init];
    self.popOver.delegate = self;
    
    self.foodImage= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ramenImage"]];
    [self.foodImage setContentMode:UIViewContentModeScaleAspectFill];
    [self.foodImage setFrame:CGRectMake(0, 100, 320, 320)];
    [self.foodImage setUserInteractionEnabled:YES];
    [self.view addSubview:self.foodImage];
    
    self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panPopOver:)];
//    pan.delaysTouchesBegan = NO;
    self.pan.delaysTouchesBegan = NO;
    self.pan.delaysTouchesEnded = NO;
    
    
    //    [self.popOver presentPopoverFromRect:CGRectMake(0, -100, 0, 0) inView:self.foodImage withStrings:@[@"Spicy Miso Ramen",[closeIcon attributedString]]];
    [self.popOver presentPopoverFromRect:CGRectMake(self.foodImage.center.x, self.foodImage.center.y, 0, 0) inView:self.foodImage withStrings:@[@"Spicy Miso Ramen"]];
    NSLog(@"initial x %f", self.popOver.arrowPoint.x);
    NSLog(@"initial y %f", self.popOver.arrowPoint.y);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)panPopOver:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:self.foodImage];
//    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y + translation.y);
    MenuPopOverView *popOver = (MenuPopOverView *)recognizer.view;
    if (popOver.isArrowUp) {
        [popOver setupLayout:CGRectMake(popOver.arrowPoint.x + translation.x, popOver.arrowPoint.y-1 + translation.y, 0, 0) inView:self.foodImage];
    } else {
        [popOver setupLayout:CGRectMake(popOver.arrowPoint.x + translation.x, popOver.arrowPoint.y+1 + translation.y, 0, 0) inView:self.foodImage];
    }
    
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.foodImage];
    
  //  NSLog(@"%f, %f", popOver.arrowPoint.x, popOver.arrowPoint.y );

}

- (void)popoverView:(MenuPopOverView *)popoverView didSelectItemAtIndex:(NSInteger)index
{
    if (index == 0) {
        NSLog(@"clicked on food");
        
        CGPoint tempArrowPoint = popoverView.arrowPoint;
        NSInteger tempButtons = [popoverView.buttons count];
        BOOL tempIsArrowUp = popoverView.isArrowUp;
        [popoverView removeFromSuperview];
        popoverView = [[MenuPopOverView alloc] init];
        popoverView.delegate = self;
        
        if (tempButtons==1) {
            // make close icon
            FAKIonIcons *closeIcon = [FAKIonIcons closeCircledIconWithSize:18];
            [closeIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
            if (tempIsArrowUp) {
                [popoverView presentPopoverFromRect:CGRectMake(tempArrowPoint.x, tempArrowPoint.y-1, 0, 0) inView:self.foodImage withStrings:@[@"Spicy Miso Ramen",[closeIcon attributedString]]];
            } else {
                [popoverView presentPopoverFromRect:CGRectMake(tempArrowPoint.x, tempArrowPoint.y+1, 0, 0) inView:self.foodImage withStrings:@[@"Spicy Miso Ramen",[closeIcon attributedString]]];
            }
            [popoverView addGestureRecognizer:self.pan];
        } else if (tempButtons==2) {
            if (tempIsArrowUp) {
                [popoverView presentPopoverFromRect:CGRectMake(tempArrowPoint.x, tempArrowPoint.y-1, 0, 0) inView:self.foodImage withStrings:@[@"Spicy Miso Ramen"]];
            } else {
                [popoverView presentPopoverFromRect:CGRectMake(tempArrowPoint.x, tempArrowPoint.y+1, 0, 0) inView:self.foodImage withStrings:@[@"Spicy Miso Ramen"]];
            }
        }
        
    } else if (index == 1) {
        NSLog(@"clicked on close icon");
        [popoverView dismiss:YES];
        [popoverView removeFromSuperview];
        popoverView = nil;
    }
}

@end
