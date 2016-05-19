//
//  ISTMineViewController.m
//  BSports
//
//  Created by 陈宇峰 on 16/5/12.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import "ISTMineViewController.h"
#import "AppDelegate.h"
#import "PersonInfoListCell.h"
#import "PersonHeadCell.h"
#import "UIAlertHelper.h"

@interface ISTMineViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
}
@property (nonatomic,strong) NSArray * listArray;

@end

@implementation ISTMineViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
    }
    return self;
}

- (ISTTopBar *)creatTopBarView:(CGRect)frame
{
    // 导航头
    ISTTopBar *tbTop = [[ISTTopBar alloc] initWithFrame:frame];
    [tbTop.btnTitle setTitle:@"个人中心" forState:UIControlStateNormal];
    
    return tbTop;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self prepareData];
    [self loadSubviews];
}

- (void)prepareData{
    
    self.listArray = @[
                       @{@"icon":@"我的订单",@"title":@"编辑资料"},
                       @{@"icon":@"我的订单",@"title":@"我的订单"},@{@"icon":@"我的订单",@"title":@"记事本"},@{@"icon":@"我的订单",@"title":@"设置"},@{@"icon":@"我的订单",@"title":@"意见反馈"},@{@"icon":@"我的订单",@"title":@"附近修理厂"},@{@"icon":@"我的订单",@"title":@"附近车主"}
                       ];
}


- (void)loadSubviews
{
    _tbTop = [self creatTopBarView:kTopFrame];
    [self.view addSubview:_tbTop];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, _contentView.height) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    [_contentView addSubview:_tableView];
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 50)];
    
    UIButton *LogoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    LogoutButton.frame = CGRectMake(kAdjustLength(40), 5, kScreen_Width - kAdjustLength(80), 40);
    [LogoutButton setTitle:@"退出账号" forState:UIControlStateNormal];
    [LogoutButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    LogoutButton.backgroundColor = kBlueColor;
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
        return self.listArray.count;
    }
    else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
//        return kScreen_Width*154/1080;
        return 50;
    }
    else{
        return 120;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        static NSString *largeCelliden = @"largeCelliden";
        PersonHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:largeCelliden];
        if (cell == nil) {
            cell = [[PersonHeadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:largeCelliden];
        }
        cell.iconImageView.image = [UIImage imageNamed:@"Default-user"];
        cell.titleLabel.text = @"隔壁老王";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    }
    else{
        static NSString *celliden = @"celliden";
        PersonInfoListCell *cell = [tableView dequeueReusableCellWithIdentifier:celliden];
        if (cell == nil) {
            cell = [[PersonInfoListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:celliden];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell reloadCellWithInfo:self.listArray[indexPath.row]];
        return cell;
        
//        static NSString *cellIdentifier = @"Cell";
//        
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//        
//        if (cell == nil) {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        }
//        
//        NSDictionary *column = self.listArray[indexPath.row];
//        
//        cell.textLabel.text = column[@"title"];
//        cell.textLabel.font = kFontNormal;
//        cell.textLabel.textColor = kDarkTextColor;
//        cell.imageView.image = [UIImage imageNamed:column[@"icon"]];
//        
//        UIView *line = [[UIView alloc] initLineWithFrame:CGRectMake(10, kScreen_Width*154/1080-1, _tableView.width-20, 1) color:kMainBGColor];
//        [cell.contentView addSubview:line];
//        
//        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            //编辑资料
        }
        else if (indexPath.row == 1){
            //我的订单
        }
        else if (indexPath.row == 2){
            //记事本
        }
        else if (indexPath.row == 3){
            //设置
        }
        else if (indexPath.row == 4){
            //意见反馈
        }
        else if (indexPath.row == 5){
            //附近修理厂
        }
        else{
            //附近车主
        }
        
        //敬请期待
        KTipFun;
        return ;
    }
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
