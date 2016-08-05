//
//  GoodOrderModel.h
//  CarLife
//
//  Created by 聂康  on 16/7/24.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodOrderModel : NSObject

@property(nonatomic,copy)NSString *orderid;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *min_price;
@property(nonatomic,copy)NSString *praise_num;
@property(nonatomic,copy)NSString *picture;
@property(nonatomic,copy)NSString *month_saled;
@property(nonatomic,copy)NSString *orderCount;
-(instancetype)initWithDictionary:(NSDictionary *)dic;



@end
