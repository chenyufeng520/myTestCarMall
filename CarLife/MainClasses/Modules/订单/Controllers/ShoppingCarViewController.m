//
//  ShoppingCarViewController.m
//  CarLife
//
//  Created by 陈宇峰 on 16/5/25.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import "ShoppingCarViewController.h"
#import "BSPayCenter.h"
#import "AppDelegate.h"

#define kWeixinPayTag           1104
#define kZhifubaoPayTag         1105
#define kYinlianPayTag          1106

@interface ShoppingCarViewController ()

@end

@implementation ShoppingCarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payBack:) name:kPaySucceedNotification object:nil];
    }
    return self;
}

- (ISTTopBar *)creatTopBarView:(CGRect)frame
{
    // 导航头
    ISTTopBar *tbTop = [[ISTTopBar alloc] initWithFrame:frame];
    [tbTop.btnTitle setTitle:@"购物车" forState:UIControlStateNormal];
    
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
    
    UIButton *zfbBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [zfbBtn setFrame:CGRectMake(15, 50, _contentView.width - 30, kScreen_Width*130/1080)];
    [zfbBtn setBackgroundColor:RGBCOLOR(121, 206, 134)];
    [zfbBtn setTitle:@"微信支付" forState:UIControlStateNormal];
    zfbBtn.titleLabel.font = kFontNormal;
    [zfbBtn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    zfbBtn.tag = kWeixinPayTag;
    zfbBtn.layer.cornerRadius = kCornerRadius;
    [_contentView addSubview:zfbBtn];
    
    UIButton *wxPayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [wxPayBtn setFrame:CGRectMake(15, zfbBtn.maxY + 10, _contentView.width - 30, kScreen_Width*130/1080)];
    [wxPayBtn setBackgroundColor:RGBCOLOR(75, 182, 218)];
    [wxPayBtn setTitle:@"支付宝支付" forState:UIControlStateNormal];
    wxPayBtn.titleLabel.font = kFontNormal;
    [wxPayBtn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    wxPayBtn.tag = kZhifubaoPayTag;
    wxPayBtn.layer.cornerRadius = kCornerRadius;
    [_contentView addSubview:wxPayBtn];
    
    UIButton *ylPayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [ylPayBtn setFrame:CGRectMake(15, wxPayBtn.maxY + 10, _contentView.width - 30, kScreen_Width*130/1080)];
    [ylPayBtn setBackgroundColor:RGBCOLOR(234, 66, 71)];
    [ylPayBtn setTitle:@"银联支付" forState:UIControlStateNormal];
    ylPayBtn.titleLabel.font = kFontNormal;
    [ylPayBtn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    ylPayBtn.tag = kYinlianPayTag;
    ylPayBtn.layer.cornerRadius = kCornerRadius;
    [_contentView addSubview:ylPayBtn];

}

#pragma mark - Actions
- (void)onClickTopBar:(UIButton *)btn
{
    if (btn.tag == BSTopBarButtonLeft) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (btn.tag == BSTopBarButtonRight) {
        
    }
}

- (void)buttonPressed:(UIButton *)sender
{
    switch (sender.tag) {
        case kWeixinPayTag:
        {
            if (![BSPayCenter isWXAppInstalled]) {
                kTipAlert(@"您还没有安装微信，请先安装");
                return;
            }
            [[BSPayCenter sharePayEngine] wxPayAction:nil];
            
        }break;
        case kZhifubaoPayTag:
        {
            [[BSPayCenter sharePayEngine] zfbPay:[NSDictionary dictionaryWithObjectsAndKeys:@"0.01",@"amount", nil]];
        }break;
        case kYinlianPayTag:
        {
            [[BSPayCenter sharePayEngine] uppay:@"201507310904430005282" mode:@"01" viewController:self];
        }break;
            
        default:
            break;
    }
}

#pragma mark - weixinpay
//微信通知处理
-(void)payBack:(NSNotification*)noti{
    BOOL suc =[noti.object[@"result"] boolValue];
   
    if (!suc) {//失败
        kTipAlert(@"很遗憾，由于您的小气，导致您支付失败");
    }
    else{
        //成功
        kTipAlert(@"恭喜您，支付成功，您又浪费了一分钱");
    }
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
