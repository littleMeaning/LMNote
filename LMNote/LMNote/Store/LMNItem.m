//
//  LMNItem.m
//  LMNote
//
//  Created by littleMeaning on 2018/7/2.
//  Copyright © 2018年 littleMeaning. All rights reserved.
//

#import "LMNItem.h"
#import "LMNStore.h"
#import "LMNFolder.h"

@interface LMNItem ()

@end

@implementation LMNItem

- (instancetype)initWithUUID:(NSUUID *)uuid name:(NSString *)name date:(NSDate *)date
{
    self = [super init];
    if (self) {
        self.uuid = uuid;
        self.name = name;
        self.date = date;
    }
    return self;
}

- (void)setParent:(LMNFolder *)parent
{
    _parent = parent;
    self.store = parent.store;
}

- (void)save
{
    if ([self.parent.contents containsObject:self]) {
        [self.store save:self userInfo:nil];
    }
    else {
        [self.parent add:self];
    }
}

- (void)delete
{
    [self.parent remove:self];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.uuid.UUIDString forKey:@"uuid"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.date forKey:@"date"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.uuid = [[NSUUID alloc] initWithUUIDString:[aDecoder decodeObjectForKey:@"uuid"]];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.date = [aDecoder decodeObjectForKey:@"date"];
    }
    return self;
}

@end
