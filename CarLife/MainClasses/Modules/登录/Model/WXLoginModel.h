//
//  WXLoginModel.h
//  OneSecond
//
//  Created by MiaoLizhuang on 15/10/20.
//  Copyright © 2015年 MiaoLizhuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXLoginModel : NSObject

//用code 获取Token和RefreshToken

+(void)getWeiXiTokenWithCode:(NSString*)code AndAppKey:(NSString *)appKey AndSecret:(NSString * )secret CallBack:(void(^)(BOOL success,NSString * message,NSDictionary * info))callBack;

//获取用户信息
+(void)getUserInfoWithToken:(NSString *)token AndOpenid:(NSString *)openid CallBack:(void(^)(BOOL success, NSString * message,NSDictionary * info))CallBack;


//刷新access Token
+(void)refreshAccess_token:(NSString*)refreshToken AndAppKey:(NSString *)appKey CallBack:(void(^)(BOOL success, NSString * message,NSDictionary * info))CallBack;


//验证access Token
+ (void)validAccess_token:(NSString *)token AndOpenid:(NSString *)openid CallBack:(void(^)(BOOL success, NSString * message,NSDictionary * info))CallBack;

@end
