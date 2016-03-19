//
//  LoginNetworkDef.h
//  Project
//
//  Created by 高大鹏 on 15/10/19.
//  Copyright © 2015年 高大鹏. All rights reserved.
//

#ifndef LoginNetworkDef_h
#define LoginNetworkDef_h

typedef enum
{
    LoginNetwork_Regist,                    //注册
    LoginNetwork_Login,                     //登录
    LoginNetwork_Getregvalidcode,           //获取验证码
    LoginNetwork_Changepwd,                 //忘记密码
    LoginNetwork_UserProtocol,              //用户协议
    LoginNetwork_RelateAccount,             //绑定账号
}LoginNetworkRequestType;


#endif /* LoginNetworkDef_h */
