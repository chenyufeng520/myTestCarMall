//
//  ISTAccountCreateViewController.m
//  PointsMall
//
//  Created by 高大鹏 on 15/11/6.
//  Copyright © 2015年 高大鹏. All rights reserved.
//

#import "ISTAccountCreateViewController.h"
#import "AppDelegate.h"
#import "NSObject+Common.h"
#import "ISTVerifyCodeButton.h"
#import "LoginDataHelper.h"
#import "LoginDef.h"

@interface ISTAccountCreateViewController ()
{
    AccountBindType _type;
    UITextField *_phoneTf;
    UITextField *_codeTf;
}

@end

@implementation ISTAccountCreateViewController

- (id)initWithType:(AccountBindType)type
{
    if (self = [super init]) {
        _type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _contentView.height += kTabBarHeight;
    _contentView.backgroundColor = kMainBGColor;
    // Do any additional setup after loading the view.
    [self configUI];
}

- (ISTTopBar *)creatTopBarView:(CGRect)frame
{
    // 导航头
    ISTTopBar *tbTop = [[ISTTopBar alloc] initWithFrame:frame];
    NSString *titleStr = (_type == AccountBindType_Register)?@"快速注册":@"账号关联";
    [tbTop.btnTitle setTitle:titleStr forState:UIControlStateNormal];
    
    [tbTop setLetfTitle:nil];
    [tbTop.btnLeft addTarget:self action:@selector(onClickTopBar:) forControlEvents:UIControlEventTouchUpInside];
    
    return tbTop;
}

-(void)configUI{
    
    _tbTop = [self creatTopBarView:kTopFrame];
    [self.view addSubview:_tbTop];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 15, kScreen_Width, 101)];
    bgView.backgroundColor = kWhiteColor;
    [_contentView addSubview:bgView];

    //手机号码
    UILabel *phoneLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 50)];
    phoneLb.backgroundColor = [UIColor clearColor];
    phoneLb.textColor = kDarkTextColor;
    phoneLb.font = kFontNormal;
    phoneLb.text = @"手机号";
    phoneLb.textAlignment = NSTextAlignmentRight;
    [bgView addSubview:phoneLb];
    
    _phoneTf = [[UITextField alloc] init];
    _phoneTf.frame = CGRectMake(100, 0, bgView.width-120-kAdjustLength(255), 50);
    _phoneTf.textColor = kDarkTextColor;
    _phoneTf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _phoneTf.font = kFontLarge_1;
    _phoneTf.text = @"";
    _phoneTf.placeholder = @"请输入手机号";
    [bgView addSubview:_phoneTf];
    
    __weak typeof(self) weakSelf = self;
    ISTVerifyCodeButton *btn = [ISTVerifyCodeButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(bgView.width-15-kAdjustLength(255),10, kAdjustLength(255), 30);
    btn.color = kBlueColor;
    [btn setBlock:^(ISTVerifyCodeButton *button){
        [weakSelf.view endEditing:YES];
        if (![NSObject isPhoneNumber:_phoneTf.text])
        {
            kTipAlert(@"输入错误，请正确填写手机号");
        }
        else
        {
            [[LoginDataHelper defaultHelper] requestForURLStr:@"" requestMethod:@"POST" info:@{@"phone":_phoneTf.text} andBlock:^(id response, NSError *error) {
                if ([response isKindOfClass:[NSDictionary class]]) {
                    if ([response[@"result"] boolValue]) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [[STHUDManager sharedManager] showHUD];
                            [STHUDManager sharedManager].HUD.margin = 15.0f;
                            [STHUDManager sharedManager].HUD.center = weakSelf.view.center;
                            [[STHUDManager sharedManager] hideHUDWithLabel:@"获取中..." afterDelay:1];
                            
                            [button startTimer];
                        });
                        
                    }
                    else
                    {
                        NSString *msg = response[@"msg"]?response[@"msg"]:@"获取验证码出错";
                        kTipAlert(@"%@",msg);
                    }
                    
                }
                else
                {
                    kTipAlert(@"获取验证码出错");
                }
            }];
        }
    }];
    [bgView addSubview:btn];
    
    
    UIView *line1 = [[UIView alloc] initLineWithFrame:CGRectMake(0, phoneLb.maxY - kLinePixel, bgView.width, kLinePixel) color:kLineColor];
    [bgView addSubview:line1];
    
    UILabel *codeLb = [[UILabel alloc]initWithFrame:CGRectMake(0, line1.maxY, 80, 50)];
    codeLb.backgroundColor = [UIColor clearColor];
    codeLb.textColor = kDarkTextColor;
    codeLb.font = kFontNormal;
    codeLb.text = @"验证码";
    codeLb.textAlignment = NSTextAlignmentRight;
    [bgView addSubview:codeLb];
    
    _codeTf = [[UITextField alloc] init];
    _codeTf.frame = CGRectMake(100, line1.maxY, bgView.width - 135, 50);
    _codeTf.textColor = kDarkTextColor;
    _codeTf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _codeTf.font = kFontLarge_1;
    _codeTf.text = @"";
    _codeTf.keyboardType = UIKeyboardTypeNumberPad;
    _codeTf.placeholder = @"请输入验证码";
    [bgView addSubview:_codeTf];
    
    NSString *btnTitle = (_type == AccountBindType_Register)?@"快速注册":@"账号关联";
    
    //按钮
    UIButton *actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    actionBtn.frame = CGRectMake(15, bgView.maxY + 15, _contentView.width - 30, kAdjustLength(120));
    [actionBtn setTitle:btnTitle forState:UIControlStateNormal];
    [actionBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    actionBtn.titleLabel.font = kFontLarge_1;
    [actionBtn setBackgroundImage:[UIImage imageWithColor:kBlueColor size:actionBtn.size] forState:UIControlStateNormal];
    [actionBtn addTarget:self action:@selector(actionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    actionBtn.layer.cornerRadius = kCornerRadius;
    actionBtn.layer.masksToBounds = YES;
    [_contentView addSubview:actionBtn];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Actions
- (void)onClickTopBar:(UIButton *)btn
{
    if (btn.tag == BSTopBarButtonLeft) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (btn.tag == BSTopBarButtonRight) {
        
    }
}

-(void)actionBtnClick:(UIButton*)sender{

    [self.view endEditing:YES];

    __weak typeof(self) weakSelf = self;
    if (![NSObject isPhoneNumber:_phoneTf.text]) {
        kTipAlert(@"手机号码有误！");
        return;
    }
    if (_codeTf.text.length == 0) {
        kTipAlert(@"请输入验证码");
        return;
    }

    
    NSMutableDictionary *infoDic = [NSMutableDictionary dictionary];
    NSString *openid = [[NSUserDefaults standardUserDefaults] objectForKey:wxOpenIdKey];
    NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:wxUserid];
    NSString *phone = _phoneTf.text;
    NSString *code = _codeTf.text;
    NSString *flag = @"";
    if (_type == AccountBindType_Relate) {
        flag = @"RelateAccount";
    }
    
    if (userid.length > 0) {
        [infoDic setValue:userid forKey:@"userID"];
    }
    [infoDic setValue:openid forKey:@"wxOpenId"];
    [infoDic setValue:phone forKey:@"phone"];
    [infoDic setValue:code forKey:@"checkCode"];
    [infoDic setValue:flag forKey:@"flag"];
    /*
     userID
     wxOpenId *
     phone *
     checkCode *
     flag 空：创建 非空：关联
     */
    [[STHUDManager sharedManager] showHUDInView:self.view];
    [[LoginDataHelper defaultHelper] requestForURLStr:@"" requestMethod:@"POST" info:infoDic andBlock:^(id response, NSError *error)  {
        [[STHUDManager sharedManager] hideHUDInView:weakSelf.view];
        if ([response isKindOfClass:[NSDictionary class]]) {
            if ([response[@"result"] boolValue]) {
                [self loginSuccessfully:response[@"data"]];
            }
            else
            {
                [weakSelf outputErrorInfo:response andDefault:@"操作失败"];
            }
        }
        else
        {
            kTipAlert(@"服务器异常");
        }
    }];
    
}

#pragma mark - 关联绑定成功

- (void)loginSuccessfully:(NSDictionary *)dic
{
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:wxUserid];
    //登录成功保存用户信息
    [[NSUserDefaults standardUserDefaults] setValue:[dic[@"uid"] stringValue] forKey:kUserid];
    [[NSUserDefaults standardUserDefaults] setValue:_phoneTf.text forKey:kPhone];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //登录完成显示首页
    [[NSNotificationCenter defaultCenter] postNotificationName:kTurnBackHomeNotification object:nil];
    //登录成功，需要做操作的界面接收此通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSucceedNotification object:nil];
    [self.navigationController popToRootViewControllerAnimated:NO];
    
    [[AppDelegate shareDelegate] showTabBar];
}

@end
