//
//  WKWebBaseVC.m
//
//  Created by Mr Lai on 2017/6/2.
//  Copyright © 2017年 Mr Lai. All rights reserved.
//

#import "WKWebBaseVC.h"
#import <WebKit/WebKit.h>

@interface WKWebBaseVC () <WKNavigationDelegate>
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) WKWebView *wkWebView;
@end

@implementation WKWebBaseVC

- (UIProgressView *)progressView
{
    if (_progressView == nil)
    {
        CGRect navBounds = self.navigationController.navigationBar.bounds;
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, navBounds.size.height, MainScreenSize.height, 2)];
        _progressView.progressTintColor = SetupColor(83, 204, 222);
        _progressView.trackTintColor = [UIColor clearColor];
        [self.navigationController.navigationBar addSubview:_progressView];
    }
    return _progressView;
}

- (WKWebView *)webView
{
    if (_wkWebView == nil)
    {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        config.selectionGranularity = WKSelectionGranularityCharacter;
        _wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, MainScreenSize.width, MainScreenSize.height - NavHeight) configuration:config];
        _wkWebView.navigationDelegate = self;
        [self progressView];
        [self.view addSubview:_wkWebView];
    }
    return _wkWebView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.webView stopLoading];
    [self.progressView removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addKVO];
    [self getRequstData];
}

- (void)getRequstData {
    switch (self.webDataType) {
        case WebDataTypeUrl:
        {
            [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
        }
            break;
        case WebDataTypeHtml:
        {
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [self setupParams:params];
            WeakSelf(weakSelf)
            [HttpTool getWithURL:[self setupUrl] params:params progress:nil success:^(id json) {
                [weakSelf.wkWebView loadHTMLString:json[Data][@"content"] baseURL:nil];
            } failure:^(NSError *error) {
                [MBProgressHUD showError:@"暂无数据"];
            }];
        }
            break;
        default:
            break;
    }
}

- (void)addKVO {
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    self.progressView.progress = self.webView.estimatedProgress;
    self.progressView.hidden = (self.webView.estimatedProgress >= 1.0);
}

// 解决<a>herf = "url" </a>不能跳转的问题
-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    //如果是跳转一个新页面
    if (navigationAction.targetFrame == nil) {
        [webView loadRequest:navigationAction.request];
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)reloadWebView {
    [self.wkWebView reload];
}

- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (void)setupParams:(NSMutableDictionary *)params {}
@end
