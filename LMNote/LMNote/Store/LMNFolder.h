//
//  LMNFolder.h
//  LMNote
//
//  Created by littleMeaning on 2018/7/2.
//  Copyright © 2018年 littleMeaning. All rights reserved.
//

#import "LMNItem.h"

@interface LMNFolder : LMNItem <NSCoding>

@property (nonatomic, strong) NSMutableArray<LMNItem *> *contents;
- (void)add:(LMNItem *)item;
- (void)remove:(LMNItem *)item;

@end
