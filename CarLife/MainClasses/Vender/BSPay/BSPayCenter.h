//
//  BSPayCenter.h
//  BSports
//
//  Created by 雷克 on 15/2/5.
//  Copyright (c) 2015年 ist. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "AFURLSessionManager.h"
#import "WXApiObject.h"
#import "WXApi.h"
@interface BSPayCenter: NSObject{
    

}
+ (instancetype)sharePayEngine;

@property (copy) NSString *traceId;//商家对用户的唯一标识,如果用微信 SSO,此处建议填写 授权用户的 openid
@property (copy) NSString *timeStamp;//时间戳,为 1970 年 1 月 1 日 00:00 到请求发起时间的秒 数
@property (copy) NSString *nonceStr;//32位内的随机串,防重发
@property (copy) NSString *package;
@property (copy) NSString *prepayid;
@property (copy) NSString *accessToken;

- (void)wxPay:(NSDictionary *)info;
- (void)zfbPay:(NSDictionary *)info;
- (void)uppay:(NSString *)tn mode:(NSString *)mode viewController:(UIViewController *)vc;

@end
