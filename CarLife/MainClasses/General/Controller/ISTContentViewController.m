//
//  ISTHomeViewController.m
//  BSports
//
//  Created by 雷克 on 14/12/25.
//  Copyright (c) 2014年 ist. All rights reserved.
//

#import "ISTContentViewController.h"
#import "ISTHomeViewController.h"
#import "ISTRefuelViewController.h"
#import "ISTMineViewController.h"
#import "BaseGlobalDef.h"
#import "TabbarItem.h"
#import "ISTBaseNavigationController.h"

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
    [dic1 setValue:@"首页" forKey:@"title"];
    [dic1 setValue:@"home" forKey:@"type"];
    [dic1 setValue:@"home1" forKey:@"unSelectImg"];
    [dic1 setValue:@"home2" forKey:@"selectImg"];
    [dic1 setValue:[NSNumber numberWithBool:NO] forKey:@"highlighted"];
    
    NSMutableDictionary *dic2 = [NSMutableDictionary dictionary];
    [dic2 setValue:@"加油" forKey:@"title"];
    [dic2 setValue:@"refuel" forKey:@"type"];
    [dic2 setValue:@"refuel1" forKey:@"unSelectImg"];
    [dic2 setValue:@"refuel2" forKey:@"selectImg"];
    [dic2 setValue:[NSNumber numberWithBool:YES] forKey:@"highlighted"];
    
    NSMutableDictionary *dic3 = [NSMutableDictionary dictionary];
    [dic3 setValue:@"我的" forKey:@"title"];
    [dic3 setValue:@"mine" forKey:@"type"];
    [dic3 setValue:@"mine1" forKey:@"unSelectImg"];
    [dic3 setValue:@"mine2" forKey:@"selectImg"];
    [dic3 setValue:[NSNumber numberWithBool:NO] forKey:@"highlighted"];
    
    NSArray *items = @[dic1, dic2, dic3];
    
    NSMutableArray *menuArray = [NSMutableArray array];
    for(NSDictionary *aItem in items)
    {
        NSString *type = [aItem objectForKey:@"type"];
        if ([type isEqualToString:@"home"])
        {
            ISTHomeViewController *theVC = [[ISTHomeViewController alloc] init];
            ISTBaseNavigationController *theNavigation = [[ISTBaseNavigationController alloc] initWithRootViewController:theVC];
            theNavigation.navigationBarHidden = YES;
            [controllers addObject:theNavigation];
        }
        else if([type isEqualToString:@"refuel"])
        {
            ISTRefuelViewController *theVC = [[ISTRefuelViewController alloc] init];
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
