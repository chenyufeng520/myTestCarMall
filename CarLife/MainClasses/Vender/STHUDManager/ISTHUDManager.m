//
//  ISTHUD.m
//  CarLife
//
//  Created by 陈宇峰 on 16/6/2.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import "ISTHUDManager.h"
#import "HttpReachabilityHelper.h"


@implementation ISTHUDManager

static ISTHUDManager *instance = nil;

+ (ISTHUDManager *)defaultManager
{
    static dispatch_once_t p;
    dispatch_once(&p,^{
        instance = [[ISTHUDManager alloc] init];
    });
    return instance;
    
    
}

- (id)init {
    if (self = [super init]) {
        NSMutableArray *tempViewArray = [[NSMutableArray alloc] init];
        self.viewArray = tempViewArray;
        
    }
    return self;
}

#pragma mark - public methods

- (void)p_showHUDWithText:(NSString *)text andImage:(NSString *)imageStr AfterDelay:(NSTimeInterval)delay
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithWindow:window];
    [window addSubview:hud];
    
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageStr]];
    hud.delegate = self;
    hud.userInteractionEnabled = NO;
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = text;
    [hud show:YES];
    [hud hide:YES afterDelay:delay];
}


- (void)p_showHUDToView:(UIView *)view withText:(NSString *)text
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.dimBackground = YES;
    hud.delegate = self;
    hud.labelText = text;
}

//动画图片加载
- (void)showAnimationHUDToView:(UIView *)view withText:(NSString *)text
{
    UIImageView *imageVIew =  [[UIImageView alloc] init];
    imageVIew.width = 60;
    imageVIew.height = 60;
    
    NSMutableArray *imageArr = [NSMutableArray array];
    //创建一个可变数组
    for(int i=1;i<13;i++){
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading%d.png",i]];
        [imageArr addObject:image];
    }
    imageVIew.animationImages = imageArr;
    imageVIew.animationDuration = imageArr.count/12;
    imageVIew.animationRepeatCount = 0;
    [imageVIew startAnimating];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.customView = imageVIew;
    hud.delegate = self;
    hud.mode = MBProgressHUDModeCustomView;
    hud.dimBackground = NO;
    hud.color = [UIColor clearColor];
//    hud.labelColor = kLightTextColor;
    hud.delegate = self;
    hud.labelText = text;
}


#pragma mark - show methods

//旧的等待框（暂时注释）
//- (void)showHUDInView:(UIView *)view withText:(NSString *)text
//{
//    if ([[HttpReachabilityHelper sharedService] checkNetwork]) {
//        
//        [_viewArray addObject:view];
//
//        view.userInteractionEnabled = NO;
//        
//        MBProgressHUD *preHud = [MBProgressHUD HUDForView:view];
//        if (!preHud.hidden) {
//            [preHud hide:YES];
//        }
//        [self p_showHUDToView:view withText:text];
//    }
//}

//动画加载(新的等待框)
- (void)showHUDInView:(UIView *)view withText:(NSString *)text
{
    text = @"";//去掉文字提示
    if ([[HttpReachabilityHelper sharedService] checkNetwork]) {
        
        [_viewArray addObject:view];
        
        view.userInteractionEnabled = NO;
        
        MBProgressHUD *preHud = [MBProgressHUD HUDForView:view];
        
        
        if (!preHud.hidden) {
            [preHud hide:YES];
        }
        [self showAnimationHUDToView:view withText:text];
    }
}


- (void)showHUDWithSuccess:(NSString *)text
{
    [self p_showHUDWithText:text andImage:@"success" AfterDelay:1.5];
}

- (void)showHUDWithError:(NSString *)text
{
    [self p_showHUDWithText:text andImage:@"error" AfterDelay:1.5];
}

- (void)showHUDWithInfo:(NSString *)text
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithWindow:window];
    [window addSubview:hud];
    
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud show:YES];
    [hud hide:YES afterDelay:3];
}

- (void)showHUDWithLabel:(NSString *)text andDetailLabel:(NSString *)detail
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithWindow:window];
    [window addSubview:hud];
    
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"info"]];
    hud.delegate = self;
    hud.removeFromSuperViewOnHide = YES;
    hud.userInteractionEnabled = NO;
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = text;
    hud.detailsLabelText = detail;
    [hud show:YES];
    [hud hide:YES afterDelay:3];
}

- (void)modifyHUDInView:(UIView *)view Status:(NSString *)status
{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:view];
    if (!hud.isHidden) {
        hud.labelText = status;
    }
    else
    {
        [self p_showHUDToView:view withText:status];
    }
}


#pragma mark - hide methods

- (void)hideHUDInView:(UIView *)view
{
    [self hideHUDInView:view AfterDelay:0];
}

- (void)hideHUDInView:(UIView *)view AfterDelay:(NSTimeInterval)delay
{
    if([_viewArray containsObject:view])
    {
        [_viewArray removeObject:view];
    }
    
    view.userInteractionEnabled = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideAllHUDsForView:view animated:NO];
    });
}

- (void)hideAllHUDs
{
    for(UIView *aview in _viewArray)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:aview animated:NO];
        });
    }
    
    [_viewArray removeAllObjects];
}


#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
    
    hud.labelText = nil;
    hud.detailsLabelText = nil;
    hud.mode = MBProgressHUDModeIndeterminate;
}


@end
