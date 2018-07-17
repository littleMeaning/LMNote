//
//  LMNTextLine.h
//  LMNote
//
//  Created by littleMeaning on 2018/3/16.
//  Copyright © 2018年 littleMeaning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMNLineModes.h"

@class LMNImageView;
@class LMNLineChain;

@interface LMNLine : NSObject <NSCoding>

@property (nonatomic, assign, readonly) BOOL isRoot;
@property (nonatomic, weak, readonly) LMNLineChain *lineChain;
- (void)makeRootOfLineChain:(LMNLineChain *)lineChain;

@property (nonatomic, copy, readonly) NSString *uuid;
@property (nonatomic, assign) NSRange range;

@property (nonatomic, weak, readonly) LMNLine *prev;
@property (nonatomic, strong) LMNLine *next;

- (NSDictionary *)attributes;
- (NSMutableDictionary *)attributesWithFont:(UIFont *)font;

- (void)insteadOfLine:(LMNLine *)line;
- (void)inheritFromLine:(LMNLine *)line;
- (void)clean;

@end

@interface LMNLine (Mode)

@property (nonatomic, readonly) LMNLineMode mode;
- (BOOL)isKindOfMode:(LMNLineMode)mode;

+ (instancetype)line;
+ (instancetype)lineWithMode:(LMNLineMode)mode;

@end
