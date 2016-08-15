//
//  AdviceViewController.m
//  CarLife
//
//  Created by 聂康  on 16/8/15.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import "AdviceViewController.h"
#import "MineDataHelper.h"

@interface AdviceViewController ()<UITextViewDelegate>{
    UITextView *_msgTextView;
    UILabel *_placeholderLab;
}

@end

@implementation AdviceViewController

- (ISTTopBar *)creatTopBarView:(CGRect)frame
{
    // 导航头
    ISTTopBar *tbTop = [[ISTTopBar alloc] initWithFrame:frame];
    [tbTop.btnTitle setTitle:@"意见反馈" forState:UIControlStateNormal];
    
    [tbTop setLetfTitle:nil];
    [tbTop.btnLeft addTarget:self action:@selector(onClickTopBar:) forControlEvents:UIControlEventTouchUpInside];
    
//    [tbTop setRightTitle:@"保存"];
//    [tbTop.btnRight addTarget:self action:@selector(onClickTopBar:) forControlEvents:UIControlEventTouchUpInside];
    
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
    [self makeTextView];
}

- (void)makeTextView{
    _msgTextView = [[UITextView alloc] initWithFrame:CGRectMake(5, self.iosChangeFloat+kNavHeight+10, kScreen_Width-10, 200)];
    _msgTextView.font = [UIFont systemFontOfSize:15];
    _msgTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    _msgTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _msgTextView.layer.borderWidth = 0.8;
    _msgTextView.layer.cornerRadius = 5;
    _msgTextView.returnKeyType = UIReturnKeyDone;
    _msgTextView.layoutManager.allowsNonContiguousLayout = NO;
    _msgTextView.delegate = self;
    _msgTextView.showsHorizontalScrollIndicator = NO;
    
    [self.view addSubview:_msgTextView];
    
    
    _placeholderLab = [[UILabel alloc] init];
    _placeholderLab.textColor = [UIColor lightGrayColor];
    _placeholderLab.font = [UIFont systemFontOfSize:15];
    _placeholderLab.numberOfLines = 0;
    _placeholderLab.text = @"请在这里提出您宝贵的意见";
    _placeholderLab.frame = CGRectMake(5, 7, _msgTextView.frame.size.width-10, STRING_HEIGHT(_placeholderLab.text, _msgTextView.frame.size.width-10, kFontLarge_1));
    
    [_msgTextView addSubview:_placeholderLab];
    
    UIButton *confimBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    confimBtn.frame = CGRectMake(60, _msgTextView.maxY+25, kScreen_Width-120, 40);
    confimBtn.backgroundColor = kNavBarColor;
    [confimBtn setTitle:@"提交" forState:UIControlStateNormal];
    [confimBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confimBtn addTarget:self action:@selector(confirmButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confimBtn];
}

- (void)confirmButtonClick:(UIButton *)btn{
    if (_msgTextView.text.length>0) {
        [[MineDataHelper defaultHelper] requestForURLStr:[kFormatUrl stringByAppendingString:@"?m=Api&c=Zone&a=message"] requestMethod:@"POST" info:@{@"phone":[[NSUserDefaults standardUserDefaults] objectForKey:kPhone],@"content":_msgTextView.text} andBlock:^(id response, NSError *error) {
            NSLog(@"%@",response);

            if (!error) {
                KTipBaseView(@"提交成功");
            }else{
                KTipBaseView(@"提交失败");
            }
        }];
    }else{
        KTipBaseView(@"请在这里提出您宝贵的意见");
    }
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length == 0) {
        _placeholderLab.hidden = NO;
        _placeholderLab.text = @"请在这里提出您宝贵的意见";
    }else{
        _placeholderLab.hidden = YES;
    }
    if (_msgTextView.text.length > 200) {
        _msgTextView.text = [_msgTextView.text substringToIndex:200];
    }
}

@end
