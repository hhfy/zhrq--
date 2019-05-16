//
//  AudioTool.m
//  66、赖同学音乐播放器
//
//  Created by Mr Lai on 2017/2/23.
//  Copyright © 2017年 赖同学. All rights reserved.
//

#import "AudioTool.h"
#import <AVFoundation/AVFoundation.h>

@implementation AudioTool

static NSMutableDictionary *_soundIDs;
static NSMutableDictionary *_players;

//+ (void)initialize
//{
//    _soundIDs = [NSMutableDictionary dictionary];
//}

// 两种方法都可以
+ (NSMutableDictionary *)soundIDs
{
    if (_soundIDs == nil)
    {
        _soundIDs = [NSMutableDictionary dictionary];
    }
    return _soundIDs;
}

+ (NSMutableDictionary *)players
{
    if (_players == nil)
    {
        _players = [NSMutableDictionary dictionary];
    }
    return _players;
}

+ (void)playAudioWithFileName:(NSString *)fileName
{
    // 判断是否为空(字典中如果为空就会报错)
    if (fileName == nil) return;
    // 取出字典中音效的ID
    SystemSoundID soundID = [[self soundIDs][fileName] intValue];
    // 判断音效ID是否为空
    if (!soundID)
    {
        // 音效为空的时候
        
        // 将音效ID
        NSURL *url = [[NSBundle mainBundle] URLForResource:fileName withExtension:nil];
        
        // 判断url是否为空
        if (url == nil) return;
        
        // 创建音效ID
        AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(url), &soundID);
        
        // 将音效ID存入字典
        [self soundIDs][fileName] = @(soundID);
    }
    
    // 播放音效（只能播放本地音效)
    AudioServicesPlaySystemSound(soundID);
}

+ (void)disposeAudioWithFileName:(NSString *)fileName
{
    if (fileName == nil) return;
    
    // 取出字典中音效的ID
    SystemSoundID soundID = [[self soundIDs][fileName] intValue];
    
    if (!soundID) return;
    // 销毁音效
    AudioServicesDisposeSystemSoundID(soundID);
    
    // 从字典中移除已销毁的音效ID
    [[self soundIDs] removeObjectForKey:fileName];
}

// 根据音乐文件名称播放音乐
+ (AVAudioPlayer *)playMusicWithFilename:(NSString  *)filename
{
    // 0.判断文件名是否为nil
    if (filename == nil) return nil;
    // 1.从字典中取出播放器
    AVAudioPlayer *player = [self players][filename];
    
    // 2.判断播放器是否为nil
    if (!player) {
        NSLog(@"创建新的播放器");
        
        // 2.1根据文件名称加载音效URL
        NSURL *url = [[NSBundle mainBundle] URLForResource:filename withExtension:nil];
        
        // 2.2判断url是否为nil
        if (!url) return nil;
        
        // 2.3创建播放器
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        
        // 2.4准备播放
        if(![player prepareToPlay]) return nil;
 
        // 允许快进
        player.enableRate = NO;
        player.rate = 3;
        
        // 2.5将播放器添加到字典中
        [self players][filename] = player;
        
    }
    // 3.播放音乐
    if (!player.isPlaying)
    {
        [player play];
    }
    
    return player;
}

// 根据音乐文件名称暂停音乐
+ (void)pauseMusicWithFilename:(NSString  *)filename
{
    // 0.判断文件名是否为nil
    if (filename == nil) {
        return;
    }
    
    // 1.从字典中取出播放器
    AVAudioPlayer *player = [self players][filename];
    
    // 2.判断播放器是否存在
    if(player)
    {
        // 2.1判断是否正在播放
        if (player.playing)
        {
            // 暂停
            [player pause];
        }
    }
    
}

// 根据音乐文件名称停止音乐
+ (void)stopMusicWithFilename:(NSString  *)filename
{
    // 0.判断文件名是否为nil
    if (filename == nil) {
        return;
    }
    
    // 1.从字典中取出播放器
    AVAudioPlayer *player = [self players][filename];
    
    // 2.判断播放器是否为nil
    if (player) {
        // 2.1停止播放
        [player stop];
        // 2.2清空播放器
        //        player = nil;
        // 2.3从字典中移除播放器
        [[self players] removeObjectForKey:filename];
    }
}

@end
