//
//  ISTLoginView.h
//  BSports
//
//  Created by 雷克 on 14/12/27.
//  Copyright (c) 2014年 ist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISTBaseView.h"

@protocol EnterDelegate

- (void)trialModeEnterance;

@end

@interface ISTEnterView : ISTBaseView

@property (nonatomic, weak) id <EnterDelegate> delegate;

@end
