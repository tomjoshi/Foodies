//
//  albumThumbCollectionViewCell.m
//  Foodies
//
//  Created by Lucas Chwe on 3/13/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import "albumThumbCollectionViewCell.h"
#import "UIColor+colorPallete.h"

@interface albumThumbCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (strong, nonatomic) UIView *selectedView;
@property (strong, nonatomic) UIView *highlightedView;

@end
@implementation albumThumbCollectionViewCell

#pragma mark - Cell methods

- (void)setAsset:(ALAsset *)asset
{
    _asset = asset;
    self.photoImageView.image = [UIImage imageWithCGImage:[asset thumbnail]];
}

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
            [self.highlightedView setBackgroundColor:[UIColor semiTransparentBlackColor]];
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
