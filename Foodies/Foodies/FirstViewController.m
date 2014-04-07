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

@interface FirstViewController ()
@property (strong, nonatomic) MenuPopOverView *popOver;
@property (nonatomic) CGRect popOverInitialRect;
@property (strong, nonatomic) UIImageView *foodImage;

@end

@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.}
    
    self.popOver = [[MenuPopOverView alloc] init];
    //    popOver.delegate = self;
    
    self.foodImage= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ramenImage"]];
    [self.foodImage setContentMode:UIViewContentModeScaleAspectFill];
    [self.foodImage setFrame:CGRectMake(0, 100, 320, 320)];
    [self.foodImage setUserInteractionEnabled:YES];
    [self.view addSubview:self.foodImage];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panPopOver:)];
//    pan.delaysTouchesBegan = NO;
    pan.delaysTouchesBegan = NO;
    pan.delaysTouchesEnded = NO;
    
    // make close icon
    FAKIonIcons *closeIcon = [FAKIonIcons closeCircledIconWithSize:25];
    [closeIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    
    [self.popOver presentPopoverFromRect:CGRectMake(0, -100, 0, 0) inView:self.foodImage withStrings:@[@"Spicy Miso Ramen",[closeIcon attributedString]]];
    NSLog(@"initial x %f", self.popOver.arrowPoint.x);
    NSLog(@"initial y %f", self.popOver.arrowPoint.y);
    [self.popOver addGestureRecognizer:pan];
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

@end
