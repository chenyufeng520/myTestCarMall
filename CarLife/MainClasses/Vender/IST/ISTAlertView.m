//
//  ISTAlertView.m
//  BSports
//
//  Created by 高大鹏 on 15/1/21.
//  Copyright (c) 2015年 ist. All rights reserved.
//

#import "ISTAlertView.h"
#import "BaseGlobalDef.h"
#import "ISTGlobal.h"

#define kDoneTag        1001
#define kCancelTag      1002
#define ConstantValue   777

@interface ISTAlertView ()

@end

@implementation ISTAlertView

+ (instancetype)alert
{
    ISTAlertView *alert = [[ISTAlertView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    return alert;
}

- (void)exChangeOut:(UIView *)changeOutView dur:(CFTimeInterval)dur{
    
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    animation.duration = dur;
    
    animation.removedOnCompletion = NO;
    
    animation.fillMode = kCAFillModeForwards;
    
    NSMutableArray *values = [NSMutableArray array];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
//
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    
    animation.values = values;
    
    animation.timingFunction = [CAMediaTimingFunction functionWithName: @"easeInEaseOut"];
    
    [changeOutView.layer addAnimation:animation forKey:nil];
    
}

- (void)configAlert
{
    UIWindow *win = [UIApplication sharedApplication].keyWindow;

    [win addSubview:self];
    
    self.backgroundColor = [UIColor clearColor];
    _index = 0;
    
    UIView *maskView = [[UIView alloc] initWithFrame:self.bounds];
    maskView.alpha = 0.7f;
    maskView.backgroundColor = [UIColor blackColor];
    [self addSubview:maskView];
    
    _drawView = [[UIView alloc] initWithFrame:self.bounds];
    _drawView.backgroundColor = [UIColor clearColor];
    [self exChangeOut:_drawView dur:0.25f];
    [self addSubview:_drawView];
}

#pragma mark - 针对事件布局，比较乱，待调整

//信息提示
- (void)showSimpleMessage:(NSString *)msg doneBlock:(void(^)(NSInteger index))block
{
    self.doneBlock3 = block;
    self.type = AlertType_Prompt;
    [self configAlert];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width - 20, kScreen_Width * 390/1080)];
    bgView.center = self.center;
    bgView.backgroundColor = kWhiteColor;
    [_drawView addSubview:bgView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 200, 20)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = @"提示";
    titleLabel.font = kFontNormal;
    titleLabel.textColor = kDarkTextColor;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:titleLabel];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, titleLabel.maxY + 10, 300, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.text = msg;
    label.font = kFontSmall;
    label.textColor = kLightTextColor;
    label.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:label];
    
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.frame = CGRectMake(bgView.width - 50, bgView.height - 35, 40, 30);
    [doneBtn setTitle:@"确定" forState:UIControlStateNormal];
    [doneBtn setTitleColor:kDarkGreenColor forState:UIControlStateNormal];
    doneBtn.titleLabel.font = kFontMiddle;
    [doneBtn setBackgroundColor:[UIColor clearColor]];
    doneBtn.tag = kDoneTag;
    [doneBtn addTarget:self action:@selector(doneBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:doneBtn];
}

