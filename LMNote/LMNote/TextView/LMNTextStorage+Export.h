//
//  LMNTextStorage+Export.h
//  LMNote
//
//  Created by littleMeaning on 2018/7/12.
//  Copyright © 2018年 littleMeaning. All rights reserved.
//

#import "LMNTextStorage.h"

@interface LMNTextStorage (Export)

- (void)exportHTML:(void (^)(BOOL succeed, NSString *html))completion;

@end
