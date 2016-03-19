//
//  SocketHelper.h
//  GasSation
//
//  Created by 高大鹏 on 15/8/18.
//  Copyright (c) 2015年 ist. All rights reserved.
//

#import "SocketHelper.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <unistd.h>
#import "AllDataReplyCenter.h"
#import "HttpReachabilityHelper.h"
#import "BusinessCode.h"
#import "MessageTool.h"
#import "STHUDManager.h"

static NSInteger    kSOCKET_PORT = 8999;
static NSString    *KSOCKET_IP = @"123.57.78.118";
static NSUInteger   KSOCKET_RECONECT = NSUIntegerMax;

static long int countTime = 0;

@interface SocketHelper()

@property (nonatomic, strong) GCDAsyncSocket  *GSSocket;
@property (nonatomic, strong) NSMutableData *receiveData;

@end

@implementation SocketHelper
{
    NSTimer *_timer;
    PackType _packtype;
    NSMutableDictionary *_mesInfo;
    NSInteger _reconnectCount;
}

+ (id) sharedService
{
	static SocketHelper *_sharedInst = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInst=[[SocketHelper alloc] init];
    });
    return _sharedInst;
}

- (void)dealloc
{
    self.receiveData = nil;
}

- (id) init
{
	if (self = [super init])
	{
        //进来是没有连接
        _isConnect = DisConnect;
        _packtype = PackType_receiveStart;
        _offlineType = OfflineType_Server;
        
        [HttpReachabilityHelper  sharedService];
        _mesInfo = [NSMutableDictionary dictionary];
        self.receiveData = [NSMutableData data];
        _reconnectCount = 0;
	}
	return self;
}

#pragma mark - 创建连接和关闭连接
//连接socket
- (void)connect
{
    [self checkTheNetWork];
    
    if (_reconnectCount > KSOCKET_RECONECT) {
        return;
    }
   
    //先断开连接
    [self resetSocket];
    _offlineType = OfflineType_Server;
    _reconnectCount ++;
    _isConnect = Connecting;
    if (!self.GSSocket)
    {
        self.GSSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    
    NSError *error;
    [_GSSocket connectToHost:KSOCKET_IP onPort:kSOCKET_PORT withTimeout:8.f error:&error];
}

- (void)cutoffConnect
{
    _offlineType = OfflineType_User;
    [self resetSocket];
}

//断开socket连接
- (void)resetSocket
{
    countTime = 0;
    _isConnect = DisConnect;
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    if (self.GSSocket) {
        [_GSSocket setDelegate:nil delegateQueue:NULL];
        if (_GSSocket.isConnected) {
            [_GSSocket disconnect];
        }
        self.GSSocket = nil;
    }
}

#pragma mark - 定时器
//启用定时器
- (void)startListenTimer
{
    countTime = 0;
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(increseTime) userInfo:nil repeats:YES];
    [_timer fire];
}

- (void)increseTime
{
    //如果正处于连接状态 则发送心跳包
    if (_isConnect == HasConnected) {
        if (countTime == 0) {
            NSString *tcpPack = [[MessageTool sharedService] generateMessage:@{@"source":@"heartbeat"} andBusinessCode:kBusinessCode_Heartbeat];
            NSData *data = [tcpPack dataUsingEncoding:NSUTF8StringEncoding];
            [_GSSocket writeData:data withTimeout: -1 tag: 0];
        }
        countTime ++;
        if (countTime > 5) {
            countTime = 0;
        }
    }
}

#pragma mark - 发送数据
- (BOOL)sendDataToServer:(NSString *)string
{
    if (_isConnect != HasConnected) {
        return NO;
    }
    NSString *sendString = string;
    NSData *data = [[NSData alloc]initWithBytes:[sendString UTF8String] length:[sendString lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];

    [_GSSocket writeData:data withTimeout:10.f tag: 0];
    return YES;
}

- (void)checkTheNetWork
{
    if (![[HttpReachabilityHelper sharedService] checkNetwork]) {
        [[STHUDManager sharedManager] removeAllWaittingViews];
        return;
    }
}

#pragma mark - AsyncSocketDelegate
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"%s %d", __FUNCTION__, __LINE__);
    
    _reconnectCount = 0;

    //连接成功
    _isConnect = HasConnected;
    [_GSSocket readDataWithTimeout:-1 tag: 0];
    
    [self startListenTimer];
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"%s %d, tag = %ld", __FUNCTION__, __LINE__, tag);
}