//信息提示
- (void)showMessage:(NSString *)str doneBlock:(void(^)(NSInteger index))block
{
    self.doneBlock3 = block;
    self.type = AlertType_SelectPrompt;
    [self configAlert];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width - 20, kScreen_Width * 390/1080)];
    bgView.center = self.center;
    bgView.backgroundColor = kWhiteColor;
    [_drawView addSubview:bgView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 200, 20)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = @"提示";
    titleLabel.font = kFontNormal;
    titleLabel.textColor = kDarkTextColor;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:titleLabel];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, titleLabel.maxY + 10, 200, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.text = str;
    label.font = kFontSmall;
    label.textColor = kLightTextColor;
    label.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:label];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(bgView.width - 90, bgView.height - 35, 40, 30);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:kDarkTextColor forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = kFontMiddle;
    [cancelBtn setBackgroundColor:[UIColor clearColor]];
    cancelBtn.tag = kCancelTag;
    [cancelBtn addTarget:self action:@selector(doneBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:cancelBtn];
    
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.frame = CGRectMake(cancelBtn.maxX + 5, cancelBtn.minY, cancelBtn.width, cancelBtn.height);
    [doneBtn setTitle:@"确定" forState:UIControlStateNormal];
    [doneBtn setTitleColor:kDarkGreenColor forState:UIControlStateNormal];
    doneBtn.titleLabel.font = kFontMiddle;
    [doneBtn setBackgroundColor:[UIColor clearColor]];
    doneBtn.tag = kDoneTag;
    [doneBtn addTarget:self action:@selector(doneBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:doneBtn];
}

//输入
- (void)showInputInfo:(NSDictionary *)dic doneBlock:(void(^)(NSInteger index, NSString *msg))block
{
    self.doneBlock = block;
    self.type = AlertType_Input;
    [self configAlert];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width - 20, kScreen_Width * 390/1080)];
    bgView.center = CGPointMake(self.centerX, self.centerY - 100);
    bgView.backgroundColor = kWhiteColor;
    [_drawView addSubview:bgView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 200, 20)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = dic[@"title"];
    titleLabel.font = kFontNormal;
    titleLabel.textColor = kDarkTextColor;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:titleLabel];
    
    _textField = [[UITextField alloc] init];
    _textField.frame = CGRectMake(15, titleLabel.maxY + 10, bgView.width - 30, 20);
    _textField.backgroundColor = [UIColor clearColor];
    _textField.textAlignment = NSTextAlignmentLeft;
    _textField.font = kFontMiddle;
    _textField.textColor = kDarkTextColor;
    _textField.clearButtonMode = UITextFieldViewModeAlways;
    _textField.placeholder = dic[@"ph"];
    _textField.text = dic[@"text"];
    [bgView addSubview:_textField];
    [_textField becomeFirstResponder];
    
    UIView *line = [[UIView alloc] initLineWithFrame:CGRectMake(15, _textField.maxY + 5, _textField.width, kLinePixel) color:kDarkGreenColor];
    [bgView addSubview:line];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(bgView.width - 90, bgView.height - 35, 40, 30);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:kDarkTextColor forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = kFontMiddle;
    [cancelBtn setBackgroundColor:[UIColor clearColor]];
    cancelBtn.tag = kCancelTag;
    [cancelBtn addTarget:self action:@selector(doneBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:cancelBtn];
    
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.frame = CGRectMake(cancelBtn.maxX + 5, cancelBtn.minY, cancelBtn.width, cancelBtn.height);
    [doneBtn setTitle:@"确定" forState:UIControlStateNormal];
    [doneBtn setTitleColor:kDarkGreenColor forState:UIControlStateNormal];
    doneBtn.titleLabel.font = kFontMiddle;
    [doneBtn setBackgroundColor:[UIColor clearColor]];
    doneBtn.tag = kDoneTag;
    [doneBtn addTarget:self action:@selector(doneBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:doneBtn];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancel:)];
    [_drawView addGestureRecognizer:tapGestureRecognizer];

}

//修改密码
- (void)changePasswordWithdoneBlock:(void(^)(BOOL flag, NSDictionary *dic))block
{
    self.doneBlock2 = block;
    self.type = AlertType_ChangePwd;
    [self configAlert];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 0, self.width - 20, 150)];
    view.center = CGPointMake(self.centerX, self.centerY - 80);
    view.backgroundColor = kMainBGColor;
    [_drawView addSubview:view];
    view.layer.cornerRadius = kCornerRadius;
    view.layer.masksToBounds = YES;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 50)];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"输入旧密码";
    label.font = kFontNormal;
    label.textColor = kDarkTextColor;
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(label.maxX + 20, 0, 150, 50)];
    _textField.secureTextEntry = YES;
    _textField.textAlignment = NSTextAlignmentLeft;
    _textField.backgroundColor = [UIColor clearColor];
    [view addSubview:_textField];
    [_textField becomeFirstResponder];
    
    UIView *line = [[UIView alloc] initLineWithFrame:CGRectMake(0, _textField.maxY, view.width, kLinePixel) color:kLineColor];
    [view addSubview:line];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(10, line.maxY, 100, 49)];
    label2.backgroundColor = [UIColor clearColor];
    label2.text = @"输入新密码";
    label2.font = kFontNormal;
    label2.textColor = kDarkTextColor;
    label2.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label2];
    
    _textField2 = [[UITextField alloc] initWithFrame:CGRectMake(label.maxX + 20, label.maxY, 150, 49)];
    _textField2.secureTextEntry = YES;
    _textField2.textAlignment = NSTextAlignmentLeft;
    _textField2.backgroundColor = [UIColor clearColor];
    [view addSubview:_textField2];
    
    UIView *line2 = [[UIView alloc] initLineWithFrame:CGRectMake(0, _textField2.maxY, view.width, kLinePixel) color:kLineColor];
    [view addSubview:line2];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(10, line2.maxY, 100, 49)];
    label3.backgroundColor = [UIColor clearColor];
    label3.text = @"确认新密码";
    label3.font = kFontNormal;
    label3.textColor = kDarkTextColor;
    label3.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label3];
    
    _textField3 = [[UITextField alloc] initWithFrame:CGRectMake(label3.maxX + 20, label2.maxY, 150, 49)];
    _textField3.secureTextEntry = YES;
    _textField3.textAlignment = NSTextAlignmentLeft;
    _textField3.backgroundColor = [UIColor clearColor];
    [view addSubview:_textField3];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(10, view.maxY + 5, (view.width - 5)/2.0, 40);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:kDarkTextColor forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = kFontLarge_1_b;
    [cancelBtn setBackgroundColor:kMainBGColor];
    cancelBtn.layer.cornerRadius = kCornerRadius;
    cancelBtn.tag = kCancelTag;
    [cancelBtn addTarget:self action:@selector(doneBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_drawView addSubview:cancelBtn];
    
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.frame = CGRectMake(cancelBtn.maxX + 5, view.maxY + 5, cancelBtn.width, 40);
    [doneBtn setTitle:@"确定" forState:UIControlStateNormal];
    [doneBtn setTitleColor:kDarkGreenColor forState:UIControlStateNormal];
    doneBtn.titleLabel.font = kFontLarge_1_b;
    [doneBtn setBackgroundColor:kMainBGColor];
    doneBtn.layer.cornerRadius = kCornerRadius;
    doneBtn.tag = kDoneTag;
    [doneBtn addTarget:self action:@selector(doneBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_drawView addSubview:doneBtn];
    
}

//输入
- (void)showPhotoWithdoneBlock:(void(^)(NSInteger index))block
{
    self.doneBlock3 = block;
    self.type = AlertType_showPhoto;
    [self configAlert];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width * 913/1080, kScreen_Width * 390/1080)];
    bgView.center = self.center;
    bgView.backgroundColor = kWhiteColor;
    [_drawView addSubview:bgView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 200, 20)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = @"设置头像";
    titleLabel.font = kFontNormal;
    titleLabel.textColor = kDarkTextColor;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:titleLabel];

    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, titleLabel.maxY + 10, bgView.width - 30, 30);
    [cancelBtn setTitle:@"本地图库" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:kLightTextColor forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = kFontMiddle;
    [cancelBtn setBackgroundColor:[UIColor clearColor]];
    cancelBtn.tag = kCancelTag;
    cancelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    cancelBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    [cancelBtn addTarget:self action:@selector(doneBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:cancelBtn];
    
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.frame = CGRectMake(0, cancelBtn.maxY + 7, cancelBtn.width, cancelBtn.height);
    [doneBtn setTitle:@"拍照" forState:UIControlStateNormal];
    [doneBtn setTitleColor:kLightTextColor forState:UIControlStateNormal];
    doneBtn.titleLabel.font = kFontMiddle;
    [doneBtn setBackgroundColor:[UIColor clearColor]];
    doneBtn.tag = kDoneTag;
    doneBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    doneBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    [doneBtn addTarget:self action:@selector(doneBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:doneBtn];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancel:)];
    [_drawView addGestureRecognizer:tapGestureRecognizer];
    
}

