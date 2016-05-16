//
//  ISTLoginView.m
//  BSports
//
//  Created by 高大鹏 on 14/12/29.
//  Copyright (c) 2014年 ist. All rights reserved.
//

#import "ISTLoginView.h"
#import "BaseDataHelper.h"
#import "ISTAgreementController.h"
#import "LoginDataHelper.h"
#define Constant 999

@implementation ISTLoginView
{
    UIScrollView *_contentView;
    UIImageView *_barView;
    
    NSTimer *_timer;
    int _num;
    
    CGFloat _itemHeight, _itemWidth;
}

@synthesize phoneNumberField,passwordField,scodeField,repasswordField;
@synthesize actionBtn,fetchscodeBtn;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self loadSubviews];
    }
    return self;
}

- (id)initForgetModeFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        self.uitype = ForgetType;
        [self loadSubviews];
    }
    return self;
}

/** 导航栏 */
- (ISTTopBar *)creatTopBarView:(CGRect)frame
{
    // 导航头
    ISTTopBar *tbTop = [[ISTTopBar alloc] initWithFrame:frame];
    [tbTop.btnTitle setTitle:@"登录／注册" forState:UIControlStateNormal];
    
    [tbTop setLetfTitle:nil];
    [tbTop.btnLeft addTarget:self action:@selector(onClickTopBar:) forControlEvents:UIControlEventTouchUpInside];

    
    if(self.uitype == ForgetType){
        [tbTop.btnTitle setTitle:@"重置密码" forState:UIControlStateNormal];
    }
    
    
    return tbTop;
}

- (void)loadSubviews
{
    self.backgroundColor = RGBCOLOR(246, 246, 246);
    _itemHeight = kScreen_Width*162/1080;
    _itemWidth = kScreen_Width*920/1080;
    
    self.currentColumn = -1;
    self.animate = YES;
    self.animationType = PresentType;
    
    _tbTop = [self creatTopBarView:kTopFrame];
    [self addSubview:_tbTop];
    
    _contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _tbTop.maxY + 45, kScreen_Width, kScreen_Height - _tbTop.maxY - 45)];
    if(self.uitype == ForgetType){
        _contentView.frame = CGRectMake(0, _tbTop.maxY, kScreen_Width, kScreen_Height - _tbTop.maxY);
    }
    _contentView.contentSize = CGSizeMake(_contentView.width, 270);
    _contentView.backgroundColor = [UIColor clearColor];
    [self addSubview:_contentView];
    
    if(self.uitype == ForgetType){
        [self initRegisterView];
    }
    else{
        [self loadCustomNavigationBar];
    }
    
    //    [self bringSubviewToFront:_tbTop];
}

- (void)showWithType:(ColumnType)type
{
    if (_barView) {
        [_barView removeFromSuperview];
        _barView = nil;
    }
    
    _barView = [[UIImageView alloc] initWithFrame:CGRectMake(type * kScreen_Width/2,self.iosChangeFloat + kNavHeight + _itemHeight - 1, kScreen_Width/3,2)];
    _barView.center = CGPointMake((type*2 + 1) * kScreen_Width/4, _barView.centerY);
    _barView.backgroundColor = kDarkGreenColor;
    [self addSubview:_barView];
    
    [self resetBtnState];
    UIButton *btn = (UIButton *)[self viewWithTag:Constant + type];
    btn.selected = YES;
    
    switch (type) {
        case Column_Login:
        {
//            [_tbTop.btnTitle setTitle:@"登录" forState:UIControlStateNormal];
            [self initLoginView];
        }break;
        case Column_Register:
        {
//            [_tbTop.btnTitle setTitle:@"注册" forState:UIControlStateNormal];
            [self initRegisterView];
        }
            break;
            
        default:
            break;
    }
    
    _currentColumn = type;
}

