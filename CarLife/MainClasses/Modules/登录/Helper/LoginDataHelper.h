//
//  LoginDataHelper.h
//  Project
//
//  Created by 高大鹏 on 15/10/19.
//  Copyright © 2015年 高大鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "LoginNetworkDef.h"
#import "STHUDManager.h"

@interface LoginDataHelper : NSObject

+ (LoginDataHelper *)defaultHelper;

- (void)checkNetwork;

- (void)requestForType:(LoginNetworkRequestType)type info:(NSDictionary *)requestInfo andBlock:(void (^)(id response, NSError *error))block;

@end
