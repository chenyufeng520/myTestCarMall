//
//  CMShoppingViewController.m
//  CarLife
//
//  Created by 陈宇峰 on 16/5/12.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import "CMShoppingViewController.h"
#import "ShoppingDataHelper.h"

@interface CMShoppingViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

/** 保存所有栏目的数据*/
@property (nonatomic, strong)NSMutableDictionary *columeModelDic;

/** 当前栏目的数据*/
@property (nonatomic, strong)NSMutableArray *nowColumeArrar;

/** 栏目*/
@property (nonatomic, strong)UIScrollView *columeScrollView;
/** 下划线*/
@property (nonatomic, strong)UIView *underline;

/** 滚动视图*/
@property (nonatomic, strong)UICollectionView *collectionView;


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
    [_contentView addSubview:self.columeScrollView];
    [_contentView addSubview:self.collectionView];
    [self loadColumeDataWithLabelTag:1];
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

- (UIScrollView *)columeScrollView{
    if (!_columeScrollView) {
        _columeScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kAdjustLength(140))];
        _columeScrollView.backgroundColor = RGBCOLOR(236, 237, 239);
        _columeScrollView.showsHorizontalScrollIndicator = NO;
        [self setupColumeLabel];
    }
    return _columeScrollView;
}

- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        CGFloat h = kScreen_Height - kNavHeight -self.iosChangeFloat - self.columeScrollView.height ;
        CGRect frame = CGRectMake(0, self.columeScrollView.maxY, kScreen_Width, h);
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
//        _collectionView.delegate = self;
//        _collectionView.dataSource = self;
//        [_collectionView registerClass:[ShopCommonCollectionViewCell class] forCellWithReuseIdentifier:reuseID];
        
        flowLayout.itemSize = _collectionView.bounds.size;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}


/** 
 * 设置_columeScrollView栏目
 */
- (void)setupColumeLabel
{
    NSArray *titileArr = @[@"用品",@"轮胎",@"机油",@"零件"];
    CGFloat h = _columeScrollView.bounds.size.height;
    CGFloat w = kScreen_Width/(float)(titileArr.count);
    CGFloat x = 0;
    int i = 0;
    
    _underline = [[UIView alloc] initWithFrame:CGRectMake(0, h-1, w, 1)];
    _underline.backgroundColor = kNavBarColor;
    [_columeScrollView addSubview:_underline];
    for (NSString *titleStr in titileArr) {
        UILabel *label = [[UILabel alloc] init];
        label.text = titleStr;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:18];
        [label sizeToFit];
        label.userInteractionEnabled = YES;
        label.frame = CGRectMake(x, 0, w, h);
        if (i==0) {
            label.textColor = kNavBarColor;
        }
        x+=label.width;
        [_columeScrollView addSubview:label];
        label.tag = i++;
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick:)]];
    }
}

/** 
 * 栏目Label点击事件
 */
- (void)labelClick:(UITapGestureRecognizer *)recognizer
{
    for (UILabel *lab in _columeScrollView.subviews) {
        if ([lab isKindOfClass:[UILabel class]]) {
            lab.textColor = [UIColor blackColor];
        }
    }
    UILabel *label = (UILabel *)recognizer.view;
    label.textColor = kNavBarColor;
    // 下划线滚动并着色
    [UIView animateWithDuration:0.5 animations:^{
        [_underline setMinX:label.minX];
    }];
    [self loadColumeDataWithLabelTag:label.tag];
}


/**
 * 加载对应栏目的数据
 */
- (void)loadColumeDataWithLabelTag:(NSInteger)labelTag{
    NSArray *urlStringArr = @[@"index.php?m=api&c=Store&a=index"];
//    [CMShopModel columeDataListWithUrlString:[urlStringArr objectAtIndex:labelTag-1] complection:^(NSMutableArray *array) {
//        _nowColumeArrar = array;
//        [_collectionView reloadData];
//    }];
}

- (void)columeDataListWithUrlString:(NSString *)urlString complection:(void (^)(NSMutableArray *array))complection{
    //    ShoppingDataHelper *helper = (ShoppingDataHelper*)[ShoppingDataHelper defaultHelper];
    [[ShoppingDataHelper defaultHelper] requestForURLStr:urlString requestMethod:@"GET" info:nil andBlock:^(id response, NSError *error) {
        NSArray *dataArray = (NSArray *)response;
        NSMutableArray *modelArr = [NSMutableArray array];
        for (NSDictionary *dic in dataArray) {
//            CMShopModel *model = [[self alloc] initWithDic:dic];
//            [modelArr addObject:model];
        }
        complection(modelArr);
    }];
}
@end
