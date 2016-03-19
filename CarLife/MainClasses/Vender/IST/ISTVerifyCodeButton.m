//
//  ISTVerifyCodeButton.m
//  PointsMall
//
//  Created by 高大鹏 on 15/10/23.
//  Copyright © 2015年 高大鹏. All rights reserved.
//

#import "ISTVerifyCodeButton.h"
#import "BaseGlobalDef.h"

static NSInteger validtime = 60;

@interface ISTVerifyCodeButton ()
{
    int _num;
    NSTimer *_timer;
}
@end

@implementation ISTVerifyCodeButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    
        [self addTarget:self action:@selector(touchAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)touchAction:(id)sender{
    if (self.block) {
        _block(self);
    }
}

- (void)startTimer
{
    [self onTimer];
}

- (void)setColor:(UIColor *)color
{
    _color = color;
    [self setBackgroundColor:kWhiteColor];
    [self setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self setTitleColor:_color forState:UIControlStateNormal];
    self.titleLabel.font = kFontSmall;
    self.layer.borderColor = _color.CGColor;
    self.layer.borderWidth = kLinePixel;
    self.layer.cornerRadius = kCornerRadius;
    self.layer.masksToBounds = YES;
}

#pragma mark - ValidCode methods

- (void)recoveryVerificationCode
{
    if(_timer)
    {
        //dispatch_source_cancel(_timer);
        [_timer invalidate];
        _timer = nil;
    }
    self.enabled = YES;
    self.layer.borderWidth = kLinePixel;
    [self setBackgroundColor:kWhiteColor];
    [self setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self setTitleColor:_color forState:UIControlStateNormal];
}

/** 计时器开始计时 */
- (void)onTimer
{
    _num = validtime;
    // 获取验证码按钮置灰
    self.enabled = NO;
    [self setBackgroundColor:[UIColor lightGrayColor]];
    [self setTitleColor:kWhiteColor forState:UIControlStateNormal];
    self.layer.borderWidth = 0;
    if (!_timer)
    {    
        _timer = [[NSTimer alloc] init];
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(getIdentifys:) userInfo:nil repeats:YES];
        [_timer fire];
    }
}

/** 短信倒计时 */
- (void)getIdentifys:(NSTimer *)timer
{
    _num -= 1;
    [self setTitle:[NSString stringWithFormat:@"剩余:%d秒", _num] forState:UIControlStateDisabled];
    if (_num == 0) {
        [self recoveryVerificationCode];
    }
}


@end
