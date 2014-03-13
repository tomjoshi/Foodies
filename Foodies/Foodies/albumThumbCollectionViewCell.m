//
//  albumThumbCollectionViewCell.m
//  Foodies
//
//  Created by Lucas Chwe on 3/13/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import "albumThumbCollectionViewCell.h"

@interface albumThumbCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;

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

@end
