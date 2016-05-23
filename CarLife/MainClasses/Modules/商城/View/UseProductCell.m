//
//  UseProductCell.m
//  CarLife
//
//  Created by 聂康  on 16/5/23.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import "UseProductCell.h"

@implementation UseProductCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeSubviews];
    }
    return self;
}

- (void)makeSubviews{
    self.leftImage = [[UIImageView alloc] init];
    [self.contentView addSubview:self.leftImage];
    
    self.nameLab = [[UILabel alloc] init];
    self.nameLab.font = [UIFont systemFontOfSize:16];
    self.nameLab.numberOfLines = 0;
    [self.contentView addSubview:self.nameLab];
    
    self.introLab = [[UILabel alloc] init];
    self.introLab.font = [UIFont systemFontOfSize:14];
    self.introLab.textColor = [UIColor grayColor];
    self.introLab.numberOfLines = 0;
    [self.contentView addSubview:self.introLab];
    
    self.priceLab = [[UILabel alloc] init];
    self.priceLab.font = [UIFont systemFontOfSize:16];
    self.priceLab.textColor = kNavBarColor;
    self.priceLab.numberOfLines = 0;
    [self.contentView addSubview:self.priceLab];
    
    self.line = [[UIView alloc] init];
    self.line.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:self.line];
}

- (void)setProductModel:(UseProductModel *)productModel{
    _productModel = productModel;
    
    self.leftImage.frame = CGRectMake(10, 5, kAdjustLength(280), kAdjustLength(280));
    [self.leftImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kMainDomain,productModel.goods_picurl]] placeholderImage:[UIImage imageNamed:@""]];
    
    self.nameLab.frame = CGRectMake(self.leftImage.maxX+10, self.leftImage.minY, kScreen_Width-self.leftImage.maxX-20, STRING_HEIGHT(productModel.goods_name, kScreen_Width-self.leftImage.maxX-20, 16));
    self.nameLab.text = productModel.goods_name;
    
    self.priceLab.frame = CGRectMake(self.leftImage.maxX+10, self.leftImage.maxY-(STRING_HEIGHT(productModel.goods_hprice, kScreen_Width-self.leftImage.maxX-20, 16)), kScreen_Width-self.leftImage.maxX-20, STRING_HEIGHT(productModel.goods_hprice, kScreen_Width-self.leftImage.maxX-20, 16));
    self.priceLab.text = productModel.goods_price;
    
    self.introLab.frame = CGRectMake(self.leftImage.maxX+10, self.nameLab.maxY, kScreen_Width-self.leftImage.maxX-20, kAdjustLength(280)-self.nameLab.height-self.priceLab.height);
    self.introLab.text = productModel.goods_intr;
    
    self.line.frame = CGRectMake(10, self.leftImage.maxY+4, kScreen_Width-20, 1);
    
}

@end
