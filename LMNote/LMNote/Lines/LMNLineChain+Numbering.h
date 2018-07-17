//
//  LMNLineChain+Numbering.h
//  LMNote
//
//  Created by littleMeaning on 2018/7/9.
//  Copyright © 2018年 littleMeaning. All rights reserved.
//

#import "LMNLineChain.h"

@interface LMNLineChain (Numbering)

- (void)updateNumberings;
- (void)updateNumberingStartWithLine:(LMNLine *)line;

@end
