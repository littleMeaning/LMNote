//
//  LMNSpecialLine.m
//  LMNote
//
//  Created by littleMeaning on 2018/7/9.
//  Copyright © 2018年 littleMeaning. All rights reserved.
//

#import "LMNSpecialLine.h"

@implementation LMNSpecialLine

CGFloat const LMNSpecialLineHeight = 26.f;

- (NSDictionary *)attributes
{
    static NSDictionary *attributes;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        attributes = [self attributesWithFont:nil];
        UIFont *font = attributes[NSFontAttributeName];
        CGFloat paragraphSpacing = (LMNSpecialLineHeight - roundf(font.lineHeight)) / 2.f;
        NSMutableParagraphStyle *paragraphStyle = attributes[NSParagraphStyleAttributeName];
        paragraphStyle.paragraphSpacing = paragraphSpacing;
        paragraphStyle.paragraphSpacingBefore = paragraphSpacing;
        attributes = [attributes copy];
    });
    return attributes;
}

- (CGSize)intrinsicLeftSize
{
    return CGSizeMake(LMNSpecialLineHeight, LMNSpecialLineHeight);
}

- (void)loadLeftView {}

- (void)clean
{
    [self.leftView removeFromSuperview];
    [super clean];
}

@end
