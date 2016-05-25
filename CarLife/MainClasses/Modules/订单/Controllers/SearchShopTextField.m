//
//  SearchShopTextField.m
//  CarLife
//
//  Created by 聂康  on 16/5/25.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import "SearchShopTextField.h"

@implementation SearchShopTextField

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self baseInit];
    }
    return self;
}

- (void)baseInit{
    self.borderStyle = UITextBorderStyleNone;
    self.layer.cornerRadius = self.height * 0.5;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_1"]];
    self.leftView = imageView;
    self.leftViewMode = UITextFieldViewModeAlways;
    self.placeholder = @"请输入关键字查询";
    self.adjustsFontSizeToFitWidth = YES;
    self.textInputView.frame = CGRectMake(80, 0, 100, self.height);
}

- (CGRect)leftViewRectForBounds:(CGRect)bounds{
    return CGRectMake(10, (self.height-kAdjustLength(50))*0.5, kAdjustLength(50), kAdjustLength(50));
}

//- (CGRect)placeholderRectForBounds:(CGRect)bounds{
//    return CGRectMake(kAdjustLength(50)+20, 0, self.width-kAdjustLength(50)-20-kAdjustLength(50)*0.5, self.height);
//}
//
//- (CGRect)editingRectForBounds:(CGRect)bounds{
//    return CGRectMake(kAdjustLength(50)+20, 0, self.width-kAdjustLength(50)-20-kAdjustLength(50)*0.5, self.height);
//}
//
//- (CGRect)textRectForBounds:(CGRect)bounds{
//    return CGRectMake(kAdjustLength(50)+20, 0, self.width-kAdjustLength(50)-20-kAdjustLength(50)*0.5, self.height);
//}

@end
