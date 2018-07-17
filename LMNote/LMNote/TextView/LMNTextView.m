//
//  LMNTextView.m
//  LMNote
//
//  Created by littleMeaning on 2018/1/10.
//  Copyright © 2018年 littleMeaning. All rights reserved.
//

#import "LMNTextView.h"
#import "LMNTextStorage.h"
#import "LMNLine.h"
#import "LMNImageView.h"
#import "LMNTextStorage+Export.h"
#import <objc/runtime.h>

#import "LMNSpecialLine.h"
#import "LMNImageLine.h"
#import "LMNTextLine.h"

#define macro_commitUpdating(code); \
BOOL ignore = self.ignoreUpdatingExclusionPaths;    \
self.ignoreUpdatingExclusionPaths = YES;    \
code    \
self.ignoreUpdatingExclusionPaths = ignore; \
if (!ignore) {  \
[self updateExclusionPathsIfNeed];  \
}   \

@interface LMNTextView () <NSTextStorageDelegate, LMNImageViewDelegate>

@property (nonatomic, weak) LMNImageView *editingImageView;

@property (nonatomic, assign) BOOL needUpdateExclusionPaths;
@property (nonatomic, assign) BOOL ignoreUpdatingExclusionPaths;

@end

@implementation LMNTextView
{
    LMNTextStorage *_textStorage;
}

- (instancetype)init
{
    return [self initWithTextStorage:nil];
}

- (instancetype)initWithTextStorage:(LMNTextStorage *)textStorage
{
    if (!textStorage) {
        textStorage = [[LMNTextStorage alloc] init];
    }
    NSTextContainer *textContainer = [[NSTextContainer alloc] init];
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    [textStorage addLayoutManager:layoutManager];
    [layoutManager addTextContainer:textContainer];
    self = [super initWithFrame:CGRectZero textContainer:textContainer];
    if (self) {
        _textStorage = textStorage;
        self.textContainerInset = UIEdgeInsetsMake(10.f, 15.f, 10.f, 15.f);
        self.typingAttributes = [self typingAttributesAtLocation:0];
        [self addObservers];
        self.needUpdateExclusionPaths = YES;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self updateExclusionPathsIfNeed];
}

- (void)dealloc
{
    [self removeObservers];
}

#pragma mark - observer

- (void)addObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textStorageDidProcessEditing:)
                                                 name:NSTextStorageDidProcessEditingNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [_textStorage addObserver:self
                       forKeyPath:@"inProcessEditing"
                          options:NSKeyValueObservingOptionNew
                          context:NULL];
}

- (void)removeObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_textStorage removeObserver:self forKeyPath:@"inProcessEditing"];
}

#pragma mark - NSTextStorageDidProcessEditingNotification

- (void)textStorageDidProcessEditing:(NSNotification *)notification
{
    if (notification.object == _textStorage) {
        
        if (!_textStorage.inProcessEditing) {
            [self updateExclusionPathsIfNeed];
        }
        else {
            self.needUpdateExclusionPaths = YES;
        }
    }
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    [self.editingImageView endEditing];
    self.editingImageView = nil;
}

#pragma mark - KVC

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (object == _textStorage && [keyPath isEqualToString:@"inProcessEditing"]) {
        BOOL inProcessEditing = [change[NSKeyValueChangeNewKey] boolValue];
        if (!inProcessEditing) {
            [self updateExclusionPathsIfNeed];
        }
    }
}

#pragma mark - update exclusionPaths

static CGFloat const kDefaultTextInset = 5.f;   // 默认文字会有5.f的缩进

