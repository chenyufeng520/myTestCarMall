//
//  BlockButton.h
//  PointsMall
//
//  Created by 高大鹏 on 15/10/23.
//  Copyright © 2015年 高大鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BlockButton;
typedef void (^TouchButton)(BlockButton*);

@interface BlockButton : UIButton

@property(nonatomic,copy)TouchButton block;

@end
