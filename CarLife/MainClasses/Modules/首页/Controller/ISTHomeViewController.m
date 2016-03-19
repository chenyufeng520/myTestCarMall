//
//  ISTHomeViewController.m
//  BSports
//
//  Created by 高大鹏 on 15/8/18.
//  Copyright (c) 2015年 ist. All rights reserved.
//

#import "ISTHomeViewController.h"
#import "BSPayCenter.h"
#import "AppDelegate.h"

#define kWeixinPayTag           1104
#define kZhifubaoPayTag         1105
#define kYinlianPayTag          1106

@interface ISTHomeViewController ()

@end

@implementation ISTHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payResult:) name:kPaySucceedNotification object:nil];
    }
    return self;
}

- (ISTTopBar *)creatTopBarView:(CGRect)frame
{
    // 导航头
    ISTTopBar *tbTop = [[ISTTopBar alloc] initWithFrame:frame];
    [tbTop.btnTitle setTitle:@"首页" forState:UIControlStateNormal];
    
//    [tbTop.btnLeft setImage:[UIImage imageNamed:@"caidan.png"] forState:UIControlStateNormal];
//    tbTop.btnLeft.imageEdgeInsets = UIEdgeInsetsMake(10, 15, 10, 42);//[_tbTop.btnLeft
//    [tbTop.btnLeft addTarget:self action:@selector(onClickTopBar:) forControlEvents:UIControlEventTouchUpInside];
    
    return tbTop;
}

- (void)loadSubviews
{
    _tbTop = [self creatTopBarView:kTopFrame];
    [self.view addSubview:_tbTop];
    
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
    [ylPayBtn setTitle:@"快捷支付" forState:UIControlStateNormal];
    ylPayBtn.titleLabel.font = kFontNormal;
    [ylPayBtn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    ylPayBtn.tag = kYinlianPayTag;
    ylPayBtn.layer.cornerRadius = kCornerRadius;
    [_contentView addSubview:ylPayBtn];
    
}

- (void)buttonPressed:(UIButton *)sender
{
    switch (sender.tag) {
        case kWeixinPayTag:
        {
            [[BSPayCenter sharePayEngine] wxPay:nil];
            
        }break;
        case kZhifubaoPayTag:
        {
            [[BSPayCenter sharePayEngine] zfbPay:[NSDictionary dictionaryWithObjectsAndKeys:@"2",@"amount", nil]];
        }break;
        case kYinlianPayTag:
        {
            [[BSPayCenter sharePayEngine] uppay:@"201507310904430005282" mode:@"01" viewController:self];
        }break;
            
        default:
            break;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kMainBGColor;
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
        [[NSNotificationCenter defaultCenter] postNotificationName:kShowMenusNotification object:nil];
    }
    else if (btn.tag == BSTopBarButtonRight) {
        
    }
}

- (void)btnPressed:(UIButton *)btn
{
    BSLog(@"btn点击事件");
    [self showHudWithTitle:@"点击提示框"];
}

#pragma mark - 通知

- (void)payResult:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
}

@end
