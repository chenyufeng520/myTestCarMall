//
//  PersonHeadCell.m
//  CarLife
//
//  Created by 陈宇峰 on 16/5/19.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import "PersonHeadCell.h"

@implementation PersonHeadCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configUI];
    }
    return self;
}


- (void)configUI{
    
    UIImageView *backImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 120)];
    [self addSubview:backImg];
    
    self.iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake((kScreen_Width - 70)/2, 10, 70, 70)];
    self.iconImageView.layer.cornerRadius = 35;
    self.iconImageView.layer.masksToBounds = YES;
    [backImg addSubview:self.iconImageView];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.iconImageView.maxY, kScreen_Width, 40)];
    self.titleLabel.font = kFontLarge_1;
    self.titleLabel.font = kFontLarge_1_b;
    self.titleLabel.textColor = kDarkTextColor;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [backImg addSubview:self.titleLabel];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
