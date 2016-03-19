//
//  BusinessCode.h
//  BSports
//
//  Created by 高大鹏 on 15/8/27.
//  Copyright (c) 2015年 ist. All rights reserved.
//

#ifndef BSports_BusinessCode_h
#define BSports_BusinessCode_h

/*
 A15_10000	App心跳数据；
 A15_10001	加油站油枪相关数据；
 A15_10002	实时加油数据数据；
 A15_10003	撤销加油操作；
 A15_10004	预置加油量
 A15_10005	同步支付结果
 A15_10006	踢掉当前设备
 */

//业务编码
static NSString *kBusinessCode_Heartbeat          = @"A15_10000";
static NSString *kBusinessCode_OilGunInfo         = @"A15_10001";
static NSString *kBusinessCode_OilDataOnTime      = @"A15_10002";
static NSString *kBusinessCode_UndoRefuel         = @"A15_10003";
static NSString *kBusinessCode_SetOilMass         = @"A15_10004";
static NSString *kBusinessCode_PayResult          = @"A15_10005";
static NSString *kBusinessCode_DeviceKickOff      = @"A15_10006";

//起始符
static const NSString *kSCode       = @"20158";

//业务编码长度
static const NSString *kPIDLenth    = @"9";

//业务编码标签
static const NSString *kBusinessCode    = @"kBusinessCode";

//报文长度标签
static const NSString *kMessageLength   = @"kMessageLength";

//报文标签
static NSString *kMessageContent  = @"kMessageContent";

//报头长度
static const NSInteger headerLength = 19;

#endif
