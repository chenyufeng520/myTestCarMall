//
//  CarCategorySearchViewController.m
//  CarLife
//
//  Created by 聂康  on 16/8/18.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import "CarCategorySearchViewController.h"
#import "ToolDataHelper.h"

@interface CarCategorySearchViewController ()<UITextFieldDelegate>{
    UITextField *_searchTextField;
}


@end

@implementation CarCategorySearchViewController

- (ISTTopBar *)creatTopBarView:(CGRect)frame
{
    // 导航头
    ISTTopBar *tbTop = [[ISTTopBar alloc] initWithFrame:frame];
    
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
    _searchTextField.placeholder = @"车系查询";
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
            [self searchWithCarCategory:_searchTextField.text];
        }else{
            KTipBaseView(@"请填写要搜索的车系")
        }
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubviews];
    [self searchWithCarCategory:@"途观"];
}

- (void)searchWithCarCategory:(NSString *)carCategory{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",nil];
    NSString *str = [NSString stringWithFormat:@"http://op.juhe.cn/onebox/car/query?key=8898f82d39c84ca94371d5883039c74d&car=%@",carCategory];
    NSString *urlString = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [manager GET:urlString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSString *reason = dic[@"reason"];
        if ([reason isEqualToString:@"查询成功"])
        {
            NSArray *arr = dic[@"result"][@"carinfo"];
        }
        else {
            [self showHint:reason];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    if (_searchTextField.text.length > 0) {
        [self searchWithCarCategory:_searchTextField.text];
    }
    return YES;
}
@end
