//
//  LMNLineChain.m
//  LMNote
//
//  Created by littleMeaning on 2018/3/17.
//  Copyright © 2018年 littleMeaning. All rights reserved.
//

#import "LMNLineChain.h"
#import "LMNImageView.h"

@interface LMNLineChain ()

@property (nonatomic, copy) NSString *text;

@end

@implementation LMNLineChain

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        NSArray *lines = [aDecoder decodeObjectForKey:@"lines"];
        if (lines.count == 0) {
            return nil;
        }
        LMNLine *tail = nil;
        for (LMNLine *line in lines) {
            if (tail) {
                tail.next = line;
            }
            else {
                [line makeRootOfLineChain:self];
            }
            tail = line;
        }
        NSString *text = [aDecoder decodeObjectForKey:@"text"];
        [self updateWithText:text];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    NSMutableArray *lines = [NSMutableArray array];
    LMNLine *line = self.rootLine;
    do {
        [lines addObject:line];
    } while ((line = line.next));
    
    [aCoder encodeObject:lines forKey:@"lines"];
    [aCoder encodeObject:self.text forKey:@"text"];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        LMNLine *line = [LMNLine lineWithMode:LMNLineModeContent];
        [line makeRootOfLineChain:self];
    }
    return self;
}

- (void)updateWithText:(NSString *)text
{
    _text = [text copy];
    
    NSRange range = NSMakeRange(0, 0);
    LMNLine *line = self.rootLine;
    while (YES) {
        range = [text paragraphRangeForRange:range];
        line.range = range;
        range.location = NSMaxRange(range);
        range.length = 0;
        if (line.next) {
            line = line.next;
            if (range.location >= text.length) {
                line.range = range;
                break;
            }
        }
        else {
            break;
        }
    }
}

- (LMNLine *)lineAtLocation:(NSUInteger)loc
{
    LMNLine *line = self.rootLine;
    while (line) {
        if (NSLocationInRange(loc, line.range)) {
            return line;
        }
        if (line.next == nil && self.text.length == loc) {
            return line;
        }
        line = line.next;
    }
    return nil;
}

@end

