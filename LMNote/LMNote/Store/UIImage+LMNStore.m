//
//  UIImage+LMNStore.m
//  LMNote
//
//  Created by littleMeaning on 2018/7/6.
//  Copyright © 2018年 littleMeaning. All rights reserved.
//

#import "UIImage+LMNStore.h"
#import <objc/runtime.h>

@implementation UIImage (LMNStore)

@dynamic lmn_fileName;

- (NSString *)lmn_fileName
{
    return objc_getAssociatedObject(self, @selector(lmn_fileName));
}

- (void)setLmn_fileName:(NSString *)lmn_fileName
{
    objc_setAssociatedObject(self, @selector(lmn_fileName), lmn_fileName, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
