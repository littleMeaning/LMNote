//
//  LMNToolBar.m
//  LMNote
//
//  Created by littleMeaning on 2018/4/17.
//  Copyright © 2018年 littleMeaning. All rights reserved.
//

#import "LMNToolBar.h"
#import "UIFont+LMNote.h"

NSString * const LMFontBoldAttributeName = @"bold";
NSString * const LMFontUnderlineAttributeName = @"underline";
NSString * const LMFontItalicAttributeName = @"italic";
NSString * const LMFontStrikethroughAttributeName = @"strikethrough";
NSString * const LMLineModeAttributeName = @"mode";

UIImage *lmn_getRectangleImageWithOptions(CGSize size, BOOL opaque, CGFloat scale, CGFloat cornerRadius, CGFloat margin, UIColor *color)
{
    UIImage *image;
    UIGraphicsBeginImageContextWithOptions(size, opaque, scale);
    {
        CGRect rect = CGRectZero;
        rect.size = size;
        rect = CGRectInset(rect, margin, margin);
        CAShapeLayer *layer = [CAShapeLayer layer];
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
        layer.path = path.CGPath;
        layer.lineWidth = 0;
        layer.fillColor = color.CGColor;
        [layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@interface LMNToolBar ()

@property (nonatomic, strong) UIView *toolBar;
@property (nonatomic, strong) UIView *subToolBar;
@property (nonatomic, strong) UIButton *subToolBarLeftView;

@property (nonatomic, copy) NSArray<UIButton *> *itemButtons;
@property (nonatomic, copy) NSArray<UIButton *> *subItemButtons;

@property (nonatomic, readonly) UIButton *fontButton;
@property (nonatomic, readonly) UIButton *titleButton;
@property (nonatomic, readonly) UIButton *listButton;
@property (nonatomic, readonly) UIButton *checkboxButton;
@property (nonatomic, readonly) UIButton *alignmentButton;
@property (nonatomic, readonly) UIButton *imageButton;
@property (nonatomic, readonly) UIButton *dismissButton;

@property (nonatomic, readonly) UIButton *boldButton;
@property (nonatomic, readonly) UIButton *italicButton;
@property (nonatomic, readonly) UIButton *underlineButton;
@property (nonatomic, readonly) UIButton *strikethroughButton;
@property (nonatomic, readonly) UIButton *foldButton;

@property (nonatomic, assign) NSTextAlignment alignment;

@end

@implementation LMNToolBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadSubviews];
    }
    return self;
}

+ (instancetype)toolBar
{
    return [[self alloc] initWithFrame:CGRectZero];
}

- (void)loadToolBar
{
    if (!_toolBar) {
        _toolBar = [[UIView alloc] init];
        _toolBar.backgroundColor = [UIColor whiteColor];
        NSMutableArray *itemButtons = [NSMutableArray array];
        NSArray *images = @[
                            [UIImage imageNamed:@"lmn_tool_a"],
                            [UIImage imageNamed:@"lmn_tool_t"],
                            [UIImage imageNamed:@"lmn_list"],
                            [UIImage imageNamed:@"lmn_list_checkbox"],
                            [UIImage imageNamed:@"lmn_alignment_left"],
                            [UIImage imageNamed:@"lmn_tool_image"],
                            [UIImage imageNamed:@"lmn_tool_close"]
                            ];
        for (int idx = 0; idx < images.count; idx ++) {
            UIImage *image = images[idx];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:image forState:UIControlStateNormal];
            [_toolBar addSubview:button];
            [itemButtons addObject:button];
            [button addTarget:self
                       action:@selector(didSelectItem:)
             forControlEvents:UIControlEventTouchUpInside];
            
            switch (idx) {
                case 0:
                    _fontButton = button;
                    break;
                case 1:
                    _titleButton = button;
                    break;
                case 2:
                    _listButton = button;
                    break;
                case 3:
                    _checkboxButton = button;
                    break;
                case 4:
                    _alignmentButton = button;
                    break;
                case 5:
                    button.tag = LMNToolBarItemTagImage;
                    _imageButton = button;
                    break;
                case 6:
                    _dismissButton = button;
                    break;
                default:
                    break;
            }
        }
        self.itemButtons = itemButtons;
    }
}

