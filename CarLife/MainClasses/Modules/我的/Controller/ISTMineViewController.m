//
//  ISTMineViewController.m
//  BSports
//
//  Created by 陈宇峰 on 16/5/12.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import "ISTMineViewController.h"
#import "AppDelegate.h"

@interface ISTMineViewController ()

@end

@implementation ISTMineViewController

- (ISTTopBar *)creatTopBarView:(CGRect)frame
{
    // 导航头
    ISTTopBar *tbTop = [[ISTTopBar alloc] initWithFrame:frame];
    [tbTop.btnTitle setTitle:@"个人中心" forState:UIControlStateNormal];
    
    return tbTop;
}

- (void)loadSubviews
{
    _tbTop = [self creatTopBarView:kTopFrame];
    [self.view addSubview:_tbTop];

    /*
     //注销
     BlockButton *btn = [BlockButton buttonWithType:UIButtonTypeCustom];
     btn.frame = CGRectMake(20, 200, 200, 40);
     [btn setBlock:^(BlockButton *button){
     [[NSNotificationCenter defaultCenter] postNotificationName:kLogoutNotification object:nil];
     }];
     [_contentView addSubview:btn];
     */
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
        
    }
    else if (btn.tag == BSTopBarButtonRight) {
        
    }
}

@end