- (void)loadCustomNavigationBar
{
    NSArray *arr = [NSArray arrayWithObjects:@"登录",@"注册", nil];
    float _x = 0.0f;
    for (int index = 0; index<[arr count]; index++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = RGBCOLOR(246, 246, 246);
        button.frame = CGRectMake(0+_x, self.iosChangeFloat + kNavHeight, kScreen_Width/[arr count], kScreen_Width*160/1080);
        button.tag = Constant + index;
        [button setTitleColor:RGBCOLOR(76, 73, 72) forState:UIControlStateNormal];
        [button setTitleColor:kDarkGreenColor forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        NSString *str = [arr objectAtIndex:index];
        [button setTitle:str forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        if (index == 0)
        {
            button.selected = YES;
        }
        [self addSubview:button];
        _x += kScreen_Width/[arr count];
    }
    
    UIView *line = [[UIView alloc] initLineWithFrame:CGRectMake(0,self.iosChangeFloat + kNavHeight + kScreen_Width*160/1080, kScreen_Width,1) color:kMainBGColor];
    [self addSubview:line];
    
    _barView = [[UIImageView alloc] initWithFrame:CGRectMake(0,self.iosChangeFloat + kNavHeight + kScreen_Width*160/1080-1, kScreen_Width/3,2)];
    _barView.center = CGPointMake(kScreen_Width/4, _barView.centerY);
    _barView.backgroundColor = kDarkGreenColor;
    [self addSubview:_barView];
    
    [self initLoginView];
    
}

#pragma mark - initViews

- (void)initLoginView
{
    if (_currentColumn == Column_Login) {
        return;
    }
    
    for (id elem in _contentView.subviews) {
        [elem removeFromSuperview];
    }
    
    UIImageView *userNameView = [[UIImageView alloc] initWithFrame:CGRectMake((self.width-_itemWidth)/2, 30, _itemWidth, _itemHeight)];
    userNameView.image = [UIImage imageNamed:@"username.png"];
    userNameView.backgroundColor = kWhiteColor;
    userNameView.userInteractionEnabled = YES;
    [_contentView addSubview:userNameView];
    
    self.phoneNumberField = [[UITextField alloc] initWithFrame:CGRectMake(kScreen_Width*130/1080, 0, userNameView.width - kScreen_Width *130/1080, _itemHeight)];
    phoneNumberField.backgroundColor = [UIColor clearColor];
    phoneNumberField.keyboardType = UIKeyboardTypeNumberPad;
    phoneNumberField.delegate = self;
    phoneNumberField.font = kFontNormal;
    phoneNumberField.placeholder = @"请输入手机号码";
    NSString *phone = [[NSUserDefaults standardUserDefaults] objectForKey:kPhone];
    if (phone) {
        phoneNumberField.text = phone;
    }
    [userNameView addSubview:self.phoneNumberField];
    
    
    UIImageView *passwordView = [[UIImageView alloc] initWithFrame:CGRectMake((self.width-_itemWidth)/2, userNameView.maxY + 10, _itemWidth, _itemHeight)];
    passwordView.image = [UIImage imageNamed:@"password.png"];
    passwordView.backgroundColor = kWhiteColor;
    passwordView.userInteractionEnabled = YES;
    [_contentView addSubview:passwordView];
    
    self.passwordField = [[UITextField alloc] initWithFrame:CGRectMake(kScreen_Width*130/1080, 0, userNameView.width - kScreen_Width *130/1080, _itemHeight)];
    passwordField.backgroundColor = [UIColor clearColor];
    //    passwordField.keyboardType = UIKeyboardTypeNumberPad;
    passwordField.font = kFontNormal;
    passwordField.placeholder = @"请输入密码";
    passwordField.secureTextEntry = YES;
    passwordField.delegate = self;
    [passwordView addSubview:self.passwordField];
    
    self.actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    actionBtn.frame = CGRectMake((self.width-_itemWidth)/2, passwordView.maxY + 10, _itemWidth, _itemHeight);
    [actionBtn setBackgroundColor:kDarkGreenColor];
    [actionBtn setTitle:@"登录" forState:UIControlStateNormal];
    actionBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [actionBtn addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:actionBtn];
    actionBtn.layer.cornerRadius = kCornerRadius;
    
    UIButton *forgot = [UIButton buttonWithType:UIButtonTypeCustom];
    forgot.frame = CGRectMake(actionBtn.minX, actionBtn.maxY, 80, 40);
    [forgot setTitleColor:kLightTextColor forState:UIControlStateNormal];
    [forgot setTitle:@"忘记密码？" forState:UIControlStateNormal];
    forgot.titleLabel.font = kFontMiddle;
    [forgot addTarget:self action:@selector(forgetPassord:) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:forgot];
}

-(void)initRegisterView
{
    if (_currentColumn == Column_Register) {
        return;
    }
    
    for (id elem in _contentView.subviews) {
        [elem removeFromSuperview];
    }
    
    
    self.phoneNumberField = [[UITextField alloc] initWithFrame:CGRectMake((self.width - _itemWidth)/2, 30, kScreen_Width * 616/1080, _itemHeight)];
    phoneNumberField.keyboardType = UIKeyboardTypeNumberPad;
    phoneNumberField.font = kFontNormal;
    phoneNumberField.placeholder = @"请输入手机号码";
    phoneNumberField.delegate = self;
    phoneNumberField.background = [UIImage imageNamed:@"zhuce_bg.png"];
    phoneNumberField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 5)];
    phoneNumberField.leftViewMode = UITextFieldViewModeAlways;
    phoneNumberField.leftView.userInteractionEnabled = NO;
    [_contentView addSubview:self.phoneNumberField];
    
    self.fetchscodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    fetchscodeBtn.frame = CGRectMake(self.width - (self.width - _itemWidth)/2 - kScreen_Width*280/1080, self.phoneNumberField.minY, kScreen_Width*280/1080, _itemHeight);
    [fetchscodeBtn setBackgroundColor:RGBCOLOR(230, 100, 10)];
    [fetchscodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [fetchscodeBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    fetchscodeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [fetchscodeBtn addTarget:self action:@selector(onClickGetIdentify:) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:fetchscodeBtn];
    fetchscodeBtn.layer.cornerRadius = kCornerRadius;
    
    
    self.scodeField = [[UITextField alloc] initWithFrame:CGRectMake((self.width - _itemWidth)/2, phoneNumberField.maxY + 10, _itemWidth, _itemHeight)];
    scodeField.font = kFontNormal;
    scodeField.placeholder = @"请输入验证码";
    scodeField.delegate = self;
    scodeField.background = [UIImage imageNamed:@"zhuce_bg.png"];
    scodeField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 5)];
    scodeField.leftViewMode = UITextFieldViewModeAlways;
    scodeField.leftView.userInteractionEnabled = NO;
    scodeField.keyboardType = UIKeyboardTypeNumberPad;
    [_contentView addSubview:self.scodeField];

    self.passwordField = [[UITextField alloc] initWithFrame:CGRectMake((self.width - _itemWidth)/2, scodeField.maxY + 10, _itemWidth, _itemHeight)];
    passwordField.font = kFontNormal;
    passwordField.placeholder = @"请输入密码";
    passwordField.secureTextEntry = YES;
    passwordField.delegate = self;
    passwordField.background = [UIImage imageNamed:@"zhuce_bg.png"];
    passwordField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 5)];
    passwordField.leftViewMode = UITextFieldViewModeAlways;
    passwordField.leftView.userInteractionEnabled = NO;
    [_contentView addSubview:self.passwordField];
    
    self.repasswordField = [[UITextField alloc] initWithFrame:CGRectMake((self.width - _itemWidth)/2, passwordField.maxY + 10, _itemWidth, _itemHeight)];
    repasswordField.font = kFontNormal;
    repasswordField.placeholder = @"请再次输入密码";
    repasswordField.secureTextEntry = YES;
    repasswordField.delegate = self;
    repasswordField.background = [UIImage imageNamed:@"zhuce_bg.png"];
    repasswordField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 5)];
    repasswordField.leftViewMode = UITextFieldViewModeAlways;
    repasswordField.leftView.userInteractionEnabled = NO;
    [_contentView addSubview:self.repasswordField];
    
    self.actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    actionBtn.frame = CGRectMake((self.width - _itemWidth)/2, repasswordField.maxY + 10, _itemWidth, _itemHeight);
    [actionBtn setBackgroundColor:kDarkGreenColor];
    [actionBtn setTitle:@"注册" forState:UIControlStateNormal];
    actionBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [actionBtn addTarget:self action:@selector(registerAccount:) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:actionBtn];
    actionBtn.layer.cornerRadius = kCornerRadius;
    
    
    if (self.uitype == ForgetType) {
        [actionBtn setTitle:@"提交" forState:UIControlStateNormal];
    }
    else
    {
        UILabel *declareLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.width - _itemWidth)/2, self.actionBtn.maxY + 20, _itemWidth, 20)];
        declareLabel.text = @"点击-提交,即表示您同意";
        declareLabel.textColor = kLightTextColor;
        declareLabel.font = kFontTiny;
        declareLabel.textAlignment = NSTextAlignmentRight;
        declareLabel.backgroundColor = [UIColor clearColor];
        [declareLabel sizeToFit];
        [_contentView addSubview:declareLabel];
        
        UIButton *declare = [UIButton buttonWithType:UIButtonTypeCustom];
        declare.frame = CGRectMake(declareLabel.maxX-2, declareLabel.minY-3, 150, 20);
        [declare setTitleColor:kDarkGreenColor forState:UIControlStateNormal];
        [declare setTitle:@"《使用条款及免责声明》" forState:UIControlStateNormal];
        [declare.titleLabel sizeToFit];
        declareLabel.textAlignment = NSTextAlignmentLeft;
        declare.titleLabel.font = kFontTiny;
        [declare addTarget:self action:@selector(userDeclare:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:declare];
    }
}

