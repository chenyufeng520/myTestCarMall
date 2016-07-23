//
//  NearCarOwerViewController.m
//  CarLife
//
//  Created by 聂康  on 16/7/19.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import "NearCarOwerViewController.h"
#import "NearCarOwerCell.h"

@interface NearCarOwerViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toTopHeight;
@property (nonatomic, strong)NSMutableArray *dataArr;

@end

@implementation NearCarOwerViewController

- (ISTTopBar *)creatTopBarView:(CGRect)frame
{
    // 导航头
    ISTTopBar *tbTop = [[ISTTopBar alloc] initWithFrame:frame];
    [tbTop.btnTitle setTitle:@"附近车主" forState:UIControlStateNormal];
    [tbTop.btnLeft addTarget:self action:@selector(onClickTopBar:) forControlEvents:UIControlEventTouchUpInside];
    [tbTop setLetfTitle:nil];
    
    return tbTop;
}

- (void)loadSubviews
{
    _tbTop = [self creatTopBarView:kTopFrame];
    [self.view addSubview:_tbTop];
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
    [self initUI];
}

- (void)initUI{
    _toTopHeight.constant = self.iosChangeFloat + kNavHeight;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = [[UIView alloc] init];
    _dataArr = [NSMutableArray array];
    for (int i = 0 ; i < 8; i ++ ) {
        [_dataArr addObject:@"1"];
    }

    [_tableView registerNib:[UINib nibWithNibName:@"NearCarOwerCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"NearCarOwerCell"];
}

#pragma mark table delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NearCarOwerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NearCarOwerCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NearCarOwerCell" owner:nil options:nil] firstObject];
    }
    return cell;
}


@end
