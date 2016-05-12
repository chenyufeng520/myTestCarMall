//
//  ISTBaseViewController.h
//  BSports
//
//  Created by 陈宇峰 on 16/5/10.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISTTopBar.h"
#import "BaseGlobalDef.h"
#import "ISTGlobal.h"

@interface ISTBaseViewController : UIViewController<UIScrollViewDelegate>
{
    ISTTopBar *_tbTop;
    UIScrollView *_contentView;
}

//@property (nonatomic, assign) ModelCode code;
@property (nonatomic, assign) float iosChangeFloat;

- (void)onClickTopBar:(UIButton *)btn;


//直接输出错误信息
- (void)outputErrorInfo:(NSDictionary *)dict andDefault:(NSString *)str;
//返回请求Msg信息
- (NSString *)getMsg:(NSDictionary *)dict andDefault:(NSString *)str;

- (void)showHudWithTitle:(NSString *)title;

@end
