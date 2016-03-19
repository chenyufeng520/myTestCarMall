//
//  ISTSectionBar.h
//  PointsMall
//
//  Created by 高大鹏 on 15/10/24.
//  Copyright © 2015年 高大鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BSSectionBarDelegate;

@interface ISTSectionBar : UIView

@property (nonatomic, strong) NSArray *sections;
@property (nonatomic, strong) UIColor *sectionColor;
@property (nonatomic, assign) id<BSSectionBarDelegate> delegate;
//@property (nonatomic, strong) void(^doneBlock)(NSInteger index);

- (void)showInView:(UIView *)superView;
- (void)changeSections:(NSArray *)sections;

@end

@protocol BSSectionBarDelegate <NSObject>

- (void)chooseColumn:(NSInteger)index;

@end
