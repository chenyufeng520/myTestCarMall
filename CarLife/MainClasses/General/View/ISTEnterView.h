//
//  ISTLoginView.h
//  BSports
//
//  Created by 陈宇峰 on 16/5/10.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISTBaseView.h"

@protocol EnterDelegate

- (void)trialModeEnterance;

@end

@interface ISTEnterView : ISTBaseView

@property (nonatomic, weak) id <EnterDelegate> delegate;

@end
