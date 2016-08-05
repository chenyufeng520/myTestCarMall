//
//  GoodOrderModel.m
//  CarLife
//
//  Created by 聂康  on 16/7/24.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import "GoodOrderModel.h"

@implementation GoodOrderModel

-(instancetype)initWithDictionary:(NSDictionary *)dic{
    
    if (self = [super init]) {
        
        [self setValue:dic[@"id"] forKey:@"orderid"];
        [self setValue:dic[@"name"] forKey:@"name"];
        [self setValue:dic[@"min_price"] forKey:@"min_price"];
        [self setValue:dic[@"praise_num"] forKey:@"praise_num"];
        [self setValue:dic[@"picture"] forKey:@"picture"];
        [self setValue:dic[@"month_saled"] forKey:@"month_saled"];
        [self setValue:dic[@"orderCount"] forKey:@"orderCount"];
    }
    
    return self;
}


@end
