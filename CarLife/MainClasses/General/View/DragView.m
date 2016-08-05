//
//  DragView.m
//  DragView
//
//  Created by 陈宇峰 on 16/5/24.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import "DragView.h"

@implementation DragView {
    CGPoint _endPoint;
    CGPoint _startPoint;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)init   {
    self = [super init];
    if(self){
        [self parametersSetup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self){
        [self parametersSetup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        [self parametersSetup];
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
     UITouch *touch = [touches anyObject];
    _startPoint = [touch locationInView:[self superview]];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self move:touches];
    
    UITouch *touch = [touches anyObject];
    if (touch.tapCount == 1) {
        if (_block!= nil) {
            _block();
        }
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self move:touches];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self move:touches];
}

/**
 *  设置关键参数
 */
- (void)parametersSetup {
    self.userInteractionEnabled = YES;
}

/**
 *  获取精准的CGPoint
 *
 *  @param start 移动前CGPoint
 *  @param end   移动的CGPoint
 *
 *  @return 精准的CGPoint
 */
- (CGPoint)getAccuratePoint:(CGPoint)start end:(CGPoint)end {
    CGPoint point = CGPointMake(end.x - (start.x - self.frame.origin.x), end.y - (start.y - self.frame.origin.y));
    return point;
}

/**
 *  边界检测
 *
 *  @param point 精准的CGPoint
 *
 *  @return 是否越界
 */
- (BOOL)checkPoint:(CGPoint)point {
//    NSLog(@"%f",kScreen_Height - kTabBarHeight);
//    if (point.y < 20+kNavHeight) {
//        return false;
//    }
//    if (point.y > kScreen_Height - kTabBarHeight-self.frame.size.height) {
//        return false;
//    }
    if (-point.x >= self.frame.size.width/2) {
        return false;
    }
    
    if (point.x >([self superview].frame.size.width - self.frame.size.width /2)) {
        return false;
    }
    
    if(-point.y >= self.frame.size.height/2){
        return false;
    }
    
    if (point.y >([self superview].frame.size.height - self.frame.size.height /2)) {
        return false;
    }
    CGRect rect = [self superview].frame;
    return true;
}

/**
 *  移动并作根据事件和精准的CGPoint作动画
 *
 *  @param touches 触摸的信息
 */
- (void)move:(NSSet<UITouch *> *)touches{
    UITouch *touch = [touches anyObject];
    _endPoint = [touch locationInView:[self superview]];
    CGPoint end = [self getAccuratePoint:_startPoint end:_endPoint];
    if (touch.phase == UITouchPhaseMoved) {
        if ([self checkPoint:end]) {
            /** 由于拖动的view在导航条下，而且拖动的view加在self.view上，所以要去掉一段距离*/
            if (end.y<20+kNavHeight) {
                end.y = 20 + kNavHeight;
            }
            if (end.y > kScreen_Height-kTabBarHeight-self.frame.size.height) {
                end.y = kScreen_Height - self.frame.size.height-kTabBarHeight;
            }
            /***/
            self.frame = CGRectMake(end.x, end.y, self.frame.size.width, self.frame.size.height);
        }
    }
    _startPoint = _endPoint;
    if (touch.phase == UITouchPhaseEnded || touch.phase == UITouchPhaseCancelled) {
        [self animate:end];
    }
}

/**
 *  根据当前的精准的CGPoint作动画
 *
 *  @param point 精准的CGPoint
 */
- (void)animate:(CGPoint)point {
    float swidth = [self superview].frame.size.width ;
    float sheight = [self superview].frame.size.height;
    
    if (point.x < 0) {
        point.x = 0;
    }
    

    if(point.x >= (swidth - self.frame.size.width)){
         point.x = swidth - self.frame.size.width;
    }
    
    if (point.y < 0) {
        point.y = 0;
    }
    
    if(point.y >= (sheight - self.frame.size.height)){
        point.y = sheight - self.frame.size.height;
    }
    
    if ((point.x + self.frame.size.width/2) < swidth / 2) {
        if (point.y < point.x ) {
            point.y = 0;
        } else if(sheight - point.y - self.frame.size.height < point.x){
            point.y = sheight - self.frame.size.height;
        } else {
            point.x = 0;
        }
    } else {
        if (point.y < swidth - self.frame.origin.x - self.frame.size.width) {
            point.y = 0;
        } else if(sheight - point.y - self.frame.size.height < swidth - self.frame.origin.x - self.frame.size.width){
           point.y = sheight - self.frame.size.height;
        } else {
           point.x = [self superview].frame.size.width - self.frame.size.width;
        }
    }
    
    /** 由于拖动的view在导航条下，而且拖动的view加在self.view上，所以要去掉一段距离*/
    if (point.y<20+kNavHeight) {
        point.y = 20 + kNavHeight;
    }
    if (point.y > kScreen_Height-kTabBarHeight-self.frame.size.height) {
        point.y = kScreen_Height - self.frame.size.height-kTabBarHeight;
    }
    /***/

    [UIView animateWithDuration:0.3f animations:^{
        self.frame = CGRectMake(point.x, point.y, self.frame.size.width, self.frame.size.height);
    }];
}

@end
