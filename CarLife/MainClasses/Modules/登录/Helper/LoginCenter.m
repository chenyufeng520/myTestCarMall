//
//  LoginCenter.m
//  BSports
//
//  Created by 雷克 on 15/3/10.
//  Copyright (c) 2015年 ist. All rights reserved.
//

#import "LoginCenter.h"
#import "ISTLoginView.h"

@implementation LoginCenter

+ (BOOL)isLoginValid
{
    BOOL islogin = NO;
    NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:kUserid];
    if([userid length])
    {
        islogin = YES;
    }
    return islogin;
}

+ (void)doLogin:(NSDictionary *)info
{
    ISTBaseViewController *vc = (ISTBaseViewController *)[info objectForKey:kLoginDelegate];
////    ColumnType columnType = (ColumnType)[[info objectForKey:kColumnType] intValue];
////    NSInteger menuIndex = [[info objectForKey:kMenuIndex] integerValue];
//    AnimationType animationType = (AnimationType)[[info objectForKey:kAnimateType] intValue];
////    UIType uitype = (UIType)[[info objectForKey:kUIType] intValue];
//    ISTBaseViewController *loginVC = [[ISTBaseViewController alloc] initWithNibName:nil bundle:nil];
    
//    ISTLoginView *registerOrLoginView = nil;
//    if(uitype != ForgetType){
//        registerOrLoginView = [[ISTLoginView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
//        [registerOrLoginView showWithType:columnType];
//    }
//    else{
//        registerOrLoginView = [[ISTLoginView alloc] initForgetModeFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
//    }
//    registerOrLoginView.vc = loginVC;
//    registerOrLoginView.animationType = animationType;
//    registerOrLoginView.uitype = uitype;
//    registerOrLoginView.menuIndex = menuIndex;
   
//    loginVC.view = loginV.view;
//    
//    //UITableView,UIScrollView的时候有时候会偏移20像素
//    if ([[UIDevice currentDevice] systemVersion].floatValue>=7.0) {
//        loginVC.automaticallyAdjustsScrollViewInsets = NO;
//    }
//    
//    if(animationType == PresentType){
//        ISTBaseNavigationController *theNavigation = [[ISTBaseNavigationController alloc] initWithRootViewController:loginVC];
//        theNavigation.navigationBarHidden = YES;
//        [vc presentViewController:theNavigation animated:YES completion:NULL];
//    }
//    else if(animationType == PushType)
//    {
//        [vc.navigationController pushViewController:loginVC animated:YES];
//    }
}
@end
