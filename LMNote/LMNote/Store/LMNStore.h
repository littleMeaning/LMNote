//
//  LMNStore.h
//  LMNote
//
//  Created by littleMeaning on 2018/7/2.
//  Copyright © 2018年 littleMeaning. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LMNFolder.h"
#import "LMNItem.h"

extern NSString * const LMNStoreVersion;
extern NSString * const LMNStoreVersionArchiveKey;
extern NSString * const LMNStoreDidChangedNotification;

@interface LMNStore : NSObject

@property (nonatomic, strong) LMNFolder *rootFolder;

+ (instancetype)shared;
- (instancetype)initWithURL:(NSURL *)url;

- (NSURL *)imageDirectory;
- (void)save:(LMNItem *)item userInfo:(NSDictionary *)userInfo;
- (void)reload;

@end
