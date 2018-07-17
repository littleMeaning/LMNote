//
//  LMNTextStorage+Export.m
//  LMNote
//
//  Created by littleMeaning on 2018/7/12.
//  Copyright © 2018年 littleMeaning. All rights reserved.
//

#import "LMNTextStorage+Export.h"
#import "UIFont+LMNote.h"
#import "LMNLineChain.h"
#import "LMNCheckboxLine.h"

@implementation LMNTextStorage (Export)

// 导出成 HTML 字符串，可以根据具体情况自由添加 css。
- (void)exportHTML:(void (^)(BOOL succeed, NSString *html))completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        NSMutableString *html = [NSMutableString string];
        LMNLine *line = self.chain.rootLine;
        do {
            NSRange range = line.range;
            if (line.next) {
                range.length -= 1;
            }
            NSAttributedString *attributedText = [self attributedSubstringFromRange:range];
            if ([line isKindOfMode:LMNLineModeModeImage]) {
                // TODO: 图片部分逻辑未处理。
                NSString *imgSrc = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1529656898878&di=530af28e54a9418a36e7b27b018f2df1&imgtype=0&src=http%3A%2F%2Fimg4.duitang.com%2Fuploads%2Fitem%2F201406%2F13%2F20140613210905_SEWfr.jpeg";
                [html appendFormat:@"<img src=\"%@\" width=\"100%%\"/>", imgSrc];
            }
            else {
                NSMutableString *lineHTML = [NSMutableString string];
                if (attributedText.length > 0) {
                    NSRange effectiveRange = NSMakeRange(0, 0);
                    do {
                        NSDictionary *attributes = [attributedText attributesAtIndex:NSMaxRange(effectiveRange) effectiveRange:&effectiveRange];
                        NSString *text = [[attributedText string] substringWithRange:effectiveRange];
                        UIFont *font = attributes[NSFontAttributeName];
                        BOOL underline = [attributes[NSUnderlineStyleAttributeName] boolValue];
                        BOOL strikethrough = [attributes[NSStrikethroughStyleAttributeName] integerValue] == 1;
                        NSString *fragment = [self htmlWithContent:text font:font underline:underline strikethrough:strikethrough];
                        [lineHTML appendString:fragment];
                    } while (NSMaxRange(effectiveRange) < attributedText.length);
                }
                NSString *styleClass = @"content";
                if ([line isKindOfMode:LMNLineModeTitle]) {
                    styleClass = @"title";
                }
                else if ([line isKindOfMode:LMNLineModeSubTitle]) {
                    styleClass = @"subtitle";
                }
                
                if ([line isKindOfMode:LMNLineModeNumbering]) {
                    if (![line.prev isKindOfMode:LMNLineModeNumbering]) {
                        [html appendString:@"<ol>"];
                    }
                    [html appendFormat:@"<li class=\"%@\">%@</p>", styleClass, lineHTML];
                    if (![line.next isKindOfMode:LMNLineModeNumbering]) {
                        [html appendString:@"</ol>"];
                    }
                }
                else if ([line isKindOfMode:LMNLineModeBullets]) {
                    if (![line.prev isKindOfMode:LMNLineModeBullets]) {
                        [html appendString:@"<ul>"];
                    }
                    [html appendFormat:@"<li class=\"%@\">%@</p>", styleClass, lineHTML];
                    if (![line.next isKindOfMode:LMNLineModeBullets]) {
                        [html appendString:@"</ul>"];
                    }
                }
                else if ([line isKindOfMode:LMNLineModeCheckbox]) {
                    NSString *checked = [(LMNCheckboxLine *)line checkboxSelected] ? @"checked " : @"";
                    [html appendFormat:@"<input class=\"%@\" type=\"checkbox\" %@>%@</p>", styleClass, checked, lineHTML];
                }
                else {
                    [html appendFormat:@"<p class=\"%@\">%@</p>", styleClass, lineHTML];
                }
            }
            line = line.next;
        } while (line);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [html insertString:@"<!DOCTYPE html><html><style type=\"text/css\">.title{font-size: 24px;};.subtitle {font-size: 20px;};.content{font-size: 17px;}</style><body>" atIndex:0];
            [html appendString:@"</body></html>"];
            completion(YES, [html copy]);
        });
    });
}

- (NSString *)htmlWithContent:(NSString *)content
                         font:(UIFont *)font
                    underline:(BOOL)underline
                strikethrough:(BOOL)strikethrough
{
    if (content.length == 0 || font == nil) {
        return @"";
    }
    NSString *html = content;
    if (font.bold) {
        html = [NSString stringWithFormat:@"<b>%@</b>", html];
    }
    if (font.italic) {
        html = [NSString stringWithFormat:@"<i>%@</i>", html];
    }
    if (underline) {
        html = [NSString stringWithFormat:@"<u>%@</u>", html];
    }
    if (strikethrough) {
        html = [NSString stringWithFormat:@"<s>%@</s>", html];
    }
    return html;
}

@end