#pragma mark - 登录成功

- (void)loginSuccessfully:(NSDictionary *)dic
{
    //登录成功保存用户信息

    
    //登录成功，需要做操作的界面接收此通知
//    [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSucceedNotification object:nil];

     //返回：
    if(self.vc && self.uitype != ForgetType)
    {
        switch (_animationType) {
            case PresentType:
            {
                [self.vc dismissViewControllerAnimated:self.animate completion:^{
                    
                }];
            }break;
            case PushType:
            {
                [self.vc.navigationController popViewControllerAnimated:self.animate];
            }break;
            default:
                break;
        }
    }
}

#pragma mark - Click Methods
/** 顶栏点击事件 */
- (void)onClickTopBar:(UIButton *)btn
{
    if (btn.tag == BSTopBarButtonLeft) {
        [self turnBack:btn];
    }
    else if (btn.tag == BSTopBarButtonRight) {
        
    }
}

//返回
- (void)turnBack:(id)sender
{
    if(self.vc){
        switch (_animationType) {
            case PresentType:
            {
                [self.vc dismissViewControllerAnimated:self.animate completion:^{
                    
                }];
            }break;
            case PushType:
            {
                [self.vc.navigationController popViewControllerAnimated:self.animate];
            }break;
            default:
                break;
        }
        
    }
}

