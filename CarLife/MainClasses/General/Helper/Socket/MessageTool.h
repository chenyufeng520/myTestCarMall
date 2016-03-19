//
//  MessageTool.h
//  BSports
//
//  Created by 高大鹏 on 15/8/27.
//  Copyright (c) 2015年 ist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageTool : NSObject

+ (id) sharedService;

- (NSString *)generateMessage:(NSDictionary *)messageInfo andBusinessCode:(NSString *)bcode;
- (NSDictionary *)messageHeaderParser:(NSString *)hearInfo;

@end
