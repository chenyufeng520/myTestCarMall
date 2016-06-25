//
//  GoodsDetailViewController.m
//  CarLife
//
//  Created by 聂康  on 16/5/26.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import "GoodsDetailViewController.h"
#import "ShoppingCarViewController.h"
#import "ShoppingDataHelper.h"
#import "AppDelegate.h"
#import "DragView.h"
#import "GoodsToPayViewController.h"

@interface GoodsDetailViewController ()<UITextFieldDelegate,UITextViewDelegate>{
    UITextField *_numTextField;
    UITextView *_msgTextView;
    UILabel *_totalLab;
    UIView *_bottomView;
    CGFloat _keyBoardHeight;
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
    _contentView.height += kTabBarHeight;
    
    [self initWithModel];

    
    //悬浮按钮
    DragView *dragView = [[DragView alloc] initWithFrame:CGRectMake(_contentView.width - kAdjustLength(200), _contentView.height - kAdjustLength(300), kAdjustLength(200), kAdjustLength(200))];
    [dragView setBlock:^(){
        BSLog(@"点击了悬浮按钮");
        ShoppingCarViewController *shoppingCar = [[ShoppingCarViewController alloc] init];
        [[AppDelegate shareDelegate].rootNavigation pushViewController:shoppingCar animated:YES];
    }];
    
    UIImageView *shopCarImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kAdjustLength(200), kAdjustLength(200))];
    shopCarImg.image = [UIImage imageNamed:@"shoppingCari"];
    [dragView addSubview:shopCarImg];
    
    [_contentView addSubview:dragView];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self addNotification];
    [self loadSubviews];
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
    UIView *firstLine = [[UIView alloc] initWithFrame:CGRectMake(10, introLab.maxY+5, kScreen_Width-10, 1)];
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
    _numTextField.returnKeyType = UIReturnKeyDone;
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

    UIView *secondLine = [[UIView alloc] initWithFrame:CGRectMake(10, buyNumLab.maxY+1, kScreen_Width-10, 1)];
    secondLine.backgroundColor = [UIColor lightGrayColor];
    [_contentView addSubview:secondLine];
    
    UILabel *stockLab = [[UILabel alloc] initWithFrame:CGRectMake(10, secondLine.maxY, 100, kAdjustLength(140))];
    stockLab.text = @"库存:";
    stockLab.font = kFont_16;
    [_contentView addSubview:stockLab];
    
    UILabel *stockRightLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_Width-110, secondLine.maxY, 100, kAdjustLength(140))];
    if (self.productModel.goods_lock.intValue == 1){
        stockRightLab.text = @"有货";
    }else{
        stockRightLab.text = @"已售空";
    }
    stockRightLab.font = kFont_16;
    stockRightLab.textColor = [UIColor grayColor];
    stockRightLab.textAlignment = NSTextAlignmentRight;
    [_contentView addSubview:stockRightLab];
    
    UIView *thirdLine = [[UIView alloc] initWithFrame:CGRectMake(10, stockLab.maxY, kScreen_Width-10, 1)];
    thirdLine.backgroundColor = [UIColor lightGrayColor];
    [_contentView addSubview:thirdLine];

    UILabel *userMsgLab = [[UILabel alloc] init];
    userMsgLab.text = @"买家留言:";
    userMsgLab.font = kFont_16;
    userMsgLab.frame = CGRectMake(10, thirdLine.maxY+2, STRING_WIDTH(userMsgLab.text, kAdjustLength(140), kFont_16), kAdjustLength(140));
    [_contentView addSubview:userMsgLab];
    