// 这里必须要使用流式数据
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSLog(@"%s %d, tag = %ld", __FUNCTION__, __LINE__, tag);
    
    //首先将计时器计1100
    countTime = 1;
    [_receiveData appendData:data];
    
    NSString *description = [[NSString alloc] initWithData:_receiveData encoding:NSUTF8StringEncoding];
    NSLog(@"\n响应报文-----------------------------------\n%@\n------------------------------------------\n",description);
    
    BOOL isExistMessage = YES;
    while (isExistMessage) {
        if (_packtype == PackType_receiveStart) {
            [_mesInfo removeAllObjects];
            //获取消息头
            if (_receiveData.length < headerLength) {
                isExistMessage = NO;
                _packtype = PackType_receiveStart;
                break;
            }
            NSData *headerData = [_receiveData subdataWithRange:NSMakeRange(0, headerLength)];
            NSString *headerStr = [[NSString alloc] initWithData:headerData encoding:NSUTF8StringEncoding];
            NSDictionary *tmpDic = [[MessageTool sharedService] messageHeaderParser:headerStr];
            [_mesInfo addEntriesFromDictionary:tmpDic];
            
            NSInteger messageLength = [_mesInfo[kMessageLength] integerValue];
            
            //获取消息体
            [_receiveData replaceBytesInRange:NSMakeRange(0, headerLength) withBytes:NULL length:0];
            if (_receiveData.length < messageLength) {
                //断包处理
                isExistMessage = NO;
                _packtype = PackType_receiving;
            }
            else
            {
                NSData *messageData = [_receiveData subdataWithRange:NSMakeRange(0, messageLength)];
                if (messageData.length != 0) {
//                    [_mesInfo setValue:messageData forKey:kMessageContent];
                    NSString *message = [[NSString alloc] initWithData:messageData encoding:NSUTF8StringEncoding];
//                    NSLog(@"\n解析报文-----------------------------------\n%@\n------------------------------------------\n",message);
                    [_mesInfo setValue:message forKey:kMessageContent];
                    [AllDataReplyCenter dealDataWithMessageDic:_mesInfo];
                }
                
                if (_receiveData.length > messageLength) {
                    
                    isExistMessage = YES;
                    //粘包处理
                    [_receiveData replaceBytesInRange:NSMakeRange(0, messageLength) withBytes:NULL length:0];
                }
                else if (_receiveData.length == messageLength)
                {
                    isExistMessage = NO;
                    //清空数据
                    [_receiveData resetBytesInRange:NSMakeRange(0, [_receiveData length])];
                    [_receiveData setLength:0];
                    
                }
                
                _packtype = PackType_receiveStart;
            }
        }
        else if (_packtype == PackType_receiving)
        {
            NSInteger messageLength = [_mesInfo[kMessageLength] integerValue];
            if (_receiveData.length < messageLength) {
                isExistMessage = NO;
                _packtype = PackType_receiving;
            }
            else
            {
                NSData *messageData = [self.receiveData subdataWithRange:NSMakeRange(0, messageLength)];
                if (messageData.length != 0) {
                    NSString *message = [[NSString alloc] initWithData:messageData encoding:NSUTF8StringEncoding];
//                    NSLog(@"\n解析报文-----------------------------------\n%@\n------------------------------------------\n",message);
                    [_mesInfo setValue:message forKey:kMessageContent];
//                    [_mesInfo setValue:messageData forKey:kMessageContent];
                    [AllDataReplyCenter dealDataWithMessageDic:_mesInfo];
                }
                
                if (_receiveData.length > messageLength) {
                    isExistMessage = YES;
                    //粘包处理
                    [_receiveData replaceBytesInRange:NSMakeRange(0, messageLength) withBytes:NULL length:0];
                }
                else if (_receiveData.length == messageLength)
                {
                    isExistMessage = NO;
                    //清空数据
                    [_receiveData resetBytesInRange:NSMakeRange(0, [_receiveData length])];
                    [_receiveData setLength:0];
                    
                }
                
                _packtype = PackType_receiveStart;
            }
        }
        
    }
    
    [sock readDataWithTimeout:-1 tag:0];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    NSLog(@"%s %d reconnect:%ld", __FUNCTION__, __LINE__, (long)_reconnectCount);
    [self resetSocket];
    
    if (_offlineType == OfflineType_Server) {
        [self connect];
    }
    else
    {
        return;
    }
}

- (void)socketDidCloseReadStream:(GCDAsyncSocket *)sock
{
    NSLog(@"%s %d", __FUNCTION__, __LINE__);
    [self resetSocket];
}

@end
