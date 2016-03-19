//
//  ISTBaseView.m
//  BSports
//
//  Created by 高大鹏 on 14/12/29.
//  Copyright (c) 2014年 ist. All rights reserved.
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
