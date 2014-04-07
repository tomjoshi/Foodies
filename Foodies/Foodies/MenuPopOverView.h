//
//  MenuPopOverView.h
//  SearchBar
//
//  Created by Camel Yang on 4/1/14.
//  Copyright (c) 2014 camelcc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MenuPopOverView;

@protocol MenuPopOverViewDelegate <NSObject>
@optional
- (void)popoverView:(MenuPopOverView *)popoverView didSelectItemAtIndex:(NSInteger)index;
- (void)popoverViewDidDismiss:(MenuPopOverView *)popoverView;

@end

@interface MenuPopOverView : UIView

@property (weak, nonatomic) id<MenuPopOverViewDelegate> delegate;
@property (nonatomic) CGRect presentedRect;
@property (nonatomic) BOOL isArrowUp;
@property (nonatomic) CGPoint arrowPoint;
@property (nonatomic) CGPoint pointCoordinates;
@property (strong, nonatomic) NSMutableArray *buttons; // of MenuPopOverButton
@property (strong, nonatomic) UITapGestureRecognizer *tap;
- (void)presentPopoverFromRect:(CGRect)rect inView:(UIView *)view withStrings:(NSArray *)stringArray;
- (void)setupLayout:(CGRect)rect inView:(UIView*)view;
- (void)dismiss:(BOOL)animate;
@end
