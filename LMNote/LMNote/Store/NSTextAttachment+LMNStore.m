//
//  NSTextAttachment+LMNStore.m
//  LMNote
//
//  Created by littleMeaning on 2018/7/6.
//  Copyright © 2018年 littleMeaning. All rights reserved.
//

#import "NSTextAttachment+LMNStore.h"
#import <objc/runtime.h>

@implementation NSTextAttachment (LMNStore)

+ (void)load
{
    Method oldMethod = class_getInstanceMethod(self, @selector(initWithCoder:));
    Method newMethod = class_getInstanceMethod(self, @selector(lmn_initWithCoder:));
    method_exchangeImplementations(oldMethod, newMethod);
    
    oldMethod = class_getInstanceMethod(self, @selector(encodeWithCoder:));
    newMethod = class_getInstanceMethod(self, @selector(lmn_encodeWithCoder:));
    method_exchangeImplementations(oldMethod, newMethod);
}

- (instancetype)lmn_initWithCoder:(NSCoder *)aDecoder
{
    NSTextAttachment *instance = [self lmn_initWithCoder:aDecoder];
    if (instance) {
        instance.bounds = [aDecoder decodeCGRectForKey:@"bounds"];
    }
    return instance;
}

- (void)lmn_encodeWithCoder:(NSCoder *)aCoder
{
    [self lmn_encodeWithCoder:aCoder];
    [aCoder encodeCGRect:self.bounds forKey:@"bounds"];
}

@end
