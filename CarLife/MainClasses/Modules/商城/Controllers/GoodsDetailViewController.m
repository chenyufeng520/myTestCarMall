//
//  GoodsDetailViewController.m
//  CarLife
//
//  Created by 聂康  on 16/5/26.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import "GoodsDetailViewController.h"
#import "ShoppingCarViewController.h"

@interface GoodsDetailViewController ()<UITextFieldDelegate,UITextViewDelegate>{
    UITextField *_numTextField;
    UITextView *_msgTextView;
    CGFloat _previousTextViewContentHeight;
}
@end

@implementation GoodsDetailViewController

- (ISTTopBar *)creatTopBarView:(CGRect)frame
{
    // 导航头
    ISTTopBar *tbTop = [[ISTTopBar alloc] initWithFrame:frame];
    [tbTop.btnTitle setTitle:self.productModel.goods_name forState:UIControlStateNormal];
    [tbTop.btnLeft addTarget:self action:@selector(onClickTopBar:) forControlEvents:UIControlEventTouchUpInside];
    [tbTop setLetfTitle:nil];
    [tbTop.btnRight setImage:[UIImage imageNamed:@"shoppingCari"] forState:UIControlStateNormal];
    [tbTop.btnRight addTarget:self action:@selector(onClickTopBar:) forControlEvents:UIControlEventTouchUpInside];

    return tbTop;
}

- (void)loadSubviews
{
    _tbTop = [self creatTopBarView:kTopFrame];
    [self.view addSubview:_tbTop];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNotification];
    [self loadSubviews];
    [self initWithModel];
}

- (void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keybordWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keybordWillHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)initWithModel{
    UIImageView *topImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Width * 9/16.f)];
    [topImage sd_setImageWithURL:KImageUrl(self.productModel.goods_picurl) placeholderImage:[UIImage imageNamed:@"占位图"]];
    [_contentView addSubview:topImage];
    
    UILabel *labOnImage = [[UILabel alloc] initWithFrame:CGRectMake(0, topImage.maxY-kAdjustLength(120), kScreen_Width, kAdjustLength(120))];
    labOnImage.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.4];
    labOnImage.textAlignment = NSTextAlignmentCenter;
    labOnImage.textColor = [UIColor whiteColor];
    labOnImage.text = [NSString stringWithFormat:@"%@(%@)",self.productModel.goods_name,self.productModel.goods_remark];
    [_contentView addSubview:labOnImage];
    
    UILabel *introLab = [[UILabel alloc] init];
    introLab.text = [self.productModel.goods_intr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    introLab.font = kFontLarge_1;
    introLab.numberOfLines = 0;
    introLab.frame = CGRectMake(10, topImage.maxY+5, kScreen_Width-20, STRING_HEIGHT(introLab.text, kScreen_Width-20, kFontLarge_1));
    [_contentView addSubview:introLab];
    
    //描述一下部分
    UIView *firstLine = [[UIView alloc] initWithFrame:CGRectMake(10, introLab.maxY+5, kScreen_Width-10, 0.8)];
    firstLine.backgroundColor = [UIColor lightGrayColor];
    [_contentView addSubview:firstLine];
    
    UILabel *buyNumLab = [[UILabel alloc] initWithFrame:CGRectMake(10, firstLine.maxY, 100, kAdjustLength(140))];
    buyNumLab.font = kFont_16;
    buyNumLab.text = @"购买数量";
    [_contentView addSubview:buyNumLab];
    
    //加
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    addBtn.frame = CGRectMake(kScreen_Width-10-kAdjustLength(110), firstLine.maxY+kAdjustLength(15), kAdjustLength(110), kAdjustLength(110));
    addBtn.layer.cornerRadius = addBtn.height/2.f;
    addBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    addBtn.layer.borderWidth = 1;
    addBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [addBtn setTitle:@"十" forState:UIControlStateNormal];
    [addBtn setTitleColor:kNavBarColor forState:UIControlStateNormal];
    [_contentView addSubview:addBtn];
    
    _numTextField = [[UITextField alloc] initWithFrame:CGRectMake(kScreen_Width-addBtn.width-10-kAdjustLength(240)-8, addBtn.minY, kAdjustLength(240), addBtn.height)];
    _numTextField.borderStyle = UITextBorderStyleNone;
    _numTextField.layer.borderWidth = 1;
    _numTextField.layer.borderColor = [UIColor grayColor].CGColor;
    _numTextField.text = @"1";
    _numTextField.textAlignment = NSTextAlignmentCenter;
    _numTextField.delegate = self;
    [_contentView addSubview:_numTextField];

    //减
    UIButton *subtractBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    subtractBtn.frame = CGRectMake(_numTextField.minX-kAdjustLength(110)-8, firstLine.maxY+kAdjustLength(10), kAdjustLength(110), kAdjustLength(110));
    subtractBtn.layer.cornerRadius = subtractBtn.height/2.f;
    subtractBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    subtractBtn.layer.borderWidth = 1;
    subtractBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [subtractBtn setTitle:@"一" forState:UIControlStateNormal];
    [subtractBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_contentView addSubview:subtractBtn];

    UIView *secondLine = [[UIView alloc] initWithFrame:CGRectMake(10, buyNumLab.maxY+1, kScreen_Width-10, 0.8)];
    secondLine.backgroundColor = [UIColor lightGrayColor];
    [_contentView addSubview:secondLine];
    
    UILabel *stockLab = [[UILabel alloc] initWithFrame:CGRectMake(10, secondLine.maxY, 100, kAdjustLength(140))];
    stockLab.text = @"库存:";
    stockLab.font = kFont_16;
    [_contentView addSubview:stockLab];
    
    UILabel *stockRightLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_Width-110, secondLine.maxY, 100, kAdjustLength(140))];
    if ([self.productModel.goods_lock isEqualToString:@"1"]){
        stockRightLab.text = @"有货";
    }else{
        stockRightLab.text = @"已售空";
    }
    stockRightLab.font = kFont_16;
    stockRightLab.textColor = [UIColor grayColor];
    stockRightLab.textAlignment = NSTextAlignmentRight;
    [_contentView addSubview:stockRightLab];
    
    UIView *thirdLine = [[UIView alloc] initWithFrame:CGRectMake(10, stockLab.maxY, kScreen_Width-10, 0.8)];
    thirdLine.backgroundColor = [UIColor lightGrayColor];
    [_contentView addSubview:thirdLine];

    UILabel *userMsgLab = [[UILabel alloc] init];
    userMsgLab.text = @"买家留言:";
    userMsgLab.font = kFont_16;
    userMsgLab.frame = CGRectMake(10, thirdLine.maxY+2, STRING_WIDTH(userMsgLab.text, kAdjustLength(140), kFont_16), kAdjustLength(140));
    [_contentView addSubview:userMsgLab];
    
    _msgTextView = [[UITextView alloc] initWithFrame:CGRectMake(userMsgLab.maxX+5, thirdLine.maxY+kAdjustLength(25), kScreen_Width-10-userMsgLab.maxX-5, kAdjustLength(105))];
    _msgTextView.font = kFontLarge_1;
    _msgTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    _msgTextView.layer.cornerRadius = 5;
    _msgTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _msgTextView.layer.borderWidth = 0.8;
    _msgTextView.delegate = self;
    [_contentView addSubview:_msgTextView];
    _previousTextViewContentHeight = [self _getTextViewContentH:_msgTextView];
}

