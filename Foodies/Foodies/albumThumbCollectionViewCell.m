//
//  albumThumbCollectionViewCell.m
//  Foodies
//
//  Created by Lucas Chwe on 3/13/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import "albumThumbCollectionViewCell.h"

#define UIColorFromRGB(rgbValue, alp) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(float)alp]

@interface albumThumbCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (strong, nonatomic) UIView *selectedView;
@property (strong, nonatomic) UIView *highlightedView;

@end
@implementation albumThumbCollectionViewCell

- (void) setAsset:(ALAsset *)asset
{
    _asset = asset;
    self.photoImageView.image = [UIImage imageWithCGImage:[asset thumbnail]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setSelected:(BOOL)selected
{
    if (selected) {
        [self setHighlighted:YES];
        if (![self.subviews containsObject:self.selectedView]) {
            self.selectedView = [[UIView alloc] initWithFrame:self.bounds];
            self.selectedView.layer.borderColor = [[UIColor redColor] CGColor];
            self.selectedView.layer.borderWidth = 1.0f;
            [self addSubview:self.selectedView];
        }
    } else {
        [self setHighlighted:NO];
        if ([self.subviews containsObject:self.selectedView]) {
            [self.selectedView removeFromSuperview];
        }
    }
}

- (void)setHighlighted:(BOOL)highlighted
{
    if (highlighted) {
        if (![self.subviews containsObject:self.highlightedView]) {
            self.highlightedView = [[UIView alloc] initWithFrame:self.bounds];
            [self.highlightedView setBackgroundColor:UIColorFromRGB(0x000000, .5)];
            self.highlightedView.layer.borderColor = [[UIColor blackColor] CGColor];
            self.highlightedView.layer.borderWidth = 2.0f;
            [self addSubview:self.highlightedView];
        }
    } else {
        if ([self.subviews containsObject:self.highlightedView]) {
            [self.highlightedView removeFromSuperview];
        }
    }
}

@end
