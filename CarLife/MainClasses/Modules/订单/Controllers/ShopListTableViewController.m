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
#import "ChatViewController.h"
#import "AppDelegate.h"
#import "OrderDatahelper.h"

@interface ShopListTableViewController ()<UITableViewDelegate,UITableViewDataSource,OrderCellDelegate>{
    UITableView *_tableView;
    NSMutableArray *_shopListArr;
    int _page;
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
    _page = 1;
    _shopListArr = [NSMutableArray array];
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
    __weak typeof(self) weakSelf = self;
    [[STHUDManager sharedManager] showHUDInView:self.view];
    [[OrderDatahelper defaultHelper] requestForURLStr:kFormatUrl requestMethod:@"GET" info:@{@"m":@"Api",@"c":@"Json",@"a":@"index",@"p":[NSString stringWithFormat:@"%d",_page]} andBlock:^(id response, NSError *error) {
        [[STHUDManager sharedManager] hideHUDInView:weakSelf.view];
        if ([response isKindOfClass:[NSDictionary class]]) {
            int status = [response[@"status"] intValue];
            
            if (status == 200) {
                NSArray *dataArr = response[@"data"];
                if (dataArr) {
                    for (NSDictionary *dic in dataArr) {
                        OrderModel *shopModel = [[OrderModel alloc] initWithDic:dic];
                        [_shopListArr addObject:shopModel];
                    }
                    [_tableView reloadData];
                }
            }
            else
            {
                [MBProgressHUD showMessag:response[@"message"] toView:self.view];
            }
        }
        else
        {
            [MBProgressHUD showError:@"网络异常" toView:self.view];

        }

        [_tableView reloadData];
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _shopListArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderModel *model = _shopListArr[indexPath.row];
    if (model.status == FoldStatus) {
        return kAdjustLength(360);
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
    cell.delegate = self;
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

#pragma mark - OrderCellDelagate
- (void)orderCellPhoneClick:(OrderModel *)orderModel{
    UIWebView *webView = [[UIWebView alloc]init];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",orderModel.store_phone]];
    [webView loadRequest:[NSURLRequest requestWithURL:url ]];
}

- (void)orderCellMessageClick:(OrderModel *)orderModel{
    ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:@"18501047155" conversationType:EMConversationTypeChat];
    chatController.title = orderModel.store_name;
    [[AppDelegate shareDelegate].rootNavigation pushViewController:chatController animated:YES];

}

@end
