//
//  CMOrderViewController.m
//  CarLife
//
//  Created by 陈宇峰 on 16/5/12.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import "CMOrderViewController.h"
#import "CustomSegmentView.h"
#import "SearchShopTextField.h"
#import "ShopListTableViewController.h"
#import "OrderTableViewController.h"

@interface CMOrderViewController ()<CustomSegmentDelegate,UIScrollViewDelegate>{
    SearchShopTextField *_textField;
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
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, self.iosChangeFloat+kNavHeight, kScreen_Width, kAdjustLength(300))];
    topView.backgroundColor = _contentView.backgroundColor;
    [self.view addSubview:topView];
    
    //选择菜单
    NSArray *titleArr = @[@"汽配店",@"下订单"];
    CustomSegmentView *segmentView = [[CustomSegmentView alloc] initWithFrame:CGRectMake(kAdjustLength(240), 10, (kScreen_Width-2*kAdjustLength(240)), kAdjustLength(100))];
    [segmentView setTitles:titleArr];
    segmentView.backgroundColor = kNavBarColor;
    segmentView.delegate = self;
    [topView addSubview:segmentView];
    
    _textField = [[SearchShopTextField alloc] initWithFrame:CGRectMake(kAdjustLength(140), segmentView.maxY + 10, (kScreen_Width-2*kAdjustLength(140)), kAdjustLength(120))];
    [topView addSubview:_textField];
    
    topView.height = _textField.maxY + 10;
    
    _contentView.minY = topView.maxY;
    _contentView.height = kScreen_Height - self.iosChangeFloat - kNavHeight - topView.height - kTabBarHeight;
    _contentView.contentSize = CGSizeMake(kScreen_Width * titleArr.count , _contentView.height);
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

#pragma mark CustomSegmentView Delegate
- (void)segmentedViewSelectTitleInteger:(NSInteger)integer{
    
}

#pragma mark UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

}
@end
