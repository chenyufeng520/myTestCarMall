//
//  CMShopModel.m
//  CarLife
//
//  Created by 聂康  on 16/5/19.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import "CMShopModel.h"
#import "ShoppingDataHelper.h"

@implementation CMShopModel

- (instancetype)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{

}

+ (void)columeDataListWithUrlString:(NSString *)urlString complection:(void (^)(NSMutableArray *array))complection{
//    ShoppingDataHelper *helper = (ShoppingDataHelper*)[ShoppingDataHelper defaultHelper];
    [[ShoppingDataHelper defaultHelper] requestForURLStr:urlString requestMethod:@"GET" info:nil andBlock:^(id response, NSError *error) {
        NSArray *dataArray = (NSArray *)response;
        NSMutableArray *modelArr = [NSMutableArray array];
        for (NSDictionary *dic in dataArray) {
            CMShopModel *model = [[self alloc] initWithDic:dic];
            [modelArr addObject:model];
        }
        complection(modelArr);
    }];
}

@end
