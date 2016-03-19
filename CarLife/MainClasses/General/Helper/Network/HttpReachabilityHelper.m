//
//  HttpReachabilityHelper.m
//  JieXinIphone
//
//  Created by tony on 14-3-19.
//  Copyright (c) 2014年 sunboxsoft. All rights reserved.
//

#import "HttpReachabilityHelper.h"
#import "BaseGlobalDef.h"

@implementation HttpReachabilityHelper

static HttpReachabilityHelper *_sharedInst = nil;

+ (id) sharedService
{
	@synchronized(self){
		if(_sharedInst == nil)
		{
			_sharedInst = [[self alloc] init];
		}
	}
	return _sharedInst;
}

- (id) init
{
	if (self = [super init])
	{
		//Change the host name here to change the server your monitoring
		internetReach = [Reachability reachabilityForInternetConnection];
	    [internetReach startNotifier];
		netStatus = [internetReach currentReachabilityStatus];
	}
	
	return self;
}

#pragma mark Reachability

- (BOOL)checkNetwork
{
	netStatus = [internetReach currentReachabilityStatus];
    //网络异常
    if(netStatus == NotReachable){
		return NO;
	}
	return YES;
}

- (void)detectNetwork
{
    internetReach.reachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            BSLog(@"网络通畅");
        });
    };
    
    internetReach.unreachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            BSLog(@"网络不通");
        });
    };
    
    [internetReach startNotifier];
}

@end
