//
//  LMNBulletsLine.m
//  LMNote
//
//  Created by littleMeaning on 2018/7/9.
//  Copyright © 2018年 littleMeaning. All rights reserved.
//

#import "LMNBulletsLine.h"

@interface LMNBulletsLine ()

@property (nonatomic, strong) UIImageView *bulletImageView;

@end

@implementation LMNBulletsLine

- (UIImage *)bulletImage
{
    static dispatch_once_t onceToken;
    static UIImage *image;
    dispatch_once(&onceToken, ^{
        CGFloat diameter = 6.f;
        CGFloat scale = [UIScreen mainScreen].scale;
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(diameter, diameter), NO, scale);
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, diameter, diameter)];
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextAddPath(ctx, path.CGPath);
        CGContextSetFillColorWithColor(ctx, [UIColor darkGrayColor].CGColor);
        CGContextDrawPath(ctx, kCGPathFill);
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    });
    return image;
}

#pragma - left view

- (void)loadLeftView
{
    if (self.bulletImageView) {
        return;
    }
    self.bulletImageView = ({
        UIImageView *imageView = [[UIImageView alloc] initWithImage:self.bulletImage];
        imageView.contentMode = UIViewContentModeCenter;
        imageView;
    });
}

- (UIView *)leftView
{
    return self.bulletImageView;
}

@end
