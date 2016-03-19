//
//  ISTStringHelper.m
//  PointsMall
//
//  Created by MiaoLizhuang on 15/10/23.
//  Copyright © 2015年 高大鹏. All rights reserved.
//

#import "ISTStringHelper.h"

@implementation ISTStringHelper


//@":"位置后边的字体用特殊颜色显示
+(NSMutableAttributedString*)getAttributedStringWithString:(NSString *)string  AndSepString:(NSString *)sepString AndColor:(UIColor *)color{
    NSMutableAttributedString * attribuString = [[NSMutableAttributedString alloc]initWithString:string];
    NSRange  range = [string rangeOfString:sepString];
    [attribuString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(range.location+1, string.length-1-range.location)];
    
    return  attribuString;
}

//@":"位置后边的字体用特殊颜色显示包括@“:”
+(NSMutableAttributedString*)getAllAttributedStringWithString:(NSString *)string  AndSepString:(NSString *)sepString AndColor:(UIColor *)color{
    
    NSMutableAttributedString * attribuString = [[NSMutableAttributedString alloc]initWithString:string];
    NSRange  range = [string rangeOfString:sepString];
    [attribuString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(range.location, string.length-range.location)];
    return  attribuString;
}

@end
