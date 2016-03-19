//
//  ISTContentViewController.h
//  BSports
//
//  Created by 雷克 on 14/12/25.
//  Copyright (c) 2014年 ist. All rights reserved.
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

@property (nonatomic, strong) ISTCustomBar *customTabbarView;
@property (nonatomic, assign) ModelCode code;

- (void)loadMenuItems;
- (void)makeTabBarHidden:(BOOL)hide;
- (void)selectItem:(int)index;

@end
