//
//  BaseDataHelper.h
//  CarLife
//
//  Created by 陈宇峰 on 16/5/10.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "STHUDManager.h"

@interface BaseDataHelper : NSObject

+ (BaseDataHelper *)defaultHelper;

- (void)checkNetwork;

//网络请求
- (void)requestForURLStr:(NSString*)URLStr requestMethod:(NSString*)requestMethod info:(NSDictionary *)requestInfo andBlock:(void (^)(id response, NSError *error))block;

//网络请求(测试)
- (void)testrequestForURLStr:(NSString*)URLStr requestMethod:(NSString*)requestMethod info:(NSDictionary *)requestInfo andBlock:(void (^)(id response, NSError *error))block;

//直接传URL
- (void)commonRequestForURLStr:(NSString*)URLStr requestMethod:(NSString*)requestMethod info:(NSDictionary *)requestInfo andBlock:(void (^)(id response, NSError *error))block;


//上传图片(不带进度条的)
- (void)updateImages:(NSArray *)imageArray urlStr:(NSString *)URLStr info:(NSDictionary *)requestInfo andBlock:(void (^)(id response, NSError *error))block;

//新上传图像
- (void)postUserImageWithUid:(NSString*)uidStr imageName:(UIImage *)Userimage completion:(void(^)(NSDictionary * responDic))complete;

//上传图片(带进度条的)
- (void)updateImages:(UIImage *)image urlStr:(NSString *)URLStr info:(NSDictionary *)requestInfo andBlock:(void (^)(id response, NSError *error))block uploadProgressBlock:(void (^)(float, long long, long long))uploadProgressBlock;


- (void)postBodyForUrlStr:(NSString *)UrlStr info:(NSDictionary *)requestInfo andBlock:(void (^)(id response, NSError *error))block;

//新闻请求
- (void)newsListRequestForPage:(int)page requestMethod:(NSString*)requestMethod info:(NSDictionary *)requestInfo andBlock:(void (^)(id response, NSError *error))block;

@end
