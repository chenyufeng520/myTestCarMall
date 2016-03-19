//
//  TabbarItem.h
//  CarLife
//
//  Created by 高大鹏 on 15/11/13.
//  Copyright © 2015年 高大鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TabbarItem : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *selectImg;
@property (nonatomic, strong) NSString *unSelectImg;
@property (nonatomic, assign) BOOL highlighted;

@end
