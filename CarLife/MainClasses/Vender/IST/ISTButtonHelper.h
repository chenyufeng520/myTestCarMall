//
//  ISTButtonHelper.h
//  PointsMall
//
//  Created by MiaoLizhuang on 15/10/22.
//  Copyright © 2015年 高大鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    LZButtonTypeRoundedRect = 0,                    //圆角无边
    LZButtonTypeRoundedRectWithBorder,              //圆角有边
    LZButtonTypeRectangle,                          //直角无边
    LZButtonTypeRectangleWithBorder,                //直角有边
}LZButtonType;
@interface ISTButtonHelper : NSObject

//圆角button
+ (UIButton *)buttonWithFrame:(CGRect)frame  AndTitle:(NSString *)title  AndColor:(UIColor*)color AndSuperView:(UIView*)superView Andaction:(SEL)action AndTarget:(id)target WithButtonType:(LZButtonType)type;

+ (UIButton *)buttonWithFrame:(CGRect)frame  AndTitle:(NSString *)title  AndColor:(UIColor*)color AndSuperView:(UIView*)superView Andaction:(SEL)action AndTarget:(id)target WithButtonType:(LZButtonType)type andTag:(NSInteger)tag;

@end
