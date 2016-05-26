//
//  AppDelegate.m
//  Project
//
//  Created by 陈宇峰 on 16/5/10.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import "AppDelegate.h"
#import "SDImageCache.h"
#import "UMSocial.h"
#import "UMSocialControllerService.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "WXApi.h"
#import "MobClick.h"
#import "HttpReachabilityHelper.h"
#import "BaseDataHelper.h"
#import <AlipaySDK/AlipaySDK.h>
#import <BaiduMapAPI/BMapKit.h>
#import <MapKit/MapKit.h>
#import "IQKeyboardManager.h"
#import "LoginCenter.h"
#import "ISTLoginViewController.h"
#import "GifViewController.h"
#import "ChatViewController.h"

@interface AppDelegate ()<UMSocialUIDelegate,WXApiDelegate,BMKGeneralDelegate>
{
    BMKMapManager* _mapManager;
    
}

@property(nonatomic,strong) ISTLoginViewController * loginVC;
@end

@implementation AppDelegate

+ (AppDelegate *)shareDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)applicationConfiguration
{
    [self startIQKeyboard];
    [self startBaiduMap];
    [self configWeiXin];
    //    [self umengTrack];
    //    [UMSocialData setAppKey:UmengAppkey];
    
    [[HttpReachabilityHelper sharedService] detectNetwork];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self applicationConfiguration];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = kWhiteColor;
    //    GifViewController *VC = [[GifViewController alloc] init];
    //    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:VC];
    //    self.window.rootViewController = nav;
    //    [self.window makeKeyAndVisible];
    [self layoutMainView:nil];
    
    
    return YES;
}

- (void)layoutMainView:(id)sender
{
    if(self.rootNavigation)
    {
        [self.rootNavigation.view removeFromSuperview];
        self.rootNavigation = nil;
    }
    
    if (self.loginNavigation) {
        [self.loginNavigation.view removeFromSuperview];
        self.loginNavigation = nil;
    }
    self.mainVC = [[ISTContentViewController alloc] initWithNibName:nil bundle:nil];
    self.rootNavigation =[[ISTBaseNavigationController alloc] initWithRootViewController:self.mainVC];
    self.rootNavigation.navigationBarHidden = YES;
    
    self.loginVC = [[ISTLoginViewController alloc]init];
    self.loginNavigation =[[ISTBaseNavigationController alloc] initWithRootViewController:self.loginVC];
    self.loginNavigation.navigationBarHidden = YES;
    
    if (![LoginCenter isLoginValid]) {
        
        [self.window setRootViewController:self.loginNavigation];
    }
    else
    {
        
        [self.window setRootViewController:self.rootNavigation];
    }
    [self.window makeKeyAndVisible];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
    [BMKMapView willBackGround];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kApplicationDidEnterBackground object:nil];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kApplicationDidBecameForeground object:nil];
    
    [BMKMapView didForeGround];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}

#pragma mark - 参数拼接

- (NSDictionary *)getParameter:(NSString *)parameterString
{
    NSArray *parameterArray = [parameterString componentsSeparatedByString:@"&"];
    NSMutableDictionary *kvDic = [NSMutableDictionary dictionary];
    for(NSString *kv in parameterArray)
    {
        NSArray *kvArray = [kv componentsSeparatedByString:@"="];
        if([kvArray count] == 2)
        {
            [kvDic setValue:[kvArray objectAtIndex:1] forKey:[kvArray objectAtIndex:0]];
        }
    }
    
    return kvDic;
}

#pragma mark - 友盟分享 method private
- (void)showShareOn:(ISTBaseViewController *)vc content:(NSString *)text imageUrl:(NSString *)imageUrl shareUrl:(NSString *)url wxsessionContent:(NSDictionary *)wxsessionContent
{
    //分享内嵌文字
    NSString *shareText = text;
    //分享内嵌图片
    UIImage *shareImage = [UIImage imageNamed:@"Icon-60"];
    if(imageUrl){
        shareImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imageUrl];
        if(shareImage == nil){
            shareImage = [[UIImage alloc] initWithData:[[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:imageUrl]]];
        }
    }
    
    // 分享到微信设置url
    [UMSocialWechatHandler setWXAppId:@"wxac4778adb8dbc9ea" appSecret:@"da972b13215611e5291c31374534d3b8" url:url];
    //[UMSocialData defaultData].extConfig.wechatSessionData.wxMessageType = UMSocialWXMessageTypeImage;
    //短信配置：
    [UMSocialData defaultData].extConfig.smsData.shareText = [NSString stringWithFormat:@"快乐生活每一天！更多优惠值得你拥有！赶快下载APP试用吧！地址：%@；",url];
    [UMSocialData defaultData].extConfig.smsData.shareImage = nil;
    
    //微信配置
    //好友：
    [UMSocialData defaultData].extConfig.wechatSessionData.shareImage = shareImage;
    [UMSocialData defaultData].extConfig.wechatSessionData.title = [wxsessionContent objectForKey:@"title"];
    [UMSocialData defaultData].extConfig.wechatSessionData.shareText = [wxsessionContent objectForKey:@"address"];
    //朋友圈：
    [UMSocialData defaultData].extConfig.wechatTimelineData.shareImage = shareImage;
    
    //微博配置
    [UMSocialData defaultData].extConfig.sinaData.shareImage = shareImage;
    
    
    //设置分享到QQ空间的应用Id，和分享url 链接
    //    [UMSocialQQHandler setQQWithAppId:@"100424323" appKey:UmengAppkey url:nil];
    NSMutableArray *names = [NSMutableArray array];
    if ([WXApi isWXAppInstalled]) {
        [names addObject:UMShareToWechatSession];
        [names addObject:UMShareToWechatTimeline];
    }
    
    [names addObject:UMShareToSina];
    //    [names addObject:UMShareToTencent];
    //    [names addObject:UMShareToQQ];
    //    [names addObject:UMShareToEmail];
    [names addObject:UMShareToSms];
    //调用快速分享接口
    [UMSocialSnsService presentSnsIconSheetView:vc
                                         appKey:UmengAppkey
                                      shareText:shareText
                                     shareImage:nil
                                shareToSnsNames:names
                                       delegate:self];
}


