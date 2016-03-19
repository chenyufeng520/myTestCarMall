//
//  BaseGlobalDef.h
//  CarLife
//
//  Created by 陈宇峰 on 16/3/19.
//  Copyright © 2016年 高大鹏. All rights reserved.
//

#ifndef BaseGlobalDef_h
#define BaseGlobalDef_h

#define kKeyWindow [UIApplication sharedApplication].keyWindow

/**System Config**/
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

#define IOSVersion              [[[UIDevice currentDevice] systemVersion] floatValue]
#define kScreen_Height          [[UIScreen mainScreen] bounds].size.height
#define kScreen_Width           [[UIScreen mainScreen] bounds].size.width
#define kTopFrame               CGRectMake(0, 0, kScreen_Width, kNavHeight+self.iosChangeFloat)
#define kTabbarOffset           0
#define kNavHeight              kAdjustLength(148)
#define kTabBarHeight           kAdjustLength(160)
#define kAdjustLength(x)        kScreen_Width*(x)/1080

#define Phone_WidthProportion(Width)     Width*kScreen_Width/375
#define Phone_HeightProportion(Height)     Height*kScreen_Height/736


//提示语
#define KTipFun [UIAlertHelper showAlert:@"敬请期待" AndShowView:_contentView];
#define KTipView(_S_, ...) [UIAlertHelper showAlert:[NSString stringWithFormat:(_S_), ##__VA_ARGS__] AndShowView:_contentView];
/**分割线及边框**/
#define kLinePixel           1
#define  kLineColor          RGBCOLOR(244, 244, 244)
#define kCornerRadius        5.0
#define kBorderWidth         1.0

/**文件路径相关设置**/
#define kDocumentPath   [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
#define kLocalDBPath   [kDocumentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"BasicDB.db"]]

/**常用函数宏**/
#define kTipAlert(_S_, ...)     [[[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:(_S_), ##__VA_ARGS__] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show]

/**编译**/
#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

#define ISDEV 1
#ifndef BSLog
#if ISDEV==1
#define BSLog(id, ...) NSLog((@"%s [Line %d] " id),__PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define BSLog(id, ...)
#endif
#endif

/**服务器主域名设置**/

#define kMainDomain             @"http://autolife.nsenz.com:80"
#define kTestMainDomain         @"http://101.201.174.252"

/**账号设置**/
#define kNoAutoLogin            @"kAutoLogin"
#define kNotFirstRun            @"kNotFirstRun"
#define kUSERINFO               @"userInfo"
#define kRememberPWD            @"kRememberPWD"
#define kPassword               @"kPassword"
#define kPhone                  @"phone"
#define kUserid                 @"kUserid"

/**第三方账号设置**/
static NSString *UmengAppkey    = @"56e67d0de0f55a6688000ee2";
static NSString *kBaiduMapAK    = @"e4xMAVREDcy16SZpDbustl2t";
static NSString *wxAppKey       = @"wxac4778adb8dbc9ea";
static NSString *wxSecret       = @"da972b13215611e5291c31374534d3b8";
static NSString *KeFuAppKey     = @"3d09752b4ad192976fd39172a9d72e1a";

/**支付方式**/
typedef enum {
    WeiXin = 0,
    AliPay = 1,
    CUP = 2,
    Offline = 3,
} PayType;

/**颜色函数和常用颜色**/
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

#define  kMainBGColor            RGBCOLOR(240,240,240)
#define  kNavBarColor            RGBCOLOR(185,0,16)
#define  kStatusBarColor         RGBCOLOR(185,0,16)
#define  kDarkTextColor          RGBCOLOR(76, 73, 72)
#define  kLightTextColor         RGBCOLOR(137, 137, 137)

#define  kClearColor             [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0]
#define  kWhiteColor             RGBCOLOR(255, 255, 255)
#define  kLightGreenColor        RGBCOLOR(122, 205, 133)
#define  kDarkGreenColor         RGBCOLOR(55, 166, 76)
#define  kDarkGreenColor1        RGBCOLOR(12, 172, 134)//积分查询的积分颜色
#define  kBlueColor              RGBCOLOR(65, 157, 246)
#define  kGreenColor             RGBCOLOR(52, 208, 97)
#define  kRedColor               RGBCOLOR(203, 47, 31)
#define  kOrangeColor            RGBCOLOR(241, 115, 27)
#define  kLigthRedColor          RGBCOLOR(223, 62, 51)
#define  kDarkRedColor           RGBCOLOR(220, 30, 70)

/**字体字号配置**/
#define kFontHuge               [UIFont systemFontOfSize:27]
#define kFontHuge_b             [UIFont boldSystemFontOfSize:27]
#define kFontSuper              [UIFont systemFontOfSize:20]
#define kFontSuper_b            [UIFont boldSystemFontOfSize:20]
#define kFontLarge_2            [UIFont systemFontOfSize:19]
#define kFontLarge_2_b          [UIFont boldSystemFontOfSize:19]
#define kFontLarge_1            [UIFont systemFontOfSize:15]
#define kFontLarge_1_b          [UIFont boldSystemFontOfSize:15]
#define kFontNormalBold         [UIFont boldSystemFontOfSize:14]
#define kFontNormal             [UIFont systemFontOfSize:14]
#define kFontMiddle             [UIFont systemFontOfSize:13]
#define kFontMiddleBold         [UIFont boldSystemFontOfSize:13]
#define kFontSmall              [UIFont systemFontOfSize:12]
#define kFontSmallBold          [UIFont boldSystemFontOfSize:12]
#define kFontTiny               [UIFont systemFontOfSize:11]
#define kFontTinyBold           [UIFont boldSystemFontOfSize:11]
#define kFontMini               [UIFont systemFontOfSize:10]
#define kFontMiniBold           [UIFont boldSystemFontOfSize:10]

/**通知**/
static NSString *kLoginNotification                 = @"kLoginNotification";                //登录操作
static NSString *kLogoutNotification                = @"kLogoutNotification";               //注销操作
static NSString *kLoginSucceedNotification          = @"kLoginSucceedNotification";         //登录成功
static NSString *kLogoutSucceedNotification         = @"kLogoutSucceedNotification";        //注销成功
static NSString *kShowMenusNotification             = @"kShowMenusNotification";            //显示侧导航
static NSString *kPaySucceedNotification            = @"kPaySucceedNotification";           //支付结果
static NSString *kApplicationDidBecameForeground    = @"applicationDidBecameForeground";    //APP进入前台
static NSString *kApplicationDidEnterBackground     = @"applicationDidEnterBackground";     //APP进入后台
static NSString *kContentItemSelectNotification     = @"kContentItemSelectNotification";    //下导航切换
static NSString *kTurnBackHomeNotification          = @"kTurnBackHomeNotification";         //返回首页
static NSString *kWXLoginSuccessed                  = @"kWXLoginSuccessed";                 //微信登录成功
static NSString *kWXLoginFailed                     = @"kWXLoginFailed";                    //微信登录失败
static NSString *kSocketConnectNotification         = @"kSocketConnectNotification";        //socket连接成功通知


#endif /* BaseGlobalDef_h */
