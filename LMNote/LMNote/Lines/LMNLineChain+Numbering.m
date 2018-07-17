//
//  LMNLineChain+Numbering.m
//  LMNote
//
//  Created by littleMeaning on 2018/7/9.
//  Copyright © 2018年 littleMeaning. All rights reserved.
//

#import "LMNLineChain+Numbering.h"
#import "LMNNumberingLine.h"
#import "LMNNumberingLine.h"

@implementation LMNLineChain (Numbering)

- (void)updateNumberings
{
    // 将连续数字段落的第一个节点提取出来。
    id headLine = nil;
    NSMutableArray *numberingLines = [NSMutableArray array];
    LMNLine *line = self.rootLine;
    do {
        BOOL isNumbering = [line isKindOfClass:[LMNNumberingLine class]];
        if (isNumbering && headLine == nil) {
            headLine = line;
        }
        else if (!isNumbering && headLine != nil) {
            [numberingLines addObject:headLine];
            headLine = nil;
        }
        line = line.next;
    }
    while (line);
    
    if (headLine) {
        [numberingLines addObject:headLine];
        headLine = nil;
    }
    for (LMNLine *line in numberingLines) {
        [self updateNumberingStartWithLine:line];
    }
}

- (void)updateNumberingStartWithLine:(LMNLine *)line
{
    if (![line isKindOfClass:[LMNNumberingLine class]]) {
        return;
    }
    NSUInteger offset = 0;
    if ([line.prev isKindOfClass:[LMNNumberingLine class]]) {
        offset += ((LMNNumberingLine *)line.prev).number;
    }
    NSMutableArray *lines = [NSMutableArray array];
    while (line && [line isKindOfClass:[LMNNumberingLine class]]) {
        [lines addObject:line];
        line = line.next;
    }
    [lines enumerateObjectsUsingBlock:^(LMNLine *obj, NSUInteger idx, BOOL *stop) {
        [(LMNNumberingLine *)obj setNumber:idx + 1 + offset];
    }];
}

@end
