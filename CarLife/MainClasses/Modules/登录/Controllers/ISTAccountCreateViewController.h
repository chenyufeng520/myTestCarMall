//
//  ISTAccountCreateViewController.h
//  PointsMall
//
//  Created by 高大鹏 on 15/11/6.
//  Copyright © 2015年 高大鹏. All rights reserved.
//

#import "ISTBaseViewController.h"

typedef enum : NSUInteger {
    AccountBindType_Register = 0,       //账号注册
    AccountBindType_Relate,             //账号绑定
} AccountBindType;

@interface ISTAccountCreateViewController : ISTBaseViewController

- (id)initWithType:(AccountBindType)type;

@end
