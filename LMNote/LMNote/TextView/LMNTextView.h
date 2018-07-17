//
//  LMNTextView.h
//  LMNote
//
//  Created by littleMeaning on 2018/1/10.
//  Copyright © 2018年 littleMeaning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMNLineModes.h"

@class LMNTextStorage;
@class LMNImageView;

@interface LMNTextView : UITextView

- (instancetype)initWithTextStorage:(LMNTextStorage *)textStorage;

- (LMNLineMode)lineModeForRange:(NSRange)range;
- (void)setLineMode:(LMNLineMode)mode forRange:(NSRange)range;
- (void)setAttributesForSelection:(NSDictionary<NSString *,id> *)attributes;
- (void)setTextAlignmentForSelection:(NSTextAlignment)alignment;
- (LMNImageView *)insertImage:(UIImage *)image atIndex:(NSInteger)index;
- (void)exportHTML:(void (^)(BOOL succeed, NSString *html))completion;

@end
