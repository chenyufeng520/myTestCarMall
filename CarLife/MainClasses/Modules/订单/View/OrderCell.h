//
//  OrderCell.h
//  CarLife
//
//  Created by 陈宇峰 on 16/5/19.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

@protocol OrderCellDelegate <NSObject>

@optional
- (void)orderCellPhoneClick:(OrderModel *)orderModel;
- (void)orderCellMessageClick:(OrderModel *)orderModel;
- (void)orderCellHiddenButtonClick:(NSInteger)index orderModel:(OrderModel *)orderModel;

@end

@interface OrderCell : UITableViewCell

@property (nonatomic, strong)UIImageView *shopImage;
@property (nonatomic, strong)UILabel *nameLab;
@property (nonatomic, strong)UILabel *typeLab;
@property (nonatomic, strong)UIButton *phoneBtn;
@property (nonatomic, strong)UIButton *msgBtn;
@property (nonatomic, strong)UIView *hiddenView;
@property (nonatomic, strong)OrderModel *orderModel;

@property (nonatomic, weak)id <OrderCellDelegate> delegate;

@end
