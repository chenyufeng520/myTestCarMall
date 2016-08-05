//
//  NewRegisterViewController.m
//  CarLife
//
//  Created by 陈宇峰 on 16/7/31.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import "NewRegisterViewController.h"
#import "ISTAgreementController.h"
#import "AppDelegate.h"
#import "NSObject+Common.h"
#import "NSObject+JDStatusBar.h"
#import "ISTVerifyCodeButton.h"
#import "LoginDataHelper.h"
#import "ISTButtonHelper.h"
#import "ActionSheetStringPicker.h"

static NSInteger phoneTag       = 3001;
static NSInteger codeTag        = 3002;
static NSInteger passwordTag    = 3003;
static NSInteger repasswordTag  = 3004;

@interface NewRegisterViewController ()<UITextFieldDelegate>
{
    UIButton *_AgreementBnt;
}

@property (nonatomic,strong) NSArray * showTitleArray;

@property (nonatomic, strong) UITextField *phoneTf;
@property (nonatomic, strong) UITextField *codeTf;
@property (nonatomic, strong) UITextField *passwordTf;
@property (nonatomic, strong) UITextField *repasswordTf;

@end

@implementation NewRegisterViewController

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
    
    [tbTop.btnTitle setTitle:@"注册" forState:UIControlStateNormal];
    
    [tbTop setLetfTitle:nil];
    [tbTop.btnLeft addTarget:self action:@selector(onClickTopBar:) forControlEvents:UIControlEventTouchUpInside];
    
    return tbTop;
}

-(void)configUI{
    
    _tbTop = [self creatTopBarView:kTopFrame];
    self.view.backgroundColor = kMainBGColor;
    [self.view addSubview:_tbTop];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreen_Width, 203)];
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
            [[LoginDataHelper defaultHelper] requestForURLStr:@"index.php" requestMethod:@"GET" info:@{@"m":@"Api",@"c":@"User",@"a":@"regHandle",@"user_username":_phoneTf.text,@"user_type":@"3"} andBlock:^(id response, NSError *error) {
                
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
    codeLb.text = @"用户类型";
    codeLb.textAlignment = NSTextAlignmentRight;
    [bgView addSubview:codeLb];
    
    _codeTf = [[UITextField alloc] initWithFrame:CGRectMake(100, line1.maxY, bgView.width-100, 50)];
    _codeTf.textColor = kDarkTextColor;
    _codeTf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _codeTf.font = kFontNormal;
    _codeTf.delegate = self;
    _codeTf.enabled = NO;
    _codeTf.tag = codeTag;
    _codeTf.placeholder = @"请选择用户类型";
    [bgView addSubview:_codeTf];
    
    UIImageView *arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(bgView.width - kAdjustLength(105), line1.maxY+ kAdjustLength(40), kAdjustLength(75), kAdjustLength(75))];
    arrowView.image = [UIImage imageNamed:@"arrowdown.png"];
    arrowView.contentMode = UIViewContentModeScaleAspectFit;
    [bgView addSubview:arrowView];
    
    BlockButton *ProviceBtn = [BlockButton buttonWithType:UIButtonTypeCustom];
    ProviceBtn.frame = _codeTf.frame;
    ProviceBtn.backgroundColor = [UIColor clearColor];
    [ProviceBtn setBlock:^(BlockButton *button){
        [weakSelf.view endEditing:YES];
        
        NSMutableArray *roleNameArr = [NSMutableArray arrayWithArray:@[@"物流队",@"汽修厂",@"个人车主／其他"]];
        
        [ActionSheetStringPicker showPickerWithTitle:@"用户类型" rows:roleNameArr initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
           
                _codeTf.text = roleNameArr[selectedIndex];
           
            
        } cancelBlock:nil origin:self.view];
    }];
    [bgView addSubview:ProviceBtn];
    
    
    
    UIView *line2 = [[UIView alloc] initLineWithFrame:CGRectMake(0, codeLb.maxY - kLinePixel, bgView.width, kLinePixel) color:kLineColor];
    [bgView addSubview:line2];
    
    UILabel *passwordLb = [[UILabel alloc]initWithFrame:CGRectMake(0, line2.maxY, 80, 50)];
    passwordLb.backgroundColor = [UIColor clearColor];
    passwordLb.textColor = kDarkTextColor;
    passwordLb.font = kFontNormal;
    passwordLb.text = @"验证密码";
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
    _passwordTf.placeholder = @"请输入密码";
    [bgView addSubview:_passwordTf];
    
    UIView *line3 = [[UIView alloc] initLineWithFrame:CGRectMake(0, passwordLb.maxY - kLinePixel, bgView.width, kLinePixel) color:kLineColor];
    [bgView addSubview:line3];
    
    UILabel *repasswordLb = [[UILabel alloc]initWithFrame:CGRectMake(0, line3.maxY, 80, 50)];
    repasswordLb.backgroundColor = [UIColor clearColor];
    repasswordLb.textColor = kDarkTextColor;
    repasswordLb.font = kFontNormal;
    repasswordLb.text = @"确认密码";
    repasswordLb.textAlignment = NSTextAlignmentRight;
    [bgView addSubview:repasswordLb];
    
    _repasswordTf = [[UITextField alloc] init];
    _repasswordTf.frame = CGRectMake(100, line3.maxY, bgView.width - 135, 50);
    _repasswordTf.textColor = kDarkTextColor;
    _repasswordTf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _repasswordTf.font = kFontLarge_1;
    _repasswordTf.text = @"";
    _repasswordTf.tag = repasswordTag;
    _repasswordTf.delegate = self;
    _repasswordTf.placeholder = @"请再次输入密码";
    [bgView addSubview:_repasswordTf];
    
    //登录按钮
    UIButton *registerBtn = [ISTButtonHelper buttonWithFrame:CGRectMake(10 , bgView.maxY + 15, self.view.width-20, 40) AndTitle:nil AndColor:kBlueColor AndSuperView:_contentView Andaction:@selector(registerBtnClick:) AndTarget:self WithButtonType:LZButtonTypeRoundedRect];
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    
    _AgreementBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    _AgreementBnt.frame = CGRectMake(10, registerBtn.bottom+10, 30, 30);
    [_AgreementBnt setImage:[UIImage imageNamed:@"login_unselectedSegment"] forState:UIControlStateNormal];
    [_AgreementBnt setImage:[UIImage imageNamed:@"login_selectedSegment"] forState:UIControlStateSelected];
    [_AgreementBnt addTarget:self action:@selector(AgreementBntClcik:) forControlEvents:UIControlEventTouchUpInside];
    
    //默认是选中的状态
    _AgreementBnt.selected = YES;
    _AgreementBnt.backgroundColor = [UIColor clearColor];
    [_contentView addSubview:_AgreementBnt];
    
    UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(_AgreementBnt.right+2, _AgreementBnt.origin.y, 0, _AgreementBnt.height)];
    label1.text = @"我已看过并同意";
    label1.font = kFontNormal;
    label1.textColor = kLightTextColor;
    label1.textAlignment = NSTextAlignmentLeft;
    [label1 sizeToFit];
    label1.frame = CGRectMake(_AgreementBnt.right+2, _AgreementBnt.origin.y,label1.width , _AgreementBnt.height);
    [_contentView addSubview:label1];
    
    
    UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(label1.right, label1.origin.y, 0, label1.height)];
    label2.text = @"《用户使用协议》";
    label2.font = kFontNormal;
    label2.textColor =  RGBCOLOR(203, 54, 55);;
    label2.textAlignment = NSTextAlignmentLeft;
    [label2 sizeToFit];
    label2.frame = CGRectMake(label1.right, _AgreementBnt.origin.y,label2.width , _AgreementBnt.height);
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(readAgreementClick:)];
    [label2 addGestureRecognizer:tap];
    label2.userInteractionEnabled = YES;
    [_contentView addSubview:label2];
    
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

