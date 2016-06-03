//
//  GoodsDetailViewController.m
//  CarLife
//
//  Created by 聂康  on 16/5/26.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import "GoodsDetailViewController.h"

@interface GoodsDetailViewController ()
@end

@implementation GoodsDetailViewController

- (ISTTopBar *)creatTopBarView:(CGRect)frame
{
    // 导航头
    ISTTopBar *tbTop = [[ISTTopBar alloc] initWithFrame:frame];
    [tbTop.btnTitle setTitle:self.productModel.goods_name forState:UIControlStateNormal];
    [tbTop.btnLeft addTarget:self action:@selector(onClickTopBar:) forControlEvents:UIControlEventTouchUpInside];
    [tbTop setLetfTitle:nil];
    
    return tbTop;
}

- (void)loadSubviews
{
    _tbTop = [self creatTopBarView:kTopFrame];
    [self.view addSubview:_tbTop];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubviews];
    [self initWithModel];
}

- (void)initWithModel{
    UIImageView *topImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Width * 9/16.f)];
    [topImage sd_setImageWithURL:KImageUrl(self.productModel.goods_picurl) placeholderImage:[UIImage imageNamed:@"占位图"]];
    [_contentView addSubview:topImage];
    
    UILabel *labOnImage = [[UILabel alloc] initWithFrame:CGRectMake(0, topImage.maxY-kAdjustLength(120), kScreen_Width, kAdjustLength(120))];
    labOnImage.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.4];
    labOnImage.textAlignment = NSTextAlignmentCenter;
    labOnImage.textColor = [UIColor whiteColor];
    labOnImage.text = [NSString stringWithFormat:@"%@(%@)",self.productModel.goods_name,self.productModel.goods_remark];
    [_contentView addSubview:labOnImage];
    
    UILabel *introLab = [[UILabel alloc] init];
    introLab.text = [self.productModel.goods_intr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    introLab.font = kFontNormal;
    introLab.numberOfLines = 0;
    introLab.frame = CGRectMake(10, topImage.maxY+5, kScreen_Width-20, STRING_HEIGHT(introLab.text, kScreen_Width-20, kFontNormal));
    [_contentView addSubview:introLab];
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



@end
