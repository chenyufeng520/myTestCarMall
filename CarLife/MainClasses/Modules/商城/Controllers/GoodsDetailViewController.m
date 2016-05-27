//
//  GoodsDetailViewController.m
//  CarLife
//
//  Created by 聂康  on 16/5/26.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import "GoodsDetailViewController.h"

@interface GoodsDetailViewController ()
@end

@implementation GoodsDetailViewController

- (ISTTopBar *)creatTopBarView:(CGRect)frame
{
    // 导航头
    ISTTopBar *tbTop = [[ISTTopBar alloc] initWithFrame:frame];
    [tbTop.btnTitle setTitle:self.productModel.goods_name forState:UIControlStateNormal];
    [tbTop.btnLeft addTarget:self action:@selector(onClickTopBar:) forControlEvents:UIControlEventTouchUpInside];
    [tbTop setLetfTitle:nil];
    
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
    [self initWithData];
}

- (void)initWithData{
    
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



@end
