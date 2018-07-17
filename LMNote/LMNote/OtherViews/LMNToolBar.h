//
//  LMNToolBar.h
//  LMNote
//
//  Created by littleMeaning on 2018/4/17.
//  Copyright © 2018年 littleMeaning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMNLineModes.h"

extern NSString * const LMFontBoldAttributeName;
extern NSString * const LMFontUnderlineAttributeName;
extern NSString * const LMFontItalicAttributeName;
extern NSString * const LMFontStrikethroughAttributeName;
extern NSString * const LMLineModeAttributeName;

typedef NS_ENUM(NSUInteger, LMNToolBarItemTag) {
    LMNToolBarItemTagImage = 1001,
};

@class LMNToolBar;

extern NSInteger const LMNToolBarIndexOfCloseItem;

@protocol LMNToolBarDelegate <NSObject>

- (void)lmn_toolBar:(LMNToolBar *)toolBar didChangedMode:(LMNLineMode)mode;
- (void)lmn_toolBar:(LMNToolBar *)toolBar didChangedAttributes:(NSDictionary *)attributes;
- (void)lmn_toolBar:(LMNToolBar *)toolBar didChangedTextAlignment:(NSTextAlignment)alignment;
- (void)lmn_toolBar:(LMNToolBar *)toolBar didSelectedItemWithTag:(LMNToolBarItemTag)tag;
- (void)lmn_toolBarClose:(LMNToolBar *)toolBar;

@end

@interface LMNToolBar : UIView

@property (nonatomic, weak) id<LMNToolBarDelegate> delegate;
@property (nonatomic, copy) LMNLineMode mode;

+ (instancetype)toolBar;

- (void)showSubToolBar:(BOOL)animated;
- (void)hideSubToolBar:(BOOL)animated;

- (void)reloadDataWithTypingAttributes:(NSDictionary *)typingAttributes mode:(LMNLineMode)mode isMultiLine:(BOOL)isMultiLine;

@end
