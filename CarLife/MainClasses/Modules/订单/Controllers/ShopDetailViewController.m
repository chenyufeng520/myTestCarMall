//
//  ShopDetailViewController.m
//  CarLife
//
//  Created by 聂康  on 16/7/24.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import "ShopDetailViewController.h"
#import "ShoppingCartView.h"
#import "ThrowLineTool.h"
#import "ViewModel.h"
#import "MainTableViewCell.h"
#import "GoodOrderModel.h"

@interface ShopDetailViewController ()<ThrowLineToolDelegate,UITableViewDataSource,UITableViewDelegate>{
    NSInteger _type;
}

@property (strong, nonatomic) UIScrollView *shopInfoView;

@property (strong, nonatomic) UIView *lineView;
//抛物线红点
@property (strong, nonatomic) UIImageView *redView;
//数据源
@property(nonatomic,strong) NSMutableArray *dataArray;
//订单数据
@property (nonatomic,strong) NSMutableArray *ordersArray;
//总数量
@property (nonatomic,assign) NSInteger totalOrders;

@property (nonatomic,strong) ShoppingCartView *shoppcartview;

@property (strong, nonatomic) UIView *topView;
@property (strong, nonatomic) UIView *middleView;
@property (strong, nonatomic) UIImageView *shopImage;
@property (strong, nonatomic) UILabel *shopNameLab;
@property (strong, nonatomic) UILabel *typeLab;
@property (strong, nonatomic) UILabel *timeLab;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIScrollView *leftScr;
@end

@implementation ShopDetailViewController

- (ISTTopBar *)creatTopBarView:(CGRect)frame
{
    // 导航头
    ISTTopBar *tbTop = [[ISTTopBar alloc] initWithFrame:frame];
    [tbTop.btnTitle setTitle:@"商铺详情" forState:UIControlStateNormal];
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
    _type = 1;
    [self loadSubviews];
    [self initUI];
    [self CustomModel];
}

- (void)initUI{
    self.dataArray = [NSMutableArray new];
//    [ThrowLineTool sharedTool].delegate = self;
    
    
    [self.view addSubview:self.topView];
    [self.view addSubview:self.middleView];
    [self.view addSubview:self.leftScr];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.shopInfoView];
    
    
    self.shoppcartview  = [[ShoppingCartView alloc] initWithFrame:CGRectMake(0, kScreen_Height - 50, kScreen_Width, 50) inView:self.view];
    [self.view addSubview:self.shoppcartview];

    [_tableView registerNib:[UINib nibWithNibName:@"MainTableViewCell" bundle:nil] forCellReuseIdentifier:@"maincell"];

    _shopNameLab.text = _orderModel.store_name;
    _typeLab.text = _orderModel.store_type;
    _timeLab.text = _orderModel.store_text;
    
}

/**
 *  抛物线小红点
 *
 *  @return
 */
- (UIImageView *)redView
{
    if (!_redView) {
        _redView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        _redView.image = [UIImage imageNamed:@"adddetail"];
        _redView.layer.cornerRadius = 10;
    }
    return _redView;
}
/**
 *  存放用户添加到购物车的商品数组
 *
 *  @return
 */
-(NSMutableArray *)ordersArray
{
    if (!_ordersArray) {
        _ordersArray = [NSMutableArray new];
    }
    return _ordersArray;
}

-(UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, _tbTop.maxY, kScreen_Width, 110)];
        _topView.backgroundColor = RGBCOLOR(242, 242, 242);
        
        _shopImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 70, 70)];
        [_topView addSubview:_shopImage];
        
        _shopNameLab = [[UILabel alloc] initWithFrame:CGRectMake(_shopImage.maxX+15, 20, kScreen_Width-_shopImage.maxX-15-10, 20)];
        _shopNameLab.font = [UIFont systemFontOfSize:16];
        _shopNameLab.textColor = [UIColor blackColor];
        [_topView addSubview:_shopNameLab];
        
        _typeLab = [[UILabel alloc] initWithFrame:CGRectMake(_shopImage.maxX+15, _shopNameLab.maxY+5, kScreen_Width-_shopImage.maxX-15-10, 20)];
        _typeLab.font = [UIFont systemFontOfSize:14];
        _typeLab.textColor = [UIColor lightGrayColor];
        [_topView addSubview:_typeLab];
        
        _timeLab = [[UILabel alloc] initWithFrame:CGRectMake(_shopImage.maxX+15, _typeLab.maxY+5, kScreen_Width-_shopImage.maxX-15-10, 20)];
        _timeLab.font = [UIFont systemFontOfSize:14];
        _timeLab.textColor = [UIColor lightGrayColor];
        [_topView addSubview:_timeLab];
    }
    return _topView;
}

