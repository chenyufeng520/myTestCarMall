//
//  ISTWebViewController.h
//  CarLife
//
//  Created by 陈宇峰 on 16/7/20.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import "ISTBaseViewController.h"

@interface ISTWebViewController : ISTBaseViewController

@property (nonatomic, strong) NSString *navTitle;
@property (nonatomic, assign) BOOL showNavBar;
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic,strong)  NSString * paraString;

- (id)initWithNavTitle:(NSString *)title andUrl:(NSString *)url;

@end
