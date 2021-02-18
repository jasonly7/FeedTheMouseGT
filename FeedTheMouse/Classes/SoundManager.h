//
//  SoundManager.h
//  ProjectX
//
//  Created by Jason Ly on 12-02-26.
//  Copyright (c) 2012 WCAC. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@interface SoundManager : NSObject
{
    AVAudioPlayer *sPlayer[10];
    int num;
}
- (AVAudioPlayer *)audioPlayerWithContentsOfFile:(NSString *)path;
//- (void):(int)numOfChannels;
- (bool)checkSound:(NSString *)path;
- (void)playSound:(NSString*)path;
- (void)playLoopedSound:(NSString*)path;
- (void)stopSound:(NSString*)path;
- (void)stopAllSounds;
- (void)dealloc;
@end


