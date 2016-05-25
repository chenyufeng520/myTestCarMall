//
//  CustomSegmentView.m
//  CarLife
//
//  Created by 聂康  on 16/5/25.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import "CustomSegmentView.h"

@interface CustomSegmentView (){
    CGFloat labelWidht;
    CGFloat labelHeight;
    NSInteger titleNumber;
    NSInteger lastSelectNumber;

}

@property (nonatomic, strong) UIView *shadeView;
@property (nonatomic, strong) UIView *topLabelView;
@property (nonatomic, strong) NSMutableArray *botLabelArray;
@property (nonatomic, strong) NSMutableArray *topLabelArray;


@end

@implementation CustomSegmentView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self baseInit];
    }
    
    return self;
}

- (void)baseInit {
    
    self.backgroundColor = [UIColor clearColor];
//    self.layer.borderWidth = 1;
//    self.layer.borderColor = [self.tintColor CGColor];
    self.layer.cornerRadius = self.height * 0.5;
    self.clipsToBounds = YES;
    self.botLabelArray = [[NSMutableArray alloc] init];
    self.topLabelArray = [[NSMutableArray alloc] init];
    
}

- (void)setTitles:(NSArray *)titles {
    
    _titles = titles;
    
    [self setSubViewWithTitles:titles];
    
}

- (void)setSubViewWithTitles:(NSArray *)titles {
    
    for(UIView *view in [self subviews])
    {
        [view removeFromSuperview];
    }
    
    titleNumber = self.titles.count;
    labelWidht = self.frame.size.width / titleNumber;
    labelHeight = self.frame.size.height;
    
    [self.botLabelArray removeAllObjects];
    
    for (int i = 0; i < titleNumber; i ++) {
        
        UILabel *titleLabel = [self labelWithFrame:CGRectMake(i * (labelWidht), 0, labelWidht, labelHeight) text:titles[i] textColor:[UIColor whiteColor]];
        
        [self.botLabelArray addObject:titleLabel];
        
        [self addSubview:titleLabel];
        
    }
    
    self.shadeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, labelWidht, labelHeight)];
    self.shadeView.backgroundColor = [UIColor whiteColor];
    self.shadeView.layer.cornerRadius = labelHeight * 0.5;
    self.shadeView.layer.borderColor = kNavBarColor.CGColor;
    self.shadeView.layer.borderWidth = 0.5;
    self.shadeView.clipsToBounds = YES;
    
    [self addSubview:self.shadeView];
    
    self.topLabelView = [[UIView alloc]initWithFrame:self.bounds];
    self.topLabelView.backgroundColor = [UIColor clearColor];
    
    [self.shadeView addSubview:self.topLabelView];
    
    [self.topLabelArray removeAllObjects];
    
    for (int i = 0; i < titleNumber; i ++) {
        
        UILabel *titleLabel = [self labelWithFrame:CGRectMake(i * (labelWidht), 0, labelWidht, labelHeight) text:titles[i] textColor:kNavBarColor];
        
        [self.topLabelArray addObject:titleLabel];
        
        [self.topLabelView addSubview:titleLabel];
    }
    
    for (int i = 0; i < titleNumber; i ++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(i * (labelWidht), 0, labelWidht, labelHeight);
        button.backgroundColor = [UIColor clearColor];
        button.tag = i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button];
        
    }
    
}

- (UILabel *)labelWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor {
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:frame];
    
    titleLabel.text = text;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = textColor;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
    
    return titleLabel;
}

- (void)setTextColor:(UIColor *)textColor {
    
    _textColor = textColor;
    
    for (UILabel *label in self.botLabelArray) {
        
        label.textColor = textColor;
        
    }
    
    self.shadeView.backgroundColor = textColor;
    self.layer.borderColor = [textColor CGColor];
}

- (void)setViewColor:(UIColor *)viewColor {
    
    _viewColor = viewColor;
    
    self.backgroundColor = viewColor;
    
    for (UILabel *label in self.topLabelArray) {
        
        if (viewColor != [UIColor clearColor]) {
            
            label.textColor = viewColor;
        }
    }
}

- (void)setSelectNumber:(NSInteger)selectNumber {
    _selectNumber = selectNumber;
    
    lastSelectNumber = selectNumber;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        [self selectTitleWithInteger:selectNumber];
        
        if ([_delegate respondsToSelector:@selector(segmentedViewSelectTitleInteger:)]) {
            [_delegate segmentedViewSelectTitleInteger:self.selectNumber];
        }
    }];
    
}

- (void)buttonClick:(UIButton *)sender {
    
    long select = sender.tag;
    
    lastSelectNumber = select;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        [self selectTitleWithInteger:select];
        
    }];
    
    if ([_delegate respondsToSelector:@selector(x)]) {
        [_delegate segmentedViewSelectTitleInteger:self.selectNumber];
    }
    
}

- (void)selectTitleWithInteger:(NSInteger)integer {
    
    _selectNumber = integer;
    
    self.shadeView.frame = CGRectMake(integer * labelWidht, 0, labelWidht, labelHeight);
    self.topLabelView.frame = CGRectMake(- integer * labelWidht, 0, self.frame.size.width, self.frame.size.height);
    
}

@end
