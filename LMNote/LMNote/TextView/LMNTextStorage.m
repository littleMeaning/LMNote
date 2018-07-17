//
//  LMNTextStorage.m
//  LMNote
//
//  Created by littleMeaning on 2018/3/12.
//  Copyright © 2018年 littleMeaning. All rights reserved.
//

#import "LMNTextStorage.h"
#import "LMNLineChain+Numbering.h"
#import "LMNStore.h"

#import "LMNTextLine.h"
#import "LMNNumberingLine.h"

@interface LMNTextStorage ()

@property (nonatomic, strong) LMNLineChain *chain;
@property (nonatomic, assign, readwrite) BOOL inProcessEditing;

@end

@implementation LMNTextStorage
{
    NSTextStorage *_imp;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _imp = [aDecoder decodeObjectForKey:@"imp"];
        _chain = [aDecoder decodeObjectForKey:@"chain"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_imp forKey:@"imp"];
    [aCoder encodeObject:_chain forKey:@"chain"];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _imp = [[NSTextStorage alloc] init];
        _chain = [[LMNLineChain alloc] init];
    }
    return self;
}

- (NSString *)string
{
    return _imp.string;
}

- (NSDictionary *)attributesAtIndex:(NSUInteger)location effectiveRange:(NSRangePointer)range
{
    return [_imp attributesAtIndex:location effectiveRange:range];
}

- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)str
{
    [_imp replaceCharactersInRange:range withString:str];
    [self edited:NSTextStorageEditedCharacters range:range changeInLength:(NSInteger)str.length - (NSInteger)range.length];
}

- (void)setAttributes:(NSDictionary *)attrs range:(NSRange)range
{
    [_imp setAttributes:attrs range:range];
    [self edited:NSTextStorageEditedAttributes range:range changeInLength:0];
}

- (void)processEditing
{
    self.inProcessEditing = YES;
    
    if (self.editedMask & NSTextStorageEditedCharacters &&
        !(self.editedRange.length == 0 && self.changeInLength == 0)) {
        
        NSRange editedRange = self.editedRange;
        NSRange replacedRange = editedRange;
        replacedRange.length -= self.changeInLength;
        
        NSString *originText = self.chain.text;
        NSString *replacementText = [self.string substringWithRange:editedRange];
        NSString *replacedText = [originText substringWithRange:replacedRange];
        
        LMNLine *forePart = [self.chain lineAtLocation:replacedRange.location];    // 前部分
        LMNLine *backPart = [self.chain lineAtLocation:NSMaxRange(replacedRange)]; // 后部分

        BOOL shouldUpdateNumbering = NO;
        if ([forePart isKindOfClass:[LMNNumberingLine class]] ||
            [backPart isKindOfClass:[LMNNumberingLine class]]) {
            shouldUpdateNumbering = YES;
        }
        // 重新整理段落个数
        NSInteger replacedCount = [replacedText componentsSeparatedByString:@"\n"].count;
        NSInteger replacementCount = [replacementText componentsSeparatedByString:@"\n"].count;
        NSInteger changeInCount = MAX(replacementCount, 1) - MAX(replacedCount, 1);
        LMNLine *line = forePart;
        LMNLine *next = backPart ? backPart.next : forePart.next;
        for (NSInteger i = 0; i < changeInCount; i ++) {
            
            LMNLine *newline = nil;
            if (i == 0 && [replacementText hasPrefix:@"\n"]) {
                newline = [LMNLine lineWithMode:forePart.mode];
                [newline inheritFromLine:line]; // 继承上一行的部分属性
            }
            else {
                newline = [LMNLine line];
            }
            line.next = newline;
            line = newline;
        }
        line.next = next;
        [self.chain updateWithText:self.string];
        if (shouldUpdateNumbering && changeInCount != 0) {
            [self.chain updateNumberings];
        }
        if (changeInCount < 0 && forePart.attributes) {
            NSRange range = self.editedRange;
            range.length = NSMaxRange(forePart.range) - range.location;
            [self addAttributes:forePart.attributes range:range];
        }
    }
    [super processEditing];
    self.inProcessEditing = NO;
}

- (void)fixAttributesInRange:(NSRange)range
{
    [super fixAttributesInRange:range];
    
    NSUInteger index = range.location;
    while (NSLocationInRange(index, range)) {
        LMNLine *line = [self lineAtLocation:index];
        if ([self attribute:NSAttachmentAttributeName atIndex:index effectiveRange:NULL]) {
            [self removeAttribute:NSParagraphStyleAttributeName range:line.range];
        }
        else {
            NSParagraphStyle *paragraphStyle = line.attributes[NSParagraphStyleAttributeName];
            if (paragraphStyle) {
                [self addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:line.range];
            }
        }
        index = NSMaxRange(line.range);
    };
}

#pragma mark - private

- (void)enumerateParagraphsInRange:(NSRange)range usingBlock:(void (^)(NSRange paragraphRange))block
{
    if (!block) {
        return;
    }
    NSRange paragraphRange = NSMakeRange(range.location, 0);
    do {
        paragraphRange = [self.string paragraphRangeForRange:paragraphRange];
        // 执行 block
        block(paragraphRange);
        
        paragraphRange.location = NSMaxRange(paragraphRange);
        paragraphRange.length = 0;
    } while (NSLocationInRange(paragraphRange.location, range));
    
    if ([[self.string substringWithRange:range] isEqualToString:@"\n"]) {
        paragraphRange = [self.string paragraphRangeForRange:paragraphRange];
        block(paragraphRange);
    }
}

- (void)updateLineDisplay:(LMNLine *)line
{
    [self setAttributes:line.attributes range:line.range];
    NSRange replaceRange = NSMakeRange(line.range.location, 0);
    [self replaceCharactersInRange:replaceRange withString:@""];  // 强制刷新行
}

#pragma mark - public

- (void)setLineMode:(LMNLineMode)mode forRange:(NSRange)range
{
    __block BOOL shouldUpdateNumbering = NO;
    [self enumerateParagraphsInRange:range usingBlock:^(NSRange paragraphRange) {

        LMNLine *line = [self.chain lineAtLocation:paragraphRange.location];
        if ([line isKindOfMode:mode]) {
            return;
        }
        LMNLine *newline = [LMNLine lineWithMode:mode];
        [newline insteadOfLine:line];
        
        if ([line isKindOfMode:LMNLineModeNumbering] || [newline isKindOfMode:LMNLineModeNumbering]) {
            shouldUpdateNumbering = YES;
        }
        [self updateLineDisplay:newline];
    }];
    [self.chain updateWithText:self.string];
    if (shouldUpdateNumbering) {
        [self.chain updateNumberings];
    }
}

- (void)setTextAlignment:(NSTextAlignment)alignment forRange:(NSRange)range
{
    LMNLine *line = [self lineAtLocation:range.location];
    if ([line isKindOfClass:[LMNTextLine class]]) {
        [(LMNTextLine *)line setTextAlignment:alignment];
    }
    [self updateLineDisplay:line];
}

- (LMNLine *)lineAtLocation:(NSUInteger)location
{
    return [self.chain lineAtLocation:location];
}

- (void)updateNumberingStartWithLine:(LMNLine *)line
{
    [self.chain updateNumberingStartWithLine:line];
}

@end
