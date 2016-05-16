//
//  LoginCenter.m
//  BSports
//
//  Created by 雷克 on 15/3/10.
//  Copyright (c) 2015年 ist. All rights reserved.
//

#import "LoginCenter.h"
#import "ISTLoginView.h"

@implementation LoginCenter

+ (BOOL)isLoginValid
{
    BOOL islogin = NO;
    NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:kUserid];
    if([userid length])
    {
        islogin = YES;
    }
    return islogin;
}

+ (void)doLogin:(NSDictionary *)info
{
    ISTBaseViewController *vc = (ISTBaseViewController *)[info objectForKey:kLoginDelegate];

}
@end
