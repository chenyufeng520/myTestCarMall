//
//  ISTAccountBindViewController.m
//  PointsMall
//
//  Created by 高大鹏 on 15/11/6.
//  Copyright © 2015年 高大鹏. All rights reserved.
//

#import "ISTAccountBindViewController.h"
#import "ISTAccountCreateViewController.h"
#import "NSString+WPAttributedMarkup.h"
#import "LoginDef.h"

@interface ISTAccountBindViewController ()
{
    UITextField *_phoneTf;
}

@end

@implementation ISTAccountBindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _contentView.height += kTabBarHeight;
    // Do any additional setup after loading the view.
    [self configUI];
}

- (ISTTopBar *)creatTopBarView:(CGRect)frame
{
    // 导航头
    ISTTopBar *tbTop = [[ISTTopBar alloc] initWithFrame:frame];
    
    [tbTop.btnTitle setTitle:@"完善信息" forState:UIControlStateNormal];
    
    [tbTop setLetfTitle:nil];
    [tbTop.btnLeft addTarget:self action:@selector(onClickTopBar:) forControlEvents:UIControlEventTouchUpInside];
    
    return tbTop;
}

-(void)configUI{
    
    _tbTop = [self creatTopBarView:kTopFrame];
    self.view.backgroundColor = kMainBGColor;
    [self.view addSubview:_tbTop];
    
    NSString *wxHeadImg = [[NSUserDefaults standardUserDefaults] objectForKey:kwxHeadImg];
    NSString *wxNickname = [[NSUserDefaults standardUserDefaults] objectForKey:kwxNickName];
    
    UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(_contentView.centerX-kAdjustLength(135), 20, kAdjustLength(270), kAdjustLength(270))];
    [logoView sd_setImageWithURL:[NSURL URLWithString:wxHeadImg] placeholderImage:[UIImage imageNamed:@"Default-user.png"]];
    logoView.contentMode = UIViewContentModeScaleAspectFit;
    [_contentView addSubview:logoView];
    [logoView.layer setCornerRadius:CGRectGetHeight([logoView bounds]) / 2];
    logoView.layer.masksToBounds = YES;
    logoView.layer.borderWidth = kLinePixel;
    logoView.layer.borderColor = kWhiteColor.CGColor;
    
    NSDictionary *style = @{@"font1":@[kFontNormal,kDarkTextColor],
                            @"font2":@[kFontNormal,kLightTextColor]};
    
    UILabel *nameLb = [[UILabel alloc] initWithFrame:CGRectMake(15, logoView.maxY + 10, kScreen_Width - 30, kAdjustLength(60))];
    nameLb.attributedText = [[NSString stringWithFormat:@"<font2>亲爱的微信用户：</font2><font1>%@</font1>",wxNickname] attributedStringWithStyleBook:style];
    nameLb.textAlignment = NSTextAlignmentLeft;
    nameLb.backgroundColor = [UIColor clearColor];
    [_contentView addSubview:nameLb];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    
    UILabel *tipLb = [[UILabel alloc]initWithFrame:CGRectMake(15, nameLb.maxY , kScreen_Width - 30, kAdjustLength(80))];
    tipLb.backgroundColor = [UIColor clearColor];
    tipLb.textColor = kDarkTextColor;
    tipLb.font = kFontLarge_1;
    tipLb.text = [NSString stringWithFormat:@"为了给您更好的服务，请关联一个%@账号",app_Name];
    tipLb.textAlignment = NSTextAlignmentLeft;
    [_contentView addSubview:tipLb];
    
    UILabel *tipLb1 = [[UILabel alloc]initWithFrame:CGRectMake(15, tipLb.maxY + 10 , kScreen_Width - 30, kAdjustLength(120))];
    tipLb1.backgroundColor = [UIColor clearColor];
    tipLb1.textColor = kLightTextColor;
    tipLb1.font = kFontLarge_1;
    tipLb1.text = [NSString stringWithFormat:@"还没有%@账号?",app_Name];
    tipLb1.textAlignment = NSTextAlignmentLeft;
    [_contentView addSubview:tipLb1];
    
    UIButton *createBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    createBtn.frame = CGRectMake(15, tipLb1.maxY, _contentView.width - 30, kAdjustLength(120));
    [createBtn setTitle:@"快速注册" forState:UIControlStateNormal];
    [createBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    createBtn.titleLabel.font = kFontLarge_1;
    [createBtn setBackgroundImage:[UIImage imageWithColor:kRedColor size:createBtn.size] forState:UIControlStateNormal];
    [createBtn addTarget:self action:@selector(createBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    createBtn.layer.cornerRadius = kCornerRadius;
    createBtn.layer.masksToBounds = YES;
    [_contentView addSubview:createBtn];
    
    if (_canRelate) {
        UILabel *tipLb2 = [[UILabel alloc]initWithFrame:CGRectMake(15, createBtn.maxY + 5 , kScreen_Width - 30, kAdjustLength(120))];
        tipLb2.backgroundColor = [UIColor clearColor];
        tipLb2.textColor = kLightTextColor;
        tipLb2.font = kFontLarge_1;
        tipLb2.text = [NSString stringWithFormat:@"已有%@账号?",app_Name];
        tipLb2.textAlignment = NSTextAlignmentLeft;
        [_contentView addSubview:tipLb2];
        
        UIButton *relateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        relateBtn.frame = CGRectMake(15, tipLb2.maxY, _contentView.width - 30, kAdjustLength(120));
        [relateBtn setTitle:@"立即关联" forState:UIControlStateNormal];
        [relateBtn setTitleColor:kLightTextColor forState:UIControlStateNormal];
        relateBtn.titleLabel.font = kFontLarge_1;
        [relateBtn setBackgroundImage:[UIImage imageWithColor:kWhiteColor size:createBtn.size] forState:UIControlStateNormal];
        [relateBtn addTarget:self action:@selector(relateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        relateBtn.layer.cornerRadius = kCornerRadius;
        relateBtn.layer.borderColor = kLineColor.CGColor;
        relateBtn.layer.borderWidth = kLinePixel;
        relateBtn.layer.masksToBounds = YES;
        [_contentView addSubview:relateBtn];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Actions
- (void)onClickTopBar:(UIButton *)btn
{
    if (btn.tag == BSTopBarButtonLeft) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else if (btn.tag == BSTopBarButtonRight) {
        
    }
}

- (void)relateBtnClick:(UIButton *)sender
{
    ISTAccountCreateViewController *theVC = [[ISTAccountCreateViewController alloc] initWithType:AccountBindType_Relate];
    [self.navigationController pushViewController:theVC animated:YES];
}

- (void)createBtnClick:(UIButton *)sender
{
    ISTAccountCreateViewController *theVC = [[ISTAccountCreateViewController alloc] initWithType:AccountBindType_Register];
    [self.navigationController pushViewController:theVC animated:YES];
}

@end
