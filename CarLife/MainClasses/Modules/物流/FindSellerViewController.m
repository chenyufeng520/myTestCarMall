



//
//  FindSellerViewController.m
//  CarLife
//
//  Created by 陈宇峰 on 16/7/23.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import "FindSellerViewController.h"
#import "ActionSheetStringPicker.h"
#import "ISTButtonHelper.h"

@interface FindSellerViewController ()<UITextFieldDelegate>

@end

@implementation FindSellerViewController

- (ISTTopBar *)creatTopBarView:(CGRect)frame
{
    // 导航头
    ISTTopBar *tbTop = [[ISTTopBar alloc] initWithFrame:frame];
    [tbTop.btnTitle setTitle:@"寻找商家" forState:UIControlStateNormal];
    
    [tbTop setLetfTitle:nil];
    [tbTop.btnLeft addTarget:self action:@selector(onClickTopBar:) forControlEvents:UIControlEventTouchUpInside];
    
    return tbTop;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubviews];
}

- (void)loadSubviews
{
    _tbTop = [self creatTopBarView:kTopFrame];
    [self.view addSubview:_tbTop];
    _contentView.height += kTabBarHeight;
    _contentView.backgroundColor = kWuLiuBGColor;
    
    
    //店铺名称
    UIView *bgView1 = [[UIView alloc] initWithFrame:CGRectMake(0, kAdjustLength(150), kScreen_Width, kAdjustLength(160))];
    bgView1.userInteractionEnabled = YES;
    [_contentView addSubview:bgView1];
    
    UIImageView *logo1 = [[UIImageView alloc] initWithFrame:CGRectMake( kAdjustLength(80), kAdjustLength(40), kAdjustLength(80), kAdjustLength(80))];
    logo1.image = [UIImage imageNamed:@"放大镜按钮"];
    [bgView1 addSubview:logo1];
    
    UIView *smallView1 = [[UIView alloc] initWithFrame:CGRectMake(bgView1.width/4 - kAdjustLength(40), kAdjustLength(20), bgView1.width/2 + kAdjustLength(80), kAdjustLength(120))];
    smallView1.backgroundColor = RGBCOLOR(59, 148, 252);
    smallView1.userInteractionEnabled = YES;
    [bgView1 addSubview:smallView1];
    
    UITextField *tf1 = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, bgView1.width/2 - kAdjustLength(40), kAdjustLength(120))];
    tf1.textColor = kWhiteColor;
    tf1.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    tf1.textAlignment = NSTextAlignmentCenter;
    tf1.font = kFont_16;
    tf1.delegate = self;
    tf1.placeholder = @"店铺名称";
    tf1.text = @"店铺名称";
    tf1.enabled = NO;
    tf1.userInteractionEnabled = YES;
    [smallView1 addSubview:tf1];
    
    UIImageView *arrowView1 = [[UIImageView alloc] initWithFrame:CGRectMake(tf1.maxX, kAdjustLength(20), kAdjustLength(80), kAdjustLength(80))];
    arrowView1.image = [UIImage imageNamed:@"下拉按钮"];
    arrowView1.contentMode = UIViewContentModeScaleAspectFit;
    arrowView1.userInteractionEnabled = YES;
    [smallView1 addSubview:arrowView1];
    
    __weak typeof(self) weakSelf = self;
    BlockButton *btn = [BlockButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(tf1.maxX, 0, smallView1.width - tf1.width, smallView1.height);
    [btn setBlock:^(BlockButton *button){
        [weakSelf.view endEditing:YES];
        
        NSMutableArray *roleNameArr = [NSMutableArray array];
        for (int i = 0; i < 6; i++) {
            [roleNameArr addObject:@"合肥三里汽配"];
        }
        
        [ActionSheetStringPicker showPickerWithTitle:@"店铺名称" rows:roleNameArr initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
            dispatch_async(dispatch_get_main_queue(), ^{
                tf1.text = roleNameArr[selectedIndex];
            });
            
        } cancelBlock:nil origin:self.view];
    }];
    [smallView1 addSubview:btn];
    
    
    //修理厂商
    UIView *bgView2 = [[UIView alloc] initWithFrame:CGRectMake(0, bgView1.maxY + kAdjustLength(30), kScreen_Width, kAdjustLength(160))];
    bgView2.userInteractionEnabled = YES;
    [_contentView addSubview:bgView2];
    
    UIImageView *logo2 = [[UIImageView alloc] initWithFrame:CGRectMake( kAdjustLength(80), kAdjustLength(40), kAdjustLength(80), kAdjustLength(80))];
    logo2.image = [UIImage imageNamed:@"车子按钮"];
    [bgView2 addSubview:logo2];
    
    UIView *smallView2 = [[UIView alloc] initWithFrame:CGRectMake(bgView2.width/4 - kAdjustLength(40), kAdjustLength(20), bgView2.width/2 + kAdjustLength(80), kAdjustLength(120))];
    smallView2.backgroundColor = RGBCOLOR(59, 148, 252);
    smallView2.userInteractionEnabled = YES;
    [bgView2 addSubview:smallView2];
    
    UITextField *tf2 = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, bgView2.width/2 - kAdjustLength(40), kAdjustLength(120))];
    tf2.textColor = kWhiteColor;
    tf2.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    tf2.textAlignment = NSTextAlignmentCenter;
    tf2.font = kFont_16;
    tf2.delegate = self;
    tf2.placeholder = @"专营类别";
    tf2.text = @"专营类别";
    tf2.enabled = NO;
    tf2.userInteractionEnabled = YES;
    [smallView2 addSubview:tf2];
    
    UIImageView *arrowView2= [[UIImageView alloc] initWithFrame:CGRectMake(tf2.maxX, kAdjustLength(20), kAdjustLength(80), kAdjustLength(80))];
    arrowView2.image = [UIImage imageNamed:@"下拉按钮"];
    arrowView2.contentMode = UIViewContentModeScaleAspectFit;
    arrowView2.userInteractionEnabled = YES;
    [smallView2 addSubview:arrowView2];
    
    BlockButton *btn2 = [BlockButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(tf2.maxX, 0, smallView2.width - tf2.width, smallView2.height);
    [btn2 setBlock:^(BlockButton *button){
        [weakSelf.view endEditing:YES];
        
        NSMutableArray *roleNameArr = [NSMutableArray array];
        for (int i = 0; i < 6; i++) {
            [roleNameArr addObject:@"专营本田汽车配件"];
        }
        
        [ActionSheetStringPicker showPickerWithTitle:@"专营类别" rows:roleNameArr initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
            dispatch_async(dispatch_get_main_queue(), ^{
                tf2.text = roleNameArr[selectedIndex];
            });
            
        } cancelBlock:nil origin:self.view];
    }];
    [smallView2 addSubview:btn2];
    
    
    //查询按钮
    UIButton *LogoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    LogoutButton.frame = CGRectMake(kAdjustLength(40), _contentView.height - kAdjustLength(300), kScreen_Width - kAdjustLength(80), kAdjustLength(120));
    [LogoutButton setTitle:@"查询" forState:UIControlStateNormal];
    [LogoutButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    LogoutButton.backgroundColor = kBlueColor;
    LogoutButton.layer.cornerRadius = kCornerRadius;
    LogoutButton.layer.masksToBounds = YES;
    LogoutButton.titleLabel.font = kFontLarge_2;
    [LogoutButton addTarget:self action:@selector(checkButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:LogoutButton];
    
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

- (void)checkButtonClick:(UIButton*)button{
    BSLog(@"查询");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
