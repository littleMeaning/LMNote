//
//  LMNImageView.h
//  LMNote
//
//  Created by littleMeaning on 2018/4/24.
//  Copyright © 2018年 littleMeaning. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LMNImageView;
@class LMNImageLine;

@protocol LMNImageViewDelegate <NSObject>

@optional
- (void)lmn_imageViewBeginEditing:(LMNImageView *)imageView;
- (void)lmn_imageViewEndEditing:(LMNImageView *)imageView;
- (void)lmn_imageViewDelete:(LMNImageView *)imageView;

@end

@interface LMNImageView : UIView

@property (nonatomic, weak) id<LMNImageViewDelegate> delegate;

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIBezierPath *exclusionPath;

@property (nonatomic, readonly) BOOL editing;

- (instancetype)initWithImage:(UIImage *)image;

- (void)beginEditing;
- (void)endEditing;

@property (nonatomic, weak) LMNImageLine *owner;
- (void)unbindFromOwner;

+ (CGSize)sizeThatFit:(UIImage *)image limitWidth:(CGFloat)limitWidth;

@end
