//
//  LMPhotoCollectionCell.m
//  SimpleWord
//
//  Created by littleMeaning on 16/5/16.
//  Copyright © 2016年 Little Meaning. All rights reserved.
//

#import "LMNPhotoCollectionCell.h"

@import Photos;

@interface LMNPhotoCollectionCell ()

@property (nonatomic, strong) PHAsset *asset;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *bezelView;
@property (nonatomic, strong) UIButton *useButton;

@end

@implementation LMNPhotoCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        [self.contentView addSubview:_imageView];
        
        _bezelView = [[UIView alloc] init];
        _bezelView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        _bezelView.layer.borderColor = [UIColor colorWithWhite:0.98 alpha:1.f].CGColor;
        _bezelView.layer.borderWidth = 2.f;
        _bezelView.hidden = YES;
        [self.contentView addSubview:_bezelView];
        
        _useButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _useButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
        _useButton.layer.borderColor = [UIColor whiteColor].CGColor;
        _useButton.layer.borderWidth = 1.f;
        _useButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3f];
        [_useButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_useButton setTitleColor:[UIColor colorWithWhite:1 alpha:0.5] forState:UIControlStateHighlighted];
        [_useButton setTitle:@"使用" forState:UIControlStateNormal];
        [_bezelView addSubview:_useButton];
        
        [_useButton addTarget:self action:@selector(useAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = self.bounds;
    self.bezelView.frame = self.bounds;
    CGRect rect = CGRectMake(0, 0, 60.f, 36.f);
    rect.origin.x = (CGRectGetWidth(self.bounds) - CGRectGetWidth(rect)) / 2.f;
    rect.origin.y = (CGRectGetHeight(self.bounds) - CGRectGetHeight(rect)) / 2.f;
    self.useButton.frame = rect;
    self.useButton.layer.cornerRadius = CGRectGetHeight(rect) / 2.f;
}

- (void)setSelected:(BOOL)selected
{
    // TODO: 在滑动的时候会触发，导致闪烁。
    [super setSelected:selected];
    self.bezelView.hidden = !selected;
}

- (void)performSelectionAnimations
{
    CGFloat scale = self.selected ? 1.1f : 1.f;
    self.bezelView.alpha = !self.selected;
    self.bezelView.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        self.bezelView.alpha = self.selected;
        self.imageView.transform = CGAffineTransformMakeScale(scale, scale);
    } completion:^(BOOL finished) {
        if (!self.selected) {
            self.bezelView.hidden = YES;
        }
    }];
}

- (void)setAsset:(PHAsset *)asset {
    
    _asset = asset;
    if (!asset) {
        return;
    }
    CGFloat imageWidth = CGRectGetWidth([UIScreen mainScreen].bounds) / 3.f;
    CGSize targetSize = CGSizeMake(imageWidth, imageWidth);
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:targetSize contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage *result, NSDictionary *info) {
        if (self.asset == asset) {
            self.imageView.image = result;
        }
    }];
}

- (void)prepareForReuse
{
    self.imageView.image = nil;
    self.asset = nil;
    self.bezelView.hidden = YES;
}

- (void)useAction:(UIButton *)sender
{
    self.handler(self.asset);
}

@end
