//
//  ShareToZoneViewController.m
//  CarLife
//
//  Created by 聂康  on 16/7/19.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import "ShareToZoneViewController.h"

@interface ShareToZoneViewController ()<UITextViewDelegate>


@property (nonatomic ,strong)UITextView *msgTextView;

@end

@implementation ShareToZoneViewController
- (ISTTopBar *)creatTopBarView:(CGRect)frame
{
    // 导航头
    ISTTopBar *tbTop = [[ISTTopBar alloc] initWithFrame:frame];
    [tbTop.btnTitle setTitle:@"转发空间及朋友圈" forState:UIControlStateNormal];
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
    [self makeUI];
}

- (void)makeUI{
    _msgTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, self.iosChangeFloat+kNavHeight, kScreen_Width, 200)];
    _msgTextView.font = kFontLarge_1;
    _msgTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    _msgTextView.layer.cornerRadius = 5;
    _msgTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _msgTextView.layer.borderWidth = 0.8;
    _msgTextView.delegate = self;
    _msgTextView.returnKeyType = UIReturnKeyDone;
    _msgTextView.layoutManager.allowsNonContiguousLayout = NO;
    [self.view addSubview:_msgTextView];
    
    NSArray *imageArr = @[@"新浪微博",@"微信",@"微信朋友圈",@"QQ好友",@"复制"];
    CGFloat w = (kScreen_Width-20*5)/4.f;
    for (NSInteger i=0; i<imageArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(20+(i%4)*(w+20), _msgTextView.maxY+25+i/4*(w+45), w, w);
        [btn setBackgroundImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
        [self.view addSubview:btn];
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10+(i%4)*(w+20), btn.maxY+5, w+20, 20)];
        lab.text = imageArr[i];
        lab.font = kFontLarge_1;
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = [UIColor grayColor];
        [self.view addSubview:lab];
    }
}
@end
