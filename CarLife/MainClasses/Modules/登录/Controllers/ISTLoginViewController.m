//
//  ISTLoginViewController.m
//  Project
//
//  Created by MiaoLizhuang on 15/10/20.
//  Copyright © 2015年 高大鹏. All rights reserved.
//

#import "ISTLoginViewController.h"
#import "ISTRegisterViewController.h"
#import "ISTAccountBindViewController.h"
#import "AppDelegate.h"
#import "LoginDef.h"
#import "WXApi.h"
#import "ISTButtonHelper.h"
#import "LoginDataHelper.h"
#import "WXLoginModel.h"

@interface ISTLoginViewController ()
@property (nonatomic,copy) NSString * access_token;
@property (nonatomic,copy) NSString *openid;
@property (nonatomic,copy) NSString *refresh_token;


@property (nonatomic,strong) UILabel * nameLabel;
@property (nonatomic,strong) UIImageView * headerImageView;
@property (nonatomic,strong) UIButton * weixinBnt;
@property (nonatomic,strong) UIButton * leftBnt;
@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UITextField *pwdTextField;
@property (nonatomic, strong) UIButton *btnCloseKeyboard;   // 关闭键盘
@property (nonatomic) CGFloat keyboardHeight;               // 键盘高度
@end

@implementation ISTLoginViewController
{
     UIScrollView *_mainView;
}
- (id)init{
    self = [super init];
    if (self) {
        // 键盘监听
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(getAccess_token:) name:@"WexinLogin"
                                                   object:nil];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _mainView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.iosChangeFloat , kScreen_Width, kScreen_Height - self.iosChangeFloat)];
    _mainView.showsHorizontalScrollIndicator = NO;
    _mainView.showsVerticalScrollIndicator = NO;
    _mainView.backgroundColor = kMainBGColor;
    [self.view addSubview:_mainView];
    [self configUI];
    
    // 键盘关闭按钮
    UIImage *imgClose = [UIImage imageNamed:@"keboard_off_btn"];
    _btnCloseKeyboard = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width - imgClose.size.width, self.view.height, imgClose.size.width + 10, imgClose.size.height + 10)];
    [_btnCloseKeyboard setImage:imgClose forState:UIControlStateNormal];
    [_btnCloseKeyboard addTarget:self action:@selector(onClickCloseKeyboard) forControlEvents:UIControlEventTouchUpInside];
    _btnCloseKeyboard.alpha = 0;
    [self.view addSubview:_btnCloseKeyboard];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//初始化登录页面