- (void)updateExclusionPaths
{
    NSString *text = self.text;
    UIEdgeInsets textContainerInset = self.textContainerInset;
    NSTextContainer *textContainer = self.textContainer;
    LMNTextStorage *textStorage = _textStorage;

    __block CGFloat yOffset = 0;
    __block NSRange range = NSMakeRange(0, 0);
    CGFloat limitWidth = textContainer.size.width - kDefaultTextInset * 2;

    NSMutableArray *exclusionPaths = [NSMutableArray array];
    [text enumerateLinesUsingBlock:^(NSString *textLine, BOOL *stop) {
        range.length = textLine.length;
        LMNLine *line = [textStorage lineAtLocation:range.location];
        NSAttributedString *attributedText = [textStorage attributedSubstringFromRange:range];
        CGFloat lineHeight = 0;
        UIFont *font = line.attributes[NSFontAttributeName];
        NSParagraphStyle *paragraphStyle = line.attributes[NSParagraphStyleAttributeName];
        if (range.length == 0) {
            lineHeight = font.lineHeight;
        }
        else {
            CGSize limitSize = CGSizeZero;
            if ([line isKindOfClass:[LMNSpecialLine class]]) {
                limitSize.width = limitWidth - ((LMNSpecialLine *)line).intrinsicLeftSize.width;
            }
            else {
                limitSize.width = limitWidth;
            }
            lineHeight = [attributedText boundingRectWithSize:limitSize
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                      context:NULL].size.height;
            if (font) {
                // 存在粗体、下划线时，考虑由于 lineSpacing 对计算结果的影响
                id tmp = [attributedText mutableCopy];
                [tmp addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, attributedText.length)];
                [tmp removeAttribute:NSUnderlineStyleAttributeName range:NSMakeRange(0, attributedText.length)];
                [tmp removeAttribute:NSStrikethroughStyleAttributeName range:NSMakeRange(0, attributedText.length)];
                
                attributedText = tmp;
                CGFloat estimatedLineHeight = [tmp boundingRectWithSize:limitSize options:NSStringDrawingUsesLineFragmentOrigin context:NULL].size.height;
                CGFloat spacing = paragraphStyle.lineSpacing + paragraphStyle.paragraphSpacing;
                if (lineHeight - estimatedLineHeight <= spacing) {
                    lineHeight = estimatedLineHeight;
                }
            }
        }
        if (paragraphStyle && ![line isKindOfClass:[LMNImageLine class]]) {
            lineHeight += paragraphStyle.lineSpacing;
            lineHeight += paragraphStyle.paragraphSpacing;
            lineHeight += paragraphStyle.paragraphSpacingBefore;
            if (range.location == 0) {
                // 首行没有段前间距
                yOffset -= paragraphStyle.paragraphSpacingBefore;
            }
        }
        
        if ([line isKindOfClass:[LMNTextLine class]]) {
            yOffset += lineHeight;
            range.location = NSMaxRange(range) + 1;
            return;
        }
        
        // 给行样式添加 exclusionPath
        CGRect rect = CGRectZero;
        rect.origin.y = ceilf(yOffset);
        rect.size.height = floorf(yOffset + lineHeight) - rect.origin.y;
        if ([line isKindOfClass:[LMNSpecialLine class]]) {
            LMNSpecialLine *specialLine = (LMNSpecialLine *)line;
            rect.size.width = [specialLine intrinsicLeftSize].width;
            // 1.f 是为小数精度做微调。
            UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectInset(rect, 0, 1.f)];
            [exclusionPaths addObject:path];

            if (!specialLine.leftView) {
                [specialLine loadLeftView];
            }
            if (!specialLine.leftView.superview) {
                [self addSubview:specialLine.leftView];
            }
            rect.origin.x = textContainerInset.left;
            rect.origin.y += textContainerInset.top;
            rect.size = [specialLine intrinsicLeftSize];
            if (rect.size.height == 0) {
                rect.size.height = lineHeight;
            }
            specialLine.leftView.frame = rect;
        }
        else if ([line isKindOfClass:[LMNImageLine class]]) {
            // 图片
            LMNImageLine *imageLine = (LMNImageLine *)line;
            LMNImageView *imageView = imageLine.bindingImageView;
            CGFloat width = CGRectGetWidth(self.frame);
            UIEdgeInsets textContainerInset = self.textContainerInset;
            width -= (textContainerInset.left + textContainerInset.right + kDefaultTextInset * 2);
            rect.size = [LMNImageView sizeThatFit:imageLine.image limitWidth:width];
            if (imageView == nil && imageLine.image != nil) {
                imageView = [[LMNImageView alloc] initWithImage:imageLine.image];
                imageView.delegate = self;
                [self addSubview:imageView];
                [imageLine bindImageView:imageView];
            }
            if (imageView) {
                rect.origin.x = kDefaultTextInset + textContainerInset.left;
                rect.origin.y += textContainerInset.top;
                imageView.frame = rect;
            }
        }
        yOffset += lineHeight;
        range.location = NSMaxRange(range) + 1;
    }];

    // 派发到下次任务中，不然会 Crash
    dispatch_async(dispatch_get_main_queue(), ^{
        self.scrollEnabled = NO;
        self.textContainer.exclusionPaths = exclusionPaths;
        self.scrollEnabled = YES;
    });
}

