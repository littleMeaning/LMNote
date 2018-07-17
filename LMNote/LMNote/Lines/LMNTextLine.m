//
//  LMNTextLine.m
//  LMNote
//
//  Created by littleMeaning on 2018/7/9.
//  Copyright © 2018年 littleMeaning. All rights reserved.
//

#import "LMNTextLine.h"
#import "UIFont+LMNote.h"

@interface LMNTextLine ()

@property (nonatomic, readonly) UIFont *textFont;

@end

@implementation LMNTextLine

- (UIFont *)textFont
{
    return nil;
}

- (NSDictionary *)attributes
{
    NSMutableDictionary *attributes = [self attributesWithFont:self.textFont];
    NSMutableParagraphStyle *paragraphStyle = attributes[NSParagraphStyleAttributeName];
    paragraphStyle.alignment = self.textAlignment;
    return attributes;
}

- (void)inheritFromLine:(LMNLine *)line
{
    [super inheritFromLine:line];
    if ([line isKindOfClass:[LMNTextLine class]]) {
        self.textAlignment = ((LMNTextLine *)line).textAlignment;
    }
}

@end

#pragma mark -

@interface LMNContentLine : LMNTextLine
@end

@implementation LMNContentLine

- (UIFont *)textFont
{
    return [UIFont fontWithFontSize:17.f bold:NO italic:NO];
}

@end

#pragma mark -

@interface LMNTitleLine : LMNTextLine
@end

@implementation LMNTitleLine

- (UIFont *)textFont
{
    return [UIFont fontWithFontSize:24.f bold:YES italic:NO];
}

@end

#pragma mark -

@interface LMNSubtitleLine : LMNTextLine
@end

@implementation LMNSubtitleLine

- (UIFont *)textFont
{
    return [UIFont fontWithFontSize:20.f bold:YES italic:NO];
}

@end
