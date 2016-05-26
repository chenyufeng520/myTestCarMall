//
//  BSPayCenter.m
//  BSports
//
//  Created by 雷克 on 15/2/5.
//  Copyright (c) 2015年 ist. All rights reserved.
//

#import "BSPayCenter.h"
#import <UIKit/UIKit.h>
#import "TenpayUtil.h"
#import "AFHTTPSessionManager.h"
#import "WXDefine.h"
#import "AlipayDefine.h"
#import "AFHTTPRequestOperationManager.h"
#import "WXApiObject.h"
#import "AliPayOrder.h"
#import <AlipaySDK/AlipaySDK.h>
#import "DataSigner.h"
#import "UPPayPlugin.h"

static NSString *const kOrderID = @"OrderID";
static NSString *const kTotalAmount = @"TotalAmount";
static NSString *const kProductDescription = @"productDescription";
static NSString *const kProductName = @"productName";
static NSString *const kNotifyURL = @"NotifyURL";

typedef void(^paymentFinishCallBack)(int statusCode, NSString *statusMessage, NSString *resultString, NSError *error, NSData *data);
@interface BSPayCenter () <UPPayPluginDelegate>
{
    NSString *_price;
}
@end

@implementation BSPayCenter
+ (instancetype)sharePayEngine {
    static BSPayCenter *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        //微信支付
        BOOL isok = [WXApi registerApp:kWXAppID];
        if (isok) {
            NSLog(@"注册微信成功");
        }else{
            NSLog(@"注册微信失败");
        }
    }
    return self;
}

+(BOOL) isWXAppInstalled{
    
    [WXApi registerApp:kWXAppID];
    BOOL isInstalled = NO;
    if ([WXApi isWXAppInstalled]) {
        isInstalled = YES;
    }
    return isInstalled;
}

#pragma mark - 微信支付过程
- (NSString *)wxPayAction:(NSDictionary *)sender{
    
    // V3&V4支付流程实现
    // 注意:参数配置请查看服务器端Demo
    // 更新时间：2015年11月20日
    //============================================================
        NSString *urlString   = @"http://wxpay.weixin.qq.com/pub_v2/app/app_pay.php?plat=ios";
//    NSString *urlString   = [NSString stringWithFormat:@"http://www.uhuitong.com:9000/trustPay/weixinPay?orderid=%@",sender[@"orderid"]];
  
    //解析服务端返回json数据
    NSError *error;
    //加载一个NSURL对象
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    //将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if ( response != nil) {
        NSMutableDictionary *dict = NULL;
        //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
        dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        
        NSLog(@"url:%@",urlString);
        if(dict != nil){
            NSMutableString *retcode = [dict objectForKey:@"retcode"];
            if (retcode.intValue == 0){
                NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
                
                //调起微信支付
                PayReq* req             = [[PayReq alloc] init];
                req.partnerId           = [dict objectForKey:@"partnerid"];
                req.prepayId            = [dict objectForKey:@"prepayid"];
                req.nonceStr            = [dict objectForKey:@"noncestr"];
                req.timeStamp           = stamp.intValue;
                req.package             = [dict objectForKey:@"package"];
                req.sign                = [dict objectForKey:@"sign"];
                [WXApi sendReq:req];
                //日志输出
                NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",[dict objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
                return @"";
            }else{
                return [dict objectForKey:@"retmsg"];
            }
        }else{
            return @"服务器返回错误，未获取到json对象";
        }
    }else{
        return @"服务器返回错误";
    }
}


- (void)prepay {
    //https://api.weixin.qq.com/pay/genprepay?access_token=ACCESS_TOKEN
    
    
    NSMutableData *postData = [self getProductArgs];
    NSString *strUrl = [NSString stringWithFormat:@"https://api.weixin.qq.com/pay/genprepay?&access_token=%@",_accessToken];
    NSURLSessionConfiguration *conf = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *sessMgr  = [[AFURLSessionManager alloc] initWithSessionConfiguration:conf];
    sessMgr.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    
    NSURL *url = [NSURL URLWithString:strUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:postData];
    [request setHTTPMethod:@"POST"];
    
    __weak BSPayCenter *tempObject = self;
    NSURLSessionDataTask *task = [sessMgr dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        NSLog(@"%@  %@",responseObject,error);
        
        int errorCode = [responseObject[@"errcode"] intValue];
        if (0 == errorCode) {
            tempObject.prepayid = responseObject[@"prepayid"];
            if([tempObject.prepayid length] != 0){
                [tempObject pay];
            }
            else{
                NSLog(@"获取订单号失败");
            }
        }
        
        if ([responseObject[@"errcode"]integerValue] == 49004) {
            NSLog(@"%@",responseObject[@"errmsg"]);
            
        }
    }];
    
    [task resume];
    
    
}
/*
 app_signature 生成方法:  [self genSign:params]
 A)参与签名的字段包括:appid、appkey、noncer、package、timestamp 以及 traceid
 B)对所有待签名参数按照字段名的 ASCII 码从小到大排序(字典序)后,使用 URL 键值对的 格式(即 key1=value1&key2=value2...)拼接成字符串 string1。 注意:所有参数名均为小写字符
 C)对 string1 作签名算法,字段名和字段值都采用原始值,不进行 URL 转义。具体签名算法 为 SHA1
 */
