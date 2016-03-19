//
//  ISTLoginView.h
//  BSports
//
//  Created by 高大鹏 on 14/12/29.
//  Copyright (c) 2014年 ist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginDef.h"
#import "LoginCenter.h"
#import "ISTBaseView.h"
#import "ISTTopBar.h"
#import "ISTBaseViewController.h"

@interface ISTLoginView : ISTBaseView<UITextFieldDelegate>
{
    
}
@property (nonatomic, weak) ISTBaseViewController *vc;
@property (nonatomic, strong) UITextField *phoneNumberField;
@property (nonatomic, strong) UITextField *passwordField;
@property (nonatomic, strong) UITextField *scodeField;
@property (nonatomic, strong) UITextField *repasswordField;
@property (nonatomic, strong) UIButton *actionBtn;
@property (nonatomic, strong) UIButton *fetchscodeBtn;
@property (nonatomic, assign) ColumnType currentColumn;
@property (nonatomic, assign) UIType uitype;
@property (nonatomic, assign) NSInteger menuIndex;
@property (nonatomic, assign) AnimationType animationType;
@property (nonatomic, assign) BOOL animate;
@property (nonatomic, strong) ISTTopBar *tbTop;


- (void)showWithType:(ColumnType)type;
//忘记密码
- (id)initForgetModeFrame:(CGRect)frame;

@end

