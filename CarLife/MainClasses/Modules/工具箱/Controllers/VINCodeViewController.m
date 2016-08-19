//
//  VINCodeViewController.m
//  CarLife
//
//  Created by 聂康  on 16/8/15.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import "VINCodeViewController.h"
#import "ToolDataHelper.h"

@interface VINCodeViewController ()<UITextFieldDelegate>{
    UITextField *_searchTextField;
}

@property (strong, nonatomic)UILabel *detailLab;

@end

@implementation VINCodeViewController

- (ISTTopBar *)creatTopBarView:(CGRect)frame
{
    // 导航头
    ISTTopBar *tbTop = [[ISTTopBar alloc] initWithFrame:frame];
    [tbTop.btnTitle setTitle:@"验证信息" forState:UIControlStateNormal];
    
    [tbTop.btnLeft addTarget:self action:@selector(onClickTopBar:) forControlEvents:UIControlEventTouchUpInside];
    [tbTop setLetfTitle:nil];
    
    [tbTop.btnRight setTitle:@"查询" forState:UIControlStateNormal];
    [tbTop.btnRight addTarget:self action:@selector(onClickTopBar:) forControlEvents:UIControlEventTouchUpInside];
    
    return tbTop;
}

- (void)loadSubviews
{
    _tbTop = [self creatTopBarView:kTopFrame];
    [self.view addSubview:_tbTop];
    [self makeSearchView];
    _contentView.height = kScreen_Height - self.iosChangeFloat-kNavHeight;
}

- (void)makeSearchView{
    _tbTop.btnLeft.width = 0.5 * _tbTop.btnLeft.width;
    _tbTop.btnLeft.imageEdgeInsets = UIEdgeInsetsMake(13, kButtonEdgeInsetsLeft, 13, 20);

    _tbTop.btnRight.width = 0.5 * _tbTop.btnRight.width;
    _tbTop.btnRight.minX = _tbTop.btnRight.minX+_tbTop.btnRight.width;
    _tbTop.btnRight.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);

    _searchTextField = [[UITextField alloc]initWithFrame:CGRectMake(_tbTop.btnLeft.maxX, (_tbTop.btnTitle.height-35)/2.f, _tbTop.btnTitle.width*1.5, 35)];
    _searchTextField.borderStyle = UITextBorderStyleRoundedRect;
    _searchTextField.backgroundColor=  [UIColor whiteColor];
    _searchTextField.layer.masksToBounds=YES;
    _searchTextField.returnKeyType = UIReturnKeyDone;
    _searchTextField.delegate = self;
    _searchTextField.placeholder = @"17位车架号";
    _searchTextField.borderStyle = UITextBorderStyleRoundedRect;
    _searchTextField.exclusiveTouch = YES;
    [_tbTop.topBarView addSubview:_searchTextField];
    
    [_tbTop.btnTitle removeFromSuperview];
}

#pragma mark - Click Menu

- (void)onClickTopBar:(UIButton *)btn
{
    if (btn.tag == BSTopBarButtonLeft) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (btn.tag == BSTopBarButtonRight) {
        if (_searchTextField.text.length > 0) {
            [self search];
        }else{
            KTipBaseView(@"请填写要搜索的车架号")
        }

    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubviews];
    [_contentView addSubview:self.detailLab];
    _contentView.backgroundColor = [UIColor whiteColor];
}

- (UILabel *)detailLab{
    if (!_detailLab) {
        _detailLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, _contentView.width, 0)];
        _detailLab.layer.borderWidth = 1;
        _detailLab.numberOfLines = 0;
        _detailLab.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _detailLab.font = kFontLarge_1;
    }
    return _detailLab;
}

#pragma mark - 搜索接口
- (void)search{
    [[ISTHUDManager defaultManager] showHUDInView:self.view withText:nil];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",nil];
    NSString *str = [NSString stringWithFormat:@"http://getVIN.api.juhe.cn/CarManagerServer/getVINFormat?&key=5c315f716c1e609fbdf9c63afbeaf136&VIN=%@",_searchTextField.text];
    NSString *urlString = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [manager GET:urlString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        [[ISTHUDManager defaultManager] hideHUDInView:self.view];
        if (!task.error) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            BSLog(@"%@",dic);
            NSString *reason = dic[@"reason"];
            if ([reason isEqualToString:@"查询成功"])
            {
                _detailLab.text = dic[@"result"][@"body"][@"CARINFO"];
                _detailLab.height = STRING_HEIGHT(_detailLab.text, _detailLab.width, kFontLarge_1);
            }
            else
            {
                [self showHint:reason];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[ISTHUDManager defaultManager] hideHUDInView:self.view];
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    if (_searchTextField.text.length > 0) {
        [self search];
    }
    return YES;
}

@end