- (NSMutableData *)getProductArgs
{
    self.timeStamp = [self genTimeStamp];
    self.nonceStr = [self genNonceStr];
    // traceId 由开发者自定义，可用于订单的查询与跟踪，建议根据支付用户信息生成此id
    self.traceId = [self genTraceId];
    self.package = [self genPackage];
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:kWXAppID forKey:@"appid"];
    [params setObject:kWXAppKey forKey:@"appkey"];
    [params setObject:self.nonceStr forKey:@"noncestr"];
    [params setObject:self.timeStamp forKey:@"timestamp"];
    [params setObject:self.traceId forKey:@"traceid"];
    [params setObject:self.package forKey:@"package"];
    [params setObject:[self genSign:params] forKey:@"app_signature"];
    [params setObject:@"sha1" forKey:@"sign_method"];
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error: &error];
    NSLog(@"--- ProductArgs: %@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
    return [NSMutableData dataWithData:jsonData];
}

#pragma mark  开始支付
- (void)pay{
    //构造支付请求
    PayReq *request = [[PayReq alloc]init];
    request.partnerId = kWXPartnerId;
    request.prepayId = self.prepayid;
    request.package = @"Sign=WXPay";
    request.nonceStr = self.nonceStr;
    request.timeStamp = [self.timeStamp integerValue];
    
    //构造参数列表
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:kWXAppID forKey:@"appid"];
    [params setObject:kWXAppKey forKey:@"appkey"];
    [params setObject:request.nonceStr forKey:@"noncestr"];
    [params setObject:request.package forKey:@"package"];
    [params setObject:request.partnerId forKey:@"partnerid"];
    [params setObject:request.prepayId forKey:@"prepayid"];
    [params setObject:self.timeStamp forKey:@"timestamp"];
    request.sign = [self genSign:params];
    
    
    
    [WXApi sendReq:request];
    
}

- (void)wxPay:(NSDictionary *)info{
    //构造支付请求
    PayReq *request = [[PayReq alloc]init];
    request.partnerId = [info objectForKey:@"partnerid"];
    request.prepayId = [info objectForKey:@"prepayid"];
    request.package = [info objectForKey:@"packageValue"];
    request.nonceStr = [info objectForKey:@"noncestr"];
    request.timeStamp = (UInt32)[[info objectForKey:@"timestamp"] integerValue];
    request.sign = [info objectForKey:@"sign"];
    
    BOOL paySucceed  = [WXApi sendReq:request];
    if(paySucceed == NO){
        BSLog(@"支付失败");
    }
}

