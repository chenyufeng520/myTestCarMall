//
//  CMToolKitViewController.m
//  CarLife
//
//  Created by 陈宇峰 on 16/5/12.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import "CMToolKitViewController.h"
#import "ToolKitCell.h"
#import "UIAlertHelper.h"
#import "RoadSearchViewController.h"
#import "AppDelegate.h"
#import "VINCodeViewController.h"

@interface CMToolKitViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
{
  UICollectionView *_collectionView;
}
@property (nonatomic,strong) NSArray * toolArray;
@end

@implementation CMToolKitViewController

- (ISTTopBar *)creatTopBarView:(CGRect)frame
{
    // 导航头
    ISTTopBar *tbTop = [[ISTTopBar alloc] initWithFrame:frame];
    [tbTop.btnTitle setTitle:@"工具箱" forState:UIControlStateNormal];
    
    return tbTop;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareData];
    [self loadSubviews];
}

- (void)loadSubviews
{
    _tbTop = [self creatTopBarView:kTopFrame];
    [self.view addSubview:_tbTop];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kAdjustLength(40), _contentView.width, _contentView.height - kAdjustLength(40)) collectionViewLayout:layout];
    [_collectionView setBackgroundColor:[UIColor clearColor]];
    [_collectionView registerClass:[ToolKitCell class] forCellWithReuseIdentifier:@"cell"];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_contentView addSubview:_collectionView];
}

- (void)prepareData{
    
    self.toolArray = @[
                       @{@"icon":@"toolKit_01",@"title":@"全国油价"},
                       @{@"icon":@"toolKit_02",@"title":@"实时路况"},@{@"icon":@"toolKit_03",@"title":@"周边停车场"},@{@"icon":@"toolKit_04",@"title":@"驾车路线"},@{@"icon":@"toolKit_05",@"title":@"汽配查询"},@{@"icon":@"toolKit_06",@"title":@"车系查询"},@{@"icon":@"toolKit_07",@"title":@"VIN识别码"},@{@"icon":@"toolKit_08",@"title":@"长途汽车"},@{@"icon":@"toolKit_09",@"title":@"城市公交"}
                       ];
}

#pragma mark - UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.toolArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ToolKitCell *cell = (ToolKitCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    for(UIView *av in cell.contentView.subviews)
    {
        [av removeFromSuperview];
    }
    [cell reloadCellWithInfo:self.toolArray[indexPath.row]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    float cellWidth = (kScreen_Width - kAdjustLength(90))/3;
    return CGSizeMake(cellWidth, cellWidth);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(kAdjustLength(20), kAdjustLength(10), kAdjustLength(20), kAdjustLength(10));//分别为上、左、下、右

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3) {
        RoadSearchViewController *roadVC = [[RoadSearchViewController alloc] init];
        [[AppDelegate shareDelegate].rootNavigation pushViewController:roadVC animated:YES];
    }else if (indexPath.row == 6){
        VINCodeViewController *vin = [[VINCodeViewController alloc] init];
        [[AppDelegate shareDelegate].rootNavigation pushViewController:vin animated:YES];
    }
    else{
        //敬请期待
        KTipFun;
        return ;
    }
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