//    NSTextStorage* textStorage = [[NSTextStorage alloc] init];
//    NSLayoutManager* layoutManager = [NSLayoutManager new];
//    [textStorage addLayoutManager:layoutManager];
//    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:CGSizeMake(kScreen_Width-10-userMsgLab.maxX-5-20, kAdjustLength(105)-20)];
//    textContainer.widthTracksTextView = YES;
//    textContainer.heightTracksTextView = YES;
//    [layoutManager addTextContainer:textContainer];
//    _msgTextView = [[UITextView alloc] initWithFrame:CGRectMake(userMsgLab.maxX+5, thirdLine.maxY+kAdjustLength(25), kScreen_Width-10-userMsgLab.maxX-5, kAdjustLength(105)) textContainer:textContainer];
    _msgTextView = [[UITextView alloc] initWithFrame:CGRectMake(userMsgLab.maxX+5, thirdLine.maxY+kAdjustLength(25), kScreen_Width-10-userMsgLab.maxX-5, kAdjustLength(105))];
    _msgTextView.font = kFontLarge_1;
    _msgTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    _msgTextView.layer.cornerRadius = 5;
    _msgTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _msgTextView.layer.borderWidth = 0.8;
    _msgTextView.delegate = self;
    _msgTextView.returnKeyType = UIReturnKeyDone;
    _msgTextView.layoutManager.allowsNonContiguousLayout = NO;
    [_contentView addSubview:_msgTextView];
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, _msgTextView.maxY+kAdjustLength(25), kScreen_Width, kAdjustLength(140)*3)];
    _bottomView.backgroundColor = _contentView.backgroundColor;
    [_contentView addSubview:_bottomView];
    
    UIView *forthLine = [[UIView alloc] initWithFrame:CGRectMake(10, 0, kScreen_Width-10, 1)];
    forthLine.backgroundColor = [UIColor lightGrayColor];
    [_bottomView addSubview:forthLine];
    
    //总计
    _totalLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kScreen_Width-20, kAdjustLength(140))];
    _totalLab.font = kFont_16;
    _totalLab.textAlignment = NSTextAlignmentRight;
    _totalLab.textColor = [UIColor redColor];
    [_bottomView addSubview:_totalLab];
    if (self.productModel.goods_dazhe.intValue == 1){
         _totalLab.text  = [NSString stringWithFormat:@"总计:￥%@",self.productModel.goods_hprice];
    }else{
         _totalLab.text  = [NSString stringWithFormat:@"总计:￥%@",self.productModel.goods_price];
    }
    
    UIView *fifthLine = [[UIView alloc] initWithFrame:CGRectMake(10, _totalLab.maxY, kScreen_Width-10, 1)];
    fifthLine.backgroundColor = [UIColor lightGrayColor];
    [_bottomView addSubview:fifthLine];

    UIButton *addCarBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    addCarBtn.frame = CGRectMake((kScreen_Width-kAdjustLength(500))/2.f, fifthLine.maxY+kAdjustLength(10), kAdjustLength(500), kAdjustLength(120));
    addCarBtn.backgroundColor = [UIColor orangeColor];
    [addCarBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
    [addCarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addCarBtn addTarget:self action:@selector(addToCar:) forControlEvents:UIControlEventTouchUpInside];
    addCarBtn.titleLabel.font = kFontSuper;
    [_bottomView addSubview:addCarBtn];
    
    UIView *sixthLine = [[UIView alloc] initWithFrame:CGRectMake(10, addCarBtn.maxY+kAdjustLength(10), kScreen_Width-10, 1)];
    sixthLine.backgroundColor = [UIColor lightGrayColor];
    [_bottomView addSubview:sixthLine];

    _contentView.contentSize = CGSizeMake(0, _bottomView.maxY);

}

#pragma mark - Click Menu

- (void)onClickTopBar:(UIButton *)btn
{
    if (btn.tag == BSTopBarButtonLeft) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (btn.tag == BSTopBarButtonRight) {
        GoodsToPayViewController *shoppingCar = [[GoodsToPayViewController alloc] init];
        [self.navigationController pushViewController:shoppingCar animated:YES];

    }
}

#pragma mark - 添加到购物车
- (void)addToCar:(UIButton *)btn{
    if (!_msgTextView.text) {
        _msgTextView.text = @"";
    }
    NSString *urlStr = [NSString stringWithFormat:@"index.php?m=api&c=Store&a=addBuycar&uid=%@&gid=%@&num=%@&dd_text=%@",kUID,self.productModel.gid,_numTextField.text,_msgTextView.text];
    [[ShoppingDataHelper defaultHelper] requestForURLStr:urlStr requestMethod:@"GET" info:nil andBlock:^(id response, NSError *error) {
        if (!error) {
            NSDictionary *dic = response;
            if ([[dic objectForKey:@"status"] integerValue] == 200) {
                [[ISTHUDManager defaultManager] showHUDWithSuccess:@"添加成功"];
            }else{
                [[ISTHUDManager defaultManager] showHUDWithError:dic[@"message"]];
            }
        }
 }];
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    CGRect rect = textView.frame;
    rect.size.height = textView.contentSize.height;
    textView.frame = rect;
    [textView scrollRangeToVisible:NSMakeRange(0,0)];
    _bottomView.frame = CGRectMake(0, _msgTextView.maxY+kAdjustLength(25), kScreen_Width, kAdjustLength(140)*3);
    _contentView.contentSize = CGSizeMake(0, _bottomView.maxY);
    _contentView.minY = self.iosChangeFloat+kNavHeight-_keyBoardHeight+kAdjustLength(140)*2-_msgTextView.height;
}

#pragma mark - keyboard
- (void)keybordWillShow:(NSNotification *)noti{
    NSDictionary *userInfo = [noti userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    _keyBoardHeight = keyboardRect.size.height;
    
    [UIView animateWithDuration:0.5 animations:^{
        _contentView.minY = self.iosChangeFloat+kNavHeight-_keyBoardHeight+kAdjustLength(140)*2-_msgTextView.height;
    }];
}

- (void)keybordWillHidden:(NSNotification *)noti{
    _keyBoardHeight = 0;
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
