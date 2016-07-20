//
//  ISTWebViewController.m
//  CarLife
//
//  Created by 陈宇峰 on 16/7/20.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import "ISTWebViewController.h"
#import "ISTWebView.h"
#import "MineDataHelper.h"

@interface ISTWebViewController ()<ISTWebViewDelegate,UIAlertViewDelegate>
{
    ISTWebView *_webview;
}

@end

@implementation ISTWebViewController

- (id)initWithNavTitle:(NSString *)title andUrl:(NSString *)url
{
    if (self = [super initWithNibName:nil bundle:nil]) {
        if (title.length > 0) {
            self.showNavBar = YES;
        }
        
        self.navTitle = title;
        self.urlString = url;
    }
    
    return self;
}
/** 导航栏 */
- (ISTTopBar *)creatTopBarView:(CGRect)frame
{
    // 导航头
    ISTTopBar *tbTop = [[ISTTopBar alloc] initWithFrame:frame];
    [tbTop.btnTitle setTitle:self.navTitle forState:UIControlStateNormal];
    [tbTop setLetfTitle:nil];
    [tbTop.btnLeft addTarget:self action:@selector(onClickTopBar:) forControlEvents:UIControlEventTouchUpInside];
    return tbTop;
}

- (void)loadSubviews
{
    _webview = [[ISTWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, _contentView.height)];
    _webview.delegate = self;
    [_contentView addSubview:_webview];
    _webview.URL = _urlString;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_showNavBar) {
        _contentView.height += kTabBarHeight;
        
        _tbTop = [self creatTopBarView:kTopFrame];
        [self.view addSubview:_tbTop];
    }
    else
    {
        UIView *statusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.iosChangeFloat)];
        statusView.backgroundColor = kStatusBarColor;
        [self.view addSubview:statusView];
        
        _contentView.frame = CGRectMake(0, self.iosChangeFloat, self.view.width, self.view.height-self.iosChangeFloat);
    }
    [self loadSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Click Menu

- (void)onClickTopBar:(UIButton *)btn
{
    if (btn.tag == BSTopBarButtonLeft) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (btn.tag == BSTopBarButtonRight) {
        
    }
}

#pragma mark - ISTWebView Delegate

- (void)jumpToWebVC:(NSString *)title andUrl:(NSString *)urlString
{
    ISTWebViewController *theVC = [[ISTWebViewController alloc] init];
    theVC.urlString = urlString;
    theVC.showNavBar = NO;
    [self.navigationController pushViewController:theVC animated:YES];
}


- (void)jumpToApp:(NSString *)type andPara:(NSString *)para{
    
}


-(void)dealloc{
    _webview.webView.delegate = nil;
}

@end