- (void)configUI{
    
    UIView *statusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, self.iosChangeFloat)];
    statusView.backgroundColor = kMainBGColor;
    [self.view addSubview:statusView];
    
    UIImageView * companyLogo = [[UIImageView alloc]initWithFrame:CGRectMake(0, kAdjustLength(400), self.view.width, kAdjustLength(300))];
    companyLogo.backgroundColor = [UIColor clearColor];
    companyLogo.contentMode = UIViewContentModeScaleAspectFit;
    companyLogo.image = [UIImage imageNamed:@"logo.png"];
    [_mainView addSubview:companyLogo];
    
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(10, companyLogo.bottom+15, self.view.width-2*10, kAdjustLength(320))];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.cornerRadius = 5.0;
    [_mainView addSubview:backView];
    
    UILabel * sepLine = [[UILabel alloc]initWithFrame:CGRectMake(0, backView.height/2.0-0.25, backView.width, 0.5)];
    sepLine.backgroundColor = kMainBGColor;
    [backView addSubview:sepLine];
    
    
    UIImageView *userNameView = [[UIImageView alloc] initWithFrame:CGRectMake(10, ((backView.height-0.5)/2.0-40)/2.0, 40, 40)];
    userNameView.image = [UIImage imageNamed:@"icons-iphoe"];
    userNameView.backgroundColor = [UIColor clearColor];
    userNameView.userInteractionEnabled = YES;
    [backView addSubview:userNameView];

    
    UIImageView *passwordView = [[UIImageView alloc] initWithFrame:CGRectMake(10, sepLine.bottom+((backView.height-0.5)/2.0-40)/2.0, 40, 40)];
    passwordView.image = [UIImage imageNamed:@"icons-lock"];
    passwordView.backgroundColor = [UIColor clearColor];
    passwordView.userInteractionEnabled = YES;
    [backView addSubview:passwordView];

    NSString *phone = [[NSUserDefaults standardUserDefaults] objectForKey:kPhone];
   
    _nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(userNameView.right+5, 0, backView.width-userNameView.right , (backView.height-0.5)/2.0)];
    _nameTextField.placeholder = @"用户名";
    _nameTextField.text = phone;
    _nameTextField.textColor = kLightTextColor;
    _nameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [_nameTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [_nameTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_nameTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    _nameTextField.font = kFontNormal;
    [backView addSubview:_nameTextField];

    _pwdTextField = [[UITextField alloc] initWithFrame:CGRectMake(passwordView.right+5 , sepLine.bottom, backView.width-userNameView.right-100 , (backView.height-0.5)/2.0)];
    _pwdTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _pwdTextField.placeholder = @"密码";
    _pwdTextField.textColor = kLightTextColor;
    [_pwdTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [_pwdTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_pwdTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    _pwdTextField.secureTextEntry = YES;
    _pwdTextField.font = kFontNormal;
    _pwdTextField.keyboardType = UIKeyboardTypeASCIICapable;
    [backView addSubview:_pwdTextField];
    
    BOOL rememberPWD = [[NSUserDefaults standardUserDefaults] boolForKey:kRememberPWD];
    if (rememberPWD) {
        _pwdTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:kPassword];
    }
   
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(_pwdTextField.right+5, (_pwdTextField.height-30)/2.0+sepLine.bottom, 80, 30);
    [btn setTitle:@"记住密码" forState:UIControlStateNormal];
    [btn setTitleColor:kBlueColor forState:UIControlStateNormal];
    [btn setTitleColor:kWhiteColor forState:UIControlStateSelected];
    [btn setBackgroundImage:[UIImage imageWithColor:kWhiteColor size:btn.size] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageWithColor:kBlueColor size:btn.size] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(remmberPassWdBntClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = kFontMiddle;
    [btn setRoundCorner];
    btn.selected = rememberPWD;
    [backView addSubview:btn];
    
    //登录按钮
    UIButton *loginBtn = [ISTButtonHelper buttonWithFrame:CGRectMake(10 , backView.bottom+15, backView.width, 40) AndTitle:@"登录" AndColor:kBlueColor AndSuperView:_mainView Andaction:@selector(onLoginResponse) AndTarget:self WithButtonType:LZButtonTypeRoundedRect];
    
    //账号注册
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.frame = CGRectMake(10, loginBtn.bottom+14, 80, 30);
    registerBtn.titleLabel.font = kFontNormal;
    [registerBtn setTitleColor:kDarkTextColor forState:UIControlStateNormal];
    [registerBtn setTitle:@"账号注册" forState:UIControlStateNormal];
    registerBtn.contentMode = UIViewContentModeLeft;
    [registerBtn addTarget:self action:@selector(registerUser:) forControlEvents:(UIControlEventTouchUpInside)];
    [_mainView addSubview:registerBtn];
    
     //忘记密码
    UIButton *forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetBtn.frame = CGRectMake(kScreen_Width - 10 - 80, loginBtn.bottom + 14, 80, 30);
    forgetBtn.titleLabel.font = kFontNormal;
    [forgetBtn setTitleColor:kDarkTextColor forState:UIControlStateNormal];
    [forgetBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [forgetBtn addTarget:self action:@selector(forgetBntClick:) forControlEvents:UIControlEventTouchUpInside];
     registerBtn.contentMode = UIViewContentModeRight;
    [_mainView addSubview:forgetBtn];
    
    
//    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, _mainView.maxY, _mainView.width, 60)];
//    bottomView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:bottomView];
    
    
    UIButton * wxLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    wxLogin.frame = CGRectMake(_mainView.centerX - kAdjustLength(100), forgetBtn.maxY + 20, kAdjustLength(200), kAdjustLength(200));
    [wxLogin addTarget:self action:@selector(wxloginClick:) forControlEvents:UIControlEventTouchUpInside];
    [wxLogin setImage:[UIImage imageNamed:@"icons-wechat"] forState:UIControlStateNormal];
    [_mainView addSubview:wxLogin];
    
    [_mainView setContentSize:CGSizeMake(_mainView.width, wxLogin.maxY + 20)];
//    UIImageView *imageView = [[UIImageView alloc] init];
//    imageView.image = [UIImage imageNamed:@"icons-wechat"];
//    [bottomView addSubview:imageView];
//    imageView.userInteractionEnabled = YES;
//    
//    UILabel * wxLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageView.right+5, 0, 0, 60)];
//    wxLabel.frame = CGRectMake(imageView.right+5, 0, wxLabel.width, 60);
//    wxLabel.font = kFontNormal;
//    wxLabel.textColor = kDarkTextColor;
//    wxLabel.text = @"微信账号登陆";
//    wxLabel.backgroundColor = [UIColor clearColor];
//    [wxLabel sizeToFit];
//    [bottomView addSubview:wxLabel];
//    imageView.frame = CGRectMake((self.view.width-( 40+5+wxLabel.width))/2.0, 10, 40, 40);
//    
//    UIButton * wxLogin = [UIButton buttonWithType:UIButtonTypeCustom];
//    wxLogin.frame = bottomView.bounds;
//    [wxLogin addTarget:self action:@selector(wxloginClick:) forControlEvents:UIControlEventTouchUpInside];
//    [bottomView addSubview:wxLogin];
   
}

-(void)refreshUIWithInfo:(NSDictionary*)info{
//    self.nameLabel.text = [info objectForKey:@"openid"];
//    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:[info objectForKey:@"headimgurl"]] placeholderImage:nil];
//    self.weixinBnt.hidden = YES;
    [[NSUserDefaults standardUserDefaults] setObject:info forKey:wxUserInfo];
    
}

#pragma  mark -  Actions
-(void)wxloginClick:(UIButton *)sender{

    //每次微信登录都重新授权
    SendAuthReq* req =[[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo,snsapi_base";
    req.state = @"Project" ;
    [WXApi sendReq:req];
    
    [[STHUDManager sharedManager] showHUDInView:self.view];
    
    //刷新微信token，不重新授权
//    NSString *access_token = [[NSUserDefaults standardUserDefaults] objectForKey:wxAccessTokenKey];
//    NSString *openid = [[NSUserDefaults standardUserDefaults] objectForKey:wxOpenIdKey];
//    NSString *refresh_token = [[NSUserDefaults standardUserDefaults] objectForKey:wxRefreshTokenKey];
//    
//    if (openid == nil || access_token == nil || refresh_token == nil) {
//        SendAuthReq* req =[[SendAuthReq alloc] init];
//        req.scope = @"snsapi_userinfo,snsapi_base";
//        req.state = @"Project" ;
//        [WXApi sendReq:req];
//    }
//    else
//    {
//        __weak typeof(self) weakSelf = self;
//        [WXLoginModel validAccess_token:access_token AndOpenid:openid CallBack:^(BOOL success, NSString *message, NSDictionary *info) {
//            if (success) {
//                [WXLoginModel getUserInfoWithToken:access_token AndOpenid:openid CallBack:^(BOOL success, NSString *message, NSDictionary *info) {
//                    if (success == YES) {
//                        NSLog(@"%@",info);
//                        [[NSUserDefaults standardUserDefaults] setObject:info[@"headimgurl"] forKey:kwxHeadImg];
//                        [[NSUserDefaults standardUserDefaults] setObject:info[@"nickname"] forKey:kwxNickName];
//                        [[NSUserDefaults standardUserDefaults] synchronize];
//                        
//                        [weakSelf wxLoginResponse:openid];
//                    }
//                }];
//            }
//            else
//            {
//                [WXLoginModel refreshAccess_token:refresh_token AndAppKey:wxAppKey CallBack:^(BOOL success, NSString *message, NSDictionary *info) {
//                    if (success == YES) {
//                        NSLog(@"%@",info);
//                        
//                        weakSelf.access_token = [info objectForKey:@"access_token"];
//                        weakSelf.openid = [info objectForKey:@"openid"];
//                        weakSelf.refresh_token = info[@"refresh_token"];
//                        
//                        [[NSUserDefaults standardUserDefaults] setObject:weakSelf.openid forKey:wxOpenIdKey];
//                        [[NSUserDefaults standardUserDefaults] setObject:weakSelf.access_token forKey:wxAccessTokenKey];
//                        [[NSUserDefaults standardUserDefaults] setObject:weakSelf.refresh_token forKey:wxRefreshTokenKey];
//                        [[NSUserDefaults standardUserDefaults] synchronize];
//                        
//                        [WXLoginModel getUserInfoWithToken:weakSelf.access_token AndOpenid:weakSelf.openid CallBack:^(BOOL success, NSString *message, NSDictionary *info) {
//                            if (success == YES) {
//                                NSLog(@"%@",info);
//                                [[NSUserDefaults standardUserDefaults] setObject:info[@"headimgurl"] forKey:kwxHeadImg];
//                                [[NSUserDefaults standardUserDefaults] setObject:info[@"nickname"] forKey:kwxNickName];
//                                [[NSUserDefaults standardUserDefaults] synchronize];
//                                
//                                [weakSelf wxLoginResponse:weakSelf.openid];
//                                // [self refreshUIWithInfo:info];
//                            }
//                        }];
//                        
//                    }
//                }];
//            }
//        }];
//    }
}

-(void)getAccess_token:(NSNotification*)noti
{
    __weak typeof(self) weakSelf = self;
    [WXLoginModel getWeiXiTokenWithCode:noti.userInfo[@"code"] AndAppKey:wxAppKey AndSecret:wxSecret CallBack:^(BOOL success, NSString *message, NSDictionary *info) {
        if (success ==YES) {
            weakSelf.access_token = [info objectForKey:@"access_token"];
            weakSelf.openid = [info objectForKey:@"openid"];
            weakSelf.refresh_token = info[@"refresh_token"];
            
            [[NSUserDefaults standardUserDefaults] setObject:weakSelf.openid forKey:wxOpenIdKey];
            [[NSUserDefaults standardUserDefaults] setObject:weakSelf.access_token forKey:wxAccessTokenKey];
            [[NSUserDefaults standardUserDefaults] setObject:weakSelf.refresh_token forKey:wxRefreshTokenKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [WXLoginModel getUserInfoWithToken:weakSelf.access_token AndOpenid:weakSelf.openid CallBack:^(BOOL success, NSString *message, NSDictionary *info) {
                if (success == YES) {
                    NSLog(@"%@",info);
                    [[NSUserDefaults standardUserDefaults] setObject:info[@"headimgurl"] forKey:kwxHeadImg];
                    [[NSUserDefaults standardUserDefaults] setObject:info[@"nickname"] forKey:kwxNickName];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    [weakSelf wxLoginResponse:weakSelf.openid];
                }
            }];
        }
    }];
}


- (void)wxLoginResponse:(NSString *)openid
{
    /*
        调用接口判断openid是否已经存在？
        1、 如果存在，判断是否有手机号码：
            1）有手机号码->根据返回的user信息直接登录
            2）无手机号码->显示绑定页面，页面按钮：快速注册
        2、如果不存在，显示绑定页面，页面按钮：快速注册、账号关联
     */
    
    __weak typeof(self) weakSelf = self;
//    [[STHUDManager sharedManager] showHUDInView:self.view];
    [[LoginDataHelper defaultHelper] requestForURLStr:@"" requestMethod:@"POST" info:@{@"wxOpenId":openid} andBlock:^(id response, NSError *error)  {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[STHUDManager sharedManager] hideHUDInView:weakSelf.view];
            if ([response isKindOfClass:[NSDictionary class]]) {
                if ([response[@"result"] boolValue]) {
                    [weakSelf loginSuccessfully:response[@"data"]];
                }
                else
                {
                    NSString *wxopenid = response[@"data"][@"wxopenID"];
                    if (wxopenid.length > 0) {
                        //存在openid
                        [[NSUserDefaults standardUserDefaults] setValue:[response[@"data"][@"userID"] stringValue] forKey:wxUserid];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        
                        //完善个人信息
                        ISTAccountBindViewController *theVC = [[ISTAccountBindViewController alloc] init];
                        theVC.canRelate = NO;
                        [self.navigationController pushViewController:theVC animated:YES];
                    }
                    else
                    {
                        
                        //不存在openid
                        ISTAccountBindViewController *theVC = [[ISTAccountBindViewController alloc] init];
                        theVC.canRelate = YES;
                        [self.navigationController pushViewController:theVC animated:YES];
                    }
                }
            }
            else
            {
                kTipAlert(@"服务器异常");
            }
        });
    }];
}

//注册账号
-(void)registerUser:(UIButton *)sender{
    
    ISTRegisterViewController * registerVC = [[ISTRegisterViewController alloc]init];
    registerVC.Navtitle = @"注册";
    [self.navigationController pushViewController:registerVC animated:YES];
}
-(void)cancleLogin:(UIButton*)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)forgetBntClick:(UIButton*)sender{
    ISTRegisterViewController * registerVC = [[ISTRegisterViewController alloc]init];
    registerVC.Navtitle = @"重置密码";
    [self.navigationController pushViewController:registerVC animated:YES];
}
//回收键盘
- (void)onClickCloseKeyboard{
    [self.view endEditing:YES];
}

//登录按钮响应
- (void)onLoginResponse{
    [self.view endEditing:YES];
    
    if ([self canLogin]) {
        
        __weak typeof(self) weakSelf = self;
        [[STHUDManager sharedManager] showHUDInView:self.view];
        [[LoginDataHelper defaultHelper] requestForURLStr:@"index.php" requestMethod:@"GET" info:@{@"m":@"Api",@"c":@"User",@"a":@"loginHandle",@"user_username":_nameTextField.text,@"user_pwd":_pwdTextField.text} andBlock:^(id response, NSError *error) {
            [[STHUDManager sharedManager] hideHUDInView:weakSelf.view];
            
            if ([response isKindOfClass:[NSDictionary class]]) {
                int status = [response[@"status"] intValue];
                
                if (status == 200) {
                    //请求成功，处理结果
                    [weakSelf loginSuccessfully:response[@"data"]];
                }
                else
                {
                    [weakSelf outputErrorInfo:response andDefault:@"登录失败"];
                }
            }
            else
            {
                   [weakSelf outputErrorInfo:nil andDefault:@"请求数据失败"];
            }
        }];

    }

}

-(void)remmberPassWdBntClick:(UIButton*)sender{

    sender.selected = !sender.selected;
    
    [[NSUserDefaults standardUserDefaults] setBool:sender.selected forKey:kRememberPWD];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - 登录成功

- (void)loginSuccessfully:(NSDictionary *)dic
{
    [[STHUDManager sharedManager] hideHUDInView:self.view];
    
    User *user = [[User alloc] init];
    user.uid = dic[@"uid"];
    user.user_email = dic[@"user_email"];
    user.user_nickname = dic[@"user_nickname"];
    user.user_phone = dic[@"user_phone"];
    user.user_time = dic[@"user_time"];
    user.user_type = dic[@"user_type"];
    user.user_username = dic[@"user_username"];
    
     NSData *userObj = [NSKeyedArchiver archivedDataWithRootObject:user];
    [[NSUserDefaults standardUserDefaults] setObject:userObj forKey:kUSERINFO];

    NSString *userid = [NSString stringWithFormat:@"%.0lf",[dic[@"uid"] doubleValue]];
    [[NSUserDefaults standardUserDefaults] setObject:userid forKey:kUserid];
    [[NSUserDefaults standardUserDefaults] setValue:_pwdTextField.text forKey:kPassword];
    [[NSUserDefaults standardUserDefaults] setValue:_nameTextField.text forKey:kPhone];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //登录完成显示首页
    [[NSNotificationCenter defaultCenter] postNotificationName:kTurnBackHomeNotification object:nil];
    //登录成功，需要做操作的界面接收此通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSucceedNotification object:nil];
    [[AppDelegate shareDelegate] showTabBar];
    
}

#pragma mark - 键盘相关
#pragma mark - Keyboard
- (void)keyboardWillShow:(NSNotification *)notification {
    // 获取键盘高度 和 动画速度
    NSDictionary *userInfo = [notification userInfo];
    CGFloat keyboardHeight = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    CGFloat animateSpeed = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    // 过滤重复
    if (_keyboardHeight == keyboardHeight)
        return;
    _keyboardHeight = keyboardHeight;
    
    UIView *vFirstResponder = [self.view subviewWithFirstResponder];
    CGRect vFirstResponderRect = [_mainView convertRect:vFirstResponder.frame fromView:vFirstResponder.superview];
    vFirstResponderRect.origin.y = vFirstResponderRect.origin.y - _mainView.contentOffset.y; // 标题栏占位偏移
    
    if (vFirstResponder) {
        [UIView animateWithDuration:animateSpeed animations:^{
            _btnCloseKeyboard.maxY = self.view.height - keyboardHeight + 5;
            _btnCloseKeyboard.alpha = 1;
            
            _mainView.contentInset = UIEdgeInsetsMake(_mainView.contentInset.top, 0, keyboardHeight, 0);
            _mainView.scrollIndicatorInsets = _mainView.contentInset;
            CGFloat offsetHeight = _mainView.height - keyboardHeight - (vFirstResponderRect.origin.y + vFirstResponderRect.size.height);
            if(offsetHeight < 0)
                _mainView.contentOffset = CGPointMake(0, _mainView.contentOffset.y - offsetHeight); // 标题栏占位偏移
        }];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    if (_keyboardHeight == 0)
        return;
    
    // 获取键盘高度 和 动画速度
    NSDictionary *userInfo = [notification userInfo];
    CGFloat animateSpeed = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    _keyboardHeight = 0;
    
    [UIView animateWithDuration:animateSpeed animations:^{
        _btnCloseKeyboard.maxY = self.view.height;
        _btnCloseKeyboard.alpha = 0;
        
        _mainView.contentInset = UIEdgeInsetsMake(_mainView.contentInset.top, 0, 0, 0);
        _mainView.scrollIndicatorInsets = _mainView.contentInset;
    }];
}
#pragma mark - 信息验证

-(BOOL)isValidateMobile:(NSString* )mobileNumber
{
    NSString *mobileStr = @"^((145|147)|(15[^4])|(17[6-8])|((13|18)[0-9]))\\d{8}$";
    NSPredicate *cateMobileStr = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",mobileStr];
    
    if ([cateMobileStr evaluateWithObject:mobileNumber]==YES)
    {
        return YES;
    }
    return NO;
}


- (BOOL)canLogin
{
    if (_nameTextField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入手机号码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        return NO;
    }
    
    if (![self isValidateMobile:_nameTextField.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"手机号码有误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        return NO;
    }
    
    if (_nameTextField.text.length == 0 || _pwdTextField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        return NO;
    }
    
    return YES;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
