

//
//  ForgetPassWordViewController.m
//  CarLife
//
//  Created by 陈宇峰 on 16/7/31.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import "ForgetPassWordViewController.h"
#import "ISTAgreementController.h"
#import "AppDelegate.h"
#import "NSObject+Common.h"
#import "NSObject+JDStatusBar.h"
#import "ISTVerifyCodeButton.h"
#import "LoginDataHelper.h"
#import "ISTButtonHelper.h"
#import "ActionSheetStringPicker.h"

static NSInteger phoneTag       = 4001;
static NSInteger codeTag        = 4002;
static NSInteger passwordTag    = 4003;
static NSInteger repasswordTag  = 4004;

@interface ForgetPassWordViewController ()<UITextFieldDelegate>
{
    UIButton *_AgreementBnt;
}

@property (nonatomic,strong) NSArray * showTitleArray;

@property (nonatomic, strong) UITextField *phoneTf;
@property (nonatomic, strong) UITextField *codeTf;
@property (nonatomic, strong) UITextField *passwordTf;
@property (nonatomic, strong) UITextField *repasswordTf;

@end

@implementation ForgetPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _contentView.height += kTabBarHeight;
    // Do any additional setup after loading the view.
    [self configUI];
}

- (ISTTopBar *)creatTopBarView:(CGRect)frame
{
    // 导航头
    ISTTopBar *tbTop = [[ISTTopBar alloc] initWithFrame:frame];
    
    [tbTop.btnTitle setTitle:@"修改密码" forState:UIControlStateNormal];
    
    [tbTop setLetfTitle:nil];
    [tbTop.btnLeft addTarget:self action:@selector(onClickTopBar:) forControlEvents:UIControlEventTouchUpInside];
    
    return tbTop;
}

