//
//  OrderCellButton.m
//  CarLife
//
//  Created by 聂康  on 16/7/19.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import "OrderCellButton.h"

@implementation OrderCellButton

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    return CGRectMake(5, (contentRect.size.height-40)/2.f, 40, 40);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    return CGRectMake(45+2.5, 0, contentRect.size.width-45-2.5-5, contentRect.size.height);
}

@end
