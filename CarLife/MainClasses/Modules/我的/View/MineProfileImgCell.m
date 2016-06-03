//
//  MineProfileImgCell.m
//  PointsMall
//
//  Created by 陈宇峰 on 16/6/2.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import "MineProfileImgCell.h"

@implementation MineProfileImgCell

- (void)awakeFromNib {
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configUI];
    }
    return self;
}

- (void)configUI{
    self.largeImg = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 80, 80)];
    self.largeImg.layer.cornerRadius = 40;
    self.largeImg.layer.masksToBounds = YES;
    self.largeImg.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.largeImg];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.largeImg.frame)+10, 40, 100, 20)];
    lab.font = kFontNormal;
    lab.textAlignment = NSTextAlignmentLeft;
    lab.textColor = kDarkTextColor;
    lab.text = @"修改头像";
    [self addSubview:lab];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
