//
//  MessageTool.m
//  BSports
//
//  Created by 高大鹏 on 15/8/27.
//  Copyright (c) 2015年 ist. All rights reserved.
//

#import "MessageTool.h"
#import "BusinessCode.h"

@implementation MessageTool

static MessageTool *_sharedInst = nil;

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
    }
    
    return self;
}

- (NSString *)convertIntegerToString:(NSInteger)size
{
    int count = 1;
    NSInteger tmpSize = size;
    while (tmpSize/10 >= 1) {
        tmpSize/=10;
        count ++;
    }
    
    if (count > 4) {
        return nil;
    }
    
    int zeroCount = 4 - count;
    
    NSString *str = @"";
    for (int i = 0; i < zeroCount; ++i) {
        str = [str stringByAppendingString:@"0"];
    }
    
    str = [str stringByAppendingString:[NSString stringWithFormat:@"%d",size]];
    
    return str;
}

- (NSString *)generateMessage:(NSDictionary *)messageInfo andBusinessCode:(NSString *)bcode
{
    NSMutableDictionary *tmpDic = [NSMutableDictionary dictionaryWithDictionary:messageInfo];
    [tmpDic setValue:[self generateStandardDate] forKey:@"time"];
    
    //将NSDictionary->String
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:tmpDic
                                                       options:0
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSString *dataLength = [self convertIntegerToString:jsonString.length];
    
    NSString *message = [NSString stringWithFormat:@"%@%@%@%@%@",kSCode,kPIDLenth,bcode,dataLength,jsonString];
    
    return message;
}

- (NSString *)generateStandardDate
{
    NSDate *curDate = [NSDate date];
    
    NSDateFormatter *formatter= [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [formatter stringFromDate:curDate];
    
    return dateStr;
}

- (NSDictionary *)messageHeaderParser:(NSString *)headerInfo
{
    NSString *businesscode = [headerInfo substringWithRange:NSMakeRange(6, 9)];
    NSString *messageLength = [headerInfo substringWithRange:NSMakeRange(headerInfo.length - 4, 4)];
    
    NSDictionary *dic = @{kBusinessCode:businesscode,kMessageLength:messageLength};
    
    return dic;
}

@end
