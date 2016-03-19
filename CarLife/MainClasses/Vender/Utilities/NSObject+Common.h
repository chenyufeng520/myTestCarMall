//
//  NSObject+Common.h
//  CarLife
//
//  Created by 高大鹏 on 15/11/12.
//  Copyright © 2015年 高大鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Common)

//验证手机号码
+ (BOOL)isPhoneNumber:(NSString *)mobileNumber;
//验证身份证号码
+ (BOOL)isIDCard:(NSString *)cardNumber;

@end