#pragma mark - UMSocialUIDelegate
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}

#pragma mark - IQKeyBoard

- (void)startIQKeyboard
{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = NO;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = YES;
}

#pragma mark Baidu Map

- (void)startBaiduMap
{
    //百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    
    BOOL ret = [_mapManager start:kBaiduMapAK generalDelegate:nil];
    
    if (!ret) {
        NSLog(@"manager start failed!");
    }
}


#pragma mark - UMTrack

- (void)umengTrack {
    //    [MobClick setCrashReportEnabled:NO]; // 如果不需要捕捉异常，注释掉此行
    //[MobClick setLogEnabled:YES];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    //
    [MobClick startWithAppkey:UmengAppkey reportPolicy:(ReportPolicy) REALTIME channelId:nil];
    //   reportPolicy为枚举类型,可以为 REALTIME, BATCH,SENDDAILY,SENDWIFIONLY几种
    //   channelId 为NSString * 类型，channelId 为nil或@""时,默认会被被当作@"App Store"渠道
    
    //      [MobClick checkUpdate];   //自动更新检查, 如果需要自定义更新请使用下面的方法,需要接收一个(NSDictionary *)appInfo的参数
    //    [MobClick checkUpdateWithDelegate:self selector:@selector(updateMethod:)];
    
    [MobClick updateOnlineConfig];  //在线参数配置
    
    //    1.6.8之前的初始化方法
    //    [MobClick setDelegate:self reportPolicy:REALTIME];  //建议使用新方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineConfigCallBack:) name:UMOnlineConfigDidFinishedNotification object:nil];
    
}

- (void)onlineConfigCallBack:(NSNotification *)note {
    
    NSLog(@"online config has fininshed and note = %@", note.userInfo);
}


#pragma mark - 登陆界面相关
- (void)showTabBar{
    
    [UIView transitionFromView:self.window.rootViewController.view
                        toView:self.rootNavigation.view
                      duration:0.5
                       options:UIViewAnimationOptionTransitionCurlUp
                    completion:^(BOOL finished)
     {
         self.window.rootViewController = self.rootNavigation;
     }];
    
    [self.window makeKeyAndVisible];
}
- (void)showLoginView{
    
    [UIView transitionFromView:self.window.rootViewController.view
                        toView:self.loginNavigation.view
                      duration:0.5
                       options:UIViewAnimationOptionTransitionCurlDown
                    completion:^(BOOL finished)
     {
         self.window.rootViewController = self.loginNavigation;
     }];
    
    [self.window makeKeyAndVisible];
}

#pragma mark - 微信相关
-(void)configWeiXin{
    [WXApi registerApp:wxAppKey withDescription:@"weixin"];
}

#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp {
    //微信登录
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        
        SendAuthResp *authResp = (SendAuthResp *)resp;
        if (authResp.errCode == 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"WexinLogin" object:nil userInfo:@{@"code":authResp.code}];
        }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"WexinLoginFailed" object:nil];
        }
        
    }
    //微信支付
    else if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        
        switch (resp.errCode) {
            case WXSuccess:
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kPaySucceedNotification object:@{@"result":[NSNumber numberWithBool:YES]}];
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                break;
                
            default:
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kPaySucceedNotification object:@{@"result":[NSNumber numberWithBool:NO]}];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }
    }
}

#pragma mark - UMSocial
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSLog(@"application %@", application);
    // 处理调用
    // 这里处理新浪微博SSO授权之后跳转回来，和微信分享完成之后跳转回来
    NSLog(@"source app-%@, des app-%@",sourceApplication,application);
    if ([sourceApplication isEqualToString:@"com.tencent.xin"]) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    else if([url.host isEqualToString:@"safepay"])
    {
        //跳转支付宝钱包进行支付，处理支付结果
        //        这个方法的block没调用，官方demo也没调用，莫名其妙的调用了BSPayCenter里的block方法：[[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic)
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url
                                                  standbyCallback:^(NSDictionary *resultDic) {
                                                      NSLog(@"result = %@",resultDic);
                                                      NSString *resultSting = resultDic[@"result"];
                                                      NSLog(@"%@",resultSting);
                                                  }];
        
        return YES;
        
    }
    //UMSocial
    else
    {
        return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
    }
}

- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    return  [WXApi handleOpenURL:url delegate:self];
}

@end
