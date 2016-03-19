//
//  BSVoicePlayer.h
//  Project
//
//  Created by 高大鹏 on 15/10/18.
//  Copyright © 2015年 高大鹏. All rights reserved.
//

/*
    对微信语音合成进行的简单封装，用于声音的播放。
    使用时导入 #import "BSVoicePlayer.h"
    在需要播放语音提示处调用[[BSVoicePlayer player] playMessage:@"播放语音内容"];
 */

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface BSVoicePlayer : NSObject

@property (nonatomic, strong) AVAudioPlayer *player;


+ (instancetype)player;
- (void)playMessage:(NSString *)message;

@end
