//
//  ISTHomeViewController.m
//  BSports
//
//  Created by 陈宇峰 on 16/5/10.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import "ISTContentViewController.h"
#import "ISTHomeViewController.h"
#import "ISTMineViewController.h"
#import "BaseGlobalDef.h"
#import "TabbarItem.h"
#import "ISTBaseNavigationController.h"
#import "CMShoppingViewController.h"
#import "CMOrderViewController.h"
#import "CMNewsViewController.h"
#import "CMToolKitViewController.h"

@interface ISTContentViewController ()
{
    UIView *_contentView;
}

@end

@implementation ISTContentViewController


- (void)test:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kShowMenusNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goHome:) name:kTurnBackHomeNotification object:nil];


    [self makeTabBarHidden:YES];
    [self loadMenuItems];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark- HiddenTabBar
//IOS7以上
- (void)showTabBar {
    [self.tabBar setTranslucent:NO];
    [self.tabBar setHidden:NO];
}

- (void)hideTabBar {
    [self.tabBar setTranslucent:YES];
    [self.tabBar setHidden:YES];
}

- (void)makeTabBarHidden:(BOOL)hide
{
    // Custom code to hide TabBar
    if ([self.view.subviews count] < 2)
    {
        return;
    }
    if (IOSVersion >= 7.0) {
        
        if(hide)
        {
            [self hideTabBar];
        }
        else
        {
            [self showTabBar];
        }
    }
    else
    {
        UIView *contentView;
        if ([[self.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] )
        {
            contentView = [self.view.subviews objectAtIndex:1];
        }
        else
        {
            contentView = [self.view.subviews objectAtIndex:0];
        }
        
        if (hide)
        {
            contentView.frame = self.view.bounds;
        }
        else
        {
            contentView.frame = CGRectMake(self.view.bounds.origin.x,
                                           self.view.bounds.origin.y,
                                           self.view.bounds.size.width,
                                           self.view.bounds.size.height - self.tabBar.frame.size.height);
        }
        self.tabBar.hidden = hide;
        
    }
}

- (void)loadMenuItems
{
    NSMutableArray *controllers = [NSMutableArray array];
//    
//    NSString *parh = [[NSBundle mainBundle] pathForResource:@"STTabBarSetting" ofType:@"plist"];
//    NSMutableDictionary *settingDic = [[NSMutableDictionary dictionaryWithContentsOfFile:parh] objectForKey:@"STTabBarSetting"];
//    NSArray *items = [settingDic objectForKey:@"Items"];

    NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
    [dic1 setValue:@"商城" forKey:@"title"];
    [dic1 setValue:@"shopping" forKey:@"type"];
    [dic1 setValue:@"btn_gray_01" forKey:@"unSelectImg"];
    [dic1 setValue:@"btn_white_01" forKey:@"selectImg"];
    [dic1 setValue:[NSNumber numberWithBool:NO] forKey:@"highlighted"];
    
    NSMutableDictionary *dic2 = [NSMutableDictionary dictionary];
    [dic2 setValue:@"订单" forKey:@"title"];
    [dic2 setValue:@"order" forKey:@"type"];
    [dic2 setValue:@"btn_gray_02" forKey:@"unSelectImg"];
    [dic2 setValue:@"btn_white_02" forKey:@"selectImg"];
    [dic2 setValue:[NSNumber numberWithBool:NO] forKey:@"highlighted"];
    
    NSMutableDictionary *dic3 = [NSMutableDictionary dictionary];
    [dic3 setValue:@"新闻" forKey:@"title"];
    [dic3 setValue:@"news" forKey:@"type"];
    [dic3 setValue:@"btn_gray_03" forKey:@"unSelectImg"];
    [dic3 setValue:@"btn_white_03" forKey:@"selectImg"];
    [dic3 setValue:[NSNumber numberWithBool:NO] forKey:@"highlighted"];
    
    NSMutableDictionary *dic4 = [NSMutableDictionary dictionary];
    [dic4 setValue:@"工具箱" forKey:@"title"];
    [dic4 setValue:@"toolKit" forKey:@"type"];
    [dic4 setValue:@"btn_gray_04" forKey:@"unSelectImg"];
    [dic4 setValue:@"btn_white_04" forKey:@"selectImg"];
    [dic4 setValue:[NSNumber numberWithBool:NO] forKey:@"highlighted"];
    
    NSMutableDictionary *dic5 = [NSMutableDictionary dictionary];
    [dic5 setValue:@"个人中心" forKey:@"title"];
    [dic5 setValue:@"mine" forKey:@"type"];
    [dic5 setValue:@"btn_gray_05" forKey:@"unSelectImg"];
    [dic5 setValue:@"btn_white_05" forKey:@"selectImg"];
    [dic5 setValue:[NSNumber numberWithBool:NO] forKey:@"highlighted"];
    
    NSArray *items = @[dic1, dic2, dic3,dic4,dic5];
    
    NSMutableArray *menuArray = [NSMutableArray array];
    for(NSDictionary *aItem in items)
    {
        NSString *type = [aItem objectForKey:@"type"];
        if ([type isEqualToString:@"shopping"])
        {
            CMShoppingViewController *theVC = [[CMShoppingViewController alloc] init];
            ISTBaseNavigationController *theNavigation = [[ISTBaseNavigationController alloc] initWithRootViewController:theVC];
            theNavigation.navigationBarHidden = YES;
            [controllers addObject:theNavigation];
        }
        else if([type isEqualToString:@"order"])
        {
            CMOrderViewController *theVC = [[CMOrderViewController alloc] init];
            ISTBaseNavigationController *theNavigation = [[ISTBaseNavigationController alloc] initWithRootViewController:theVC];
            theNavigation.navigationBarHidden = YES;
            [controllers addObject:theNavigation];
        }
        else if([type isEqualToString:@"news"])
        {
            CMNewsViewController *theVC = [[CMNewsViewController alloc] init];
            ISTBaseNavigationController *theNavigation = [[ISTBaseNavigationController alloc] initWithRootViewController:theVC];
            theNavigation.navigationBarHidden = YES;
            [controllers addObject:theNavigation];
        }
        else if([type isEqualToString:@"toolKit"])
        {
            CMToolKitViewController *theVC = [[CMToolKitViewController alloc] init];
            ISTBaseNavigationController *theNavigation = [[ISTBaseNavigationController alloc] initWithRootViewController:theVC];
            theNavigation.navigationBarHidden = YES;
            [controllers addObject:theNavigation];
        }
        else if([type isEqualToString:@"mine"])
        {
            ISTMineViewController *theVC = [[ISTMineViewController alloc] init];
            ISTBaseNavigationController *theNavigation = [[ISTBaseNavigationController alloc] initWithRootViewController:theVC];
            theNavigation.navigationBarHidden = YES;
            [controllers addObject:theNavigation];
        }
        else
        {
            //展示不区分类型
            ISTBaseViewController *theVC= [[ISTBaseViewController alloc] initWithNibName:nil bundle:nil];
            ISTBaseNavigationController *navigation = [[ISTBaseNavigationController alloc] initWithRootViewController:theVC];
            navigation.navigationBarHidden = YES;
            theVC.view.backgroundColor = [UIColor greenColor];
            [controllers addObject:navigation];
           
            UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 164/2.0,93/2.0)];
            headerLabel.text = [NSString stringWithFormat:@"%@",[aItem objectForKey:@"title"]];
            headerLabel.textAlignment = NSTextAlignmentCenter;
            headerLabel.backgroundColor = [UIColor clearColor];
            headerLabel.center = theVC.view.center;
            headerLabel.textColor = [UIColor redColor];
            headerLabel.font = [UIFont boldSystemFontOfSize:18];
            //headerLabel.text = @"test";
            [theVC.view addSubview:headerLabel];
        }
        
        TabbarItem *tb = [[TabbarItem alloc] init];
        tb.title = aItem[@"title"];
        tb.type = aItem[@"type"];
        tb.selectImg = aItem[@"selectImg"];
        tb.unSelectImg = aItem[@"unSelectImg"];
        tb.highlighted = [aItem[@"highlighted"] boolValue];
        
        [menuArray addObject:tb];
    }
    self.viewControllers = controllers;
    if(_customTabbarView)
    {
        [_customTabbarView removeFromSuperview];
        self.customTabbarView = nil;
    }
    self.customTabbarView = [[ISTCustomBar alloc] initWithFrame:CGRectMake(0, kScreen_Height-kTabBarHeight, kScreen_Width, kTabBarHeight) withContent:menuArray];
    self.customTabbarView.delegate = self;
    [self.customTabbarView setSelectedIndex:0];
    self.customTabbarView.backgroundColor = kWhiteColor;
    [self.view addSubview:self.customTabbarView];
    [self.view bringSubviewToFront:self.customTabbarView];
}

#pragma mark - customtabbar delegate
- (void)didTabbarViewButtonTouched:(int)index
{
    self.selectedIndex = index;
    
}

- (void)goHome:(NSNotification *)notification
{
    [self selectItem:0];
}

#pragma mark- private method
- (void)selectItem:(int)index{
    [self.customTabbarView setSelectedIndex:index];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);//(interfaceOrientation == UIInterfaceOrientationLandscapeRight);//(interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}
- (NSUInteger) supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL) shouldAutorotate {
    return YES;
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
