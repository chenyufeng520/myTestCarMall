//
//  ISTSupBaseViewController.m
//  CarLife
//
//  Created by 陈宇峰 on 16/5/26.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import "ISTSupBaseViewController.h"
#import "TXCustomAlertWindow.h"
#import "STHUDManager.h"

@interface ISTSupBaseViewController ()

@end

@implementation ISTSupBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        if (IOSVersion < 7.0) {
            self.iosChangeFloat = 0;
        }else{
            self.iosChangeFloat = 20;
        }
        
    }
    
    return self;
}

/** 导航栏 */
- (ISTTopBar *)creatTopBarView:(CGRect)frame
{
    // 导航头
    ISTTopBar *tbTop = [[ISTTopBar alloc] initWithFrame:frame];
    [tbTop.btnTitle setTitle:@"天天运动" forState:UIControlStateNormal];
    [tbTop setLetfTitle:nil];
    [tbTop.btnLeft addTarget:self action:@selector(onClickTopBar:) forControlEvents:UIControlEventTouchUpInside];
    return tbTop;
}


//重要：不然有偏移
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
   
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = kMainBGColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - btn method
/** 顶栏点击事件 */
- (void)onClickTopBar:(UIButton *)btn
{
    if (btn.tag == BSTopBarButtonLeft) {
        
    }
    else if (btn.tag == BSTopBarButtonRight) {
        
    }
}

#pragma mark - 输出请求返回提示

- (void)outputErrorInfo:(NSDictionary *)dict andDefault:(NSString *)str
{
    if (str.length == 0) {
        str = @"请求数据失败！";
    }
    NSString *msg = str;
    if ([[dict objectForKey:@"message"] isKindOfClass:[NSString class]]) {
        msg = [dict objectForKey:@"message"];
    }
    
    kTipAlert(@"%@",msg);
}

- (NSString *)getMsg:(NSDictionary *)dict andDefault:(NSString *)str
{
    NSString *msg = str;
    if ([[dict objectForKey:@"msg"] isKindOfClass:[NSString class]]) {
        msg = [dict objectForKey:@"msg"];
    }
    
    return msg;
}

//显示HUD信息
- (void)showHudWithTitle:(NSString *)title
{
    [self showFailedHudWithTitle:title showSuccessImage:NO];
}

- (void)showFailedHudWithTitle:(NSString *)title
              showSuccessImage:(BOOL)showSuccessImage
{
    MBProgressHUD *failedHud = [[MBProgressHUD alloc] initWithView:self.view];
    //    failedHud.layer.cornerRadius = 5.f;
    //    failedHud.backgroundColor = RGBACOLOR(0, 0, 0, 0.7);
    //    [self.view addSubview:failedHud];
    [[TXCustomAlertWindow sharedWindow] showWithView:failedHud];
    
    if (showSuccessImage) {
        failedHud.mode = MBProgressHUDModeCustomView;
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hud_failed"]];
        failedHud.customView = imageView;
    }
    else{
        failedHud.mode = MBProgressHUDModeText;
    }
    
    failedHud.labelText = title;
    [failedHud show:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [failedHud hide:YES];
        [[TXCustomAlertWindow sharedWindow] hide];
    });
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
