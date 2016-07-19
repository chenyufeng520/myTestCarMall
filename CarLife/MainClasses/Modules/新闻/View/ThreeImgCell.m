//
//  ThreeImgCell.m
//  DianCheWuLiu
//
//  Created by 陈宇峰 on 16/7/19.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//
#define begin 5

#import "ThreeImgCell.h"

@implementation ThreeImgCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        //标题
        float imgWith = (kScreen_Width-30)/3;
        self.titleLab = [[UILabel alloc]initWithFrame:CGRectMake(begin*2, begin, kScreen_Width-begin*4, 20)];
        self.titleLab.font = [UIFont systemFontOfSize:16];
        self.titleLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.titleLab];
        //时间
        self.timeLab = [[UILabel alloc]initWithFrame:CGRectMake(kScreen_Width-130, imgWith+5, 130, 10)];
        self.timeLab.font = [UIFont systemFontOfSize:13];
        [self addSubview:self.timeLab];
        //相册
        self.newsImgV1 = [[UIImageView alloc] initWithFrame:CGRectMake(begin, 25, imgWith, imgWith-begin*2-20)];
        [self addSubview:self.newsImgV1];
        
        self.newsImgV2 = [[UIImageView alloc] initWithFrame:CGRectMake(begin+imgWith+10, 25, imgWith, imgWith-begin*2-20)];
        [self addSubview:self.newsImgV2];
        
        self.newsImgV3 = [[UIImageView alloc] initWithFrame:CGRectMake(begin+imgWith*2+20, 25, imgWith, imgWith-begin*2-20)];
        [self addSubview:self.newsImgV3];
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
