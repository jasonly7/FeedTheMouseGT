//
//  PauseButton.m
//  FeedTheMouse
//
//  Created by Jason Ly on 2021-01-06.
//  Copyright © 2021 Jason Ly. All rights reserved.
//

#import "PauseButton.h"

@implementation PauseButton

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
            pauseSprite = [Picture fromFile:@"large_pause_button.png"];
        else
            pauseSprite = [Picture fromFile:@"pause_button.png"];
        
    }
    return self;
}

- (bool) pointIsInside: (CGPoint)pt withScreenScale:(float)scale
{
    
        
    
    
    float top = self->y *scale+pauseSprite.height*scale;
    float bottom = self->y * scale-pauseSprite.height*scale;
    float right = (self->x + pauseSprite.width/2)*scale;
    float left = (self->x - pauseSprite.width/2) * scale;
    if (scale == 2.36619711f)
    {
        right = self->x + pauseSprite.width;
        left = self->x;
        top = self->y+pauseSprite.height;//*3*scale;
        bottom = self->y;// -pauseSprite.height*3*scale;
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
    [pauseSprite draw:context at:CGPointMake(self.x , self.y)];
}
@end
