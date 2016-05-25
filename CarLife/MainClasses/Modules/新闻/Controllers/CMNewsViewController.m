//
//  CMNewsViewController.m
//  CarLife
//
//  Created by 陈宇峰 on 16/5/12.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import "CMNewsViewController.h"
#import "NewsListCell.h"
#import "MJRefresh.h"
#import "NewsDataHelper.h"
#import "DragView.h"
#import "ShoppingCarViewController.h"
#import "AppDelegate.h"

@interface CMNewsViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
}
@property(nonatomic,strong)NSMutableArray *dataArr;
@end

@implementation CMNewsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _dataArr = [NSMutableArray array];
    }
    return self;
}

- (ISTTopBar *)creatTopBarView:(CGRect)frame
{
    // 导航头
    ISTTopBar *tbTop = [[ISTTopBar alloc] initWithFrame:frame];
    [tbTop.btnTitle setTitle:@"新闻" forState:UIControlStateNormal];
    
    return tbTop;
}

- (void)loadSubviews{
    
    _tbTop = [self creatTopBarView:kTopFrame];
    [self.view addSubview:_tbTop];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, _contentView.width, _contentView.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    [_contentView addSubview:_tableView];
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self resetData];
    }];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self performData];
    }];
    
    //悬浮按钮
    DragView *dragView = [[DragView alloc] initWithFrame:CGRectMake(_contentView.width - kAdjustLength(200), _contentView.height - kAdjustLength(300), kAdjustLength(200), kAdjustLength(200))];
    [dragView setBlock:^(){
        BSLog(@"点击了悬浮按钮");
        ShoppingCarViewController *shoppingCar = [[ShoppingCarViewController alloc] init];
        [[AppDelegate shareDelegate].rootNavigation pushViewController:shoppingCar animated:YES];
    }];
    
    UIImageView *shopCarImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kAdjustLength(200), kAdjustLength(200))];
    shopCarImg.image = [UIImage imageNamed:@"shoppingCari"];
    [dragView addSubview:shopCarImg];
    
    [_contentView addSubview:dragView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubviews];
    [self performData];
//    [self loadData];
}

#pragma mark - 网络请求

- (void)performData{
    for (int i = 0; i < 5; i++) {
        [_dataArr addObject:@"测试"];
    }
    [_tableView.mj_footer endRefreshing];
    
    [_tableView reloadData];
}

- (void)resetData{
    [_dataArr removeAllObjects];
    
    for (int i = 0; i < 5; i++) {
        [_dataArr addObject:@"测试"];
    }
   
    [_tableView.mj_header endRefreshing];
    
    [_tableView reloadData];
}

- (void)loadData{
    
    [[NewsDataHelper defaultHelper] commonRequestForURLStr:nil requestMethod:@"GET" info:@{@"channelId":@"5572a109b3cdc86cf39001e5",@"page":@"1"} andBlock:^(id response, NSError *error) {
        
    }];
}

#pragma mark - tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kAdjustLength(400);
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  static NSString *celliden = @"celliden";
    NewsListCell *cell = [tableView dequeueReusableCellWithIdentifier:celliden];
    if (cell == nil) {
        cell = [[NewsListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:celliden];
    }
    cell.titleLable.text = @"全新测试宝马";
    cell.detailLable.text = @"这是全新的一轮打浆机，是不是宿舍啦吧啦啦啦；世界观啊；时时刻刻难受了道路";
    cell.timeLable.text = @"2016-5-23";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES]; 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
