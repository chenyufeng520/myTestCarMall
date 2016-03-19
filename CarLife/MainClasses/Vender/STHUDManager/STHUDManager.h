//
//  STHUDManager.h
//  LoginDemo
//
//  Created by Xiaoming Han on 12-8-7.
//  Copyright (c) 2012年 ispirit. All rights reserved.
//
//实现简单显示的HUD，复杂的实现请参考HUD demo进行实现。

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface STHUDManager : NSObject<MBProgressHUDDelegate>
{
    BOOL _isHidden;
}
@property (nonatomic, strong) MBProgressHUD *HUD;
@property(nonatomic,strong)NSMutableArray *viewArray;
+ (STHUDManager *)sharedManager;

- (void)hideHUDWithLabel:(NSString *)label;
- (void)hideHUDWithLabel:(NSString *)label afterDelay:(NSTimeInterval)delay;
- (void)hideHUD:(BOOL)animated;
- (void)showHUD;  
- (void)showHUDWithLabel:(NSString *)label;
- (void)showHUDWithLabel:(NSString *)label detail:(NSString *)detail;
- (void)showHUDWithCustomView:(UIView *)view label:(NSString *)label; 

//覆盖到某一个view上
- (void)showHUDInView:(UIView *)view;
- (void)showHUDInViewToMySelf:(UIView *)view;
- (void)showHUDInView:(UIView *)view hideHUDAfterDelay:(NSTimeInterval)delay;
- (void)hideHUDInView:(UIView *)view;

- (void)removeAllWaittingViews;
#if NS_BLOCKS_AVAILABLE

- (void)showHUDWithLabel:(NSString *)label processingBlock:(void (^)())process finishBlock:(void(^)())finish;

#endif

@end
