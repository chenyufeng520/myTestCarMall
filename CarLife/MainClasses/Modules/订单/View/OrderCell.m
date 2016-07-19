//
//  OrderCell.m
//  CarLife
//
//  Created by 陈宇峰 on 16/5/19.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import "OrderCell.h"
#import "OrderCellButton.h"

@implementation OrderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self makeSubViews];
    }
    return self;
}

-(UIImageView *)shopImage{
    if (!_shopImage) {
        _shopImage = [[UIImageView alloc] init];
    }
    return _shopImage;
}

- (UILabel *)nameLab{
    if (!_nameLab) {
        _nameLab = [[UILabel alloc] init];
        _nameLab.font = kFontLarge_1;
        _nameLab.textAlignment = NSTextAlignmentCenter;
        _nameLab.textColor = [UIColor grayColor];
        _nameLab.numberOfLines = 0;
    }
    return _nameLab;
}

- (UILabel *)typeLab{
    if (!_typeLab) {
        _typeLab = [[UILabel alloc] init];
        _typeLab.font = kFontLarge_1;
        _typeLab.textAlignment = NSTextAlignmentCenter;
        _typeLab.textColor = [UIColor lightGrayColor];
        _typeLab.numberOfLines = 0;
    }
    return _typeLab;
}

- (UIView *)hiddenView{
    if (!_hiddenView) {
        _hiddenView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, kScreen_Width, 10*2+45*3+20*2)];
        _hiddenView.backgroundColor = kMainBGColor;
        NSArray *imageArr = @[@"附近车主按钮",@"红包按钮",@"添加好友按钮",@"语音视频按钮",@"电话联系按钮",@"转发按钮"];
        NSArray *titleArr = @[@"附近车主",@"发红包",@"添加好友",@"语音/视频联系",@"电话联系",@"转发空间/朋友圈"];
        CGFloat w = 160;
        CGFloat interval = (kScreen_Width-w*2)/3.f;
        for (NSInteger i=0; i<imageArr.count; i++) {
            OrderCellButton *btn = [OrderCellButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(interval+i%2*(w+interval), 10+i/2*(45+20), w, 45);
            [btn setTitle:titleArr[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(hiddenViewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.titleLabel.font = kFontNormal;
            btn.titleLabel.numberOfLines = 0;
            btn.tag = 1000 + i;
            [_hiddenView addSubview:btn];
        }
        _hiddenView.hidden = YES;
    }
    return _hiddenView;
}

- (UIButton *)phoneBtn{
    if (!_phoneBtn) {
        _phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _phoneBtn.backgroundColor = kNavBarColor;
        [_phoneBtn setTitle:@"联系店家" forState:UIControlStateNormal];
        [_phoneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_phoneBtn addTarget:self action:@selector(phoneButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _phoneBtn.titleLabel.font = kFont_16;
    }
    return _phoneBtn;
}

- (UIButton *)msgBtn{
    if (!_msgBtn) {
        _msgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _msgBtn.backgroundColor = kNavBarColor;
        [_msgBtn setTitle:@"进入店铺" forState:UIControlStateNormal];
        [_msgBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_msgBtn addTarget:self action:@selector(msgButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _msgBtn.titleLabel.font = kFont_16;
    }
    return _msgBtn;
}


- (void)setOrderModel:(OrderModel *)orderModel{
    _orderModel = orderModel;
    CGFloat w = kScreen_Width/3.f;

    self.shopImage.frame = CGRectMake((w-80)/2.f, 10, 80, 80);
    
    self.nameLab.frame = CGRectMake(w, 10, w, 40);
    self.nameLab.text = orderModel.store_name;
    
    self.typeLab.frame = CGRectMake(w, self.nameLab.maxY, w, 40);
    self.typeLab.text = orderModel.store_type;
    
    self.phoneBtn.frame = CGRectMake(2*w+(w-100)/2.f, 15, 100, 30);
    self.phoneBtn.layer.cornerRadius = self.phoneBtn.height/2.f;

    self.msgBtn.frame = CGRectMake(2*w+(w-100)/2.f, _phoneBtn.maxY+10, 100, 30);
    self.msgBtn.layer.cornerRadius = self.msgBtn.height/2.f;

    if (orderModel.status == FoldStatus) {
        self.hiddenView.hidden = NO;
    }else{
        self.hiddenView.hidden = YES;
    }
}

- (void)makeSubViews{
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:line];
    
    [self.contentView addSubview:self.shopImage];
    [self.contentView addSubview:self.nameLab];
    [self.contentView addSubview:self.typeLab];
    [self.contentView addSubview:self.phoneBtn];
    [self.contentView addSubview:self.msgBtn];
    [self.contentView addSubview:self.hiddenView];

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

- (void)hiddenViewButtonClick:(UIButton *)btn{
    if (self.delegate && [self.delegate respondsToSelector:@selector(orderCellHiddenButtonClick:orderModel:)]) {
        [self.delegate orderCellHiddenButtonClick:btn.tag-1000 orderModel:_orderModel];
    }}

@end
