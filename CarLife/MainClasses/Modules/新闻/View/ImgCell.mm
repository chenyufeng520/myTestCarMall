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
    if (self)
    {    //相册
        float imgWith = (kScreen_Width-10)/4;
        self.imgV = [[UIImageView alloc]initWithFrame:CGRectMake(begin, begin, imgWith, imgWith-begin*2)];
            [self addSubview:self.imgV];
        //标题lab
        self.titleLab = [[UILabel alloc]initWithFrame:CGRectMake(5+imgWith, 5, kScreen_Width-imgWith-begin*2, 20)];
        self.titleLab.textAlignment = NSTextAlignmentCenter;
        self.titleLab.font = [UIFont systemFontOfSize:16];
        [self addSubview:self.titleLab];
        //详情lab
        self.descriptionLab = [[UILabel alloc]initWithFrame:CGRectMake(8+imgWith, 20, kScreen_Width-begin*2-imgWith-6, imgWith-begin*2-20)];
        self.descriptionLab.textColor = [UIColor grayColor];
        self.descriptionLab.font = [UIFont systemFontOfSize:15];
        self.descriptionLab.numberOfLines = 0;
        [self addSubview:self.descriptionLab];
        //时间
        self.timeLab = [[UILabel alloc]initWithFrame:CGRectMake(kScreen_Width-130, imgWith-13, 130, 10)];
        self.timeLab.font = [UIFont systemFontOfSize:13];
        [self addSubview:self.timeLab];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
