//
//  ISTMineViewController.m
//  BSports
//
//  Created by 陈宇峰 on 16/5/12.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import "ISTMineViewController.h"
#import "AppDelegate.h"

@interface ISTMineViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
}
@end

@implementation ISTMineViewController

- (ISTTopBar *)creatTopBarView:(CGRect)frame
{
    // 导航头
    ISTTopBar *tbTop = [[ISTTopBar alloc] initWithFrame:frame];
    [tbTop.btnTitle setTitle:@"个人中心" forState:UIControlStateNormal];
    
    return tbTop;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadSubviews];
}

- (void)loadSubviews
{
    _tbTop = [self creatTopBarView:kTopFrame];
    [self.view addSubview:_tbTop];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, _contentView.height) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    [_contentView addSubview:_tableView];
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 50)];
    
    UIButton *LogoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    LogoutButton.frame = CGRectMake(kAdjustLength(40), 5, kScreen_Width - kAdjustLength(80), 40);
    [LogoutButton setTitle:@"退出登录" forState:UIControlStateNormal];
    [LogoutButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    LogoutButton.backgroundColor = kRedColor;
    LogoutButton.layer.cornerRadius = kCornerRadius;
    LogoutButton.layer.masksToBounds = YES;
    LogoutButton.titleLabel.font = kFontNormal;
    [LogoutButton addTarget:self action:@selector(logoutButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:LogoutButton];
    
    _tableView.tableFooterView = footView;
}

#pragma mark - tableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return 6;
    }
    else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        return 50;
    }
    else{
        return 100;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   static NSString *celliden = @"celliden";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:celliden];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:celliden];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
}

#pragma mark - Click Menu

- (void)onClickTopBar:(UIButton *)btn
{
    if (btn.tag == BSTopBarButtonLeft) {
        
    }
    else if (btn.tag == BSTopBarButtonRight) {
        
    }
}

//注销
- (void)logoutButtonClick:(UIButton*)button{
    [[NSNotificationCenter defaultCenter] postNotificationName:kLogoutNotification object:nil];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kUSERINFO];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[AppDelegate shareDelegate] showLoginView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
