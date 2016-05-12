//
//  ISTCustomBar.h
//  HMDemo
//
//  Created by 陈宇峰 on 16/5/10.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ISTCustomBarDelegate <NSObject>
@optional
- (void)didTabbarViewButtonTouched:(NSInteger)index;
@end

@interface ISTCustomBar : UIView
{
    UIButton *_currentBtn;
    int _selectedIndex;
}
@property (nonatomic, assign) id<ISTCustomBarDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *tabbars;
@property (nonatomic, assign) int seletedIndex;

- (id)initWithFrame:(CGRect)frame withContent:(NSArray *)array;
- (void)setSelectedIndex:(int)index;

@end
