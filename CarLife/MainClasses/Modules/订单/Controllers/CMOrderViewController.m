//
//  CMOrderViewController.m
//  CarLife
//
//  Created by 陈宇峰 on 16/5/12.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import "CMOrderViewController.h"
#import "CustomSegmentView.h"

@interface CMOrderViewController ()<CustomSegmentDelegate,UIScrollViewDelegate>{
    UITextField *_textField;
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
}

- (void)makeTopButtton{
    //上部分View
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, self.iosChangeFloat+kNavHeight, kScreen_Width, kAdjustLength(300))];
    topView.backgroundColor = _contentView.backgroundColor;
    [self.view addSubview:topView];
    
    //选择菜单
    NSArray *titleArr = @[@"汽配店",@"下订单"];
    CustomSegmentView *segmentView = [[CustomSegmentView alloc] initWithFrame:CGRectMake((kScreen_Width-kAdjustLength(560))*0.5, 10, kAdjustLength(560), kAdjustLength(100))];
    [segmentView setTitles:titleArr];
    segmentView.backgroundColor = kNavBarColor;
    segmentView.delegate = self;
    [topView addSubview:segmentView];
    
    
    
    _contentView.minY = topView.maxY;
    _contentView.height = kScreen_Height - self.iosChangeFloat - kNavHeight - topView.height - kTabBarHeight;
    _contentView.contentSize = CGSizeMake(kScreen_Width * titleArr.count , _contentView.height);
    _contentView.pagingEnabled = YES;
    _contentView.delegate = self;
}

#pragma mark CustomSegmentViewDelegate
- (void)segmentedViewSelectTitleInteger:(NSInteger)integer{
    
}

@end
