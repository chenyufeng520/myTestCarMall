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
        _nameLab.textAlignment = NSTextAlignmentCenter;
        _nameLab.textColor = [UIColor grayColor];
        _nameLab.text = @"合肥三益汽配";
    }
    return _nameLab;
}

- (UILabel *)typeLab{
    if (!_typeLab) {
        _typeLab = [[UILabel alloc] init];
        _typeLab.font = kFontLarge_1;
        _typeLab.textAlignment = NSTextAlignmentCenter;
        _typeLab.textColor = [UIColor grayColor];
        _typeLab.text = @"专营本田汽车配件";
    }
    return _typeLab;
}

- (UILabel *)hiddenNameLab{
    if (!_hiddenNameLab) {
        _hiddenNameLab = [[UILabel alloc] init];
        _hiddenNameLab.font = kFontLarge_1;
        _hiddenNameLab.textAlignment = NSTextAlignmentCenter;
        _hiddenNameLab.textColor = [UIColor grayColor];
        _hiddenNameLab.text = @"聂康";
    }
    return _hiddenNameLab;
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

    self.nameLab.frame = CGRectMake(0, 0, w, kAdjustLength(160));
    self.typeLab.frame = CGRectMake(w, 0, w, kAdjustLength(160));
    self.phoneBtn.frame = CGRectMake(2*w, 0, w/2.f, kAdjustLength(160));
    self.msgBtn.frame = CGRectMake(2*w+w/2.f, 0, w/2.f, kAdjustLength(160));
    if (orderModel.status == FoldStatus) {
        self.hiddenNameLab.hidden = NO;
        self.hiddenNameLab.frame = CGRectMake(0, kAdjustLength(160), kScreen_Width, kAdjustLength(100));
    }else{
        self.hiddenNameLab.hidden = YES;
        self.hiddenNameLab.frame = CGRectZero;
    }
}

- (void)makeSubViews{
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:line];
    
    [self.contentView addSubview:self.nameLab];
    [self.contentView addSubview:self.typeLab];
    [self.contentView addSubview:self.hiddenNameLab];
    [self.contentView addSubview:self.phoneBtn];
    [self.contentView addSubview:self.msgBtn];
}

- (void)phoneButtonClick:(UIButton *)btn{

}

- (void)msgButtonClick:(UIButton *)btn{

}

@end
