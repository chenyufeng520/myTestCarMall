//
//  AllDataReplyCenter.h
//  GasSation
//
//  Created by 高大鹏 on 15/8/18.
//  Copyright (c) 2015年 ist. All rights reserved.
//

#import "AllDataReplyCenter.h"
#import "BusinessCode.h"

@implementation AllDataReplyCenter

+ (void)dealDataWithMessageDic:(NSDictionary *)mesDic
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData *data = [mesDic[kMessageContent] dataUsingEncoding:NSUTF8StringEncoding];
        if (data == nil) {
            return;
        }
        
        //将json转化为NSDictionary
        NSError *error = nil;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                        options:NSJSONReadingAllowFragments
                                                          error:&error];
        
        NSDictionary *message = (NSDictionary *)jsonObject;
        if (message == nil) {
            return;
        }
        NSString *cmd = mesDic[kBusinessCode];
        dispatch_async(dispatch_get_main_queue(), ^{
            //发送数据
            if(![cmd isEqualToString:kBusinessCode_Heartbeat])
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:cmd
                                                                    object:nil
                                                                  userInfo:message];
            }
        });
        
    });

}

@end
