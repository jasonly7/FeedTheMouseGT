//
//  PauseButton.m
//  FeedTheMouse
//
//  Created by Jason Ly on 2021-01-06.
//  Copyright © 2021 Jason Ly. All rights reserved.
//

#import "MusicButton.h"

@implementation MusicButton

- (id) init
{
    self = [super init];
    if (self)
    {
        float screenWidth = [UIScreen.mainScreen bounds].size.width * [UIScreen.mainScreen scale];
        float screenHeight = [UIScreen.mainScreen bounds].size.height * [UIScreen.mainScreen scale];
        float sx = screenWidth/640.0f;
        float sy = screenHeight/1136.0f;
        if (screenWidth == 1242)
            musicSprite = [Picture fromFile:@"music.png"];
        else
            musicSprite = [Picture fromFile:@"small_music.png"];
        
    }
    return self;
}

- (void) turnOffMusic
{
    float screenWidth = [UIScreen.mainScreen bounds].size.width * [UIScreen.mainScreen scale];
    if (screenWidth == 1242)
        musicSprite = [Picture fromFile:@"music_off.png"];
    else
        musicSprite = [Picture fromFile:@"small_music_off.png"];
}

- (void) turnOnMusic
{
    float screenWidth = [UIScreen.mainScreen bounds].size.width * [UIScreen.mainScreen scale];
    if (screenWidth == 1242)
        musicSprite = [Picture fromFile:@"music.png"];
    else
        musicSprite = [Picture fromFile:@"small_music.png"];
}

- (bool) pointIsInside: (CGPoint)pt withScreenScale:(float)scale
{
    float top = (self->y+musicSprite.height)*scale;
    float bottom = (self->y-musicSprite.height)*scale;
    float right = (self->x + musicSprite.width)*scale;
    float left = (self->x ) * scale;
    if (scale == 2.36619711f)
    {
        right = self->x + musicSprite.width;
        left = self->x;
        top = self->y+musicSprite.height;
        bottom = self->y;
    }
   
    if (pt.x > right)
        return false;
    else if (pt.x < left)
        return false;
    
    if (pt.y > top)
        return false;
    else if (pt.y < bottom)
        return false;
    return true;
}

- (void) draw: (CGContextRef) context
{
    [musicSprite draw:context at:CGPointMake(self.x , self.y)];
}
@end
