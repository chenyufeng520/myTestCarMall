//
//  ProductDetailViewController.m
//  CarLife
//
//  Created by 聂康  on 16/5/23.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import "ProductDetailViewController.h"

@interface ProductDetailViewController (){
    UIImageView *_productImage;
    UILabel *_labOnImage;
    UILabel *_productIntroLab;
    UIButton *_addBtn;
    UIButton *_reduceBtn;
    UITextField *_numTextField;
    UITextView *_messageTextView;
    UILabel *_totalCountLab;
    UIButton *_addToCart;
}

@end

@implementation ProductDetailViewController
- (ISTTopBar *)creatTopBarView:(CGRect)frame
{
    // 导航头
    ISTTopBar *tbTop = [[ISTTopBar alloc] initWithFrame:frame];
    [tbTop.btnTitle setTitle:self.title forState:UIControlStateNormal];
    [tbTop.btnLeft addTarget:self action:@selector(onClickTopBar:) forControlEvents:UIControlEventTouchUpInside];
    [tbTop setLetfTitle:nil];
    
    return tbTop;
}

- (void)loadSubviews
{
    _tbTop = [self creatTopBarView:kTopFrame];
    [self.view addSubview:_tbTop];
    _contentView.height += kTabBarHeight;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubviews];
    [self loadSubviewsOfContentView];
    [self loadProductDetailData];
}

#pragma mark - Click Menu

- (void)onClickTopBar:(UIButton *)btn
{
    if (btn.tag == BSTopBarButtonLeft) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (btn.tag == BSTopBarButtonRight) {
        
    }
}
  
- (void)loadSubviewsOfContentView{
    _productImage = [[UIImageView alloc] init];
    [_contentView addSubview:_productImage];
    
    _labOnImage = [[UILabel alloc] init];
    [_productImage addSubview:_labOnImage];
    
    _productIntroLab = [[UILabel alloc] init];
    _productIntroLab.font = [UIFont systemFontOfSize:14];
    _productIntroLab.numberOfLines = 0;
    [_contentView addSubview:_productIntroLab];
    
}

- (void)loadProductDetailData{

}

- (void)resetFrame{

}


@end
