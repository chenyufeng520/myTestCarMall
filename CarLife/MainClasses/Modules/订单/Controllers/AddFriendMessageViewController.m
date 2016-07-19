//
//  AddFriendMessageViewController.m
//  CarLife
//
//  Created by 聂康  on 16/7/19.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import "AddFriendMessageViewController.h"

@interface AddFriendMessageViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toTopHeight;

@end

@implementation AddFriendMessageViewController
- (ISTTopBar *)creatTopBarView:(CGRect)frame
{
    // 导航头
    ISTTopBar *tbTop = [[ISTTopBar alloc] initWithFrame:frame];
    [tbTop.btnTitle setTitle:@"验证信息" forState:UIControlStateNormal];
    [tbTop.btnLeft addTarget:self action:@selector(onClickTopBar:) forControlEvents:UIControlEventTouchUpInside];
    [tbTop setLetfTitle:nil];
    
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
    _toTopHeight.constant = self.iosChangeFloat + kNavHeight;
    [self loadSubviews];
}


@end
