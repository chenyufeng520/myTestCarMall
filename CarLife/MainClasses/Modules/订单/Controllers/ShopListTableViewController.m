//
//  ShopListTableViewController.m
//  CarLife
//
//  Created by 聂康  on 16/5/25.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import "ShopListTableViewController.h"
#import "OrderDatahelper.h"
#import "OrderCell.h"

@interface ShopListTableViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *_tableView;
    NSMutableArray *_shopListArr;
}

@end

@implementation ShopListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self makeUI];
    [self loadShopListData];
}

- (void)initData{
    _shopListArr = [NSMutableArray array];
    for (int i=0; i<20; i++) {
        OrderModel *model = [[OrderModel alloc] init];
        [_shopListArr addObject:model];
    }
}

- (void)makeUI{
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line];
    
    NSArray *titleArr = @[@"店铺名称",@"专营类别",@"联系方式"];
    CGFloat w = kScreen_Width/(float)titleArr.count;
    for (int i=0; i<titleArr.count; i++) {
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(i*w, 0, w, kAdjustLength(160))];
        lab.font = kFont_16;
        lab.text = titleArr[i];
        lab.backgroundColor = [UIColor whiteColor];
        lab.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:lab];
    }
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kAdjustLength(160), kScreen_Width, kScreen_Height-self.iosChangeFloat-kNavHeight-30-kAdjustLength(100)-kAdjustLength(120)-kAdjustLength(160)-kTabBarHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = kMainBGColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

- (void)loadShopListData{
    [_tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _shopListArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderModel *model = _shopListArr[indexPath.row];
    if (model.status == FoldStatus) {
        return kAdjustLength(260);
    }
    return kAdjustLength(160);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *iden = @"OrderCell";
    OrderCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[OrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    cell.orderModel = _shopListArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.orderModel.status == FoldStatus) {
        cell.orderModel.status = UnfoldStatus;
    }else if (cell.orderModel.status == UnfoldStatus) {
        cell.orderModel.status = FoldStatus;
    }
    [_tableView reloadData];
}

@end
