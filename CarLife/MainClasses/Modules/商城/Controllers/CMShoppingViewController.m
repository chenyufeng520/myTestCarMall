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
#import "DragView.h"
#import "ShoppingCarViewController.h"
#import "AppDelegate.h"

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
    [self configDragView];
}

- (void)addFirstVCView{
    if (!_productVC) {
        _productVC = [[UseProductTableViewController alloc] initWithStyle:UITableViewStylePlain];
        _productVC.view.frame = _contentView.bounds;
        [self addChildViewController:_productVC];
        [_contentView addSubview:_productVC.view];
    }
}

//添加悬浮购物车
- (void)configDragView{
    //悬浮按钮
    DragView *dragView = [[DragView alloc] initWithFrame:CGRectMake(_contentView.width - kAdjustLength(200), _contentView.height - kAdjustLength(300), 50, 50)];
    [dragView setBlock:^(){
        BSLog(@"点击了悬浮按钮");
        ShoppingCarViewController *shoppingCar = [[ShoppingCarViewController alloc] init];
        [[AppDelegate shareDelegate].rootNavigation pushViewController:shoppingCar animated:YES];
    }];
    
    UIImageView *shopCarImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    shopCarImg.image = [UIImage imageNamed:@"shoppingCari"];
    [dragView addSubview:shopCarImg];
    
    [self.view addSubview:dragView];
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
    [_contentView scrollRectToVisible:CGRectMake(btn.tag * kScreen_Width, _contentView.minY, _contentView.width, _contentView.height) animated:YES];
}


/**
 * 加载对应栏目的数据
 */
- (void)loadColumeDataWithLabelTag:(NSInteger)labelTag{
 
}

#pragma mark UIScrowViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x<0) {
        _contentView.contentOffset = CGPointMake(0, 0);
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int page = (scrollView.contentOffset.x/kScreen_Width);
    scrollView.contentOffset = CGPointMake(page * kScreen_Width, 0);
    for (UIButton *tempBtn in _columeView.subviews) {
        if ([tempBtn isKindOfClass:[UIButton class]]) {
            [tempBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            if (tempBtn.tag == page) {
                [tempBtn setTitleColor:kNavBarColor forState:UIControlStateNormal];
                [UIView animateWithDuration:0.5 animations:^{
                    [_underline setMinX:tempBtn.minX];
                }];
            }

        }
    }
}

@end