- (void)buttonPressed:(UIButton *)sender
{
    int column = sender.tag - Constant;
    if (_barView) {
        [_barView removeFromSuperview];
        _barView = nil;
    }
    _barView = [[UIImageView alloc] initWithFrame:CGRectMake(column * kScreen_Width/2,self.iosChangeFloat + kNavHeight + kScreen_Width*160/1080-1, kScreen_Width/3,2)];
    _barView.center = CGPointMake((column*2 + 1) * kScreen_Width/4, _barView.centerY);
    _barView.backgroundColor = kDarkGreenColor;
    [self addSubview:_barView];
    
    switch (column) {
        case 0:
        {
//            [_tbTop.btnTitle setTitle:@"登录" forState:UIControlStateNormal];
            [self initLoginView];
            _currentColumn = Column_Login;
        } break;
        case 1:
        {
//            [_tbTop.btnTitle setTitle:@"注册" forState:UIControlStateNormal];
            [self initRegisterView];
            _currentColumn = Column_Register;
        } break;
            
        default:
            break;
    }
    
    [self resetBtnState];
    sender.selected = YES;
}

- (void)resetBtnState
{
    for (id elem in self.subviews)
    {
        if ([elem isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)elem;
            btn.selected = NO;
        }
    }
}

//登录
- (void)login:(UIButton *)sender
{
    [self loginSuccessfully:nil];
//    if ([self canLogin]) {
//        [self endEditing:YES];
//        __weak typeof(self) weakSelf = self;
//        [[STHUDManager sharedManager] showHUDInView:self];
//        [[DataHelper defaultHelper] requestForType:NetWork_Login info:@{@"phone":self.phoneNumberField.text,@"pwd":self.passwordField.text} andBlock:^(id response, NSError *error) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [[STHUDManager sharedManager] hideHUDInView:self];
//                if ([response isKindOfClass:[NSDictionary class]]) {
//                    if ([response[@"result"] boolValue]) {
//                        [weakSelf loginSuccessfully:response[@"data"]];
//                    }
//                    else
//                    {
//                        NSString *msg = [response[@"msg"] isKindOfClass:[NSNull class]]?@"登录失败":response[@"msg"];
//                        kTipAlert(@"%@",msg);
//                    }
//                }
//                else
//                {
//                    kTipAlert(@"出错了");
//                }
//            });
//        }];
//    }
}

