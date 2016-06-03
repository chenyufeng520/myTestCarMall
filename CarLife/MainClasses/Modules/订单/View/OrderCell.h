//
//  OrderCell.h
//  CarLife
//
//  Created by 陈宇峰 on 16/5/19.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

@interface OrderCell : UITableViewCell

@property (nonatomic, strong)UILabel *nameLab;
@property (nonatomic, strong)UILabel *typeLab;
@property (nonatomic, strong)UIButton *phoneBtn;
@property (nonatomic, strong)UIButton *msgBtn;
@property (nonatomic, strong)UILabel *hiddenShopLab;
@property (nonatomic, strong)UILabel *hiddenNameLab;
@property (nonatomic, strong)OrderModel *orderModel;

@end
