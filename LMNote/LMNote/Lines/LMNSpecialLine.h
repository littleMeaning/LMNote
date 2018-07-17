//
//  LMNSpecialLine.h
//  LMNote
//
//  Created by littleMeaning on 2018/7/9.
//  Copyright © 2018年 littleMeaning. All rights reserved.
//

#import "LMNLine.h"

extern CGFloat const LMNSpecialLineHeight;

@interface LMNSpecialLine : LMNLine

@property (nonatomic, readonly) UIView *leftView;
- (CGSize)intrinsicLeftSize;
- (void)loadLeftView;

@end
