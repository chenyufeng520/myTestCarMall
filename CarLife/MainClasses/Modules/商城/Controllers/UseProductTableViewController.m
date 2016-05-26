//
//  UseProductTableViewController.m
//  CarLife
//
//  Created by 聂康  on 16/5/23.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import "UseProductTableViewController.h"
#import "UseProductCell.h"
#import "ShoppingDataHelper.h"
#import "UseProductModel.h"
#import "ProductDetailViewController.h"
#import "AppDelegate.h"
#import "GoodsDetailViewController.h"

@interface UseProductTableViewController ()

@property (nonatomic, strong)NSMutableArray *dataArr;

@end

@implementation UseProductTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _dataArr = [NSMutableArray array];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self loadUseProductData];
}

- (void)loadUseProductData{
     NSString *urlString = @"index.php?m=api&c=Store&a=index";
    [[ShoppingDataHelper defaultHelper] requestForURLStr:urlString requestMethod:@"GET" info:nil andBlock:^(id response, NSError *error) {
        if (error) {
            [MBProgressHUD showError:@"网络异常" toView:self.view];
        }else{
            if ([response isKindOfClass:[NSDictionary class]]) {
                NSDictionary *responseDic = (NSDictionary *)response;
                if ([response[@"status"] intValue] == 200) {
                    NSArray *resArr = responseDic[@"data"];
                    for (NSDictionary *dic in resArr) {
                        UseProductModel *model = [[UseProductModel alloc] initWithDic:dic];
                        [self.dataArr addObject:model];
                    }
                    [self.tableView reloadData];
                }else{
                    [MBProgressHUD showMessag:responseDic[@"message"] toView:self.view];
                }

            }
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kAdjustLength(280)+10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *iden = @"UseProductCell";
    UseProductCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[UseProductCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    cell.productModel = self.dataArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UseProductCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    GoodsDetailViewController *goodsDetail = [[GoodsDetailViewController alloc] initWithNibName:@"GoodsDetailViewController" bundle:[NSBundle mainBundle]];

    goodsDetail.title = cell.nameLab.text;
    goodsDetail.productModel = cell.productModel;
    [[AppDelegate shareDelegate].rootNavigation pushViewController:goodsDetail animated:YES];
}

@end
