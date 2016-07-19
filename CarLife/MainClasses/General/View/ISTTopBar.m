//
//  ISTTopBar.m
//  BSports
//
//  Created by 陈宇峰 on 16/5/10.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import "ISTTopBar.h"
#import "BaseGlobalDef.h"

@implementation ISTTopBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    _statusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.iosChangeFloat)];
    _statusView.backgroundColor = kStatusBarColor;
    [self addSubview:_statusView];
    
    _topBarView = [[UIView alloc] initWithFrame:CGRectMake(0, self.iosChangeFloat, self.width, kNavHeight)];
    _topBarView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    self.backgroundColor = kNavBarColor;
    CGFloat segmentWidth = _topBarView.width / 4;
    
    // 标题
    _btnTitle = [[UIButton alloc] initWithFrame:CGRectMake(segmentWidth, 0, segmentWidth * 2, _topBarView.height)];
    _btnTitle.titleLabel.font = kFontLarge_2_b;
    _btnTitle.tag = BSTopBarButtonTitle;
    _btnTitle.exclusiveTouch = YES;
    [_btnTitle setTitleColor:kWhiteColor forState:UIControlStateNormal];
    
    // 左按钮
    _btnLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, segmentWidth, _topBarView.height)];
    _btnLeft.tag = BSTopBarButtonLeft;
    _btnLeft.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _btnLeft.titleLabel.font = kFontLarge_1;
    _btnLeft.titleEdgeInsets = UIEdgeInsetsMake(0, kButtonEdgeInsetsLeft, 0, 0);
    _btnLeft.imageEdgeInsets = UIEdgeInsetsMake(13, kButtonEdgeInsetsLeft, 13, 55);
    _btnLeft.exclusiveTouch = YES;
    [_btnLeft setTitleColor:kWhiteColor  forState:UIControlStateNormal];
    
    // 右按钮
    _btnRight = [[UIButton alloc] initWithFrame:CGRectMake(_topBarView.width - segmentWidth, 0, segmentWidth, _topBarView.height)];
    _btnRight.tag = BSTopBarButtonRight;
    _btnRight.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _btnRight.titleLabel.font = kFontLarge_1;
    _btnRight.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, kButtonEdgeInsetsLeft);
    _btnRight.exclusiveTouch = YES;
    [_btnRight setTitleColor:kWhiteColor  forState:UIControlStateNormal];
    
    //line:
    //UIView *line = [[UIView alloc] initLineWithFrame:CGRectMake(0, vBar.height-1, vBar.width, kLinePixel) color:kLineColor];
    
    [_topBarView addSubview:_btnTitle];
    [_topBarView addSubview:_btnLeft];
    [_topBarView addSubview:_btnRight];
    //[vBar addSubview:line];
    
    [self addSubview:_topBarView];
}

- (void)setLetfTitle:(NSString *)title
{
    if (title == nil || ![title length]) {
        [_btnLeft setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
        _btnLeft.imageView.contentMode = UIViewContentModeScaleAspectFit;
//        _btnLeft.imageEdgeInsets = [_btnLeft setImageEdgeInsetsFromOriginOffSet:CGVectorMake(15,15) imageSize:CGSizeMake(8, 15)];
    }
    [_btnLeft setTitle:title forState:UIControlStateNormal];
}

- (void)setRightTitle:(NSString *)title
{
    [_btnRight setTitle:title forState:UIControlStateNormal];
}

- (void)setShrink:(BOOL)shrink animated:(BOOL)animated
{
    
}

@end