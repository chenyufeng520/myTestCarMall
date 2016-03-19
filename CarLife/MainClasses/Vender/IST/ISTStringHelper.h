//
//  ISTStringHelper.h
//  PointsMall
//
//  Created by MiaoLizhuang on 15/10/23.
//  Copyright © 2015年 高大鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ISTStringHelper : NSObject
//@":"位置后边的字体用特殊颜色显示
+(NSMutableAttributedString*)getAttributedStringWithString:(NSString *)string  AndSepString:(NSString *)sepString AndColor:(UIColor *)color;
//@":"位置后边的字体用特殊颜色显示包括@“:”
+(NSMutableAttributedString*)getAllAttributedStringWithString:(NSString *)string  AndSepString:(NSString *)sepString AndColor:(UIColor *)color;
@end
