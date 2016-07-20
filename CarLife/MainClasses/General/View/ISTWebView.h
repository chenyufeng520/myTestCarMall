//
//  WebView.h
//  PointsMall
//
//  Created by 陈宇峰 on 16/7/20.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import "ISTBaseView.h"

@protocol  ISTWebViewDelegate;

@interface ISTWebView : ISTBaseView

@property (nonatomic, copy) NSString *URL;
@property (nonatomic, assign) id<ISTWebViewDelegate> delegate;
@property (nonatomic, strong) UIWebView *webView;

@end

@protocol ISTWebViewDelegate <NSObject>

@optional
- (void)webHeightAdjusted:(CGFloat )height;

@optional
-(void)jumpToWebVC:(NSString *)title andUrl:(NSString *)urlString;

@optional
-(void)jumpToApp:(NSString *)type andPara:(NSString *)para;

@end