//注册
- (void)registerAccount:(UIButton *)sender
{
    if ([self canRegister])
    {
        [self endEditing:YES];
        
        [[STHUDManager sharedManager] showHUDInView:self];
        if(self.uitype == ForgetType){
            [self resetPassword:sender];
        }
        else{
            NSMutableDictionary *info = [NSMutableDictionary dictionary];
            [info setValue:phoneNumberField.text forKey:@"phone"];
            [info setValue:passwordField.text forKey:@"pwd"];
            [info setValue:scodeField.text forKey:@"validcode"];
            
            __weak typeof(self) weakSelf = self;
            [[LoginDataHelper defaultHelper] requestForURLStr:@"" requestMethod:@"POST" info:info andBlock:^(id response, NSError *error)  {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[STHUDManager sharedManager] hideHUDInView:self];
                    if ([response isKindOfClass:[NSDictionary class]]) {
                        if ([response[@"result"] boolValue]) {
                            [weakSelf loginSuccessfully:response[@"data"]];
                        }
                        else
                        {
                            NSString *msg = [response[@"msg"] isKindOfClass:[NSString class]]?response[@"msg"]:@"注册失败";
                            kTipAlert(@"%@",msg);
                        }
                    }
                    else
                    {
                        kTipAlert(@"注册失败！");
                    }
                });
            }];
        }
    }
}

//修改密码
- (void)resetPassword:(UIButton *)sender
{
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setValue:phoneNumberField.text forKey:@"phone"];
    [info setValue:passwordField.text forKey:@"npwd"];
    [info setValue:scodeField.text forKey:@"validcode"];
    
    __weak typeof(self) weakSelf = self;
    [[LoginDataHelper defaultHelper] requestForURLStr:@"" requestMethod:@"POST" info:info andBlock:^(id response, NSError *error)  {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[STHUDManager sharedManager] hideHUDInView:self];
            if ([response isKindOfClass:[NSDictionary class]]) {
                if ([response[@"result"] boolValue]) {
                    //成功:
                    [weakSelf loginSuccessfully:response[@"data"]];

                    weakSelf.animationType = PresentType;
                    [weakSelf turnBack:nil];
                }
                else
                {
                    NSString *msg = response[@"msg"]?response[@"msg"]:@"重置密码失败";
                    kTipAlert(@"%@",msg);
                }
            }
            else
            {
                kTipAlert(@"重置密码失败！");
            }
        });
    }];
}

