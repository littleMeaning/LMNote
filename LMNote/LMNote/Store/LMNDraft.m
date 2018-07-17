//
//  LMNDraft.m
//  LMNote
//
//  Created by littleMeaning on 2018/7/3.
//  Copyright © 2018年 littleMeaning. All rights reserved.
//

#import "LMNDraft.h"

@implementation LMNDraft

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.textStorage forKey:@"textStorage"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.textStorage = [aDecoder decodeObjectForKey:@"textStorage"];
    }
    return self;
}

@end
