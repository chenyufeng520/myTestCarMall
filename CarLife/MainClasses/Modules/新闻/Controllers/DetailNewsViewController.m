//
//  DetailNewsViewController.m
//  CarLife
//
//  Created by 陈宇峰 on 16/7/19.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import "DetailNewsViewController.h"

@interface DetailNewsViewController ()<UIWebViewDelegate>

@end

@implementation DetailNewsViewController

- (ISTTopBar *)creatTopBarView:(CGRect)frame
{
    // 导航头
    ISTTopBar *tbTop = [[ISTTopBar alloc] initWithFrame:frame];
    [tbTop.btnTitle setTitle:@"详情" forState:UIControlStateNormal];
    
    [tbTop setLetfTitle:nil];
    [tbTop.btnLeft addTarget:self action:@selector(onClickTopBar:) forControlEvents:UIControlEventTouchUpInside];
    
    return tbTop;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubviews];
}

- (void)loadSubviews
{
    _tbTop = [self creatTopBarView:kTopFrame];
    [self.view addSubview:_tbTop];
    _contentView.height += kTabBarHeight;
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, _contentView.width, _contentView.height)];
    webView.scalesPageToFit = YES;
    webView.scrollView.bounces = NO;
    webView.delegate = self;
    [_contentView addSubview:webView];
    
    [[ISTHUDManager defaultManager] showHUDInView:_contentView withText:@"加载中"];
    //创建一个并行队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.newsModel.link]]];
    });

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

#pragma mark - webview

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[ISTHUDManager defaultManager] hideHUDInView:_contentView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
