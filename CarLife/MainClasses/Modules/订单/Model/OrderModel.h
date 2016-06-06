//
//  OrderModel.h
//  CarLife
//
//  Created by 陈宇峰 on 16/5/20.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,Status){
    UnfoldStatus = 0,
    FoldStatus,
};

@interface OrderModel : NSObject

@property (nonatomic, assign)Status status;
@property (nonatomic, strong)NSString *sid,*store_area,*store_name,*store_phone,*store_qq,*store_text,*store_type;

- (id)initWithDic:(NSDictionary *)dic;

@end
