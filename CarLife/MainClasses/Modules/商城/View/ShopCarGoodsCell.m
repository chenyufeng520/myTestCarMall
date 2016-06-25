//
//  ShopCarGoodsCell.m
//  CarLife
//
//  Created by 聂康  on 16/6/25.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import "ShopCarGoodsCell.h"

@implementation ShopCarGoodsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeSubviews];
    }
    return self;
}

- (void)makeSubviews{
    _nameLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width/3.f, kAdjustLength(140))];
    _nameLab.textAlignment = NSTextAlignmentCenter;
    _nameLab.font = kFontLarge_1;
    [self.contentView addSubview:_nameLab];
    
    _numLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_Width/3.f, 0, kScreen_Width/3.f, kAdjustLength(140))];
    _numLab.textAlignment = NSTextAlignmentCenter;
    _numLab.font = kFontLarge_1;
    [self.contentView addSubview:_numLab];
    
    _priceLab = [[UILabel alloc] initWithFrame:CGRectMake(2*kScreen_Width/3.f, 0, kScreen_Width/3.f, kAdjustLength(140))];
    _priceLab.textAlignment = NSTextAlignmentCenter;
    _priceLab.font = kFontLarge_1;
    [self.contentView addSubview:_priceLab];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, kAdjustLength(140)-1, kScreen_Width-10, 1)];
    line.backgroundColor = RGBCOLOR(234, 234, 234);
    [self.contentView addSubview:line];
}

@end
