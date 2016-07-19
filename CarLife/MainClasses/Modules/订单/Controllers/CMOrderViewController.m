//
//  CMOrderViewController.m
//  CarLife
//
//  Created by 陈宇峰 on 16/5/12.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import "CMOrderViewController.h"
#import "CustomSegmentView.h"
#import "ShopListTableViewController.h"
#import "OrderTableViewController.h"
#import "EaseConversationListViewController.h"
#import "ConversationListController.h"
#import "AppDelegate.h"
@interface CMOrderViewController ()<CustomSegmentDelegate,UIScrollViewDelegate>{
    ShopListTableViewController *_shopListVC;
    OrderTableViewController *_orderVC;
}

@end

@implementation CMOrderViewController

- (ISTTopBar *)creatTopBarView:(CGRect)frame
{
    // 导航头
    ISTTopBar *tbTop = [[ISTTopBar alloc] initWithFrame:frame];
    [tbTop.btnTitle setTitle:@"下订单" forState:UIControlStateNormal];
    
    [tbTop.btnRight setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [tbTop.btnRight setTitle:@"消息" forState:UIControlStateNormal];
    [tbTop.btnRight addTarget:self action:@selector(messageListVC:) forControlEvents:UIControlEventTouchUpInside];
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
    [self makeTopButtton];
    [self addShopListView];
}

- (void)makeTopButtton{
    //上部分View
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, self.iosChangeFloat+kNavHeight, kScreen_Width, kAdjustLength(100)+20)];
    topView.backgroundColor = _contentView.backgroundColor;
    [self.view addSubview:topView];
    
    //选择菜单
    NSArray *titleArr = @[@"汽配店",@"下订单"];
    CustomSegmentView *segmentView = [[CustomSegmentView alloc] initWithFrame:CGRectMake(kAdjustLength(240), 10, (kScreen_Width-2*kAdjustLength(240)), kAdjustLength(100))];
    [segmentView setTitles:titleArr];
    segmentView.backgroundColor = kNavBarColor;
    segmentView.delegate = self;
    [topView addSubview:segmentView];
    
    _contentView.frame = CGRectMake(0, topView.maxY, kScreen_Width, kScreen_Height-topView.maxY-kTabBarHeight);
    _contentView.contentSize = CGSizeMake(kScreen_Width * titleArr.count , 0);
    _contentView.pagingEnabled = YES;
    _contentView.delegate = self;
}

/**
 * 商铺列表vc
 **/
- (void)addShopListView{
    if (!_shopListVC) {
        _shopListVC = [[ShopListTableViewController alloc] init];
        _shopListVC.view.frame = _contentView.bounds;
        [self addChildViewController:_shopListVC];
        [_contentView addSubview:_shopListVC.view];
    }
}

#pragma mark - 跳转消息列表页面
- (void)messageListVC:(UIButton *)btn{
    ConversationListController *chatListVC = [[ConversationListController alloc] init];
    [[AppDelegate shareDelegate].rootNavigation pushViewController:chatListVC animated:YES];

}

#pragma mark - CustomSegmentView Delegate
- (void)segmentedViewSelectTitleInteger:(NSInteger)integer{
    
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

}
@end
