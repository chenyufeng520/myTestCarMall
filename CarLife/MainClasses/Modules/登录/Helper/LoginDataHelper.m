//
//  LoginDataHelper.m
//  Project
//
//  Created by 高大鹏 on 15/10/19.
//  Copyright © 2015年 高大鹏. All rights reserved.
//

#import "LoginDataHelper.h"
#import "HttpReachabilityHelper.h"
#import "NSString+Util.h"
#import "BaseGlobalDef.h"

@implementation LoginDataHelper

static NSString *kRegist                = @"/app/register";                 //注册
static NSString *kLogin                 = @"/app/login";                    //登录
static NSString *kGetregvalidcode       = @"/app/sendValidCode";            //获取手机验证码
static NSString *kChangepwd             = @"/app/changePassWord";           //忘记密码
static NSString *kUserProtocol          = @"/app/agreement";                //用户协议
static NSString *kRelateAccount         = @"/app/bindingAppPhone";          //账号关联

static LoginDataHelper *_sharedInst = nil;

+ (id)defaultHelper
{
    @synchronized(self){
        if(_sharedInst == nil)
        {
            _sharedInst = [[self alloc] init];
        }
    }
    return _sharedInst;
}

- (id) init
{
    if (self = [super init])
    {

    }
    return self;
}

#pragma mark - 检测网络状况

- (void)checkNetwork
{
    if (![[HttpReachabilityHelper sharedService] checkNetwork]) {
        //        kTipAlert(@"网络连接已断开");
        [[STHUDManager sharedManager] removeAllWaittingViews];
        return;
    }
}

#pragma mark - Url拼接及分割

//拼接路径参数
- (NSString *)setParameter:(NSDictionary *)parameter withBaseUrl:(NSString *)url
{
    NSString *newUrl = [url copy];
    for(NSString *key in parameter.allKeys)
    {
        NSRange ret = [newUrl rangeOfString:@"?"];
        NSString *param = [parameter objectForKey:key];
        if(ret.location == NSNotFound)
        {
            newUrl = [newUrl stringByAppendingFormat:@"?%@=%@", key, param];
        }
        else
        {
            newUrl = [newUrl stringByAppendingFormat:@"&%@=%@", key, param];
        }
    }
    
    return newUrl;
}

//获取路径上的参数；
- (NSDictionary *)getParameter:(NSDictionary *)parameter withBaseUrl:(NSString *)url
{
    NSMutableDictionary *kvDic = [NSMutableDictionary dictionary];
    NSURL *baseUrl = [NSURL URLWithString:url];
    if(baseUrl)
    {
        NSString *parameterString = [baseUrl query];
        NSArray *parameterArray = [parameterString componentsSeparatedByString:@"&"];
        NSMutableDictionary *kvDic = [NSMutableDictionary dictionary];
        for(NSString *kv in parameterArray)
        {
            NSArray *kvArray = [kv componentsSeparatedByString:@"="];
            if([kvArray count] == 2)
            {
                [kvDic setValue:[kvArray objectAtIndex:1] forKey:[kvArray objectAtIndex:0]];
            }
        }
        
    }
    return kvDic;
}

#pragma mark - 网络请求

- (void)requestForType:(LoginNetworkRequestType)type info:(NSDictionary *)requestInfo andBlock:(void (^)(id response, NSError *error))block
{
    NSString *urlString = nil;
    NSString *requestMethod = @"POST";
    switch (type) {
        case LoginNetwork_Login:
        {
            urlString = [NSString stringWithFormat:@"%@%@",kMainDomain,kLogin];
        }
            break;
        case LoginNetwork_Getregvalidcode:
        {
            urlString = [NSString stringWithFormat:@"%@%@",kMainDomain,kGetregvalidcode];
        }break;
        case LoginNetwork_Regist:
        {
            urlString = [NSString stringWithFormat:@"%@%@",kMainDomain,kRegist];
        }break;
        case LoginNetwork_Changepwd:
        {
            urlString = [NSString stringWithFormat:@"%@%@",kMainDomain,kChangepwd];
        }break;
        case LoginNetwork_UserProtocol:
        {
            urlString = [NSString stringWithFormat:@"%@%@",kMainDomain,kUserProtocol];
        }break;
        case LoginNetwork_RelateAccount:
        {
            urlString = [NSString stringWithFormat:@"%@%@",kMainDomain,kRelateAccount];
        }break;
            
        default:
            break;
    }
    
    urlString = [NSString encodeChineseToUTF8:urlString];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.HTTPCookieAcceptPolicy = NSHTTPCookieAcceptPolicyAlways;
    configuration.HTTPShouldSetCookies = YES;
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
    [manager setResponseSerializer:[AFJSONResponseSerializer new]];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager.requestSerializer setTimeoutInterval:30];
    
    if ([requestMethod isEqualToString:@"POST"]) {
        [manager POST:urlString parameters:requestInfo  success:^(NSURLSessionDataTask *task, id responseObject){
            BSLog(@"\n\n路径:%@\n***请求结果:\n%@\n***结束\n\n", task.response.URL,responseObject);
            block(responseObject,nil);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            BSLog(@"%@",error);
            block(nil,error);
        }];
    } else {
        [manager GET:urlString parameters:nil  success:^(NSURLSessionDataTask *task, id responseObject) {
            BSLog(@"\n\n路径:%@\n***请求结果:\n%@\n***结束\n\n", task.response.URL,responseObject);
            block(responseObject,nil);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            BSLog(@"%@",error);
            block(nil,error);
        }];
    }
}

#pragma mark - 上传图片

- (void)updateImages:(NSArray *)imageArray type:(LoginNetworkRequestType)type info:(NSDictionary *)requestInfo andBlock:(void (^)(id response, NSError *error))block
{
    NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:kUserid];
    NSString *urlString = nil;
    switch (type) {
            
        default:
            break;
    }
    
    urlString = [NSString encodeChineseToUTF8:urlString];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];\
    [manager.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil]];
    [manager.requestSerializer setTimeoutInterval:30];
    [manager POST:urlString parameters:requestInfo constructingBodyWithBlock:^(id<AFMultipartFormData> formData){
        for (int i = 0; i < [imageArray count]; ++i)
        {
            NSString *imageKey = @"file";
            UIImage *image = [imageArray objectAtIndex:i];
            NSData *data = UIImageJPEGRepresentation(image,1.0);
            [formData appendPartWithFileData :data name:imageKey fileName:[NSString stringWithFormat:@"%@.jpg",imageKey] mimeType:@"multipart/form-data"];
        }
    } success:^(AFHTTPRequestOperation *operation,id responseObject) {
        block(responseObject,nil);
        
    } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
        block(nil,error);
        
    }];
}

@end
