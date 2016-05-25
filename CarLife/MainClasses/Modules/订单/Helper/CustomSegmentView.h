//
//  CustomSegmentView.h
//  CarLife
//
//  Created by 聂康  on 16/5/25.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomSegmentDelegate <NSObject>

/*
 当滑动XSSegmentedView滑块时，或者XSSegmentedView被点击时，会调用此方法。
 */
- (void)segmentedViewSelectTitleInteger:(NSInteger)integer;


@end

@interface CustomSegmentView : UIView

//标题数组
@property (nonatomic, copy) NSArray *titles;
//未选中文字、边框、滑块颜色
@property (nonatomic, strong) UIColor *textColor;
//背景、选中文字颜色，当设置为透明时，选中文字为白色
@property (nonatomic, strong) UIColor *viewColor;
//选中的标题
@property (nonatomic) NSInteger selectNumber;

@property (nonatomic, weak) id <CustomSegmentDelegate> delegate;


#pragma mark - 方法
/*
 设置标题
 */
- (void)setTitles:(NSArray *)titles;


@end