-(void)configUI{
    
    _tbTop = [self creatTopBarView:kTopFrame];
    self.view.backgroundColor = kMainBGColor;
    [self.view addSubview:_tbTop];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreen_Width, 152)];
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
    _phoneTf.tag = phoneTag;
    _phoneTf.delegate = self;
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
            
            [button startTimer];
            [[LoginDataHelper defaultHelper] requestForURLStr:@"index.php" requestMethod:@"GET" info:@{@"m":@"Api",@"c":@"User",@"a":@"getpwd",@"phone":_phoneTf.text} andBlock:^(id response, NSError *error) {
                
                if ([response isKindOfClass:[NSDictionary class]]) {
                    int status = [response[@"status"] intValue];
                    
                    if (status == 200) {
                        [[STHUDManager sharedManager] showHUD];
                        [STHUDManager sharedManager].HUD.margin = 15.0f;
                        [STHUDManager sharedManager].HUD.center = weakSelf.view.center;
                        [[STHUDManager sharedManager] hideHUDWithLabel:@"获取中..." afterDelay:1];
                        //请求成功，处理结果
                    }
                    else
                    {
                        [button stopTimer];
                        KTipView(@"验证密码获取失败");
                    }
                }
                else
                {
                    [button stopTimer];
                    KTipView(@"验证密码获取失败");
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
    _codeTf.tag = codeTag;
    _codeTf.delegate = self;
    _codeTf.keyboardType = UIKeyboardTypeNumberPad;
    _codeTf.placeholder = @"请输入验证码";
    [bgView addSubview:_codeTf];
    
    UIView *line2 = [[UIView alloc] initLineWithFrame:CGRectMake(0, codeLb.maxY - kLinePixel, bgView.width, kLinePixel) color:kLineColor];
    [bgView addSubview:line2];
    
    UILabel *passwordLb = [[UILabel alloc]initWithFrame:CGRectMake(0, line2.maxY, 80, 50)];
    passwordLb.backgroundColor = [UIColor clearColor];
    passwordLb.textColor = kDarkTextColor;
    passwordLb.font = kFontNormal;
    passwordLb.text = @"新密码";
    passwordLb.textAlignment = NSTextAlignmentRight;
    [bgView addSubview:passwordLb];
    
    _passwordTf = [[UITextField alloc] init];
    _passwordTf.frame = CGRectMake(100, line2.maxY, bgView.width - 135, 50);
    _passwordTf.textColor = kDarkTextColor;
    _passwordTf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _passwordTf.font = kFontLarge_1;
    _passwordTf.text = @"";
    _passwordTf.tag = passwordTag;
    _passwordTf.delegate = self;
    _passwordTf.placeholder = @"请输入新密码";
    [bgView addSubview:_passwordTf];
    
//    UIView *line3 = [[UIView alloc] initLineWithFrame:CGRectMake(0, passwordLb.maxY - kLinePixel, bgView.width, kLinePixel) color:kLineColor];
//    [bgView addSubview:line3];
//    
//    UILabel *repasswordLb = [[UILabel alloc]initWithFrame:CGRectMake(0, line3.maxY, 80, 50)];
//    repasswordLb.backgroundColor = [UIColor clearColor];
//    repasswordLb.textColor = kDarkTextColor;
//    repasswordLb.font = kFontNormal;
//    repasswordLb.text = @"确认密码";
//    repasswordLb.textAlignment = NSTextAlignmentRight;
//    [bgView addSubview:repasswordLb];
//    
//    _repasswordTf = [[UITextField alloc] init];
//    _repasswordTf.frame = CGRectMake(100, line3.maxY, bgView.width - 135, 50);
//    _repasswordTf.textColor = kDarkTextColor;
//    _repasswordTf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//    _repasswordTf.font = kFontLarge_1;
//    _repasswordTf.text = @"";
//    _repasswordTf.tag = repasswordTag;
//    _repasswordTf.delegate = self;
//    _repasswordTf.placeholder = @"请再次输入密码";
//    [bgView addSubview:_repasswordTf];
    
    //登录按钮
    UIButton *registerBtn = [ISTButtonHelper buttonWithFrame:CGRectMake(10 , bgView.maxY + 15, self.view.width-20, 40) AndTitle:nil AndColor:kBlueColor AndSuperView:_contentView Andaction:@selector(registerBtnClick:) AndTarget:self WithButtonType:LZButtonTypeRoundedRect];
    [registerBtn setTitle:@"确认修改" forState:UIControlStateNormal];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Actions
- (void)onClickTopBar:(UIButton *)btn
{
    if (btn.tag == BSTopBarButtonLeft) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else if (btn.tag == BSTopBarButtonRight) {
        
    }
}

//修改密码
-(void)registerBtnClick:(UIButton*)sender{
    
    [self.view endEditing:YES];
    
    if (![NSObject isPhoneNumber:_phoneTf.text]) {
        kTipAlert(@"手机号码错误");
        return;
    }
    if (_codeTf.text.length == 0) {
        kTipAlert(@"请输入验证码");
        return;
    }
    if (_passwordTf.text.length == 0) {
        kTipAlert(@"请输入新密码");
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    
    
    [[STHUDManager sharedManager] showHUDInView:self.view];
    [[LoginDataHelper defaultHelper] requestForURLStr:@"index.php" requestMethod:@"GET" info:@{@"m":@"Api",@"c":@"User",@"a":@"forgetPsdHandle",@"phone":_phoneTf.text,@"user_pwd":_passwordTf.text,@"code":_codeTf.text} andBlock:^(id response, NSError *error) {
        [[STHUDManager sharedManager] hideHUDInView:weakSelf.view];
        
        if ([response isKindOfClass:[NSDictionary class]]) {
            int status = [response[@"status"] intValue];
            
            if (status == 200) {
                KTipView(@"密码修改成功");
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                KTipView(@"密码修改失败");
            }
        }
        else
        {
            KTipView(@"密码修改失败");
        }
    }];
    
    
}


#pragma mark -UITextField Delegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == phoneTag) {
        _phoneTf.text = textField.text;
    }
    else if (textField.tag == codeTag) {
        _codeTf.text = textField.text;
    }
    else if (textField.tag == passwordTag) {
        _passwordTf.text = textField.text;
    }
    else if (textField.tag == repasswordTag) {
        _repasswordTf.text = textField.text;
    }
}

@end
