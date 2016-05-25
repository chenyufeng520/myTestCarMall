//
//  CMOrderViewController.m
//  CarLife
//
//  Created by 陈宇峰 on 16/5/12.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import "CMOrderViewController.h"

@interface CMOrderViewController ()

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
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, self.iosChangeFloat+kNavHeight, kScreen_Width, kAdjustLength(300))];
    topView.backgroundColor = _contentView.backgroundColor;
    [_contentView addSubview:topView];
    
    UIView *btnView = [[UIView alloc] initWithFrame:CGRectMake((kScreen_Width-kAdjustLength(560)/2.f), 10, kAdjustLength(560), kAdjustLength(100))];
    btnView.backgroundColor = kNavBarColor;
    btnView.layer.cornerRadius = kAdjustLength(50);
    [topView addSubview:btnView];
    
    NSArray *segTitiArr = @[@"汽配店",@"下订单"];
    UIButton *shopBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    shopBtn.frame = CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
}

@end
