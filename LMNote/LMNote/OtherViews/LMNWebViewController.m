//
//  LMNWebViewController.m
//  LMNote
//
//  Created by littleMeaning on 2018/7/12.
//  Copyright © 2018年 littleMeaning. All rights reserved.
//

#import "LMNWebViewController.h"
@import WebKit;

@interface LMNWebViewController ()

@property (nonatomic, strong) UIWebView *webview;

@end

@implementation LMNWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.webview.frame = self.view.bounds;
}

- (UIWebView *)webview
{
    if (!_webview) {
        _webview = [[UIWebView alloc] init];
        [self.view addSubview:_webview];
    }
    return _webview;
}

- (void)setHtml:(NSString *)html
{
    _html = [html copy];
    [self.webview loadHTMLString:html baseURL:nil];
}

@end
