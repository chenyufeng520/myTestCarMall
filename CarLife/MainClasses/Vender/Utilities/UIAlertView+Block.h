//
//  UIAlertView+Block.h
//  1111
//
//  Created by 高大鹏 on 15/3/20.
//  Copyright (c) 2015年 高大鹏. All rights reserved.
//

/*
 /////调用
 UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"hello" message:@"hello world" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
 
 [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
 NSLog(@"button index=%d",buttonIndex);
 }];
 */

#import <UIKit/UIKit.h>
typedef void(^CompleteBlock) (NSInteger buttonIndex);

@interface UIAlertView (Block)

// 用Block的方式回调，这时候会默认用self作为Delegate
- (void)showAlertViewWithCompleteBlock:(CompleteBlock) block;

@end