//忘记密码
- (void)forgetPassord:(id)sender
{
    BSLog(@"忘记密码");
    NSLog(@"%@",self.vc);
    
    NSMutableDictionary *loginInfo = [NSMutableDictionary dictionary];
    [loginInfo setValue:self.vc forKey:kLoginDelegate];
    [loginInfo setValue:[NSNumber numberWithInt:ForgetType] forKey:kUIType];
    [loginInfo setValue:[NSNumber numberWithInt:PushType] forKey:kAnimateType];
    [LoginCenter doLogin:loginInfo];
}

//获取验证码
- (void)onClickGetIdentify:(UIButton *)btn
{
    [self endEditing:YES];
    // 开启验证码倒计时
    if (![self isValidateMobile:self.phoneNumberField.text])
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"输入错误，请正确填写手机号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        __weak typeof(self) weakSelf = self;
        [[LoginDataHelper defaultHelper] requestForURLStr:@"" requestMethod:@"POST" info:@{@"phone":self.phoneNumberField.text} andBlock:^(id response, NSError *error)
         {
            if ([response isKindOfClass:[NSDictionary class]]) {
                if ([response[@"result"] boolValue]) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [[STHUDManager sharedManager] showHUD];
                        [STHUDManager sharedManager].HUD.margin = 15.0f;
                        [STHUDManager sharedManager].HUD.center = self.center;
                        [[STHUDManager sharedManager] hideHUDWithLabel:@"获取中..." afterDelay:1];
                    });
                    
                    [weakSelf onTimer];
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
}

//用户协议
- (void)userDeclare:(UIButton *)sender
{
    ISTAgreementController *vc = [[ISTAgreementController alloc] init];
    [self.vc.navigationController pushViewController:vc animated:YES];
}

#pragma mark - ValidCode methods

- (void)recoveryVerificationCode
{
    if(_timer)
    {
        //dispatch_source_cancel(_timer);
        [_timer invalidate];
        _timer = nil;
    }
    self.fetchscodeBtn.enabled = YES;
    [self.fetchscodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [fetchscodeBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [fetchscodeBtn setBackgroundColor:RGBCOLOR(230, 100, 10)];
}

/** 计时器开始计时 */
- (void)onTimer
{
    _num = 60;
    // 获取验证码按钮置灰
    self.fetchscodeBtn.enabled = NO;
    [fetchscodeBtn setBackgroundColor:[UIColor lightGrayColor]];
    [fetchscodeBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    fetchscodeBtn.layer.borderWidth = 0;
    if (!_timer)
        _timer = [[NSTimer alloc] init];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(getIdentifys:) userInfo:nil repeats:YES];
    [_timer fire];
}

/** 短信倒计时 */
- (void)getIdentifys:(NSTimer *)timer
{
    _num -= 1;
    [self.fetchscodeBtn setTitle:[NSString stringWithFormat:@"剩余:%d秒", _num] forState:UIControlStateDisabled];
    if (_num == 0) {
        [self recoveryVerificationCode];
    }
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self endEditing:YES];
    return YES;
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

- (BOOL)canRegister
{
    if (![self isValidateMobile:phoneNumberField.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"手机号码错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        return NO;
    }
    
    if (scodeField.text.length == 0 ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入验证码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        return NO;
    }
    
    if (passwordField.text.length == 0 || repasswordField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        return NO;
    }
    
    if (![passwordField.text isEqualToString:repasswordField.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"输入密码不一致" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        return NO;
    }
    
    return YES;
}

- (BOOL)canLogin
{
    if (phoneNumberField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入手机号码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        return NO;
    }
    
    if (![self isValidateMobile:phoneNumberField.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"手机号码有误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        return NO;
    }
    
    if (phoneNumberField.text.length == 0 || passwordField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        return NO;
    }
    
    return YES;
}

#pragma mark - dealloc

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
