//
//  ISTTopBar.h
//  BSports
//
//  Created by 陈宇峰 on 16/5/10.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISTBaseView.h"

#define kButtonEdgeInsetsLeft               15
#define kBackButtonEdgeInsetsLeft           10

typedef enum {
    BSTopBarButtonLeft = 1,
    BSTopBarButtonRight = 2,
    BSTopBarButtonTitle = 3
} UCTopBarButton;

@interface ISTTopBar : ISTBaseView

@property (nonatomic, readonly) UIButton *btnTitle;
@property (nonatomic, readonly) UIButton *btnLeft;
@property (nonatomic, strong) UIButton *btnRight;

- (void)setLetfTitle:(NSString *)title;
- (void)setRightTitle:(NSString *)title;
@end
