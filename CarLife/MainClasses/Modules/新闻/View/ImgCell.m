//
//  ImgCell.m
//  DianCheWuLiu
//
//  Created by 陈宇峰 on 16/7/19.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//
#define begin 5
#import "ImgCell.h"

@implementation ImgCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        [self configUI];
    }
    return self;
}

- (void)configUI{
    //logo
    self.imgV = [[UIImageView alloc]initWithFrame:CGRectMake(kAdjustLength(20), kAdjustLength(40), kAdjustLength(320), kAdjustLength(240))];
    self.imgV.backgroundColor = kMainBGColor;
    [self.contentView addSubview:self.imgV];
    //标题lab
    self.titleLab = [[UILabel alloc]initWithFrame:CGRectMake(self.imgV.right + kAdjustLength(20), kAdjustLength(40), kScreen_Width - kAdjustLength(400), kAdjustLength(60))];
    self.titleLab.textAlignment = NSTextAlignmentLeft;
    self.titleLab.font = kFont_16;
    self.titleLab.textColor = kDarkTextColor;
    [self.contentView addSubview:self.titleLab];
    //详情lab
    self.descriptionLab = [[UILabel alloc]initWithFrame:CGRectMake(self.imgV.right+ kAdjustLength(20), self.titleLab.maxY, kScreen_Width- self.imgV.maxX - kAdjustLength(40), kAdjustLength(170))];
    self.descriptionLab.textColor = kLightTextColor;
    self.descriptionLab.font = kFontNormal;
    self.descriptionLab.textAlignment = NSTextAlignmentLeft;
    self.descriptionLab.numberOfLines = 0;
    [self.contentView addSubview:self.descriptionLab];
    //时间
    self.timeLab = [[UILabel alloc]initWithFrame:CGRectMake(kScreen_Width/2, kAdjustLength(270), kScreen_Width/2 - kAdjustLength(20), kAdjustLength(40))];
    self.timeLab.font = kFontSmall;
    self.timeLab.textColor = kLightTextColor;
    self.timeLab.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.timeLab];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, kAdjustLength(320) - 1, kScreen_Width, 1)];
    line.backgroundColor = kLineColor;
    [self.contentView addSubview:line];

}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
