//
//  ToolKitCell.m
//  CarLife
//
//  Created by 陈宇峰 on 16/5/19.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import "ToolKitCell.h"

@implementation ToolKitCell


- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

- (void)configUI{
    
    float cellWidth = self.width;
    float imgWidth = cellWidth - kAdjustLength(90);
    
    _toolImg = [[UIImageView alloc] initWithFrame:CGRectMake(kAdjustLength(45), 0, imgWidth, imgWidth)];
    [self addSubview:_toolImg];
    
    _toolTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, _toolImg.maxY + kAdjustLength(10), cellWidth, kAdjustLength(70))];
    _toolTitle.textAlignment = NSTextAlignmentCenter;
    _toolTitle.textColor = kDarkTextColor;
    _toolTitle.font = kFontNormal;
    [self addSubview:_toolTitle];
}

- (void)reloadCellWithInfo:(NSDictionary*)info{
    self.toolImg.image = [UIImage imageNamed:info[@"icon"]];
    self.toolTitle.text = info[@"title"];
}

@end
