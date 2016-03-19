//
//  ISTAlertView.h
//  BSports
//
//  Created by 高大鹏 on 15/1/21.
//  Copyright (c) 2015年 ist. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    //通用
    AlertType_Prompt = 0,           //常规信息提示
    AlertType_SelectPrompt,         //选择性操作
    AlertType_Input,                //输入弹出框
    //特例
    AlertType_ChangePwd,            //修改密码
    AlertType_showPhoto,            //显示图片菜单
    
}AlertType;

//弹出框
@interface ISTAlertView : UIView
{
    NSArray *_distantArray;
    UIView *_view;
}


@property (nonatomic, assign) AlertType type;
@property (nonatomic, strong) NSArray *btnsArray;
@property (nonatomic, strong) void(^doneBlock)(NSInteger index, NSString *msg);
@property (nonatomic, strong) void(^doneBlock2)(BOOL flag, NSDictionary *dic);
@property (nonatomic, strong) void(^doneBlock3)(NSInteger index);
@property (nonatomic, strong) UITextField *textField, *textField2, *textField3;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSDictionary *dataDic;
@property (nonatomic, strong) UIView *drawView;

+ (instancetype)alert;

//各种类型
- (void)showSimpleMessage:(NSString *)msg doneBlock:(void(^)(NSInteger index))block;
- (void)showMessage:(NSString *)str doneBlock:(void(^)(NSInteger index))block;
- (void)changePasswordWithdoneBlock:(void(^)(BOOL flag, NSDictionary *dic))block;
- (void)showInputInfo:(NSDictionary *)dic doneBlock:(void(^)(NSInteger index, NSString *msg))block;
- (void)showPhotoWithdoneBlock:(void(^)(NSInteger index))block;

@end

