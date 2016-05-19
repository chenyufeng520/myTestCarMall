//
//  UseProductModel.m
//  CarLife
//
//  Created by 聂康  on 16/5/19.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import "UseProductModel.h"

@implementation UseProductModel

- (instancetype)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end
