//
//  LMNTextStorage.h
//  LMNote
//
//  Created by littleMeaning on 2018/3/12.
//  Copyright © 2018年 littleMeaning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMNLineModes.h"

@class LMNLine;
@class LMNLineChain;

@interface LMNTextStorage : NSTextStorage

@property (nonatomic, strong, readonly) LMNLineChain *chain;
@property (nonatomic, assign, readonly) BOOL inProcessEditing;

- (void)setLineMode:(LMNLineMode)mode forRange:(NSRange)range;
- (void)setTextAlignment:(NSTextAlignment)alignment forRange:(NSRange)range;

- (LMNLine *)lineAtLocation:(NSUInteger)location;
- (void)updateNumberingStartWithLine:(LMNLine *)line;

@end
