//
//  CMShoppingViewController.m
//  CarLife
//
//  Created by 陈宇峰 on 16/5/12.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import "CMShoppingViewController.h"
#import "ShoppingDataHelper.h"
#import "UseProductTableViewController.h"
#import "TyreTableViewController.h"
#import "OilTableViewController.h"
#import "PartsTableViewController.h"

@interface CMShoppingViewController ()<UIScrollViewDelegate>{
    UseProductTableViewController *_productVC;
    TyreTableViewController *_tyreVC;
    OilTableViewController *_oilVC;
    PartsTableViewController *_partsVC;
}

/** 保存所有栏目的数据*/
@property (nonatomic, strong)NSMutableDictionary *columeModelDic;

/** 当前栏目的数据*/
@property (nonatomic, strong)NSMutableArray *nowColumeArrar;

/** 栏目*/
@property (nonatomic, strong)UIView *columeView;
/** 下划线*/
@property (nonatomic, strong)UIView *underline;


@end

@implementation CMShoppingViewController

- (ISTTopBar *)creatTopBarView:(CGRect)frame
{
    // 导航头
    ISTTopBar *tbTop = [[ISTTopBar alloc] initWithFrame:frame];
    [tbTop.btnTitle setTitle:@"点车商城" forState:UIControlStateNormal];
    
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
    [self.view addSubview:self.columeView];

    [self addFirstVCView];
}

- (void)addFirstVCView{
    if (!_productVC) {
        _productVC = [[UseProductTableViewController alloc] initWithStyle:UITableViewStylePlain];
        _productVC.view.frame = _contentView.bounds;
        [self addChildViewController:_productVC];
        [_contentView addSubview:_productVC.view];
    }
}

#pragma mark 懒加载

- (NSMutableDictionary *)columeModelDic{
    if (!_columeModelDic) {
        _columeModelDic = [NSMutableDictionary dictionary];
    }
    return _columeModelDic;
}

- (NSMutableArray *)nowColumeArrar{
    if (!_nowColumeArrar) {
        _nowColumeArrar = [NSMutableArray array];
    }
    return _nowColumeArrar;
}

- (UIView *)columeView{
    if (!_columeView) {
        _columeView = [[UIView alloc] initWithFrame:CGRectMake(0, self.iosChangeFloat+kNavHeight, kScreen_Width, kAdjustLength(140))];
        _columeView.backgroundColor = RGBCOLOR(236, 237, 239);
        [self setupColumeLabel];
    }
    return _columeView;
}

/** 
 * 设置_columeScrollView栏目
 */
- (void)setupColumeLabel
{
    NSArray *titileArr = @[@"用品",@"轮胎",@"机油",@"零件"];
    CGFloat h = _columeView.bounds.size.height;
    CGFloat w = kScreen_Width/(float)(titileArr.count);
    
    _contentView.frame = CGRectMake(0, self.iosChangeFloat + kNavHeight + _columeView.height, kScreen_Width, kScreen_Height - (kNavHeight+self.iosChangeFloat + _columeView.height)-kTabBarHeight);
    _contentView.delegate = self;
    _contentView.pagingEnabled = YES;
    _contentView.backgroundColor = [UIColor whiteColor];
    _contentView.contentSize = CGSizeMake(kScreen_Width*4, _contentView.height);
    
    _underline = [[UIView alloc] initWithFrame:CGRectMake(0, h-1, w, 1)];
    _underline.backgroundColor = kNavBarColor;
    [_columeView addSubview:_underline];
    
    for (NSInteger i=0; i<titileArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btn setFrame:CGRectMake(i*w, 0, w, _columeView.height)];
        [btn setTitle:titileArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        if (i==0) {
            [btn setTitleColor:kNavBarColor forState:UIControlStateNormal];
        }
        btn.tag = i;
        btn.titleLabel.font = [UIFont systemFontOfSize:18];
        [btn addTarget:self action:@selector(colemeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_columeView addSubview:btn];
    }
}

/** 
 * 栏目btn点击事件
 */
- (void)colemeButtonClick:(UIButton *)btn
{
    for (UIButton *tempBtn in _columeView.subviews) {
        if ([tempBtn isKindOfClass:[UIButton class]]) {
            [tempBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
    }
    [btn setTitleColor:kNavBarColor forState:UIControlStateNormal];
    // 下划线滚动并着色
    [UIView animateWithDuration:0.5 animations:^{
        [_underline setMinX:btn.minX];
    }];
    CGPoint point = CGPointMake(btn.tag * kScreen_Width, 0);
    _contentView.contentOffset = point;
}


/**
 * 加载对应栏目的数据
 */
- (void)loadColumeDataWithLabelTag:(NSInteger)labelTag{
 
}

#pragma mark UIScrowViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    if (scrollView.contentOffset.x < 0) {
//        scrollView.contentOffset = CGPointMake(0, 0);
//    }
}

@end
