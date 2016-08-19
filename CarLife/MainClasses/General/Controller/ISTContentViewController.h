//
//  ISTContentViewController.h
//  BSports
//
//  Created by 陈宇峰 on 16/5/10.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

//#import "CMTabBarController.h"
#import "ISTCustomBar.h"

//个人中心
typedef enum
{
    kDefaultCode = -1,
    kHomeCode = 1,
}ModelCode;

//底下导航：5个标签页，采用官方的类；
@interface ISTContentViewController : UITabBarController<ISTCustomBarDelegate>
//:CMTabBarController
{
    EMConnectionState _connectionState;
}

@property (nonatomic, strong) ISTCustomBar *customTabbarView;
@property (nonatomic, assign) ModelCode code;

- (void)loadMenuItems;
- (void)makeTabBarHidden:(BOOL)hide;
- (void)selectItem:(int)index;


- (void)setupUntreatedApplyCount;

- (void)setupUnreadMessageCount;

- (void)networkChanged:(EMConnectionState)connectionState;

- (void)didReceiveLocalNotification:(UILocalNotification *)notification;

- (void)playSoundAndVibration;

- (void)showNotificationWithMessage:(EMMessage *)message;

@end
