//
//  CMShopModel.h
//  CarLife
//
//  Created by 聂康  on 16/5/19.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMShopModel : NSObject

@property (nonatomic, strong)NSString *gid;
@property (nonatomic, strong)NSString *goods_dazhe;
@property (nonatomic, strong)NSString *goods_hprice;
@property (nonatomic, strong)NSString *goods_intr;
@property (nonatomic, strong)NSString *goods_lock;
@property (nonatomic, strong)NSString *goods_name;
@property (nonatomic, strong)NSString *goods_picurl;
@property (nonatomic, strong)NSString *goods_price;
@property (nonatomic, strong)NSString *goods_remark;

- (instancetype)initWithDic:(NSDictionary *)dic;

+ (void)columeDataListWithUrlString:(NSString *)urlString complection:(void (^)(NSMutableArray *array))complection;

@end
