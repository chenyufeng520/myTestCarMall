//
//  ISTSectionBar.m
//  PointsMall
//
//  Created by 高大鹏 on 15/10/24.
//  Copyright © 2015年 高大鹏. All rights reserved.
//

#import "ISTSectionBar.h"
#import "BaseGlobalDef.h"
#import "ISTGlobal.h"

static NSInteger kBaseTag = 2001;

@interface ISTSectionBar ()
{
    UIView *_barView;
}

@end

@implementation ISTSectionBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = RGBCOLOR(247, 247, 247);
    }
    
    return self;
}

- (void)showInView:(UIView *)superView
{
    NSInteger itemCount = _sections.count;
    CGFloat _x = 0.0f, itemWidth = (self.width - itemCount + kLinePixel)/itemCount;
    
    for (int i = 0; i < itemCount; ++i)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0+_x, 0, itemWidth, self.height);
        button.tag = kBaseTag + i;
        [button setTitle:_sections[i] forState:UIControlStateNormal];
        [button setTitleColor:kDarkTextColor forState:UIControlStateNormal];
        [button setTitleColor:_sectionColor forState:UIControlStateSelected];
        button.titleLabel.font = kFontNormal;
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0)
        {
            button.selected = YES;
        }
        
        [self addSubview:button];
        _x += itemWidth + kLinePixel;
    }
    
    for (int i = 1; i < itemCount; ++i) {
        UIView *vline = [[UIView alloc] initLineWithFrame:CGRectMake((itemWidth + kLinePixel) * i, 0, kLinePixel, self.height) color:RGBCOLOR(215, 217, 218)];
        [self addSubview:vline];
    }
    
    UIView *hline = [[UIView alloc] initLineWithFrame:CGRectMake(0, self.height - kLinePixel, self.width, kLinePixel) color:RGBCOLOR(215, 217, 218)];
    [self addSubview:hline];
    
    _barView = [[UIView alloc] initWithFrame:CGRectMake(0, -kLinePixel, itemWidth*2/3, kLinePixel * 2)];
    _barView.center = CGPointMake(itemWidth/2, _barView.centerY);
    _barView.backgroundColor = _sectionColor;
    [hline addSubview:_barView];
    
    [superView addSubview:self];
}

#pragma mark - changeTitle

- (void)changeSections:(NSArray *)sections
{
    _sections = nil;
    _sections = sections;

    for (id elem in self.subviews) {
        if ([elem isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)elem;
            if (btn.tag == kBaseTag + 0) {
                [btn setTitle:_sections[0] forState:UIControlStateNormal];
            }
            else if (btn.tag == kBaseTag + 1) {
                [btn setTitle:_sections[1] forState:UIControlStateNormal];
            }
        }
    }
}

#pragma mark - button Click

- (void)buttonPressed:(UIButton *)sender
{
    if (sender.selected) {
        return;
    }
    
    NSInteger index = sender.tag - kBaseTag;
    
    NSInteger itemCount = _sections.count;
    CGFloat itemWidth = self.width/itemCount;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        _barView.center = CGPointMake(itemWidth/2 + index * itemWidth, _barView.centerY);
    }];
    
//    if (self.doneBlock) {
//        _doneBlock(index);
//    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(chooseColumn:)]) {
        [_delegate chooseColumn:index];
    }
    
    [self resetBtnState];
    sender.selected = YES;
}

- (void)resetBtnState
{
    for (id elem in self.subviews)
    {
        if ([elem isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)elem;
            btn.selected = NO;
        }
    }
}

@end