//MARK: 注意:不能hardcode在客户端,建议genPackage这个过程都由服务器端完成
- (NSString *)genPackage{
    // 构造参数列表
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"WX" forKey:@"bank_type"];
    [params setObject:@"商品名称" forKey:@"body"];
    [params setObject:@"1" forKey:@"fee_type"];
    [params setObject:@"UTF-8" forKey:@"input_charset"];
    [params setObject:@"http://weixin.qq.com" forKey:@"notify_url"];
    [params setObject:[self genOutTradNo] forKey:@"out_trade_no"];
    [params setObject:kWXPartnerId forKey:@"partner"];
    [params setObject:[TenpayUtil getIPAddress:YES] forKey:@"spbill_create_ip"];
    [params setObject:[NSString stringWithFormat:@"%d",[_price intValue]] forKey:@"total_fee"];
    
    NSArray *allKeys =nil;
    allKeys = [[params allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString *str1 = (NSString *)obj1;
        NSString *str2 = (NSString *)obj2;
        NSComparisonResult comRes = [str1 compare:str2 ];
        return comRes;
    }];
    
    // 生成 packageSign
    NSMutableString *package = [NSMutableString string];
    for (NSString *key in allKeys) {
        [package appendString:key];
        [package appendString:@"="];
        [package appendString:[params objectForKey:key]];
        [package appendString:@"&"];
    }
    [package appendString:@"key="];
    
    [package appendString:kWXPartnerKey];
    
    // 进行md5摘要前,params内容为原始内容,未经过url encode处理
    NSString *packageSign = [[TenpayUtil md5:[package copy]] uppercaseString];
    package = nil;
    
    // 生成 packageParamsString
    NSString *value = nil;
    package = [NSMutableString string];
    for (NSString *key in allKeys) {
        [package appendString:key];
        [package appendString:@"="];
        value = [params objectForKey:key];
        
        // 对所有键值对中的 value 进行 urlencode 转码
        value = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)value, nil, (CFStringRef)@"!*'&=();:@+$,/?%#[]", kCFStringEncodingUTF8));
        
        [package appendString:value];
        [package appendString:@"&"];
    }
    NSString *packageParamsString = [package substringWithRange:NSMakeRange(0, package.length - 1)];
    
    NSString *result = [NSString stringWithFormat:@"%@&sign=%@", packageParamsString, packageSign];
    
    NSLog(@"--- Package: %@", result);
    return result;
}
//MARK: 时间戳
- (NSString *)genTimeStamp
{
    return [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
}


//MARK: 建议 traceid 字段包含用户信息及订单信息，方便后续对订单状态的查询和跟踪

- (NSString *)genTraceId
{
    return [NSString stringWithFormat:@"crestxu_%@", [self genTimeStamp]];
}

//MARK: sign
- (NSString *)genSign:(NSDictionary *)signParams
{
    // 排序
    NSArray *keys = [signParams allKeys];
    NSArray *sortedKeys = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    // 生成
    NSMutableString *sign = [NSMutableString string];
    for (NSString *key in sortedKeys) {
        [sign appendString:key];
        [sign appendString:@"="];
        [sign appendString:[signParams objectForKey:key]];
        [sign appendString:@"&"];
    }
    NSString *signString = [[sign copy] substringWithRange:NSMakeRange(0, sign.length - 1)];
    
    NSString *result = [TenpayUtil sha1:signString];
    NSLog(@"--- Gen sign: %@", result);
    return result;
}


/**
 * 注意：商户系统内部的订单号,32个字符内、可包含字母,确保在商户系统唯一
 */
- (NSString *)genNonceStr
{
    return [TenpayUtil md5:[NSString stringWithFormat:@"%d", arc4random() % 10000]];
}

- (NSString *)genOutTradNo
{
    return [TenpayUtil md5:[NSString stringWithFormat:@"%d", arc4random() % 10000]];
}



#pragma mark -
#pragma mark - 支付宝支付过程

- (void)zfbPay:(NSDictionary *)info
{
    BSLog(@"%@",info);
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *partner = PartnerID;//[info objectForKey:@"partner"];
    NSString *seller = SellerID;//[info objectForKey:@"seller"];
    NSString *privateKey = PartnerPrivKey;//[info objectForKey:@"partnerPrivKey"];
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    AliPayOrder *order = [[AliPayOrder alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = [self generateTradeNO];//[info objectForKey:@"tradeno"]; //[self generateTradeNO];////订单ID（由商家自行制定）
    order.productName = @"测试";//[info objectForKey:@"productname"]; //商品标题
    order.productDescription = @"ceshi";//[info objectForKey:@"productname"];; //商品描述
    order.amount = [info objectForKey:@"amount"]; //商品价格
    order.notifyURL =  [info objectForKey:@"notifyurl"]; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"sinopcalipay";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            NSString *resultSting = resultDic[@"result"];
            NSArray *resultStringArray =[resultSting componentsSeparatedByString:NSLocalizedString(@"&", nil)];
            BOOL isSuccess = NO;
            for (NSString *str in resultStringArray)
            {
                NSString *newstring = nil;
                newstring = [str stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                NSArray *strArray = [newstring componentsSeparatedByString:NSLocalizedString(@"=", nil)];
                for (int i = 0 ; i < [strArray count] ; i++)
                {
                    NSString *st = [strArray objectAtIndex:i];
                    if ([st isEqualToString:@"success"])
                    {
                        NSString *result = (NSString *)[strArray objectAtIndex:1];
                        if([[result lowercaseString] isEqualToString:@"true"]){
                            isSuccess = YES;
                            break;
                        }
                    }
                }
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kPaySucceedNotification object:@{@"result":[NSNumber numberWithBool:isSuccess]}];
        }];
    }
}

- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand(time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

#pragma mark - 银联支付

- (void)uppay:(NSString *)tn mode:(NSString *)mode viewController:(UIViewController *)vc
{
    [UPPayPlugin startPay:tn mode:mode viewController:vc delegate:self];
}

- (void)uppayPluginResult:(NSString *)result
{
    //success、fail、cancel,
    BOOL flag = NO;
    if ([result isEqualToString:@"success"]) {
        flag = YES;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kPaySucceedNotification object:@{@"result":[NSNumber numberWithBool:flag]}];
}

@end
