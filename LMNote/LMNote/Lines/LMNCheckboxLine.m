//
//  LMNCheckboxLine.m
//  LMNote
//
//  Created by littleMeaning on 2018/7/9.
//  Copyright © 2018年 littleMeaning. All rights reserved.
//

#import "LMNCheckboxLine.h"

@interface LMNCheckboxLine ()

@property (nonatomic, strong) UIButton *checkbox;

@end

@implementation LMNCheckboxLine

static CGFloat const kCheckboxLineHeight = 30.f;

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.checkboxSelected = [aDecoder decodeBoolForKey:@"checkboxSelected"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeBool:self.checkboxSelected forKey:@"checkboxSelected"];
}

- (NSDictionary *)attributes
{
    static NSDictionary *attributes;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        attributes = [self attributesWithFont:nil];
        UIFont *font = attributes[NSFontAttributeName];
        CGFloat paragraphSpacing = (kCheckboxLineHeight - roundf(font.lineHeight)) / 2.f;
        NSMutableParagraphStyle *paragraphStyle = attributes[NSParagraphStyleAttributeName];
        paragraphStyle.paragraphSpacing = paragraphSpacing;
        paragraphStyle.paragraphSpacingBefore = paragraphSpacing;
        attributes = [attributes copy];
    });
    return attributes;
}

#pragma mark - checkbox

- (void)setCheckboxSelected:(BOOL)checkboxSelected
{
    _checkboxSelected = checkboxSelected;
    self.checkbox.selected = checkboxSelected;
}

- (void)selectCheckbox:(id)sender
{
    self.checkboxSelected = !self.checkboxSelected;
}

#pragma - left view

- (CGSize)intrinsicLeftSize
{
    return CGSizeMake(kCheckboxLineHeight, kCheckboxLineHeight);
}

- (void)loadLeftView
{
    if (self.checkbox) {
        return;
    }
    
    self.checkbox = ({
        UIImage *imageNormal = [UIImage imageNamed:@"lmn_accessory_checkbox"];
        UIImage *imageSelected = [UIImage imageNamed:@"lmn_accessory_checkbox_"];
        UIButton *checkbox = [UIButton buttonWithType:UIButtonTypeCustom];
        [checkbox setImage:imageNormal forState:UIControlStateNormal];
        [checkbox setImage:imageSelected forState:UIControlStateSelected];
        [checkbox addTarget:self action:@selector(selectCheckbox:) forControlEvents:UIControlEventTouchUpInside];
        checkbox;
    });
    [self setCheckboxSelected:_checkboxSelected];
}

- (UIView *)leftView
{
    return self.checkbox;
}

@end
