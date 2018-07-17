//
//  UIFont+LMNote.h
//  SimpleWord
//
//  Created by littleMeaning on 16/6/30.
//  Copyright © 2016年 Little Meaning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (LMNote)

@property (nonatomic, readonly) BOOL bold;
@property (nonatomic, readonly) BOOL italic;
@property (nonatomic, readonly) float fontSize;

+ (instancetype)fontWithFontSize:(float)fontSize bold:(BOOL)bold italic:(BOOL)italic;

@end

