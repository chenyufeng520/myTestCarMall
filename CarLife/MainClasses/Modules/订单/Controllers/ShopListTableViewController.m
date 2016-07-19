//
//  ShopListTableViewController.m
//  CarLife
//
//  Created by 聂康  on 16/5/25.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import "ShopListTableViewController.h"
#import "OrderDatahelper.h"
#import "OrderCell.h"
#import "ChatViewController.h"
#import "AppDelegate.h"
#import "OrderDatahelper.h"
#import "PhoneContactViewController.h"
#import "NearCarOwerViewController.h"
#import "RedEnvelopeViewController.h"
#import "AddFriendMessageViewController.h"
#import "ShareToZoneViewController.h"
#import "OrderDatahelper.h"

@interface ShopListTableViewController ()<UITableViewDelegate,UITableViewDataSource,OrderCellDelegate,UITextFieldDelegate>{
    UITableView *_tableView;
    NSMutableArray *_shopListArr;
    int _page;
    UIWebView *_phoneWebView;
    UITextField *_textField;
    BOOL _isSearch;
}

@end

@implementation ShopListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initData];
    [self makeUI];
    [self loadShopListData];
}

- (void)initData{
    _page = 0;
    _shopListArr = [NSMutableArray array];
}

- (void)makeUI{
    UIView *sideView = [[UIView alloc] initWithFrame:CGRectMake(25,0, (kScreen_Width-25-50-15-15), 45)];
    sideView.layer.cornerRadius = sideView.height * 0.5;
    sideView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    sideView.layer.borderWidth = 0.8;
    [self.view addSubview:sideView];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.backgroundColor = kNavBarColor;
    searchBtn.frame = CGRectMake(sideView.maxX+15, sideView.minY+5, 50, 45-10);
    [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchButtonDown:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchBtn];
    
    UIImageView *leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, sideView.height-20, sideView.height-20)];
    leftImage.image = [UIImage imageNamed:@"icon_1"];
    [sideView addSubview:leftImage];
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(leftImage.maxX+5, 0, sideView.width-2*(leftImage.width+5), 45)];
    _textField.borderStyle = UITextBorderStyleNone;
    _textField.placeholder = @"输入关键字查询";
    _textField.tintColor = kNavBarColor;
    _textField.delegate = self;
    [_textField addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    [sideView addSubview:_textField];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, _textField.maxY+10, kScreen_Width, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line];
    
    NSArray *titleArr = @[@"店铺页",@"智能排序",@"筛选"];
    CGFloat w = (kScreen_Width-10)/(float)titleArr.count;
    for (int i=0; i<titleArr.count; i++) {
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(i*(w+5), line.maxY, w, kAdjustLength(160))];
        lab.font = kFont_16;
        lab.text = titleArr[i];
        lab.textColor = [UIColor whiteColor];
        lab.backgroundColor = kNavBarColor;
        lab.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:lab];
    }
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kAdjustLength(160)+sideView.height+10, kScreen_Width, kScreen_Height-self.iosChangeFloat-kNavHeight-30-kAdjustLength(100)-sideView.height-kAdjustLength(160)-kTabBarHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = kMainBGColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
    
    __weak typeof(self) weakSelf = self;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf headerRefresh];
    }];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf footerRefresh];
    }];
}

/**
 * 上下拉加载数据
 **/
- (void)headerRefresh{
    _page = 0;
    [self commonRefreshLoadData];
}

- (void)footerRefresh{
    [self commonRefreshLoadData];
}

- (void)commonRefreshLoadData{
    if (_isSearch) {
        [self loadSearchData];
    }else{
        [self loadShopListData];
    }
}

- (void)endRefresh{
    [_tableView.mj_header endRefreshing];
    [_tableView.mj_footer endRefreshing];
}

- (void)loadShopListData{
    _page++;
    __weak typeof(self) weakSelf = self;
    [[STHUDManager sharedManager] showHUDInView:self.view];
    [[OrderDatahelper defaultHelper] requestForURLStr:kFormatUrl requestMethod:@"GET" info:@{@"m":@"Api",@"c":@"Json",@"a":@"index",@"p":[NSString stringWithFormat:@"%d",_page]} andBlock:^(id response, NSError *error) {
        [self endRefresh];
        [[STHUDManager sharedManager] hideHUDInView:weakSelf.view];
        if ([response isKindOfClass:[NSDictionary class]]) {
            int status = [response[@"status"] intValue];
            
            if (status == 200) {
                NSArray *dataArr = response[@"data"];
                if (dataArr) {
                    if (_page == 1) {
                        [_shopListArr removeAllObjects];
                    }
                    for (NSDictionary *dic in dataArr) {
                        OrderModel *shopModel = [[OrderModel alloc] initWithDic:dic];
                        [_shopListArr addObject:shopModel];
                    }
                    [_tableView reloadData];
                }
            }
            else
            {
                [MBProgressHUD showMessag:response[@"message"] toView:self.view];
            }
        }
        else
        {
            [MBProgressHUD showError:@"网络异常" toView:self.view];

        }

        [_tableView reloadData];
    }];
}

