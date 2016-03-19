//
//  ISTCustomBar.h
//  HMDemo
//
//  Created by Raik on 14-3-17.
//  Copyright (c) 2014年 iShinetech. All rights reserved.
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
