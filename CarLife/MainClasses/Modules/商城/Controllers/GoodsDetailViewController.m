//
//  GoodsDetailViewController.m
//  CarLife
//
//  Created by 聂康  on 16/5/26.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import "GoodsDetailViewController.h"

@interface GoodsDetailViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UILabel *labelOnImage;
@property (weak, nonatomic) IBOutlet UILabel *introLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topImageViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alphaLabelHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alphaLabelToTop;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrToTopHeight;
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
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initConstantWithData];
}

/** 根据传过来的模型数据设置约束*/
- (void)initConstantWithData{
    _scrToTopHeight.constant = self.iosChangeFloat + kNavHeight;
    _topImageViewHeight.constant = kScreen_Width *9/16.f;
    
    [_topImageView sd_setImageWithURL:KImageUrl(self.productModel.goods_picurl) placeholderImage:[UIImage imageNamed:@"占位图"]];
    
    _alphaLabelHeight.constant = kAdjustLength(100);
    _alphaLabelToTop.constant = _topImageViewHeight.constant - kAdjustLength(100);
    _labelOnImage.text = [NSString stringWithFormat:@"%@(%@)",self.productModel.goods_name,self.productModel.goods_remark];
    
    _introLabel.text = self.productModel.goods_intr;
    
    _contentView.contentSize = CGSizeMake(kScreen_Width,kScreen_Height - self.iosChangeFloat - kNavHeight);
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
