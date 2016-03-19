//
//  SocketHelper.h
//  GasSation
//
//  Created by 高大鹏 on 15/8/18.
//  Copyright (c) 2015年 ist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"

typedef enum : NSUInteger {
    OfflineType_Server = 0, //服务器断线
    OfflineType_User,       //用户主动断线
} OfflineType;

typedef enum
{
    Connecting = 100,//正在连接
    HasConnected,      //联通中
    DisConnect,     //连接失败
}ConnectStatus;

typedef enum
{
    PackType_receiveStart = 0,         //开始获取数据
    PackType_receiving,                //获取包不完整
}PackType;

@interface SocketHelper : NSObject

@property (nonatomic, assign) ConnectStatus isConnect;
@property (nonatomic, assign) OfflineType offlineType;

+ (id) sharedService;

//连接服务器
- (void)connect;
//用户断开连接
- (void)cutoffConnect;
//发送数据到服务器
- (BOOL)sendDataToServer:(NSString *)string;

@end
