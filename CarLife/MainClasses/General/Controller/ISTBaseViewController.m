//
//  ISTBaseViewController.m
//  BSports
//
//  Created by 陈宇峰 on 16/5/10.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import "ISTBaseViewController.h"


@interface ISTBaseViewController ()

@end

@implementation ISTBaseViewController


//重要：不然有偏移
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _contentView.contentInset = UIEdgeInsetsZero;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.iosChangeFloat + kNavHeight, kScreen_Width, kScreen_Height - (kNavHeight+self.iosChangeFloat)-kTabBarHeight)];
    _contentView.backgroundColor = kMainBGColor;
    _contentView.scrollEnabled = YES;
    _contentView.showsVerticalScrollIndicator = NO;
    _contentView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_contentView];
    self.view.backgroundColor = kMainBGColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
