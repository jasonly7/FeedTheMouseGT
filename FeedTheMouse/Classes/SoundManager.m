//
//  SoundManager.m
//  ProjectX
//
//  Created by Jason Ly on 12-02-26.
//  Copyright (c) 2012 WCAC. All rights reserved.
//

#import "SoundManager.h"

@implementation SoundManager
- (void)initializeSoundManager:(int)numOfChannels
{
    num = numOfChannels;
}

- (bool)checkSound:(NSString *)path
{
    NSURL* soundFile = [[NSURL alloc] initFileURLWithPath:path];
    for (int i=0; i < num; i++)
    {
        int lastIndexOfSlideSlash1 = [sPlayer[i].url.path rangeOfString:@"/" options:NSBackwardsSearch].location;
        int lastIndexOfSlideSlash2 = [soundFile.path rangeOfString:@"/" options:NSBackwardsSearch].location;
        NSString *str1 = [sPlayer[i].url.path substringFromIndex:lastIndexOfSlideSlash1];
        NSString *str2 = [soundFile.path substringFromIndex:lastIndexOfSlideSlash2];
        if ([str1 isEqualToString:str2])
        {
            return true;
        }
    }
    return false;
}

- (void)playSound:(NSString*)path 
{
    NSURL* soundFile = [[NSURL alloc] initFileURLWithPath:path];
   
    for (int i=0; i < num; i++)
    {
        if (!sPlayer[i].playing)
        {
            [sPlayer[i] release];
            sPlayer[i] = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFile error:NULL];
            [sPlayer[i] prepareToPlay];
            [sPlayer[i] play];
            break;
        }
    }
    [soundFile release];
}

-(void)stopAllSounds
{
    for (int i=0; i < num; i++)
    {
        if (sPlayer[i].playing)
        {
            [sPlayer[i] stop];
        }
    }
}

- (void)stopSound:(NSString*)path
{
    NSURL* soundFile = [[NSURL alloc] initFileURLWithPath:path];
    for (int i=0; i < num; i++)
    {
        if (sPlayer[i].playing)
        {
            int lastIndexOfSlideSlash1 = [sPlayer[i].url.path rangeOfString:@"/" options:NSBackwardsSearch].location;
            int lastIndexOfSlideSlash2 = [soundFile.path rangeOfString:@"/" options:NSBackwardsSearch].location;
            NSString *str1 = [sPlayer[i].url.path substringFromIndex:lastIndexOfSlideSlash1];
            NSString *str2 = [soundFile.path substringFromIndex:lastIndexOfSlideSlash2];
            if ([str1 isEqualToString:str2])
            {
                [sPlayer[i] stop];
                [sPlayer[i] release];
                sPlayer[i] = nil;
            }
        }
    }
    [soundFile release];
}

- (void)playLoopedSound:(NSString*)path
{
    NSURL* soundFile = [[NSURL alloc] initFileURLWithPath:path];
    for (int i=0; i < num; i++)
    {
        if (!sPlayer[i].playing)
        {
            [sPlayer[i] release];
            sPlayer[i] = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFile error:NULL];
            sPlayer[i].numberOfLoops = -1; // negative # for infinite loop
            [sPlayer[i] prepareToPlay];
            [sPlayer[i] play];
            break;
        }
    }
    [soundFile release];
}

- (AVAudioPlayer *)audioPlayerWithContentsOfFile:(NSString *)path {
    NSData *audioData = [NSData dataWithContentsOfFile:path];
    AVAudioPlayer *player = [AVAudioPlayer alloc];
    if([player initWithData:audioData error:NULL]) {
        [player autorelease];
    } else {
        [player release];
        player = nil;
    }
    return player;
}

- (void)dealloc
{
    
    for (int i = 0; i < num; i++)
    {
        [sPlayer[i] release];
    }
    [super dealloc];
}
@end

