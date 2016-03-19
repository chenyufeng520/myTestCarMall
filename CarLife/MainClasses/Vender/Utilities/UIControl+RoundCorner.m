//
//  UIControl+RoundCorner.m
//  BSports
//
//  Created by 高大鹏 on 15/4/7.
//  Copyright (c) 2015年 ist. All rights reserved.
//

#import "UIControl+RoundCorner.h"
#import "BaseGlobalDef.h"

@implementation UIControl (RoundCorner)

- (void)setRoundCorner
{
    self.layer.cornerRadius = kCornerRadius;
    self.layer.borderColor = kLineColor.CGColor;
    self.layer.borderWidth = kLinePixel;
    self.layer.masksToBounds = YES;
}

@end
