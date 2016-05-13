//
//  CustomBarButton.m
//  CarLife
//
//  Created by 陈宇峰 on 16/5/11.
//  Copyright © 2016年 高大鹏. All rights reserved.
//

#import "CustomBarButton.h"

@implementation CustomBarButton

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    return CGRectMake(contentRect.origin.x, contentRect.size.height - kAdjustLength(60), contentRect.size.width, kAdjustLength(60));
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    return CGRectMake(contentRect.origin.x, contentRect.origin.y + kAdjustLength(10), contentRect.size.width, contentRect.size.height - kAdjustLength(70));
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