- (void)loadSubToolBar
{
    static UIImage *bgImage;
    static UIImage *bgImageSelected;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bgImage = lmn_getRectangleImageWithOptions(CGSizeMake(44.f, 44.f), NO, [UIScreen mainScreen].scale, 4.f, 7.f, [UIColor colorWithWhite:230/255.f alpha:1.f]);
        bgImageSelected = lmn_getRectangleImageWithOptions(CGSizeMake(44.f, 44.f), NO, [UIScreen mainScreen].scale, 4.f, 7.f, [UIColor colorWithRed:43/255.f green:132/255.f blue:210/255.f alpha:1.f]);
    });
    
    _subToolBar = [[UIView alloc] init];
    _subToolBar.backgroundColor = [UIColor whiteColor];
    NSMutableArray *itemButtons = [NSMutableArray array];
    NSArray *images = @[
                        [UIImage imageNamed:@"lmn_font_bold"],
                        [UIImage imageNamed:@"lmn_font_italic"],
                        [UIImage imageNamed:@"lmn_font_underline"],
                        [UIImage imageNamed:@"lmn_font_strikethrough"],
                        [UIImage imageNamed:@"lmn_left_square"]
                        ];;
    for (int idx = 0; idx < images.count; idx ++) {
        UIImage *image = images[idx];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:image forState:UIControlStateNormal];
        if (idx != 4) {
            [button setBackgroundImage:bgImage forState:UIControlStateNormal];
            [button setBackgroundImage:bgImageSelected forState:UIControlStateSelected];
        }
        [_subToolBar addSubview:button];
        [itemButtons addObject:button];
        [button addTarget:self
                   action:@selector(didSelectItem:)
         forControlEvents:UIControlEventTouchUpInside];
        
        switch (idx) {
            case 0:
                _boldButton = button;
                break;
            case 1:
                _italicButton = button;
                break;
            case 2:
                _underlineButton = button;
                break;
            case 3:
                _strikethroughButton = button;
                break;
            case 4:
                _foldButton = button;
            default:
                break;
        }
    }
    self.subItemButtons = itemButtons;
}

