//
//  LMNLineChain.h
//  LMNote
//
//  Created by littleMeaning on 2018/3/17.
//  Copyright © 2018年 littleMeaning. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LMNLine.h"

@class LMNImageView;

@interface LMNLineChain : NSObject <NSCoding>

@property (nonatomic, readonly) NSString *text;
- (void)updateWithText:(NSString *)text;

@property (nonatomic, strong) LMNLine *rootLine;
- (LMNLine *)lineAtLocation:(NSUInteger)loc;

@end
