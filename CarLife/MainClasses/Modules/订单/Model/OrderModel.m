//
//  OrderModel.m
//  CarLife
//
//  Created by 陈宇峰 on 16/5/20.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import "OrderModel.h"

@implementation OrderModel

- (id)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{

}

@end
