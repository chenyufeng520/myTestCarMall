//
//  NSObject+Common.m
//  CarLife
//
//  Created by 高大鹏 on 15/11/12.
//  Copyright © 2015年 高大鹏. All rights reserved.
//

#import "NSObject+Common.h"

@implementation NSObject (Common)

#pragma mark - 手机号码验证

+ (BOOL)isPhoneNumber:(NSString *)mobileNumber
{
    NSString *mobileStr = @"^((145|147)|(15[^4])|(17[6-8])|((13|18)[0-9]))\\d{8}$";
    NSPredicate *cateMobileStr = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",mobileStr];
    
    if ([cateMobileStr evaluateWithObject:mobileNumber]==YES)
    {
        return YES;
    }
    return NO;
}

#pragma mark - 身份证号码验证

+ (BOOL)isIDCard:(NSString *)cardNumber
{
    NSString *idcardStr = @"^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{4}$";
    NSPredicate *cateIdCardStr = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",idcardStr];
    
    if ([cateIdCardStr evaluateWithObject:cardNumber]==YES)
    {
        return YES;
    }
    return NO;
}

@end
