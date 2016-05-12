//
//  ISTBaseView.m
//  BSports
//
//  Created by 陈宇峰 on 16/5/10.
//  Copyright © 2016年 陈宇峰. All rights reserved.
//

#import "ISTBaseView.h"

@implementation ISTBaseView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        if (IOSVersion < 7.0) {
            self.iosChangeFloat = 0;
        }else{
            self.iosChangeFloat = 20;
        }
    }
    return self;
}

@end
