//
//  QNSearchViewController.m
//  CarLife
//
//  Created by 聂康  on 16/8/19.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import "QNSearchViewController.h"
#import "ToolDataHelper.h"

@interface QNSearchViewController ()<UITextFieldDelegate>{
    UITextField *_searchTextField;
    int _page;
}


@end

@implementation QNSearchViewController

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
    _searchTextField.placeholder = @"请输入关键字";
    _searchTextField.borderStyle = UITextBorderStyleRoundedRect;
    _searchTextField.exclusiveTouch = YES;
    [_tbTop.topBarView addSubview:_searchTextField];
    
    [_tbTop.btnTitle removeFromSuperview];
}

- (void)onClickTopBar:(UIButton *)btn
{
    if (btn.tag == BSTopBarButtonLeft) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (btn.tag == BSTopBarButtonRight) {
        if (_searchTextField.text.length > 0) {
            [self searchWithString:_searchTextField.text];
        }else{
            KTipBaseView(@"请输入关键字")
        }
        
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    if (_searchTextField.text.length > 0) {
        [self searchWithString:_searchTextField.text];
    }
    return YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 1;
    [self loadSubviews];
}

- (void)searchWithString:(NSString *)searchString{
    [[ISTHUDManager defaultManager] showHUDInView:self.view withText:nil];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",nil];
    NSString *str = [NSString stringWithFormat:@"http://v.juhe.cn/carzone/acc/query?action=search&pageSize=20&pageNo=%d&type=0&key=0b64bdee66f06914deb5cdac53871f8b&keyword=%@",_page,searchString];
    NSString *urlString = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [manager GET:urlString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        [[ISTHUDManager defaultManager] hideHUDInView:self.view];

        NSDictionary *responDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([responDic[@"reason"] isEqualToString:@"查询成功"])
        {
            NSArray *dataArr = responDic[@"result"][@"detail"][@"accInfos"];
        }else{
        
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[ISTHUDManager defaultManager] hideHUDInView:self.view];
    }];

}

@end
