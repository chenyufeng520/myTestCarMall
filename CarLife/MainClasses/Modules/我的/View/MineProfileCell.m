
//
//  MineProfileCell.m
//  PointsMall
//
//  Created by 陈宇峰 on 16/6/2.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import "MineProfileCell.h"

@implementation MineProfileCell

- (void)awakeFromNib {
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self makeUI];
    }
    return self;
}

-(void)makeUI{
    self.title = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 70, 30)];
    self.title.font = kFontNormal;
    self.title.textColor = kDarkTextColor;
    self.title.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.title];
    
//    self.detail = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.title.frame)+20, 10, kScreen_Width-140, 30)];
//    self.detail.font = kFontNormal;
//    self.detail.textColor = kDarkTextColor;
//    self.detail.textAlignment = NSTextAlignmentLeft;
//    [self addSubview:self.detail];
    
    self.field = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.title.frame)+20, 10, kScreen_Width-140, 30)];
    self.field.textColor = kDarkTextColor;
    self.field.font = kFontNormal;
    [self addSubview:self.field];
    
    UILabel * sepLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 50-1, kScreen_Width, 1)];
    sepLine.backgroundColor = kMainBGColor;
    [self addSubview:sepLine];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