#pragma mark - 手势

- (void)cancel:(UITapGestureRecognizer *)tap
{
    [UIView animateWithDuration:0.35 animations:^{
        
        [self removeFromSuperview];
        [_drawView removeGestureRecognizer:tap];
    }];
}

#pragma mark - buttonPressed!

- (void)doneBtnClicked:(UIButton *)sender
{
    switch (self.type) {
        case AlertType_Prompt:
        {
            [UIView animateWithDuration:0.35 animations:^{
                
                [self removeFromSuperview];
            }];
            
            if (self.doneBlock3) {
                self.doneBlock3(0);
            }
        }
            break;
        case AlertType_SelectPrompt:
        {
            [UIView animateWithDuration:0.35 animations:^{
                
                [self removeFromSuperview];
            }];
            
            if (self.doneBlock) {
                if (sender.tag == kDoneTag) {
                    self.doneBlock3(1);
                }
                else if(sender.tag == kCancelTag)
                {
                    self.doneBlock3(0);
                }
            }
        }
            break;
        case AlertType_Input:
        {
            [UIView animateWithDuration:0.35 animations:^{
                
                [self removeFromSuperview];
            }];
            
            if (self.doneBlock) {
                if (sender.tag == kDoneTag) {
                    self.doneBlock(1, _textField.text);
                }
                else if(sender.tag == kCancelTag)
                {
                    self.doneBlock(0, @"");
                }
            }
        }
            break;
        case AlertType_ChangePwd:
        {
            if (self.doneBlock2) {
                if (sender.tag == kDoneTag) {
                    if (![_textField2.text isEqualToString:_textField3.text])
                    {
                        kTipAlert(@"密码输入不一致");
                    }
                    else if (_textField.text.length == 0 || _textField2.text.length == 0 || _textField3.text.length == 0)
                    {
                        kTipAlert(@"密码不能为空");
                    }
                    else
                    {
                        [UIView animateWithDuration:0.35 animations:^{
                            
                            [self removeFromSuperview];
                        }];
                        self.doneBlock2(YES, @{@"old":_textField.text,@"new":_textField2.text});

                    }

                }
                else if(sender.tag == kCancelTag)
                {
                    [UIView animateWithDuration:0.35 animations:^{
                        
                        [self removeFromSuperview];
                    }];
                    self.doneBlock2(NO, @{});
                }
            }
        }
            break;
        case AlertType_showPhoto:
        {
            [UIView animateWithDuration:0.35 animations:^{
                
                [self removeFromSuperview];
            }];
            
            if (self.doneBlock3) {
                if (sender.tag == kDoneTag) {
                    self.doneBlock3(1);
                }
                else if(sender.tag == kCancelTag)
                {
                    self.doneBlock3(0);
                }
            }
        }
            break;
            
        default:
            break;
    }
    
}



@end
