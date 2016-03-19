//
//  ISTCustomBar.m
//  HMDemo
//
//  Created by Raik on 14-3-17.
//  Copyright (c) 2014年 iShinetech. All rights reserved.
//

#import "ISTCustomBar.h"
#import "ISTGlobal.h"
#import "BaseGlobalDef.h"
#import "TabbarItem.h"

#define kItemLineTag               110
@implementation ISTCustomBar

- (id)initWithFrame:(CGRect)frame withContent:(NSArray *)array
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        self.tabbars = [NSMutableArray array];
        
        UIView *line = [[UIView alloc] initLineWithFrame:CGRectMake(0, 0, self.width, kLinePixel) color:kLineColor];
        [self addSubview:line];
        
        CGFloat kTabbarItemWidth = kScreen_Width/array.count;
        
        for (int i = 0; i < array.count; i++)
        {
            TabbarItem *tb = array[i];
            
            CGRect btmFrame = CGRectMake(kTabbarItemWidth*i, 0, kTabbarItemWidth, kTabBarHeight);
            if (tb.highlighted) {
                btmFrame = CGRectMake(kTabbarItemWidth*i, -0.2 * kTabBarHeight, kTabbarItemWidth, kTabBarHeight * 1.2);
            }
            UIButton *barItem = [UIButton buttonWithType:UIButtonTypeCustom];
            barItem.frame = btmFrame;
            barItem.tag = i;
            [barItem addTarget:self action:@selector(tabbarItemAction:) forControlEvents:UIControlEventTouchUpInside];
            
            UIImage *normalImage = [UIImage imageNamed:tb.unSelectImg];
            UIImage *selectedImage = [UIImage imageNamed:tb.selectImg];
            
            [barItem setImage:normalImage forState:UIControlStateNormal];
            [barItem setImage:selectedImage forState:UIControlStateSelected];
            barItem.imageView.contentMode = UIViewContentModeScaleAspectFit;
            barItem.imageEdgeInsets = [barItem setImageEdgeInsetsFromCenterOffSet:CGVectorMake(0, 0) imageSize:CGSizeMake(kTabbarItemWidth, btmFrame.size.height)];
            barItem.adjustsImageWhenHighlighted = NO;
            barItem.showsTouchWhenHighlighted = NO;
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 17, barItem.width, barItem.height-10)];
            //titleLabel.text = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"Title"]];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.textColor = kWhiteColor;
            titleLabel.font = [UIFont systemFontOfSize:14];
            //headerLabel.text = @"test";
            //            [barItem addSubview:titleLabel];
            //line:
            UIView *line = [[UIView alloc] initLineWithFrame:CGRectMake(0, 0, barItem.width, kLinePixel) color:kLightGreenColor];
            //            [barItem addSubview:line];
            line.hidden = YES;
            line.tag = kItemLineTag;
            
            [self.tabbars addObject:barItem];
            [self addSubview:barItem];
        }
    }
    return self;
}

- (void)dealloc
{
    self.tabbars = nil;
}

- (void)onTabbarItemTouched:(id)sender
{
    UIButton *item = (UIButton *)sender;
    if(_delegate && [_delegate respondsToSelector:@selector(didTabbarViewButtonTouched:)])
    {
        [self.delegate didTabbarViewButtonTouched:item.tag];
    }
}

//TODO:点击事件
- (void)tabbarItemAction:(UIButton *)btn
{
    [self setSelectedIndex:btn.tag];
}

- (void)setSelectedIndex:(int)index
{
    _selectedIndex = index;
    if (index < 0 || index > _tabbars.count - 1) {
        return;
    }
    UIButton *item = [_tabbars objectAtIndex:index];
    if(_currentBtn == nil || _currentBtn != item)
    {
        UIView *oldLine = [_currentBtn viewWithTag:kItemLineTag];
        if(oldLine){
            oldLine.hidden = YES;
        }
        UIView *newLine = [item viewWithTag:kItemLineTag];
        if(newLine){
            newLine.hidden = NO;
        }
        
        _currentBtn.selected = NO;
        _currentBtn = item;
        _currentBtn.selected = YES;
        
        [self bringSubviewToFront:item];
        [self onTabbarItemTouched:item];
    }
    else
    {
        
    }
}


@end
