//
//  AppDelegate.h
//  Project
//
//  Created by 高大鹏 on 15/10/17.
//  Copyright © 2015年 高大鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISTBaseNavigationController.h"
#import "ISTContentViewController.h"
#import "ISTBaseViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ISTBaseNavigationController *rootNavigation;
@property (strong, nonatomic) ISTBaseNavigationController * loginNavigation;
@property (strong, nonatomic) ISTContentViewController *mainVC;

+ (AppDelegate *)shareDelegate;
-(void)showTabBar;
-(void)showLoginView;

//分享：
- (void)showShareOn:(ISTBaseViewController *)vc content:(NSString *)text imageUrl:(NSString *)imageUrl shareUrl:(NSString *)url wxsessionContent:(NSDictionary *)wxsessionContent;

@end

