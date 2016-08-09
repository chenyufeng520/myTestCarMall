//
//  AddFriendMessageViewController.m
//  CarLife
//
//  Created by 聂康  on 16/7/19.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import "AddFriendMessageViewController.h"

@interface AddFriendMessageViewController (){
    UILabel *_placeHolderLab;

}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toTopHeight;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation AddFriendMessageViewController
- (ISTTopBar *)creatTopBarView:(CGRect)frame
{
    // 导航头
    ISTTopBar *tbTop = [[ISTTopBar alloc] initWithFrame:frame];
    [tbTop.btnTitle setTitle:@"验证信息" forState:UIControlStateNormal];
    [tbTop.btnLeft addTarget:self action:@selector(onClickTopBar:) forControlEvents:UIControlEventTouchUpInside];
    [tbTop setLetfTitle:nil];
    
    [tbTop.btnRight setTitle:@"发送" forState:UIControlStateNormal];
    [tbTop.btnRight addTarget:self action:@selector(onClickTopBar:) forControlEvents:UIControlEventTouchUpInside];
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
        [self sendAddFriendMessage];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _toTopHeight.constant = self.iosChangeFloat + kNavHeight+10;
    [self loadSubviews];
    [self initPlaceHolderLab];
}

- (void)initPlaceHolderLab{
    _placeHolderLab = [[UILabel alloc] initWithFrame:CGRectMake(5, 8, _textView.width-10, 20)];
    _placeHolderLab.font = kFont_16;
    _placeHolderLab.textColor = [UIColor lightGrayColor];
    _placeHolderLab.text = @"我是...";
    [_textView addSubview:_placeHolderLab];

}

- (void)sendAddFriendMessage{
    EMError *error = [[EMClient sharedClient].contactManager addContact:_orderModel.store_phone message:_textView.text];
    if (!error) {
        NSLog(@"添加成功");
    }
    [MBProgressHUD showError:error.description toView:self.view];

}

- (IBAction)confirmSend:(id)sender {
    if (_textView.text.length > 0 && ![self isEmpty:_textView.text]) {
        [self sendAddFriendMessage];
    }else{
        [MBProgressHUD showError:@"请输入验证信息" toView:self.view];
    }
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    if (_textView.text.length == 0) {
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