#pragma mark - Click Menu

- (void)onClickTopBar:(UIButton *)btn
{
    if (btn.tag == BSTopBarButtonLeft) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (btn.tag == BSTopBarButtonRight) {
        ShoppingCarViewController *shoppingCar = [[ShoppingCarViewController alloc] init];
        [self.navigationController pushViewController:shoppingCar animated:YES];

    }
}

#pragma mark - private _msgTextView

- (CGFloat)_getTextViewContentH:(UITextView *)textView
{
    if (IOSVersion >= 7.0)
    {
        return ceilf([textView sizeThatFits:textView.frame.size].height);
    } else {
        return textView.contentSize.height;
    }
}

- (void)_willShowInputTextViewToHeight:(CGFloat)toHeight
{
    if (toHeight == _previousTextViewContentHeight)
    {
        return;
    }
    else{
        CGFloat changeHeight = toHeight - _previousTextViewContentHeight;
        
    }
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [self _willShowInputTextViewToHeight:[self _getTextViewContentH:_msgTextView]];;
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
//    [self _willShowInputTextViewToHeight:[self _getTextViewContentH:textView]];
    CGRect rect = textView.frame;
    rect.size.height = textView.contentSize.height;
    textView.frame = rect;
    [textView scrollRangeToVisible:NSMakeRange(0,0)];
}

#pragma mark - keyboard
- (void)keybordWillShow:(NSNotification *)noti{
    [UIView animateWithDuration:0.5 animations:^{
        _contentView.minY = self.iosChangeFloat+kNavHeight-80;
    }];
}

- (void)keybordWillHidden:(NSNotification *)noti{
    [UIView animateWithDuration:0.5 animations:^{
        _contentView.minY = self.iosChangeFloat+kNavHeight;
    }];
}

#pragma mark - UITextField delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL canChange = [string isEqualToString:filtered];
    if ([string isEqualToString:@""]) {
        return YES;
    }
    
    return canChange;
}
@end
