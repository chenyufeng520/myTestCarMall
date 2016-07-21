//
//  WebView.m
//  PointsMall
//
//  Created by 陈宇峰 on 16/7/20.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import "ISTWebView.h"
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"
#import "BSPayCenter.h"
#import "MineDataHelper.h"
#import "ISTHUDManager.h"

@interface ISTWebView ()<UIWebViewDelegate ,NJKWebViewProgressDelegate>
{
    NJKWebViewProgressView *_webViewProgressView;
    NJKWebViewProgress *_webViewProgress;
}
@end

@implementation ISTWebView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        [self _initSubView];
        
    }
    return self;
}

- (void)_initSubView
{
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:self.bounds];
    bgView.image = [UIImage imageNamed:@"scbg"];
    bgView.contentMode = UIViewContentModeScaleAspectFit;
    bgView.userInteractionEnabled = YES;
    [self addSubview:bgView];
    
    _webView = [[UIWebView alloc]initWithFrame:bgView.bounds];
    _webView.delegate = self;
    _webView.backgroundColor = [UIColor clearColor];
    _webView.opaque = NO;
    _webView.scrollView.bounces = NO;
    [bgView addSubview:_webView];
    
    _webViewProgress = [[NJKWebViewProgress alloc] init];
    _webView.delegate = _webViewProgress;
    _webViewProgress.webViewProxyDelegate = self;
    _webViewProgress.progressDelegate = self;
    
    CGRect barFrame = CGRectMake(0, 0, _webView.width, 2);
    _webViewProgressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _webViewProgressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [_webViewProgressView setProgress:0 animated:YES];
}

- (void)setURL:(NSString *)URL
{
    if (_URL != URL) {
        _URL = URL;
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URL]];
        [_webView loadRequest:request];
        [_webView addSubview:_webViewProgressView];
    }
}

#pragma mark - UIWebViewDelegate


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    double htmlHeight = [[_webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] doubleValue];
    if (_delegate && [_delegate respondsToSelector:@selector(webHeightAdjusted:)]) {
        [_delegate webHeightAdjusted:htmlHeight];
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
   [[ISTHUDManager defaultManager] showHUDInView:self withText:@"加载中"];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[ISTHUDManager defaultManager] hideHUDInView:self];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    //调整webview的高度
    double htmlHeight = [[_webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] doubleValue];
    if (_delegate && [_delegate respondsToSelector:@selector(webHeightAdjusted:)]) {
        [_delegate webHeightAdjusted:htmlHeight];
    }
    
    [_webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    [_webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error
{
    [[ISTHUDManager defaultManager] hideHUDInView:self];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_webViewProgressView setProgress:progress animated:YES];

}

@end
