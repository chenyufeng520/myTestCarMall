//
//  NSObject+JDStatusBar.h
//  BSports
//
//  Created by 高大鹏 on 15/9/20.
//  Copyright © 2015年 ist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Common)

- (void)dismissStatusBar;
- (void)showStatusBarQueryStr:(NSString *)tipStr;
- (void)showStatusBarSuccessStr:(NSString *)tipStr;

@end