- (void)updateExclusionPathsIfNeed
{
    if (CGRectGetWidth(self.bounds) == 0) {
        return;
    }
    if (self.needUpdateExclusionPaths && !self.ignoreUpdatingExclusionPaths) {
        [self updateExclusionPaths];
        self.needUpdateExclusionPaths = NO;
    }
}

#pragma mark - extraLine

- (BOOL)isSelectedExtraLine
{
    return ([self.text hasSuffix:@"\n"] && NSMaxRange(self.selectedRange) == self.text.length);
}

// 通过 [NSLayoutManager -drawBackgroundForGlyphRange:atPoint:] 来给行绘制项目符号，但对于没有内容最后一行(extraLine)则不会触发绘制方法，这里添加特殊处理，给 extraLine 添加一个 "\n" 以触发绘制方法。
- (void)appendingLineBreakForExtraLine
{
    NSRange paragraphRange = [self.text paragraphRangeForRange:self.selectedRange];
    NSString *endingText = [self.text substringWithRange:paragraphRange];
    if (![endingText containsString:@"\n"]) {
        // 选中行为最后一行
        NSRange range = NSMakeRange(self.text.length, 0);
        LMNLine *lastLine = [_textStorage lineAtLocation:range.location];
        if ([lastLine isKindOfClass:[LMNSpecialLine class]]) {
            [_textStorage replaceCharactersInRange:range withAttributedString:[[NSAttributedString alloc] initWithString:@"\n" attributes:lastLine.attributes]];
            [[LMNLine line] insteadOfLine:lastLine.next];
        }
    }
}

#pragma mark - override

- (BOOL)shouldDeleteBackward
{
    NSRange selectedRange = self.selectedRange;
    if (selectedRange.length == 0 && selectedRange.location > 0) {
        LMNLine *line = [_textStorage lineAtLocation:selectedRange.location - 1];
        if (NSMaxRange(line.range) == selectedRange.location &&
            [line isKindOfClass:[LMNImageLine class]]) {
            [((LMNImageLine *)line).bindingImageView beginEditing];
            return NO;
        }
    }
    return YES;
}

- (void)deleteBackward
{
    if (![self shouldDeleteBackward]) {
        return;
    }
    if (NSEqualRanges(self.selectedRange, NSMakeRange(0, 0))) {
        LMNLine *line = [_textStorage lineAtLocation:0];
        if ([line isKindOfClass:[LMNSpecialLine class]]) {
            [_textStorage setLineMode:LMNLineModeContent forRange:NSMakeRange(0, 0)];
            return;
        }
    }
    macro_commitUpdating({
        [super deleteBackward];
        [self appendingLineBreakForExtraLine];
    });
}

- (void)insertText:(NSString *)text
{
#pragma warning - 粘贴不走该逻辑
    if ([text isEqualToString:@"\n"] && self.selectedRange.length == 0) {
        
        LMNLine *line = [_textStorage lineAtLocation:self.selectedRange.location];
        if ([line isKindOfClass:[LMNSpecialLine class]]) {
            NSString *prevStr = self.selectedRange.location == 0 ? @"\n" : [self.text substringWithRange:NSMakeRange(self.selectedRange.location - 1, 1)];
            NSString *nextStr = [self.text substringWithRange:NSMakeRange(self.selectedRange.location, 1)];
            if ([prevStr isEqualToString:@"\n"] && [nextStr isEqualToString:@"\n"]) {
                [self setLineMode:LMNLineModeContent forRange:self.selectedRange];
                return;
            }
        }
    }
    macro_commitUpdating({
        [super insertText:text];
        [self appendingLineBreakForExtraLine];
    });
}

#pragma mark - private

- (NSDictionary *)typingAttributesAtLocation:(NSUInteger)location
{
    return [_textStorage lineAtLocation:location].attributes;
}

#pragma mark - public method

- (LMNLineMode)lineModeForRange:(NSRange)range
{
    LMNLine *line = [_textStorage lineAtLocation:range.location];
    return line.mode;
}

