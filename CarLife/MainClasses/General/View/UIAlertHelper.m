//
//  UIAlertHelper.m
//  Sunbox_DeeperMobile_IPhone
//
//  Created by 陈宇峰 on 16/5/10.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import "UIAlertHelper.h"

@implementation UIAlertHelper

+ (void)showAlert:(NSString *)str AndShowView:(UIView*)view
{
    NSString *tmpStr = nil;
    if (!str) {
        tmpStr = @"暂无信息,请尝试刷新!";
    }else{
        tmpStr = str;
    }
    UILabel *alert = [[UILabel alloc]init] ;
    alert.bounds = CGRectMake(0, 0, 150, 30);
    alert.center = CGPointMake(kScreen_Width / 2, kScreen_Height - 80);
    alert.backgroundColor = [UIColor colorWithWhite:.2 alpha:.8];
    alert.text = tmpStr;
    alert.textColor = [UIColor whiteColor];
    alert.textAlignment = NSTextAlignmentCenter;
    alert.font = [UIFont systemFontOfSize:12];
    alert.alpha = 0.0;
    alert.layer.cornerRadius = 10.0;
    alert.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    alert.layer.shadowRadius = 10.0;
    alert.layer.shadowOpacity = 5;
    alert.clipsToBounds = YES;
    //[view addSubview:alert];
  UIWindow * window=  [UIApplication sharedApplication].keyWindow;
    [window addSubview:alert];
    [UIView animateWithDuration:.5 animations:^{
        alert.alpha = 1.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.5 delay:1.0 options:UIViewAnimationOptionCurveEaseInOut  animations:^{
            alert.alpha = 0.0;
        } completion:^(BOOL finished) {
            [alert removeFromSuperview];
        }];
    }];
}
@end
