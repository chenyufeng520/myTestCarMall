//
//  GoodsToPayViewController.m
//  CarLife
//
//  Created by 聂康  on 16/6/25.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import "GoodsToPayViewController.h"
#import "ShoppingDataHelper.h"
#import "ShopCarGoodsCell.h"

@interface GoodsToPayViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>{
    NSArray *_dataArr;
    UITextView *_addressTextView;
    UILabel *_totalLab;
}

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UIView *headerView;
@property (nonatomic, strong)UIView *footerView;

@end

@implementation GoodsToPayViewController

- (ISTTopBar *)creatTopBarView:(CGRect)frame
{
    // 导航头
    ISTTopBar *tbTop = [[ISTTopBar alloc] initWithFrame:frame];
    [tbTop.btnTitle setTitle:@"购物车" forState:UIControlStateNormal];
    [tbTop.btnLeft addTarget:self action:@selector(onClickTopBar:) forControlEvents:UIControlEventTouchUpInside];
    [tbTop setLetfTitle:nil];
    
    return tbTop;
}

- (void)loadSubviews
{
    _tbTop = [self creatTopBarView:kTopFrame];
    [self.view addSubview:_tbTop];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.iosChangeFloat+kNavHeight, kScreen_Width, kScreen_Height-self.iosChangeFloat-kNavHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    _tableView.tableHeaderView = self.headerView;
    _tableView.tableFooterView = self.footerView;
}

#pragma mark - 懒加载
- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kAdjustLength(140))];
        NSArray *titleArr = @[@"名称",@"数量",@"单价"];
        for (NSInteger i=0; i<titleArr.count; i++) {
            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(i*kScreen_Width/3.f, 0, kScreen_Width/3.f, kAdjustLength(140))];
            lab.textAlignment = NSTextAlignmentCenter;
            lab.font = kFontLarge_1;
            lab.text = titleArr[i];
            [_headerView addSubview:lab];
        }
    }
    return _headerView;
}

- (UIView *)footerView{
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 4*kAdjustLength(140))];
        
        _totalLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width-10, kAdjustLength(140))];
        _totalLab.textAlignment = NSTextAlignmentRight;
        _totalLab.textColor = [UIColor redColor];
        _totalLab.font = kFontLarge_1;
        [_footerView addSubview:_totalLab];
        
        _addressTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, _totalLab.maxY+5, kScreen_Width-20, kAdjustLength(140)-10)];
        _addressTextView.font = kFontLarge_1;
        _addressTextView.autocorrectionType = UITextAutocorrectionTypeNo;
//        _addressTextView.layer.cornerRadius = 5;
        _addressTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _addressTextView.layer.borderWidth = 0.8;
        _addressTextView.delegate = self;
        _addressTextView.returnKeyType = UIReturnKeyDone;
        _addressTextView.layoutManager.allowsNonContiguousLayout = NO;
        [_footerView addSubview:_addressTextView];

    }
    return _footerView;
}

#pragma mark - Click Menu

- (void)onClickTopBar:(UIButton *)btn
{
    if (btn.tag == BSTopBarButtonLeft) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (btn.tag == BSTopBarButtonRight) {
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubviews];
    [self loadShopCarGoodsData];
}

- (void)loadShopCarGoodsData{
    [[ISTHUDManager defaultManager] showHUDInView:self.view withText:nil];
    NSString *urlStr = [NSString stringWithFormat:@"index.php?m=api&c=Store&a=pay&uid=%@",kUID];
    [[ShoppingDataHelper defaultHelper] requestForURLStr:urlStr requestMethod:@"GET" info:nil andBlock:^(id response, NSError *error) {
        if (!error) {
            [[ISTHUDManager defaultManager] hideHUDInView:self.view];
            NSDictionary *dic = response;
            if ([[dic objectForKey:@"status"] integerValue] == 200) {
                _dataArr = [dic objectForKey:@"data"];
                [_tableView reloadData];
            }
        }
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kAdjustLength(140);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *iden = @"ShopCarGoodsCell";
    ShopCarGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell == nil) {
        cell = [[ShopCarGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    
#pragma 注意这里的打折价需要考虑
    cell.nameLab.text = [[_dataArr[indexPath.row] objectForKey:@"goods"] objectForKey:@"goods_name"];
    cell.numLab.text = [_dataArr[indexPath.row] objectForKey:@"num"];
    cell.priceLab.text = [[_dataArr[indexPath.row] objectForKey:@"goods"] objectForKey:@"goods_price"];

    return cell;
}

@end
