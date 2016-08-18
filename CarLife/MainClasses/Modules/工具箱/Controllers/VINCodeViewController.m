//
//  VINCodeViewController.m
//  CarLife
//
//  Created by 聂康  on 16/8/15.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import "VINCodeViewController.h"

@interface VINCodeViewController ()<UITextFieldDelegate>{
    UITextField *_searchTextField;
}

@end

@implementation VINCodeViewController

- (ISTTopBar *)creatTopBarView:(CGRect)frame
{
    // 导航头
    ISTTopBar *tbTop = [[ISTTopBar alloc] initWithFrame:frame];
    [tbTop.btnTitle setTitle:@"验证信息" forState:UIControlStateNormal];
    
    [tbTop.btnLeft addTarget:self action:@selector(onClickTopBar:) forControlEvents:UIControlEventTouchUpInside];
    [tbTop setLetfTitle:nil];
    
    [tbTop.btnRight setTitle:@"发送" forState:UIControlStateNormal];
    [tbTop.btnRight addTarget:self action:@selector(onClickTopBar:) forControlEvents:UIControlEventTouchUpInside];
    
    return tbTop;
}

- (void)loadSubviews
{
    _tbTop = [self creatTopBarView:kTopFrame];
    [self.view addSubview:_tbTop];
    [self makeSearchView];
}

- (void)makeSearchView{
    _tbTop.btnLeft.width = 0.5 * _tbTop.btnLeft.width;
    _tbTop.btnLeft.imageEdgeInsets = UIEdgeInsetsMake(13, kButtonEdgeInsetsLeft, 13, 20);

    _tbTop.btnRight.width = 0.5 * _tbTop.btnRight.width;
    _tbTop.btnRight.minX = _tbTop.btnRight.minX+_tbTop.btnRight.width;
    _tbTop.btnRight.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);

    _searchTextField = [[UITextField alloc]initWithFrame:CGRectMake(_tbTop.btnLeft.maxX, (_tbTop.btnTitle.height-35)/2.f, _tbTop.btnTitle.width*1.5, 35)];
    _searchTextField.borderStyle = UITextBorderStyleRoundedRect;
    _searchTextField.backgroundColor=  [UIColor whiteColor];
    _searchTextField.layer.masksToBounds=YES;
    _searchTextField.returnKeyType = UIReturnKeyDone;
    _searchTextField.delegate = self;
    _searchTextField.placeholder = @"17位车架号";
    _searchTextField.borderStyle = UITextBorderStyleRoundedRect;
    _searchTextField.exclusiveTouch = YES;
    [_tbTop.topBarView addSubview:_searchTextField];
    
    [_tbTop.btnTitle removeFromSuperview];
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
}

@end
