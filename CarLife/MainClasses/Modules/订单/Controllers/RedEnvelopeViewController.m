
//
//  RedEnvelopeViewController.m
//  CarLife
//
//  Created by 聂康  on 16/7/19.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import "RedEnvelopeViewController.h"

@interface RedEnvelopeViewController ()
@property (weak, nonatomic) IBOutlet UITextField *firstTextField;
@property (weak, nonatomic) IBOutlet UITextField *secondTextField;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UIButton *addMoneyButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toTopHeight;
@end

@implementation RedEnvelopeViewController

- (ISTTopBar *)creatTopBarView:(CGRect)frame
{
    // 导航头
    ISTTopBar *tbTop = [[ISTTopBar alloc] initWithFrame:frame];
    [tbTop.btnTitle setTitle:@"发红包" forState:UIControlStateNormal];
    [tbTop.btnLeft addTarget:self action:@selector(onClickTopBar:) forControlEvents:UIControlEventTouchUpInside];
    [tbTop setLetfTitle:nil];
    
    return tbTop;
}

- (void)loadSubviews
{
    _tbTop = [self creatTopBarView:kTopFrame];
    _tbTop.backgroundColor = RGBCOLOR(251, 59, 67);
    _tbTop.statusView.backgroundColor = RGBCOLOR(251, 59, 67);
    [self.view addSubview:_tbTop];
    self.view.backgroundColor = RGBCOLOR(255, 240, 240);
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

- (void)viewDidLoad {
    [super viewDidLoad];
    _toTopHeight.constant = self.iosChangeFloat + kNavHeight + 30;
    [self loadSubviews];
}
@end
