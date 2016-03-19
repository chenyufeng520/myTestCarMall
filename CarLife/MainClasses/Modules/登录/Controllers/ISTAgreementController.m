//
//  ISTAgreementController.m
//  BSports
//
//  Created by 高大鹏 on 15/3/13.
//  Copyright (c) 2015年 ist. All rights reserved.
//

#import "ISTAgreementController.h"
#import "LoginDataHelper.h"

@interface ISTAgreementController ()
{
    UITextView *_textView;
}

@end

@implementation ISTAgreementController

/** 导航栏 */
- (ISTTopBar *)creatTopBarView:(CGRect)frame
{
    // 导航头
    ISTTopBar *tbTop = [[ISTTopBar alloc] initWithFrame:frame];
    [tbTop.btnTitle setTitle:@"用户协议" forState:UIControlStateNormal];
    [tbTop setLetfTitle:nil];
    [tbTop.btnLeft addTarget:self action:@selector(onClickTopBar:) forControlEvents:UIControlEventTouchUpInside];
    
    return tbTop;
}

- (void)loadSubviews
{
    _tbTop = [self creatTopBarView:kTopFrame];
    [self.view addSubview:_tbTop];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(5, 0, _contentView.width - 10, _contentView.height)];
    _textView.editable = NO;
    _textView.selectable = NO;
    _textView.showsVerticalScrollIndicator = NO;
    _textView.textColor = kLightTextColor;
    _textView.font = kFontNormal;
    _textView.text = @"";
    _textView.backgroundColor = [UIColor clearColor];
    [_contentView addSubview:_textView];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _contentView.height += (kTabBarHeight);
    _contentView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = kWhiteColor;
    [self getArtcileInfo];
    [self loadSubviews];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - button methods
/** 顶栏点击事件 */
- (void)onClickTopBar:(UIButton *)btn
{
    if (btn.tag == BSTopBarButtonLeft) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (btn.tag == BSTopBarButtonRight) {
        
    }
}

#pragma mark - 获取文本信息

- (void)getArtcileInfo
{
    [[STHUDManager sharedManager] showHUDInView:_contentView];
    
    [[LoginDataHelper defaultHelper] requestForType:LoginNetwork_UserProtocol info:nil andBlock:^(id response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[STHUDManager sharedManager] hideHUDInView:_contentView];
            if ([response isKindOfClass:[NSDictionary class]]) {
                if ([response[@"result"] boolValue]) {
                    _textView.text = response[@"data"];
                }
                else
                {
                    _textView.text = @"获取信息失败";
                }
            }
            else
            {
                _textView.text = @"获取信息失败";
            }
        });
    }];
}

@end
