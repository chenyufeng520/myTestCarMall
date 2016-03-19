//
//  HttpServiceHelper.h
//  JieXinIphone
//
//  Created by  tony on 14-3-19.
//  Copyright (c) 2014年 sunboxsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface HttpReachabilityHelper : NSObject
{
    Reachability* internetReach;
    NetworkStatus netStatus;
}

+ (HttpReachabilityHelper *)sharedService;
- (BOOL)checkNetwork;
- (void)detectNetwork;

@end
