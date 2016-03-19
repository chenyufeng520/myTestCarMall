//
//  ISTMineViewController.m
//  BSports
//
//  Created by 高大鹏 on 15/8/18.
//  Copyright (c) 2015年 ist. All rights reserved.
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
    [tbTop.btnTitle setTitle:@"我的" forState:UIControlStateNormal];
    
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
