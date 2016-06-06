//
//  OrderCell.m
//  CarLife
//
//  Created by 陈宇峰 on 16/5/19.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import "OrderCell.h"

@implementation OrderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = kMainBGColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self makeSubViews];
    }
    return self;
}

- (UILabel *)nameLab{
    if (!_nameLab) {
        _nameLab = [[UILabel alloc] init];
        _nameLab.font = kFontLarge_1;
        _nameLab.textAlignment = NSTextAlignmentLeft;
        _nameLab.textColor = [UIColor grayColor];
        _nameLab.numberOfLines = 0;
    }
    return _nameLab;
}

- (UILabel *)typeLab{
    if (!_typeLab) {
        _typeLab = [[UILabel alloc] init];
        _typeLab.font = kFontLarge_1;
        _typeLab.textAlignment = NSTextAlignmentLeft;
        _typeLab.textColor = [UIColor lightGrayColor];
        _typeLab.numberOfLines = 0;
    }
    return _typeLab;
}

- (UILabel *)hiddenNameLab{
    if (!_hiddenNameLab) {
        _hiddenNameLab = [[UILabel alloc] init];
        _hiddenNameLab.font = kFontLarge_1;
        _hiddenNameLab.textAlignment = NSTextAlignmentLeft;
        _hiddenNameLab.textColor = [UIColor grayColor];
    }
    return _hiddenNameLab;
}

- (UILabel *)hiddenShopLab{
    if (!_hiddenShopLab) {
        _hiddenShopLab = [[UILabel alloc] init];
        _hiddenShopLab.font = kFontLarge_1;
        _hiddenShopLab.textAlignment = NSTextAlignmentLeft;
        _hiddenShopLab.textColor = [UIColor grayColor];
    }
    return _hiddenShopLab;
}

- (UIButton *)phoneBtn{
    if (!_phoneBtn) {
        _phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_phoneBtn setImage:[UIImage imageNamed:@"icon_2"] forState:UIControlStateNormal];
        [_phoneBtn addTarget:self action:@selector(phoneButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _phoneBtn;
}

- (UIButton *)msgBtn{
    if (!_msgBtn) {
        _msgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_msgBtn setImage:[UIImage imageNamed:@"icon_3"] forState:UIControlStateNormal];
        [_msgBtn addTarget:self action:@selector(msgButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _msgBtn;
}


- (void)setOrderModel:(OrderModel *)orderModel{
    _orderModel = orderModel;
    CGFloat w = kScreen_Width/3.f;

    self.nameLab.frame = CGRectMake(5, 0, w-10, kAdjustLength(160));
    self.nameLab.text = orderModel.store_name;
    
    self.typeLab.frame = CGRectMake(w+5, 0, w-10, kAdjustLength(160));
    self.typeLab.text = orderModel.store_type;
    
    self.phoneBtn.frame = CGRectMake(2*w, 0, w/2.f, kAdjustLength(160));
    self.msgBtn.frame = CGRectMake(2*w+w/2.f, 0, w/2.f, kAdjustLength(160));
    if (orderModel.status == FoldStatus) {
        self.hiddenShopLab.hidden = NO;
        self.hiddenShopLab.frame = CGRectMake(5, kAdjustLength(160), kScreen_Width-10, kAdjustLength(100));
        self.hiddenShopLab.text = orderModel.store_area;
        self.hiddenNameLab.hidden = NO;
        self.hiddenNameLab.frame = CGRectMake(5, kAdjustLength(260), kScreen_Width-10, kAdjustLength(100));
        self.hiddenNameLab.text = orderModel.store_text;

    }else{
        self.hiddenShopLab.hidden = YES;
        self.hiddenNameLab.hidden = YES;
    }
}

- (void)makeSubViews{
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:line];
    
    [self.contentView addSubview:self.nameLab];
    [self.contentView addSubview:self.typeLab];
    [self.contentView addSubview:self.phoneBtn];
    [self.contentView addSubview:self.msgBtn];
    [self.contentView addSubview:self.hiddenNameLab];
    [self.contentView addSubview:self.hiddenShopLab];

}

- (void)phoneButtonClick:(UIButton *)btn{
    if (self.delegate && [self.delegate respondsToSelector:@selector(orderCellPhoneClick:)]) {
        [self.delegate orderCellPhoneClick:_orderModel];
    }
}

- (void)msgButtonClick:(UIButton *)btn{
    if (self.delegate && [self.delegate respondsToSelector:@selector(orderCellMessageClick:)]) {
        [self.delegate orderCellMessageClick:_orderModel];
    }
}

@end
