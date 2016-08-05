//
//  ShareToZoneViewController.m
//  CarLife
//
//  Created by 聂康  on 16/7/19.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import "ShareToZoneViewController.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"

@interface ShareToZoneViewController ()<UITextViewDelegate,UMSocialUIDelegate>{
    UILabel *_placeHolderLab;
}


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
    _contentView.height = kScreen_Height-kNavHeight-self.iosChangeFloat;
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
    _msgTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 200)];
    _msgTextView.font = kFontLarge_1;
    _msgTextView.autocorrectionType = UITextAutocorrectionTypeNo;
//    _msgTextView.layer.cornerRadius = 5;
//    _msgTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    _msgTextView.layer.borderWidth = 0.8;
    _msgTextView.delegate = self;
    _msgTextView.returnKeyType = UIReturnKeyDone;
    _msgTextView.layoutManager.allowsNonContiguousLayout = NO;
    _msgTextView.font = kFont_16;;
    [_contentView addSubview:_msgTextView];
    
    _placeHolderLab = [[UILabel alloc] initWithFrame:CGRectMake(5, 8, _msgTextView.width-10, 20)];
    _placeHolderLab.font = kFont_16;
    _placeHolderLab.textColor = [UIColor lightGrayColor];
    _placeHolderLab.text = @"说点儿什么...";
    [_msgTextView addSubview:_placeHolderLab];
    
    NSArray *imageArr = @[@"新浪微博",@"微信",@"微信朋友圈",@"QQ好友",@"复制"];
    CGFloat w = (kScreen_Width-20*5)/4.f;
    for (NSInteger i=0; i<imageArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(20+(i%4)*(w+20), _msgTextView.maxY+25+i/4*(w+45), w, w);
        [btn setBackgroundImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 2000 + i;
        [_contentView addSubview:btn];
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10+(i%4)*(w+20), btn.maxY+5, w+20, 20)];
        lab.text = imageArr[i];
        lab.font = kFontLarge_1;
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = [UIColor grayColor];
        [_contentView addSubview:lab];
    }
    
}

- (void)shareButtonClick:(UIButton *)btn{
    if (_msgTextView.text.length == 0 || [self isEmpty:_msgTextView.text]) {
        KTipView(@"说点什么吧！");
        return;
    }
    switch (btn.tag) {
        case 2000:
        {
            [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeDefault url:@"http://baidu.com"];
            [UMSocialData defaultData].extConfig.title = @"今天是个好日子";
            [UMSocialData defaultData].extConfig.sinaData.shareText = _msgTextView.text;
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:nil image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                NSLog(@"%@",response);
                if (response.responseCode == UMSResponseCodeSuccess) {
                    
                }
            }];

            break;
        }
        case 2001:
        {
            [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeDefault url:@"http://baidu.com"];
            [UMSocialData defaultData].extConfig.title = @"今天是个好日子";
            [UMSocialData defaultData].extConfig.wechatSessionData.url = @"http://baidu.com";
            [UMSocialData defaultData].extConfig.wechatSessionData.shareText = _msgTextView.text;
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:nil image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                NSLog(@"%@",response);
                if (response.responseCode == UMSResponseCodeSuccess) {
                    
                }
            }];
            
            break;
        }
        case 2002:
        {
            [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeDefault url:@"http://baidu.com"];
            [UMSocialData defaultData].extConfig.title = @"今天是个好日子";
            [UMSocialData defaultData].extConfig.qqData.url = @"http://baidu.com";
            [UMSocialData defaultData].extConfig.qqData.shareText = _msgTextView.text;
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:nil image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                NSLog(@"%@",response);
                if (response.responseCode == UMSResponseCodeSuccess) {
                    
                }
            }];
            break;
        }
        case 2003:
        {
            [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeDefault url:@"http://baidu.com"];
            [UMSocialData defaultData].extConfig.title = @"今天是个好日子";
            [UMSocialData defaultData].extConfig.wechatTimelineData.url = @"http://baidu.com";
            [UMSocialData defaultData].extConfig.wechatTimelineData.shareText = _msgTextView.text;
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:nil image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                NSLog(@"%@",response);
                if (response.responseCode == UMSResponseCodeSuccess) {
                    
                }
            }];
            break;
        }
        case 2004:
        {
            break;
        }
        default:
            break;
    }
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    if (_msgTextView.text.length == 0) {
        _placeHolderLab.hidden = NO;
    }else{
        _placeHolderLab.hidden = YES;
    }
}

//判断内容是否全部为空格  yes 全部为空格  no 不是
- (BOOL) isEmpty:(NSString *) str {
    
    if (!str) {
        return true;
    } else {
        //A character set containing only the whitespace characters space (U+0020) and tab (U+0009) and the newline and nextline characters (U+000A–U+000D, U+0085).
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        
        //Returns a new string made by removing from both ends of the receiver characters contained in a given character set.
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        
        if ([trimedString length] == 0) {
            return true;
        } else {
            return false;
        }
    }
}
@end
