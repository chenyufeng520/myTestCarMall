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

//两次提示的默认间隔
static const CGFloat kDefaultPlaySoundInterval = 3.0;
static NSString *kMessageType = @"MessageType";
static NSString *kConversationChatter = @"ConversationChatter";
static NSString *kGroupName = @"GroupName";


@interface ISTContentViewController ()
{
    UIView *_contentView;
}

@property (strong, nonatomic) NSDate *lastPlaySoundDate;


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

//    NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
//    [dic1 setValue:@"商城" forKey:@"title"];
//    [dic1 setValue:@"shopping" forKey:@"type"];
//    [dic1 setValue:@"btn_gray_01" forKey:@"unSelectImg"];
//    [dic1 setValue:@"btn_white_01" forKey:@"selectImg"];
//    [dic1 setValue:[NSNumber numberWithBool:NO] forKey:@"highlighted"];
    
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
    
    NSArray *items = @[dic2, dic3,dic4,dic5];
    
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
- (void)didTabbarViewButtonTouched:(NSInteger)index
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

// 统计未读消息数
-(void)setupUnreadMessageCount
{
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        unreadCount += conversation.unreadMessagesCount;
    }
//    if (_chatListVC) {
//        if (unreadCount > 0) {
//            _chatListVC.tabBarItem.badgeValue = [NSString stringWithFormat:@"%i",(int)unreadCount];
//        }else{
//            _chatListVC.tabBarItem.badgeValue = nil;
//        }
//    }
    
    UIApplication *application = [UIApplication sharedApplication];
    [application setApplicationIconBadgeNumber:unreadCount];
}

- (void)setupUntreatedApplyCount
{
//    NSInteger unreadCount = [[[ApplyViewController shareController] dataSource] count];
//    if (_contactsVC) {
//        if (unreadCount > 0) {
//            _contactsVC.tabBarItem.badgeValue = [NSString stringWithFormat:@"%i",(int)unreadCount];
//        }else{
//            _contactsVC.tabBarItem.badgeValue = nil;
//        }
//    }
}

- (void)networkChanged:(EMConnectionState)connectionState
{
    _connectionState = connectionState;
//    [_chatListVC networkChanged:connectionState];
}

- (void)playSoundAndVibration{
    NSTimeInterval timeInterval = [[NSDate date]
                                   timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < kDefaultPlaySoundInterval) {
        //如果距离上次响铃和震动时间太短, 则跳过响铃
        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
        return;
    }
    
    //保存最后一次响铃时间
    self.lastPlaySoundDate = [NSDate date];
    
    // 收到消息时，播放音频
    [[EMCDDeviceManager sharedInstance] playNewMessageSound];
    // 收到消息时，震动
    [[EMCDDeviceManager sharedInstance] playVibration];
}

- (void)showNotificationWithMessage:(EMMessage *)message
{
    EMPushOptions *options = [[EMClient sharedClient] pushOptions];
    //发送本地推送
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate date]; //触发通知的时间
    
    if (options.displayStyle == EMPushDisplayStyleMessageSummary) {
        EMMessageBody *messageBody = message.body;
        NSString *messageStr = nil;
        switch (messageBody.type) {
            case EMMessageBodyTypeText:
            {
                messageStr = ((EMTextMessageBody *)messageBody).text;
            }
                break;
            case EMMessageBodyTypeImage:
            {
                messageStr = NSLocalizedString(@"message.image", @"Image");
            }
                break;
            case EMMessageBodyTypeLocation:
            {
                messageStr = NSLocalizedString(@"message.location", @"Location");
            }
                break;
            case EMMessageBodyTypeVoice:
            {
                messageStr = NSLocalizedString(@"message.voice", @"Voice");
            }
                break;
            case EMMessageBodyTypeVideo:{
                messageStr = NSLocalizedString(@"message.video", @"Video");
            }
                break;
            default:
                break;
        }
        
        do {
            NSString *title = [[NSUserDefaults standardUserDefaults] objectForKey:kPhone];
            if (message.chatType == EMChatTypeGroupChat) {
                NSDictionary *ext = message.ext;
                if (ext && ext[kGroupMessageAtList]) {
                    id target = ext[kGroupMessageAtList];
                    if ([target isKindOfClass:[NSString class]]) {
                        if ([kGroupMessageAtAll compare:target options:NSCaseInsensitiveSearch] == NSOrderedSame) {
                            notification.alertBody = [NSString stringWithFormat:@"%@%@", title, NSLocalizedString(@"group.atPushTitle", @" @ me in the group")];
                            break;
                        }
                    }
                    else if ([target isKindOfClass:[NSArray class]]) {
                        NSArray *atTargets = (NSArray*)target;
                        if ([atTargets containsObject:[EMClient sharedClient].currentUsername]) {
                            notification.alertBody = [NSString stringWithFormat:@"%@%@", title, NSLocalizedString(@"group.atPushTitle", @" @ me in the group")];
                            break;
                        }
                    }
                }
                NSArray *groupArray = [[EMClient sharedClient].groupManager getAllGroups];
                for (EMGroup *group in groupArray) {
                    if ([group.groupId isEqualToString:message.conversationId]) {
                        title = [NSString stringWithFormat:@"%@(%@)", message.from, group.subject];
                        break;
                    }
                }
            }
            else if (message.chatType == EMChatTypeChatRoom)
            {
                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                NSString *key = [NSString stringWithFormat:@"OnceJoinedChatrooms_%@", [[EMClient sharedClient] currentUsername]];
                NSMutableDictionary *chatrooms = [NSMutableDictionary dictionaryWithDictionary:[ud objectForKey:key]];
                NSString *chatroomName = [chatrooms objectForKey:message.conversationId];
                if (chatroomName)
                {
                    title = [NSString stringWithFormat:@"%@(%@)", message.from, chatroomName];
                }
            }
            
            notification.alertBody = [NSString stringWithFormat:@"%@:%@", title, messageStr];
        } while (0);
    }
    else{
        notification.alertBody = NSLocalizedString(@"receiveMessage", @"you have a new message");
    }
    
#warning 去掉注释会显示[本地]开头, 方便在开发中区分是否为本地推送
    //notification.alertBody = [[NSString alloc] initWithFormat:@"[本地]%@", notification.alertBody];
    
    notification.alertAction = NSLocalizedString(@"open", @"Open");
    notification.timeZone = [NSTimeZone defaultTimeZone];
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < kDefaultPlaySoundInterval) {
        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
    } else {
        notification.soundName = UILocalNotificationDefaultSoundName;
        self.lastPlaySoundDate = [NSDate date];
    }
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:[NSNumber numberWithInt:message.chatType] forKey:kMessageType];
    [userInfo setObject:message.conversationId forKey:kConversationChatter];
    notification.userInfo = userInfo;
    
    //发送通知
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    //    UIApplication *application = [UIApplication sharedApplication];
    //    application.applicationIconBadgeNumber += 1;
}
@end
