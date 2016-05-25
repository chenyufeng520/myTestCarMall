//
//  CMOrderViewController.m
//  CarLife
//
//  Created by 陈宇峰 on 16/5/12.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import "CMOrderViewController.h"

@interface CMOrderViewController (){
    UIButton *_shopBtn;
    UIButton *_orderBtn;
}

@end

@implementation CMOrderViewController

- (ISTTopBar *)creatTopBarView:(CGRect)frame
{
    // 导航头
    ISTTopBar *tbTop = [[ISTTopBar alloc] initWithFrame:frame];
    [tbTop.btnTitle setTitle:@"下订单" forState:UIControlStateNormal];
    
    return tbTop;
}

- (void)loadSubviews
{
    _tbTop = [self creatTopBarView:kTopFrame];
    [self.view addSubview:_tbTop];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubviews];
    _contentView.height += kAdjustLength(240);
    [self makeTopButtton];
}

- (void)makeTopButtton{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kAdjustLength(300))];
    topView.backgroundColor = _contentView.backgroundColor;
    [_contentView addSubview:topView];
    
    UIView *btnView = [[UIView alloc] initWithFrame:CGRectMake((kScreen_Width-kAdjustLength(560))*0.5, 10, kAdjustLength(560), kAdjustLength(100))];
    btnView.backgroundColor = kNavBarColor;
    btnView.layer.cornerRadius = btnView.height * 0.5;
    [topView addSubview:btnView];
    
    _shopBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _shopBtn.frame = CGRectMake(0, 0, btnView.width*0.5, btnView.height);
    _shopBtn.backgroundColor = kNavBarColor;
    _shopBtn.layer.cornerRadius = _shopBtn.height * 0.5;
//    _shopBtn.layer.borderColor = kNavBarColor.CGColor;
//    _shopBtn.layer.borderWidth = 5;
    [_shopBtn setTitle:@"汽配店" forState:UIControlStateNormal];
    [_shopBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_shopBtn addTarget:self action:@selector(shopButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:_shopBtn];
    
    _orderBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _orderBtn.frame = CGRectMake(btnView.width*0.5, 0, btnView.width*0.5, btnView.height);
    _orderBtn.backgroundColor = kNavBarColor;
    _orderBtn.layer.cornerRadius = _orderBtn.height * 0.5;
//    _orderBtn.layer.borderColor = kNavBarColor.CGColor;
//    _orderBtn.layer.borderWidth = 2;
    [_orderBtn setTitle:@"下订单" forState:UIControlStateNormal];
    [_orderBtn setTitleColor:kNavBarColor forState:UIControlStateNormal];
    [_orderBtn addTarget:self action:@selector(orderButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:_orderBtn];
}

#pragma mark Button 点击事件
- (void)shopButtonClick:(UIButton *)btn{
    btn.backgroundColor = [UIColor whiteColor];
    [btn setTitleColor:kNavBarColor forState:UIControlStateNormal];
    _orderBtn.backgroundColor = kNavBarColor;
    [_orderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)orderButtonClick:(UIButton *)btn{
    btn.layer.borderColor = kNavBarColor.CGColor;
    btn.backgroundColor = [UIColor whiteColor];
    [btn setTitleColor:kNavBarColor forState:UIControlStateNormal];
    _shopBtn.backgroundColor = kNavBarColor;
    [_shopBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

@end
