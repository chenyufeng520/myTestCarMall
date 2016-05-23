//
//  NewsListCell.m
//  CarLife
//
//  Created by 陈宇峰 on 16/5/20.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import "NewsListCell.h"

@implementation NewsListCell

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
    _iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(kAdjustLength(40), kAdjustLength(40), kAdjustLength(320), kAdjustLength(320))];
    _iconImg.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
    [self.contentView addSubview:_iconImg];
    
    _titleLable = [[UILabel alloc] initWithFrame:CGRectMake(_iconImg.maxX + kAdjustLength(40), kAdjustLength(40), kScreen_Width - _iconImg.maxX - kAdjustLength(80), kAdjustLength(60))];
    _titleLable.textAlignment = NSTextAlignmentLeft;
    _titleLable.font = kFontLarge_2;
//    _titleLable.font = kFontLarge_2_b;
    _titleLable.textColor = kDarkTextColor;
    [self.contentView addSubview:_titleLable];
    
    _detailLable = [[UILabel alloc] initWithFrame:CGRectMake(_iconImg.maxX + kAdjustLength(40), _titleLable.maxY, kScreen_Width - _iconImg.maxX - kAdjustLength(80), kAdjustLength(240))];
    _detailLable.textAlignment = NSTextAlignmentLeft;
    _detailLable.font = kFontNormal;
    _detailLable.textColor = kLightTextColor;
    _detailLable.numberOfLines = 0;
    [self.contentView addSubview:_detailLable];
    
    _timeLable = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_Width -  kAdjustLength(440), _detailLable.maxY, kAdjustLength(400), kAdjustLength(40))];
    _timeLable.textAlignment = NSTextAlignmentRight;
    _timeLable.font = kFontSmall;
    _timeLable.textColor = kLightTextColor;
    [self.contentView addSubview:_timeLable];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
