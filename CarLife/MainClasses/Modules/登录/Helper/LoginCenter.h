//
//  LoginCenter.h
//  BSports
//
//  Created by 雷克 on 15/3/10.
//  Copyright (c) 2015年 ist. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kLoginDelegate    @"thelogindelegate"
#define kLoginMode        @"loginmode"
#define kColumnType       @"columntype"
#define kMenuIndex        @"menuindex"
#define kAnimateType      @"animatetype"
#define kUIType           @"uitype"
#define kNoBack           @"noback"

typedef enum
{
    Column_Login = 0,               //登录
    Column_Register,                //注册
}ColumnType;

typedef enum{
    LoginType = 0,                  //登陆界面；
    ForgetType                      //忘记密码界面；
}UIType;

typedef enum
{
    PresentType = 0,
    PushType = 1
}AnimationType;


@interface LoginCenter : NSObject

+ (BOOL)isLoginValid;
+ (void)doLogin:(NSDictionary *)info;

/*
 NSMutableDictionary *loginInfo = [NSMutableDictionary dictionary];
 [loginInfo setValue:self forKey:kViewController];
 [loginInfo setValue:[NSNumber numberWithInt:LoginMode_Vistor] forKey:kLoginMode];
 [loginInfo setValue:[NSNumber numberWithInt:Column_Login] forKey:kColumnType];
 [loginInfo setValue:[NSNumber numberWithInt:index] forKey:kMenuIndex];
 [loginInfo setValue:[NSNumber numberWithInt:PresentType] forKey:kAnimateType];
 [LoginCenter doLogin:loginInfo];
*/
@end
