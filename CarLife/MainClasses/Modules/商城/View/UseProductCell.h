//
//  UseProductCell.h
//  CarLife
//
//  Created by 聂康  on 16/5/23.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UseProductModel.h"

@interface UseProductCell : UITableViewCell

@property (nonatomic, strong)UIImageView *leftImage;
@property (nonatomic, strong)UILabel *nameLab;
@property (nonatomic, strong)UILabel *introLab;
@property (nonatomic, strong)UILabel *priceLab;
@property (nonatomic, strong)UIImageView *priceImage;
@property (nonatomic, strong)UIView *line;

@property (nonatomic, strong)UseProductModel *productModel;

@end
