//
//  MyOrderViewController.m
//  CarLife
//
//  Created by 聂康  on 16/8/19.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import "MyOrderViewController.h"
#import "MineDataHelper.h"

@interface MyOrderViewController ()

@end

@implementation MyOrderViewController

- (ISTTopBar *)creatTopBarView:(CGRect)frame
{
    // 导航头
    ISTTopBar *tbTop = [[ISTTopBar alloc] initWithFrame:frame];
    [tbTop.btnTitle setTitle:@"我的订单" forState:UIControlStateNormal];
    
    [tbTop setLetfTitle:nil];
    [tbTop.btnLeft addTarget:self action:@selector(onClickTopBar:) forControlEvents:UIControlEventTouchUpInside];
    
    
    return tbTop;
}

- (void)loadSubviews
{
    _tbTop = [self creatTopBarView:kTopFrame];
    [self.view addSubview:_tbTop];
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


- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubviews];
    [self loadOrderData];
}

- (void)loadOrderData{
    [[ISTHUDManager defaultManager] showHUDInView:self.view withText:nil];
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:kUID];
    [[MineDataHelper defaultHelper] requestForURLStr:[NSString stringWithFormat:@"%@?m=Api&c=Zone&a=dingdan&uid=%@",kFormatUrl,uid] requestMethod:@"GET" info:nil andBlock:^(id response, NSError *error) {
        [[ISTHUDManager defaultManager] hideHUDInView:self.view];
        if (!error) {
            if ([response[@"status"] integerValue] == 200) {
                NSArray *dataArr = response[@"data"];
                if (![dataArr isEqual:[NSNull null]] && dataArr.count > 0) {
                    
                }else{
                    [self showHint:@"无订单数据"];
                }
            }else{
                [self showHint:response[@"message"]];
            }
        }
    }];
}

@end
