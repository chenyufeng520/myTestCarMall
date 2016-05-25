//
//  DragView.h
//  DragView
//
//  Created by 陈宇峰 on 16/5/24.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DragBlock)();

@interface DragView : UIView

@property(nonatomic, copy)DragBlock block;

@end