- (UIView *)middleView{
    if (!_middleView) {
        _middleView = [[UIView alloc] initWithFrame:CGRectMake(0, _topView.maxY, kScreen_Width, 50)];
        _middleView.backgroundColor = [UIColor whiteColor];
        NSArray *titleArr = nil;
        if (_type == 0) {
            titleArr = @[@"汽配",@"商家信息"];
        }else if (_type == 1){
            titleArr = @[@"汽车美容",@"商家信息"];
        }else{
            titleArr = @[@"汽车保养",@"商家信息"];
        }

        CGFloat w = kScreen_Width/titleArr.count;
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _middleView.height-2, w, 2)];
        _lineView.backgroundColor = RGBCOLOR(249, 0, 7);
        [_middleView addSubview:_lineView];
        
        for (NSInteger i=0; i<titleArr.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            btn.frame = CGRectMake(i*w, 0, w, _middleView.height);
            [btn setTitle:titleArr[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(middleColumeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = 3000 + i;
            if (i==0) {
                [btn setTitleColor:RGBCOLOR(249, 0, 7) forState:UIControlStateNormal];
            }
            [_middleView addSubview:btn];
        }
        
    }
    return _middleView;
}

- (UIScrollView *)leftScr{
    if (!_leftScr) {
        _leftScr = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _middleView.maxY+1, kScreen_Width, kScreen_Height-_middleView.maxY-1-50)];
        _leftScr.showsHorizontalScrollIndicator = NO;
        _leftScr.showsVerticalScrollIndicator = NO;
        _leftScr.scrollEnabled = NO;
        NSArray *leftTitleArr = nil;
        if (_type == 0) {
            leftTitleArr = @[@"用品",@"轮胎",@"机油",@"零件"];
        }else if (_type == 1){
            leftTitleArr = @[@"汽车美容",@"汽车保养",@"汽车服务",@"汽车服务"];
        }else{
            leftTitleArr = @[@"汽车美容",@"汽车保养",@"汽车服务",@"汽车服务"];
        }
        CGFloat h = _leftScr.height/leftTitleArr.count;
        for (NSInteger i=0; i<leftTitleArr.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            btn.frame = CGRectMake(0, i*h, 100,h-1);
            [btn setTitle:leftTitleArr[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(leftColumeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.backgroundColor = _leftScr.backgroundColor;
            btn.tag = 2000 + i;
            if (i==0) {
                btn.backgroundColor = [UIColor whiteColor];
            }
            [_leftScr addSubview:btn];
        }
    }
    return _leftScr;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(100, _leftScr.minY, kScreen_Width-100, _leftScr.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

-(UIView *)shopInfoView{
    if (!_shopInfoView) {
        _shopInfoView = [[UIScrollView alloc] initWithFrame:CGRectMake(kScreen_Width, _leftScr.minY, kScreen_Width, _leftScr.height)];
        _shopInfoView.showsVerticalScrollIndicator = NO;
        _shopInfoView.showsHorizontalScrollIndicator = NO;
        _shopInfoView.backgroundColor = RGBCOLOR(235, 235, 235);
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, kScreen_Width, 190)];
        backView.backgroundColor = [UIColor whiteColor];
        [_shopInfoView addSubview:backView];
        
        NSArray *leftTitleArr = @[@"地       址:",@"电       话:",@"营业时间:"];
        for (NSInteger i=0; i<leftTitleArr.count; i++) {
            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 10+i*50, 100, 50)];
            lab.text = leftTitleArr[i];
            lab.font = [UIFont systemFontOfSize:16];
            lab.textAlignment = NSTextAlignmentRight;
            [backView addSubview:lab];
            
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(lab.maxX+5, 10+i*50, kScreen_Width-lab.maxX-5, 50)];
            textField.borderStyle = UITextBorderStyleNone;
            [backView addSubview:textField];
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(lab.maxX+5, 10+i*50+50-1, kScreen_Width-lab.maxX-5, 1)];
            line.backgroundColor = RGBCOLOR(234, 234, 234);
            [backView addSubview:line];
        }
        
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, backView.maxY+20, kScreen_Width, 120)];
        bottomView.backgroundColor = [UIColor whiteColor];
        [_shopInfoView addSubview:bottomView];
        
        UILabel *activityLab = [[UILabel alloc] initWithFrame:CGRectMake(25, 15, kScreen_Width-25, 20)];
        activityLab.text = @"最新活动:";
        activityLab.font = [UIFont systemFontOfSize:16];
        activityLab.numberOfLines = 0;
        [bottomView addSubview:activityLab];
    }
    return _shopInfoView;
}

#pragma  mark - 初始化数据
/**
 *  当前店铺商品数据
 */
-(void)CustomModel{
    
    [ViewModel GetShoppdata:^(NSMutableArray *array){
        self.dataArray = array;
    }];
    
}

#pragma mark - Click Memu
- (void)leftColumeButtonClick:(UIButton *)btn{
    [self resetLeftButtonColor:btn.tag];
}

- (void)resetLeftButtonColor:(NSInteger)tag{
    for (UIView *tempView in _leftScr.subviews) {
        if ([tempView isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)tempView;
            if (btn.tag == tag) {
                btn.backgroundColor = [UIColor whiteColor];
            }else{
                btn.backgroundColor = _leftScr.backgroundColor;
            }
        }
        
    }
}