- (void)setLineMode:(LMNLineMode)mode forRange:(NSRange)range
{
    macro_commitUpdating({
        [_textStorage setLineMode:mode forRange:range];
        [self appendingLineBreakForExtraLine];
    });
    self.typingAttributes = [self typingAttributesAtLocation:range.location];
}

- (void)setAttributesForSelection:(NSDictionary<NSString *,id> *)attributes
{
    [_textStorage setAttributes:attributes range:self.selectedRange];
}

- (void)setTextAlignmentForSelection:(NSTextAlignment)alignment
{
    LMNTextStorage *textStorage = (LMNTextStorage *)_textStorage;
    [textStorage setTextAlignment:alignment forRange:self.selectedRange];
}

- (void)exportHTML:(void (^)(BOOL succeed, NSString *html))completion
{
    [_textStorage exportHTML:completion];
}

#pragma mark - image

- (LMNImageView *)insertImage:(UIImage *)image atIndex:(NSInteger)index
{
    if (index >= self.text.length) {
        index = self.text.length;
    }

    CGFloat width = CGRectGetWidth(self.frame);
    UIEdgeInsets textContainerInset = self.textContainerInset;
    width -= (textContainerInset.left + textContainerInset.right + kDefaultTextInset * 2);
    CGSize size = [LMNImageView sizeThatFit:image limitWidth:width];
    
    LMNImageView *imageView = [[LMNImageView alloc] initWithImage:image];
    imageView.delegate = self;
    [self addSubview:imageView];
    
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    CGRect bounds = CGRectZero;
    bounds.size = size;
    attachment.image = [UIImage new];
    attachment.bounds = bounds;
    NSAttributedString *imgStr = [NSAttributedString attributedStringWithAttachment:attachment];

    LMNLine *lineAtIndex = [_textStorage lineAtLocation:index];
    NSMutableAttributedString *replacementString = [[NSMutableAttributedString alloc] init];
    [replacementString appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n" attributes:lineAtIndex.attributes]];
    BOOL inCurrentLine = NO;
    NSUInteger insertLocation = NSMaxRange(lineAtIndex.range) - 1;
    if (lineAtIndex.range.location == index) {
        // 如果光标位置是行首，则图片在该行之前
        inCurrentLine = YES;
        insertLocation = lineAtIndex.range.location;
    }
    else if (lineAtIndex.next == nil) {
        // 最后一行，则在图片之后新增一行。
        [replacementString appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n" attributes:[LMNLine line].attributes]];
        insertLocation ++;
    }
    [replacementString insertAttributedString:imgStr atIndex:inCurrentLine ? 0 : 1];
    
    macro_commitUpdating({
        [_textStorage replaceCharactersInRange:NSMakeRange(insertLocation, 0) withAttributedString:replacementString];

        LMNLine *line = [_textStorage lineAtLocation:index];
        if (!inCurrentLine) {
            line = line.next;
        }
        if (line.next.range.length == 0) {
            LMNLine *newline = [LMNLine lineWithMode:LMNLineModeContent];
            [newline insteadOfLine:line.next];
        }
        LMNLine *newline = [LMNLine lineWithMode:LMNLineModeModeImage];
        [newline insteadOfLine:line];
        [(LMNImageLine *)newline bindImageView:imageView];
        [_textStorage updateNumberingStartWithLine:newline.next];
    });
    
    return imageView;
}

#pragma mark <LMNImageViewDelegate>

- (void)lmn_imageViewBeginEditing:(LMNImageView *)imageView
{
    [self.editingImageView endEditing];
    self.editingImageView = imageView;
    [self resignFirstResponder];
}

- (void)lmn_imageViewEndEditing:(LMNImageView *)imageView
{
    self.editingImageView = nil;
}

- (void)lmn_imageViewDelete:(LMNImageView *)imageView
{
    LMNLine *line = imageView.owner;
    LMNLine *nextline = line.next;
    [imageView removeFromSuperview];
    [imageView unbindFromOwner];
    macro_commitUpdating({
        [_textStorage replaceCharactersInRange:line.range withString:@""];
        [nextline insteadOfLine:line];
        [_textStorage updateNumberingStartWithLine:nextline];
    });
}

@end
