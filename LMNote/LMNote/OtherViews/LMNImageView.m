//
//  LMNImageView.m
//  LMNote
//
//  Created by littleMeaning on 2018/4/24.
//  Copyright © 2018年 littleMeaning. All rights reserved.
//

#import "LMNImageView.h"
#import "LMNImageLine.h"

@interface LMNImageView ()

@property (nonatomic, strong) UIControl *borderView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *deleteButton;

@property (nonatomic, strong) UIVisualEffectView *blurEffectView;
@property (nonatomic, assign) BOOL editing;

@end

@implementation LMNImageView

static CGFloat const kMargin = 5.f;
static CGFloat const kVerticalInset = 5.f;
static CGFloat const kVerticalMargin = kVerticalInset + kMargin;

+ (CGSize)sizeThatFit:(UIImage *)image limitWidth:(CGFloat)limitWidth
{
    if (!image) {
        return CGSizeZero;
    }
    CGFloat height = (limitWidth - kMargin * 2) * image.size.height / image.size.width + kVerticalMargin * 2;
    return CGSizeMake(limitWidth, roundf(height));
}

- (instancetype)initWithImage:(UIImage *)image
{
    self = [self initWithFrame:CGRectZero];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _borderView = [[UIControl alloc] init];
        _borderView.layer.borderColor = [UIColor colorWithWhite:0.8f alpha:1.f].CGColor;
        _borderView.layer.borderWidth = 0.5f;
        _borderView.layer.cornerRadius = 2.f;
        [self addSubview:_borderView];
        
        _image = image;
        _imageView = [[UIImageView alloc] initWithImage:image];
        _imageView.clipsToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [_borderView addSubview:_imageView];
        
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setImage:[UIImage imageNamed:@"lmn_delete"] forState:UIControlStateNormal];
        _deleteButton.hidden = YES;
        [self addSubview:_deleteButton];
        
        [_borderView addTarget:self action:@selector(tapContainer:) forControlEvents:UIControlEventTouchUpInside];
        [_deleteButton addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.borderView.frame = CGRectInset(self.bounds, 0, kVerticalInset);
    self.imageView.frame = CGRectInset(self.borderView.bounds, kMargin, kMargin);
    self.deleteButton.frame = CGRectMake(kMargin + 5.f, kVerticalMargin + 5.f, 34.f, 34.f);
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    self.imageView.image = image;
    [self setNeedsDisplay];
}

#pragma mark - editing

- (void)setEditing:(BOOL)editing
{
    if (_editing == editing) {
        return;
    }
    _editing = editing;
    
    if (!self.blurEffectView) {
        if (!UIAccessibilityIsReduceTransparencyEnabled()) {
            UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
            UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
            blurEffectView.userInteractionEnabled = NO;
            _blurEffectView = blurEffectView;
        }
    }
    if (!self.blurEffectView) {
        self.deleteButton.hidden = !editing;
        return;
    }
    
    self.deleteButton.hidden = !editing;
    if (editing) {
        self.blurEffectView.frame = self.imageView.frame;
        [self.borderView addSubview:self.blurEffectView];
        
        self.deleteButton.alpha = 0;
        self.blurEffectView.alpha = 0;
        [UIView animateWithDuration:0.25 animations:^{
            self.blurEffectView.alpha = 1;
            self.deleteButton.alpha = 1;
        }];
    }
    else {
        [UIView animateWithDuration:0.25 animations:^{
            self.blurEffectView.alpha = 0;
            self.deleteButton.alpha = 0;
        } completion:^(BOOL finished) {
            [self.blurEffectView removeFromSuperview];
        }];
    }
}

- (void)beginEditing
{
    self.editing = YES;
    if ([self.delegate respondsToSelector:@selector(lmn_imageViewBeginEditing:)]) {
        [self.delegate lmn_imageViewBeginEditing:self];
    }
}

- (void)endEditing
{
    self.editing = NO;
    if ([self.delegate respondsToSelector:@selector(lmn_imageViewEndEditing:)]) {
        [self.delegate lmn_imageViewEndEditing:self];
    }
}

#pragma mark - actions

- (void)tapContainer:(id)sender
{
    if (self.editing) {
        [self endEditing];
    }
    else {
        [self beginEditing];
    }
}

- (void)delete:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(lmn_imageViewDelete:)]) {
        [self.delegate lmn_imageViewDelete:self];
    }
}

#pragma mark -

- (void)unbindFromOwner
{
    if (self.owner.bindingImageView == self) {
        [self.owner unbindImageView];
    }
}

@end