//注册
-(void)registerBtnClick:(UIButton*)sender{
    
    [self.view endEditing:YES];
    
    if (![NSObject isPhoneNumber:_phoneTf.text]) {
        kTipAlert(@"手机号码错误");
        return;
    }
    if (![_passwordTf.text isEqualToString:_repasswordTf.text] && _passwordTf.text.length > 0) {
        kTipAlert(@"二次输入密码不一致");
        return;
    }
    
    if (_codeTf.text.length == 0) {
        kTipAlert(@"请选择用户类型");
        return;
    }
    
    __weak typeof(self) weakSelf = self;

        if (!_AgreementBnt.selected) {
            kTipAlert(@"请阅读并同意用户协议");
            return;
        }
    
    [[STHUDManager sharedManager] showHUDInView:self.view];
    [[LoginDataHelper defaultHelper] requestForURLStr:@"index.php" requestMethod:@"GET" info:@{@"m":@"Api",@"c":@"User",@"a":@"loginHandle",@"user_username":_phoneTf.text,@"user_pwd":_passwordTf.text} andBlock:^(id response, NSError *error) {
        [[STHUDManager sharedManager] hideHUDInView:weakSelf.view];
        
        if ([response isKindOfClass:[NSDictionary class]]) {
            int status = [response[@"status"] intValue];
            
            if (status == 200) {
                //登录环信
               [weakSelf registEMService];
                //请求成功，处理结果
                [weakSelf loginSuccessfully:response[@"data"]];
            }
            else
            {
                KTipView(@"注册失败");
            }
        }
        else
        {
            KTipView(@"注册失败");
        }
    }];


}

/** 新用户注册环信*/
- (void)registEMService{
    EMError *error = [[EMClient sharedClient] registerWithUsername:_phoneTf.text password:_phoneTf.text];
    if (!error) {
        [[EMClient sharedClient] loginWithUsername:_phoneTf.text password:_phoneTf.text];
    }
}

- (void)loginSuccessfully:(NSDictionary *)dic
{
    //登录成功保存用户信息
    [[NSUserDefaults standardUserDefaults] setValue:[dic[@"userID"] stringValue] forKey:kUserid];
    [[NSUserDefaults standardUserDefaults] setValue:_passwordTf.text forKey:kPassword];
    [[NSUserDefaults standardUserDefaults] setValue:_phoneTf.text forKey:kPhone];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //登录完成显示首页
    [[NSNotificationCenter defaultCenter] postNotificationName:kTurnBackHomeNotification object:nil];
    //登录成功，需要做操作的界面接收此通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSucceedNotification object:nil];
    [self.navigationController popViewControllerAnimated:NO];
    
    [[AppDelegate shareDelegate] showTabBar];
}


//是否同意协议
-(void)AgreementBntClcik:(UIButton * )sender{
    sender.selected = !sender.selected;
    
}

//阅读协议
-(void)readAgreementClick:(UITapGestureRecognizer*)tap{
    ISTAgreementController *vc = [[ISTAgreementController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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
