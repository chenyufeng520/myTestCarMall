//
//  ISTLoginView.m
//  BSports
//
//  Created by 陈宇峰 on 16/5/10.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import "ISTEnterView.h"
#import "AppDelegate.h"
#import "LoginCenter.h"
#import "BaseGlobalDef.h"

@implementation ISTEnterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = kMainBGColor;
        
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews
{
    CGFloat itemHeight = kScreen_Width*120/1080;
    CGFloat itemWidth = kScreen_Width*800/1080;
    
    UIView *bgView = [[UIView alloc] initWithFrame:self.bounds];
    bgView.backgroundColor = [UIColor clearColor];
    [self addSubview:bgView];
    
    UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0.8 * kScreen_Width, 0.8 * kScreen_Width * 0.88)];
    logoView.center = CGPointMake(self.centerX, self.iosChangeFloat + 0.32 * kScreen_Height);
    logoView.image = [UIImage imageNamed:@"yindaotu.png"];
    [bgView addSubview:logoView];
    
    //登录按钮
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(0, 0, itemWidth, itemHeight);
    loginBtn.center = CGPointMake(self.centerX, self.centerY + 120);
    loginBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -80, 0, 80);
    loginBtn.imageEdgeInsets = UIEdgeInsetsMake(10, loginBtn.width-58, 10, 18);
    loginBtn.titleLabel.font = kFontLarge_1_b;
    [loginBtn setTitle:@"手机号登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [loginBtn setImage:[UIImage imageNamed:@"yindao_jiantou_bai.png"] forState:UIControlStateNormal];
    loginBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    loginBtn.backgroundColor = kGreenColor;
    [loginBtn addTarget:self action:@selector(loginEvent:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:loginBtn];
    
    //访客按钮
    UIButton *guestBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    guestBtn.frame = CGRectMake(loginBtn.minX, loginBtn.maxY + 20, itemWidth, itemHeight);
    guestBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -80, 0, 80);
    guestBtn.imageEdgeInsets = UIEdgeInsetsMake(10, guestBtn.width-58, 10, 18);
    guestBtn.titleLabel.font = kFontLarge_1_b;    [guestBtn setTitle:@"随便看看" forState:UIControlStateNormal];
    [guestBtn setTitleColor:kGreenColor forState:UIControlStateNormal];
    [guestBtn setImage:[UIImage imageNamed:@"jiantou_huang.png"] forState:UIControlStateNormal];
    guestBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    guestBtn.backgroundColor = kWhiteColor;
    guestBtn.layer.borderColor = kGreenColor.CGColor;
    guestBtn.layer.borderWidth = kLinePixel;
    [guestBtn addTarget:self action:@selector(vistorEvent:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:guestBtn];
}

#pragma mark - Btn Click

-(void)loginEvent:(UIButton *)sender
{
    NSMutableDictionary *loginInfo = [NSMutableDictionary dictionary];
    [loginInfo setValue:[AppDelegate shareDelegate].mainVC forKey:kLoginDelegate];
    [loginInfo setValue:[NSNumber numberWithInt:Column_Login] forKey:kColumnType];
    [loginInfo setValue:[NSNumber numberWithInt:PushType] forKey:kAnimateType];
    [LoginCenter doLogin:loginInfo];
}

- (void)vistorEvent:(id)sender
{
    if(_delegate && [(NSObject *)_delegate respondsToSelector:@selector(trialModeEnterance)])
    {
        [_delegate trialModeEnterance];
    }
}

#pragma mark - dealloc

- (void)dealloc{

}
@end
