//
//  PersonInfoListCell.m
//  CarLife
//
//  Created by 陈宇峰 on 16/5/19.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import "PersonInfoListCell.h"

@implementation PersonInfoListCell

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
    
    self.iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 12, 25, 25)];
    [self addSubview:self.iconImageView];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.iconImageView.right+5, 0, kScreen_Width-10-self.iconImageView.width-5-25, 50)];
    self.titleLabel.font = kFontNormal;
    self.titleLabel.textColor = kDarkTextColor;
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.titleLabel];
    
    UILabel * sepLine = [[UILabel alloc]initWithFrame:CGRectMake(20, 50-1, kScreen_Width - 40, 1)];
    sepLine.backgroundColor = kMainBGColor;
    [self addSubview:sepLine];
    
}

- (void)reloadCellWithInfo:(NSDictionary*)info{
    self.iconImageView.image = [UIImage imageNamed:info[@"icon"]];
    self.titleLabel.text = info[@"title"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
