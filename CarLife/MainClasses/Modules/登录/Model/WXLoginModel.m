//
//  WXLoginModel.m
//  OneSecond
//
//  Created by MiaoLizhuang on 15/10/20.
//  Copyright © 2015年 MiaoLizhuang. All rights reserved.
//

#import "WXLoginModel.h"
#import "BaseGlobalDef.h"

@implementation WXLoginModel

+(void)getWeiXiTokenWithCode:(NSString*)code AndAppKey:(NSString *)appKey AndSecret:(NSString * )secret CallBack:(void(^)(BOOL success,NSString * message,NSDictionary * info))CallBack{
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",wxAppKey,wxSecret,code];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                CallBack(YES,@"ok",dic);
                
            }else{
                CallBack(NO,@"no data",nil);
                
            }
        });
    });
    
    
}

+(void)getUserInfoWithToken:(NSString *)token AndOpenid:(NSString *)openid CallBack:(void(^)(BOOL success, NSString * message,NSDictionary * info))CallBack{
    
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",token,openid];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                CallBack(YES,@"Ok",dic);
                
            }else{
                CallBack(NO,@"error",nil);
            }
        });
        
    });
    
}

+(void)refreshAccess_token:(NSString *)refreshToken AndAppKey:(NSString *)appKey CallBack:(void(^)(BOOL success, NSString * message,NSDictionary * info))CallBack{
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=%@&grant_type=refresh_token&refresh_token=%@",wxAppKey,refreshToken];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                if (![dic objectForKey:@"errmsg"]) {
                     CallBack(YES,@"Ok",dic);
                }else{
                    CallBack(NO,[dic objectForKey:@"errmsg"],dic);
                }
                
            }else{
                CallBack(NO,@"request failed",nil);
            }
        });
        
    });
    

    
}

+ (void)validAccess_token:(NSString *)token AndOpenid:(NSString *)openid CallBack:(void(^)(BOOL success, NSString * message,NSDictionary * info))CallBack
{
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/auth?access_token=%@&openid=%@",token,openid];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                if ([dic[@"errcode"] integerValue] == 0) {
                    CallBack(YES,@"Ok",dic);
                }
                else
                {
                    CallBack(NO,[dic objectForKey:@"errmsg"],dic);
                }
                
            }
        });
        
    });

}

@end
