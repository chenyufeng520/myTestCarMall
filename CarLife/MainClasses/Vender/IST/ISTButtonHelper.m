//
//  ISTButtonHelper.m
//  PointsMall
//
//  Created by MiaoLizhuang on 15/10/22.
//  Copyright © 2015年 高大鹏. All rights reserved.
//

#import "ISTButtonHelper.h"
#import "BaseGlobalDef.h"
#import "ISTGlobal.h"

@implementation ISTButtonHelper


//圆角button
+ (UIButton *)buttonWithFrame:(CGRect)frame  AndTitle:(NSString *)title  AndColor:(UIColor*)color AndSuperView:(UIView*)superView Andaction:(SEL)action AndTarget:(id)target WithButtonType:(LZButtonType)type
{
    UIButton *button = [ISTButtonHelper buttonWithFrame:frame AndTitle:title AndColor:color AndSuperView:superView Andaction:action AndTarget:target WithButtonType:type andTag:0];
    return button;
}

+ (UIButton *)buttonWithFrame:(CGRect)frame  AndTitle:(NSString *)title  AndColor:(UIColor*)color AndSuperView:(UIView*)superView Andaction:(SEL)action AndTarget:(id)target WithButtonType:(LZButtonType)type andTag:(NSInteger)tag
{
    UIButton * button= [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setFont:kFontNormal];
    button.tag = tag;
    if (type == LZButtonTypeRoundedRectWithBorder) {
        [button setTitleColor:color forState:UIControlStateNormal];
        button.layer.borderWidth = kLinePixel;
        button.layer.borderColor =color.CGColor;
        button.layer.cornerRadius = kCornerRadius;
        button.layer.masksToBounds = YES;
    }
    else if(type == LZButtonTypeRoundedRect)
    {
        button.layer.cornerRadius = kCornerRadius;
        button.layer.masksToBounds = YES;
        [button setBackgroundImage:[UIImage imageWithColor:color size:button.size] forState:UIControlStateNormal];
    }
    else if (type == LZButtonTypeRectangleWithBorder)
    {
        [button setTitleColor:color forState:UIControlStateNormal];
        button.layer.borderWidth = kLinePixel;
        button.layer.borderColor =color.CGColor;
    }
    else if (type == LZButtonTypeRectangleWithBorder)
    {
         [button setTitleColor:color forState:UIControlStateNormal];
    }
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:button];
    return button;
}

@end