- (void)middleColumeButtonClick:(UIButton *)btn{
    [self resetMiddleButtonColor:btn.tag];
    if (btn.tag == 3001) {
        [UIView animateWithDuration:0.5 animations:^{
            _shopInfoView.frame = CGRectMake(0, _leftScr.minY, kScreen_Width, _leftScr.height);
        }];
    }else if (btn.tag == 3000){
        [UIView animateWithDuration:0.5 animations:^{
            _shopInfoView.frame = CGRectMake(kScreen_Width, _leftScr.minY, kScreen_Width, _leftScr.height);
        }];

    }
}

- (void)resetMiddleButtonColor:(NSInteger)tag{
    for (UIView *tempView in _middleView.subviews) {
        if ([tempView isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)tempView;
            if (btn.tag == tag) {
                [btn setTitleColor:RGBCOLOR(249, 0, 7) forState:UIControlStateNormal];
            }else{
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
        }
        
    }
    [UIView animateWithDuration:0.5 animations:^{
        _lineView.minX = (tag-3000)*_lineView.width;
    }];
    if (tag == 3001) {
        
    }
}


#pragma mark - TableViewDelegate and DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"maincell" forIndexPath:indexPath];
    GoodOrderModel *model = [[GoodOrderModel alloc]initWithDictionary:[self.dataArray objectAtIndex:indexPath.row]];
    [cell setmaintablecell:model];
    __weak __typeof(&*cell)weakCell =cell;
    __block __typeof(self)bself = self;
    cell.plusBlock = ^(NSInteger nCount,BOOL animated)
    {
        /**
         *   给当前选中商品添加一个数量
         */
        NSMutableDictionary * dic = self.dataArray[indexPath.row];
        [dic setObject:[NSNumber numberWithInteger:nCount] forKey:@"orderCount"];
        
        /**
         *  通过坐标转换得到抛物线的起点和终点
         */
        CGRect parentRectA = [weakCell convertRect:weakCell.addBtn.frame toView:self.view];
        CGRect parentRectB = [self.shoppcartview convertRect:self.shoppcartview.shoppingCartBtn.frame toView:self.view];
        /**
         *  是否执行添加的动画
         */
        if (animated) {
            UIImageView *redView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
            redView.image = [UIImage imageNamed:@"adddetail"];
            redView.layer.cornerRadius = 10;

            [bself.view addSubview:redView];
            ThrowLineTool *throw = [[ThrowLineTool alloc] init];
            throw.delegate = self;
            [throw throwObject:redView from:parentRectA.origin to:parentRectB.origin];
            bself.ordersArray = [ViewModel storeOrders:dic OrderData:self.ordersArray isAdded:YES];
        } else{
            bself.ordersArray = [ViewModel storeOrders:dic OrderData:self.ordersArray isAdded:NO];
        }
        
        bself.shoppcartview.OrderList.objects = self.ordersArray;
        [bself.shoppcartview updateFrame:self.shoppcartview.OrderList];
        [bself.shoppcartview.OrderList.tableView reloadData];
        bself.shoppcartview.badgeValue =  [ViewModel CountOthersWithorderData:self.ordersArray];
        double price = [ViewModel GetTotalPrice:bself.ordersArray];
        [bself.shoppcartview setTotalMoney:price];
        
    };
    
    return cell;
}

#pragma mark - 设置购物车动画
- (void)animationDidFinish
{
    
//    [self.redView removeFromSuperview];
    [UIView animateWithDuration:0.1 animations:^{
        self.shoppcartview.shoppingCartBtn.transform = CGAffineTransformMakeScale(0.8, 0.8);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            self.shoppcartview.shoppingCartBtn.transform = CGAffineTransformMakeScale(1, 1);
        } completion:^(BOOL finished) {
            
        }];
        
    }];
}

#pragma mark - 通知更新
-(void)UpdatemainUI:(NSNotification *)Notification{
    
    NSMutableDictionary *dic =[NSMutableDictionary dictionaryWithDictionary: Notification.userInfo];
    //重新计算订单数组。
    self.ordersArray = [ViewModel storeOrders:dic[@"update"] OrderData:self.ordersArray isAdded:[dic[@"isAdd"] boolValue]];
    self.shoppcartview.OrderList.objects = self.ordersArray;
    //设置高度。
    [self.shoppcartview updateFrame:self.shoppcartview.OrderList];
    [self.shoppcartview.OrderList.tableView reloadData];
    //设置数量、价格
    self.shoppcartview.badgeValue =  [ViewModel CountOthersWithorderData:self.ordersArray];
    double price = [ViewModel GetTotalPrice:self.ordersArray];
    [self.shoppcartview setTotalMoney:price];
    //重新设置数据源
    self.dataArray = [ViewModel UpdateArray:self.dataArray atSelectDictionary:dic[@"update"]];
    [self.tableView reloadData];
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:@"updateUI"];
}

@end
