//
//  BSVoicePlayer.m
//  Project
//
//  Created by 高大鹏 on 15/10/18.
//  Copyright © 2015年 高大鹏. All rights reserved.
//

#import "BSVoicePlayer.h"
#import "WXSpeechSynthesizer.h"
#import "WXDefine.h"

@interface BSVoicePlayer ()<AVAudioPlayerDelegate,WXSpeechSynthesizerDelegate>
{
    AVAudioPlayer *_player;
}

@end

@implementation BSVoicePlayer

+ (instancetype)player {
    static BSVoicePlayer *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        WXSpeechSynthesizer * speechSynthesizer = [WXSpeechSynthesizer sharedSpeechSynthesizer];
        [speechSynthesizer setDelegate:self];
        [speechSynthesizer setAppID:kWXAppID];
        [speechSynthesizer setVolumn:1.0];
    
    }
    return self;
}


#pragma mark - Common Operation

- (void)playMessage:(NSString *)message
{
    [self startWithText:message];
}


- (BOOL)startWithText:(NSString *)text{
    
    return [[WXSpeechSynthesizer sharedSpeechSynthesizer] startWithText:text];
    
}

- (void)playNewData:(NSData *)data
{
    if (_player) {
        _player = nil;
    }
    _player = [[AVAudioPlayer alloc] initWithData:data error:nil];
    _player.delegate = self;
    if ([_player prepareToPlay] && [_player play]) {
        
    } else {
        _player = nil;
    }
}

#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (player == _player) {
        _player = nil;
        BSLog(@"播放完成");
    }
}

#pragma mark - WXSpeechSynthesizerDelegate

- (void)speechSynthesizerResultSpeechData:(NSData *)speechData speechFormat:(int)speechFormat
{
    [self playNewData:speechData];
}

- (void)speechSynthesizerMakeError:(NSInteger)error
{

}

- (void)speechSynthesizerDidCancel
{
    
}

@end
