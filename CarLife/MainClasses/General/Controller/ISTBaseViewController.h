//
//  ISTBaseViewController.h
//  BSports
//
//  Created by 陈宇峰 on 16/5/10.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISTTopBar.h"
#import "BaseGlobalDef.h"
#import "ISTGlobal.h"
#import "ISTSupBaseViewController.h"

@interface ISTBaseViewController : ISTSupBaseViewController<UIScrollViewDelegate>
{
    UIScrollView *_contentView;
}

@end
