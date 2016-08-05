//
//  PhoneContactViewController.m
//  CarLife
//
//  Created by 聂康  on 16/7/19.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import "PhoneContactViewController.h"

@interface PhoneContactViewController (){
    UIWebView *_phoneWebView;
}
@property (weak, nonatomic) IBOutlet UILabel *firstLab;
@property (weak, nonatomic) IBOutlet UILabel *secondLab;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toTopHeight;

@end

@implementation PhoneContactViewController
- (ISTTopBar *)creatTopBarView:(CGRect)frame
{
    // 导航头
    ISTTopBar *tbTop = [[ISTTopBar alloc] initWithFrame:frame];
    [tbTop.btnTitle setTitle:@"电话联系" forState:UIControlStateNormal];
    [tbTop.btnLeft addTarget:self action:@selector(onClickTopBar:) forControlEvents:UIControlEventTouchUpInside];
    [tbTop setLetfTitle:nil];
    
    return tbTop;
}

- (void)loadSubviews
{
    _tbTop = [self creatTopBarView:kTopFrame];
    [self.view addSubview:_tbTop];
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
    [self loadSubviews];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initUI];
}

- (void)initUI{
    _toTopHeight.constant = kNavHeight+self.iosChangeFloat+30;
    _firstLab.text = _orderModel.store_phone;
    _firstLab.layer.cornerRadius = _firstLab.height/2.f;
    _firstLab.layer.masksToBounds = YES;
    
    _secondLab.text = _orderModel.store_qq;
    _secondLab.layer.cornerRadius = _firstLab.height/2.f;
    _secondLab.layer.masksToBounds = YES;

    _cancelButton.layer.cornerRadius = _cancelButton.height/2.f;
}
- (IBAction)phoneContack:(id)sender {
    if (!_phoneWebView) {
        _phoneWebView = [[UIWebView alloc]init];
        [self.view addSubview:_phoneWebView];
    }
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_orderModel.store_phone]];
    [_phoneWebView loadRequest:[NSURLRequest requestWithURL:url]];
}
- (IBAction)cancelContack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
