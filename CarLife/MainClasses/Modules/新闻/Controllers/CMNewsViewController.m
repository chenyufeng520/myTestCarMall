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
#import "ShoppingCarViewController.h"
#import "ImgCell.h"
#import "NoneImgCell.h"
#import "ThreeImgCell.h"
#import "NewsListModel.h"
#import "DetailNewsViewController.h"
#import "AppDelegate.h"
#import "ISTWebViewController.h"

@interface CMNewsViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    int _pageCount;
}
@property(nonatomic,strong)NSMutableArray *dataArr;
@end

@implementation CMNewsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _dataArr = [NSMutableArray array];
        _pageCount = 1;
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
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_contentView addSubview:_tableView];
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self resetData];
    }];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
       
        [self performData];
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
     [self loadData];
    [self loadSubviews];
}

#pragma mark - 网络请求

- (void)performData{
    _pageCount++;
    [self loadData];
}

- (void)resetData{
    _pageCount = 1;
   [self loadData];
}

#pragma mark  请求数据
- (void)loadData
{
    [[ISTHUDManager defaultManager] showHUDInView:_contentView withText:@"加载中"];
    [[NewsDataHelper defaultHelper] newsListRequestForPage:_pageCount requestMethod:@"GET" info:nil andBlock:^(id response, NSError *error) {

        [[ISTHUDManager defaultManager] hideHUDInView:_contentView];
        if (_pageCount == 1)
        {
            [self.dataArr removeAllObjects];
        }
        NSArray *resultArr = response[@"showapi_res_body"][@"pagebean"][@"contentlist"];
        for (NSDictionary *dic in resultArr)
        {
            NSArray *arr = dic[@"imageurls"];
            if (arr.count !=3&&arr.count!=0){
                NewsListModel *news = [[NewsListModel alloc]initWithJasonDic:dic];
                [self.dataArr addObject:news];
            }
        }
        
        [_tableView reloadData];
        [_tableView.mj_footer endRefreshing];
        [_tableView.mj_header endRefreshing];
    }];
}

#pragma mark - tableview
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    return kAdjustLength(320);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return .001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return .001;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
//    NewsListModel *news = self.dataArr[indexPath.row];
//    NSArray *arr = news.imageurls;
//    if (arr.count == 3)
//    {
//        ThreeImgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ThreeImgCell" forIndexPath:indexPath];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.titleLab.text = news.title;
//        cell.timeLab.text = news.pubDate;
//        for (int i = 0; i < arr.count; i++)
//        {
//            NSString * imageKey = [NSString stringWithFormat:@"newsImgV%d",i+1];
//            
//            UIImageView * showImage = [cell valueForKey:imageKey];
//            
//            [showImage sd_setImageWithURL:[NSURL URLWithString:arr[i]] placeholderImage:[UIImage imageNamed:@"loadind.jpg"]];
//        }
//    }
//    else if (arr.count !=3&&arr.count!=0)
//    {
//        ImgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ImgCell" forIndexPath:indexPath];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.titleLab.text = news.title;
//        cell.descriptionLab.text = news.desc;
//        cell.timeLab.text = news.pubDate;
//        [cell.imgV sd_setImageWithURL:arr[0] placeholderImage:[UIImage imageNamed:@"loadind.jpg"]];
//        return cell;
//    }
//    
//    NoneImgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoneImgCell" forIndexPath:indexPath];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.titleLab.text = news.title;
//    cell.descriptionLab.text = news.desc;
//    cell.timeLab.text = news.pubDate;
//    return cell;
    
    
    static NSString *celliden = @"celliden";
    ImgCell *cell = [tableView dequeueReusableCellWithIdentifier:celliden];
    if (cell == nil) {
        cell = [[ImgCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:celliden];
    }
    
    NewsListModel *news = self.dataArr[indexPath.row];
    NSArray *arr = news.imageurls;
    cell.titleLab.text = news.title;
    cell.descriptionLab.text = news.desc;
    cell.timeLab.text = news.pubDate;
    [cell.imgV sd_setImageWithURL:arr[0] placeholderImage:[UIImage imageNamed:@"defaultimg"]];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NewsListModel *model = self.dataArr[indexPath.row];
    ISTWebViewController *webVC = [[ISTWebViewController alloc] initWithNavTitle:@"详情" andUrl:model.link];
    [[AppDelegate shareDelegate].rootNavigation pushViewController:webVC animated:YES];
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
