//
//  AudioTool.h
//  66、赖同学音乐播放器
//
//  Created by Mr Lai on 2017/2/23.
//  Copyright © 2017年 赖同学. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AVAudioPlayer;
@interface AudioTool : NSObject

// 传入需要 播放的音效文件名称
+ (void)playAudioWithFileName:(NSString *)fileName;

// 销毁音效
+ (void)disposeAudioWithFileName:(NSString *)fileName;

// 根据音乐文件名称播放音乐
+ (AVAudioPlayer *)playMusicWithFilename:(NSString  *)filename;

// 根据音乐文件名称暂停音乐
+ (void)pauseMusicWithFilename:(NSString  *)filename;

// 根据音乐文件名称停止音乐
+ (void)stopMusicWithFilename:(NSString  *)filename;

@end
