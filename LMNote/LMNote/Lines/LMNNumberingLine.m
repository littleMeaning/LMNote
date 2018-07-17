//
//  LMNNumberingLine.m
//  LMNote
//
//  Created by littleMeaning on 2018/7/9.
//  Copyright © 2018年 littleMeaning. All rights reserved.
//

#import "LMNNumberingLine.h"
#import "UIFont+LMNote.h"

@interface LMNNumberingLine ()

@property (nonatomic, strong) UILabel *numberLabel;

@end

@implementation LMNNumberingLine

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.number = [aDecoder decodeIntegerForKey:@"number"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeInteger:self.number forKey:@"number"];
}

#pragma mark - number

- (void)setNumber:(NSUInteger)number
{
    _number = number;
    self.numberLabel.text = [@(number).stringValue stringByAppendingString:@" ."];
    self.numberLabel.attributedText = ({
        NSMutableAttributedString *attributedText = [self.numberLabel.attributedText mutableCopy];
        [attributedText addAttribute:NSBaselineOffsetAttributeName value:@(-0.5f) range:NSMakeRange(0, attributedText.length)];
        attributedText;
    });
}

#pragma - left view

- (CGSize)intrinsicLeftSize
{
    CGFloat width = LMNSpecialLineHeight;
    if (self.numberLabel) {
        [self.numberLabel sizeToFit];
        width = MAX(CGRectGetWidth(self.numberLabel.frame), LMNSpecialLineHeight);
    }
    return CGSizeMake(width, CGRectGetHeight(self.numberLabel.frame));
}

- (void)loadLeftView
{
    if (self.numberLabel) {
        return;
    }
    self.numberLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont fontWithFontSize:17.f bold:NO italic:NO];
        label.textAlignment = NSTextAlignmentRight;
        label.textColor = [UIColor grayColor];
        label;
    });
    self.number = self.number;
}

- (UIView *)leftView
{
    return self.numberLabel;
}

@end