- (void)loadSubviews
{
    [self loadToolBar];
    [self loadSubToolBar];
    UIImage *image = [self.fontButton imageForState:UIControlStateNormal];
    self.subToolBarLeftView = [UIButton buttonWithType:UIButtonTypeCustom];
    self.subToolBarLeftView.backgroundColor = [UIColor whiteColor];
    [self.subToolBarLeftView setImage:image forState:UIControlStateNormal];
    self.subToolBarLeftView.hidden = YES;
    self.subToolBar.hidden = YES;
    [self addSubview:self.toolBar];
    [self addSubview:self.subToolBarLeftView];
    [self addSubview:self.subToolBar];
    [self.subToolBarLeftView addTarget:self action:@selector(didSelectItem:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    {
        self.toolBar.frame = self.bounds;
        CGRect rect = self.toolBar.bounds;
        rect.size.width = CGRectGetHeight(rect);
        rect.origin.x = 8.f;
        for (UIButton *button in self.itemButtons) {
            if (button == self.itemButtons.lastObject) {
                rect.origin.x = CGRectGetWidth(self.toolBar.bounds) - CGRectGetWidth(rect) - 8.f;
            }
            button.frame = rect;
            rect.origin.x += CGRectGetWidth(rect) + 4.f;
        }
    }
    CGFloat height = CGRectGetHeight(self.bounds);
    self.subToolBarLeftView.frame = CGRectMake(0, 0, height, height);
    {
        self.subToolBar.frame = ({
            CGRect rect = self.bounds;
            rect.size.width -= height;
            rect.origin.x = height;
            rect;
        });
        CGRect rect = self.subToolBar.bounds;
        rect.size.width = CGRectGetHeight(rect);
        rect.origin.x = 8.f;
        for (UIButton *button in self.subItemButtons) {
            // 隐藏斜体按钮，"PingFang SC" 字体不支持斜体。
            if (button == self.italicButton) {
                button.hidden = YES;
                continue;
            }
            if (button == self.subItemButtons.lastObject) {
                rect.origin.x = CGRectGetWidth(self.subToolBar.bounds) - CGRectGetWidth(rect) - 8.f;
            }
            button.frame = rect;
            rect.origin.x += CGRectGetWidth(rect) + 4.f;
        }
    }
}

- (void)didSelectItem:(UIButton *)itemButton
{
    if (itemButton.tag > 0) {
        [self.delegate lmn_toolBar:self didSelectedItemWithTag:itemButton.tag];
    }
    if (itemButton == self.foldButton || itemButton == self.subToolBarLeftView) {
        [self hideSubToolBar:YES];
        return;
    }
    if (itemButton == self.dismissButton) {
        [self.delegate lmn_toolBarClose:self];
        return;
    }
    if (itemButton == self.alignmentButton) {
        self.alignment = (self.alignment + 1) % 3;
        [self.delegate lmn_toolBar:self didChangedTextAlignment:self.alignment];
        return;
    }
    if ([self.subItemButtons containsObject:itemButton]) {

        itemButton.selected = !itemButton.selected;
        
        BOOL bold          = self.boldButton.selected;
        BOOL italic        = self.italicButton.selected;
        BOOL underline     = self.underlineButton.selected;
        BOOL strikethrough = self.strikethroughButton.selected;
        
        NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
        attributes[LMFontBoldAttributeName]          = @(bold);
        attributes[LMFontItalicAttributeName]        = @(italic);
        attributes[LMFontUnderlineAttributeName]     = @(underline);
        attributes[LMFontStrikethroughAttributeName] = @(strikethrough);
        
        [self.delegate lmn_toolBar:self didChangedAttributes:attributes];
        return;
    }
    if ([self.itemButtons containsObject:itemButton]) {
        
        if (itemButton == self.fontButton) {
            [self showSubToolBar:YES];
        }
        else if (itemButton == self.titleButton) {
            
            if ([self.mode isEqualToString:LMNLineModeTitle]) {
                [self setMode:LMNLineModeSubTitle];
            }
            else if ([self.mode isEqualToString:LMNLineModeSubTitle]) {
                [self setMode:LMNLineModeContent];
            }
            else {
                [self setMode:LMNLineModeTitle];
            }
        }
        else if (itemButton == self.listButton) {
            
            if (self.mode == LMNLineModeBullets) {
                [self setMode:LMNLineModeNumbering];
            }
            else if ([self.mode isEqualToString:LMNLineModeNumbering]) {
                [self setMode:LMNLineModeContent];
            }
            else {
                [self setMode:LMNLineModeBullets];
            }
        }
        else if (itemButton == self.checkboxButton) {
            
            if ([self.mode isEqualToString:LMNLineModeCheckbox]) {
                [self setMode:LMNLineModeContent];
            }
            else {
                [self setMode:LMNLineModeCheckbox];
            }
        }
        [self.delegate lmn_toolBar:self didChangedMode:self.mode];
        return;
    }
}

- (void)showSubToolBar:(BOOL)animated
{
    self.subToolBar.alpha = 0;
    self.subToolBar.hidden = NO;
    self.subToolBarLeftView.frame = [self convertRect:self.fontButton.frame fromView:self.toolBar];
    self.subToolBarLeftView.hidden = NO;
    UIButton *foldButton = self.foldButton;
    foldButton.alpha = 0;
    foldButton.frame = CGRectOffset(foldButton.frame, -CGRectGetWidth(self.subToolBar.frame), 0);
    self.fontButton.hidden = YES;
    
    [UIView animateWithDuration: animated ? 0.35 : 0 animations:^{
        
        self.subToolBar.alpha = 1;
        self.toolBar.alpha = 0;
        self.toolBar.frame = ({
            CGRect rect = self.toolBar.frame;
            rect.origin.x += CGRectGetWidth(rect);
            rect;
        });
        self.subToolBarLeftView.frame = ({
            CGRect rect = self.subToolBarLeftView.frame;
            rect.origin.x = 0;
            rect;
        });
        foldButton.alpha = 1;
        foldButton.frame = CGRectOffset(foldButton.frame, CGRectGetWidth(self.subToolBar.frame), 0);
        
    } completion:^(BOOL finished) {
        
        self.toolBar.hidden = YES;
    }];
}

- (void)hideSubToolBar:(BOOL)animated
{
    UIButton *fontItemButton = self.fontButton;
    UIButton *leftButton = self.foldButton;
    self.toolBar.alpha = 0;
    self.toolBar.hidden = NO;
    [UIView animateWithDuration: animated ? 0.35 : 0 animations:^{
        
        self.subToolBar.alpha = 0;
        self.toolBar.alpha = 1.f;
        self.toolBar.frame = ({
            CGRect rect = self.toolBar.frame;
            rect.origin.x -= CGRectGetWidth(rect);
            rect;
        });
        self.subToolBarLeftView.frame = [self convertRect:fontItemButton.frame fromView:self.toolBar];
        leftButton.alpha = 0;
        leftButton.frame = CGRectOffset(leftButton.frame, -CGRectGetWidth(self.subToolBar.frame), 0);
        
    } completion:^(BOOL finished) {
        
        fontItemButton.hidden = NO;
        self.subToolBar.hidden = YES;
        self.subToolBarLeftView.hidden = YES;
        leftButton.frame = CGRectOffset(leftButton.frame, CGRectGetWidth(self.subToolBar.frame), 0);
    }];
}

- (void)reloadDataWithTypingAttributes:(NSDictionary *)typingAttributes mode:(LMNLineMode)mode isMultiLine:(BOOL)isMultiLine
{
    UIFont *font = typingAttributes[NSFontAttributeName];
    BOOL bold          = font.bold;
    BOOL italic        = font.italic;
    BOOL underline     = (typingAttributes[NSUnderlineStyleAttributeName] != nil);
    BOOL strikethrough = (typingAttributes[NSStrikethroughStyleAttributeName] != nil);
    
    if (isMultiLine || ![@[LMNLineModeTitle, LMNLineModeSubTitle, LMNLineModeContent] containsObject:mode]) {
        self.alignment = NSTextAlignmentLeft;
        self.alignmentButton.enabled = NO;
    }
    else {
        self.alignmentButton.enabled = YES;
        NSParagraphStyle *paragraphStyle = typingAttributes[NSParagraphStyleAttributeName];
        if (paragraphStyle) {
            self.alignment = paragraphStyle.alignment;
        }
        else {
            self.alignment = NSTextAlignmentLeft;
        }
    }
    
    self.boldButton.selected = bold;
    self.italicButton.selected = italic;
    self.underlineButton.selected = underline;
    self.strikethroughButton.selected = strikethrough;
    
    [self setMode:mode];
}

- (void)setMode:(LMNLineMode)mode
{
    if ([_mode isEqualToString:mode]) {
        return;
    }
    _mode = mode;
    
    UIImage *tNormal = [UIImage imageNamed:@"lmn_tool_t"];
    UIImage *listNormal = [UIImage imageNamed:@"lmn_list"];
    [self.titleButton setImage:tNormal forState:UIControlStateNormal];
    [self.listButton setImage:listNormal forState:UIControlStateNormal];
    
    if ([mode isEqualToString:LMNLineModeTitle]) {
        UIImage *tTitle = [UIImage imageNamed:@"lmn_tool_title"];
        [self.titleButton setImage:tTitle forState:UIControlStateNormal];
    }
    if ([mode isEqualToString:LMNLineModeSubTitle]) {
        UIImage *tSubTitle = [UIImage imageNamed:@"lmn_tool_subtitle"];
        [self.titleButton setImage:tSubTitle forState:UIControlStateNormal];
    }
    if ([mode isEqualToString:LMNLineModeBullets]) {
        UIImage *listDot = [UIImage imageNamed:@"lmn_list_dot"];
        [self.listButton setImage:listDot forState:UIControlStateNormal];
    }
    if ([mode isEqualToString:LMNLineModeNumbering]) {
        UIImage *listNumber = [UIImage imageNamed:@"lmn_list_number"];
        [self.listButton setImage:listNumber forState:UIControlStateNormal];
    }
}

- (void)setAlignment:(NSTextAlignment)alignment
{
    if (alignment > 2) {
        alignment = NSTextAlignmentLeft;
    }
    if (_alignment == alignment) {
        return;
    }
    _alignment = alignment;
    UIImage *image;
    switch (alignment) {
        case NSTextAlignmentLeft:
            image = [UIImage imageNamed:@"lmn_alignment_left"];
            break;
        case NSTextAlignmentCenter:
            image = [UIImage imageNamed:@"lmn_alignment_center"];
            break;
        case NSTextAlignmentRight:
            image = [UIImage imageNamed:@"lmn_alignment_right"];
            break;
        default:
            break;
    }
    [self.alignmentButton setImage:image forState:UIControlStateNormal];
}

@end
