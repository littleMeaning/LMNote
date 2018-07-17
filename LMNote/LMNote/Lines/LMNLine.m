//
//  LMNTextLine.m
//  LMNote
//
//  Created by littleMeaning on 2018/3/16.
//  Copyright © 2018年 littleMeaning. All rights reserved.
//

#import "LMNLine.h"
#import "UIFont+LMNote.h"
#import "LMNLineChain.h"

LMNLineMode const LMNLineModeContent     = @"content";
LMNLineMode const LMNLineModeTitle       = @"title";
LMNLineMode const LMNLineModeSubTitle    = @"subtitle";
LMNLineMode const LMNLineModeNumbering   = @"numbering";
LMNLineMode const LMNLineModeBullets     = @"bullets";
LMNLineMode const LMNLineModeCheckbox    = @"checkbox";
LMNLineMode const LMNLineModeModeImage   = @"image";
LMNLineMode const LMNLineModeModeUnknown = @"Unknown";

static Class lmn_lineClassOf(LMNLineMode mode)
{
    NSString *className = [NSString stringWithFormat:@"LMN%@Line", [mode capitalizedString]];
    return NSClassFromString(className);
}

@interface LMNLine ()

@property (nonatomic, assign) BOOL isRoot;
@property (nonatomic, weak) LMNLineChain *lineChain;

@property (nonatomic, copy, readwrite) NSString *uuid;
@property (nonatomic, weak, readwrite) LMNLine *prev;

@end

@implementation LMNLine

static CGFloat kLineSpacing = 2.f;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _uuid = [NSUUID UUID].UUIDString;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.uuid = [aDecoder decodeObjectForKey:@"uuid"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.uuid forKey:@"uuid"];
}

#pragma mark - getter & setter

- (void)setNext:(LMNLine *)next
{
    _next = next;
    next.prev = self;
}

- (void)makeRootOfLineChain:(LMNLineChain *)lineChain
{
    self.isRoot = YES;
    self.lineChain = lineChain;
    lineChain.rootLine = self;
}

#pragma mark - attributes for paragraph modes

- (NSMutableDictionary *)attributesWithFont:(UIFont *)font
{
    static UIFont *defaultFont;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultFont = [UIFont fontWithFontSize:17.f bold:NO italic:NO];
    });
    if (!font) {
        font = defaultFont;
    }
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[NSForegroundColorAttributeName] = [UIColor grayColor];
    attributes[NSFontAttributeName] = font;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = kLineSpacing;
    attributes[NSParagraphStyleAttributeName] = paragraphStyle;
    return attributes;
}

- (NSDictionary *)attributes
{
    return nil;
}

- (void)insteadOfLine:(LMNLine *)line
{
    self.range = line.range;
    self.next = line.next;
    line.prev.next = self;
    if (line.isRoot) {
        [self makeRootOfLineChain:line.lineChain];
    }
    [line clean];
}

- (void)inheritFromLine:(LMNLine *)line {}

- (void)clean {}

- (void)dealloc {
    [self clean];
}

@end

@implementation LMNLine (Mode)

#pragma mark - mode

+ (instancetype)line
{
    return [self lineWithMode:LMNLineModeContent];
}

+ (instancetype)lineWithMode:(LMNLineMode)mode
{
    return [lmn_lineClassOf(mode) new];
}

- (BOOL)isKindOfMode:(LMNLineMode)mode
{
    Class cls = lmn_lineClassOf(mode);
    return [self isKindOfClass:cls];
}

- (LMNLineMode)mode
{
    NSArray *modes = @[
                       LMNLineModeContent,
                       LMNLineModeTitle,
                       LMNLineModeSubTitle,
                       LMNLineModeNumbering,
                       LMNLineModeBullets,
                       LMNLineModeCheckbox,
                       LMNLineModeModeImage,
                       ];
    for (LMNLineMode mode in modes) {
        if ([self isKindOfMode:mode]) {
            return mode;
        }
    }
    return LMNLineModeModeUnknown;
}

@end
