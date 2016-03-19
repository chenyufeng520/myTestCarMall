//
//  BlockButton.m
//  PointsMall
//
//  Created by 高大鹏 on 15/10/23.
//  Copyright © 2015年 高大鹏. All rights reserved.
//

#import "BlockButton.h"

@implementation BlockButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addTarget:self action:@selector(touchAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

- (void)touchAction:(id)sender{
    _block(self);
}


@end