/**
 * 加载搜索数据
 **/
- (void)loadSearchData{
    _page++;
    NSString *urlStr = [NSString stringWithFormat:@"%@?m=Api&c=Json&a=search&word=%@&page=20&curpage=%d",kFormatUrl,_textField.text,_page];
    [[OrderDatahelper defaultHelper] requestForURLStr:urlStr requestMethod:@"GET" info:nil andBlock:^(id response, NSError *error) {
        NSLog(@"%@",response);
        [self endRefresh];
        if (error) {
            
        }else{
            if ([[response objectForKey:@"status"] integerValue] == 200) {
                NSArray *dataArr = response[@"data"];
                if ([dataArr isKindOfClass:[NSArray class]]) {
                    if (_page == 1) {
                        [_shopListArr removeAllObjects];
                    }
                    for (NSDictionary *dic in dataArr) {
                        OrderModel *shopModel = [[OrderModel alloc] initWithDic:dic];
                        [_shopListArr addObject:shopModel];
                    }
                    [_tableView reloadData];
                }
            }
        }
    }];
}

//点击搜索按钮或键盘搜索
- (void)searchShop{
    _isSearch = YES;
    _page = 0;
    [self loadSearchData];
    [_textField resignFirstResponder];
}

#pragma mark - Click Menu
- (void)searchButtonDown:(UIButton *)btn{
    [self searchShop];
}

#pragma mark - UITextFieldDelegaet
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (_textField.text.length > 0){
        [self searchShop];
    }else{
        [_textField resignFirstResponder];
    }
    return YES;
}

- (void)textFieldValueChanged:(UITextField *)textField{
    if (_textField.text.length == 0) {
        _isSearch = NO;
        _page = 0;
        [self loadShopListData];
    }
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _shopListArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderModel *model = _shopListArr[indexPath.row];
    if (model.status == FoldStatus) {
        return 100+10*2+45*3+20*2;
    }
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *iden = @"OrderCell";
    OrderCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[OrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    cell.orderModel = _shopListArr[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.orderModel.status == FoldStatus) {
        cell.orderModel.status = UnfoldStatus;
    }else if (cell.orderModel.status == UnfoldStatus) {
        cell.orderModel.status = FoldStatus;
    }
    [_tableView reloadData];
}

#pragma mark - OrderCellDelagate
- (void)orderCellPhoneClick:(OrderModel *)orderModel{
    if (!_phoneWebView) {
        _phoneWebView = [[UIWebView alloc]init];
        [self.view addSubview:_phoneWebView];
    }
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",orderModel.store_phone]];
    [_phoneWebView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)orderCellMessageClick:(OrderModel *)orderModel{
    ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:@"18501047155" conversationType:EMConversationTypeChat];
    chatController.title = orderModel.store_name;
    [[AppDelegate shareDelegate].rootNavigation pushViewController:chatController animated:YES];

}

- (void)orderCellHiddenButtonClick:(NSInteger)index orderModel:(OrderModel *)orderModel{
    switch (index) {
        case 0:
        {
            NearCarOwerViewController *nearCarOwer = [[NearCarOwerViewController alloc] init];
            [[AppDelegate shareDelegate].rootNavigation pushViewController:nearCarOwer animated:YES];
            break;
        }
        case 1:
        {
            RedEnvelopeViewController *redEnvelope = [[RedEnvelopeViewController alloc] init];
            [[AppDelegate shareDelegate].rootNavigation pushViewController:redEnvelope animated:YES];
            break;
        }
        case 2:
        {
            AddFriendMessageViewController *addMessage = [[AddFriendMessageViewController alloc] init];
            [[AppDelegate shareDelegate].rootNavigation pushViewController:addMessage animated:YES];

            break;
        }
        case 3:
        {

            break;
        }
        case 4:
        {
            PhoneContactViewController *phoneContact = [[    PhoneContactViewController alloc] init];
            phoneContact.orderModel = orderModel;
            [[AppDelegate shareDelegate].rootNavigation pushViewController:phoneContact animated:YES];
            break;
        }
        case 5:
        {
            ShareToZoneViewController *shareZone = [[ShareToZoneViewController alloc] init];
            [[AppDelegate shareDelegate].rootNavigation pushViewController:shareZone animated:YES];

            break;
        }
            
        default:
            break;
    }
}

@end
