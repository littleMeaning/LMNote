//
//  LMNItem.h
//  LMNote
//
//  Created by littleMeaning on 2018/7/2.
//  Copyright © 2018年 littleMeaning. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LMNFolder;
@class LMNStore;

@interface LMNItem : NSObject <NSCoding>

@property (nonatomic, strong) NSUUID *uuid;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSDate *date;

@property (nonatomic, weak) LMNStore *store;
@property (nonatomic, weak) LMNFolder *parent;

- (instancetype)initWithUUID:(NSUUID *)uuid name:(NSString *)name date:(NSDate *)date;

- (void)save;
- (void)delete;

@end
