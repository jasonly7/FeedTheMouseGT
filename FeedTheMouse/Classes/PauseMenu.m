//
//  PauseMenu.m
//  FeedTheMouse
//
//  Created by Jason Ly on 2021-01-09.
//  Copyright © 2021 Jason Ly. All rights reserved.
//

#import "PauseMenu.h"

@implementation PauseMenu
- (id) init
{
    self = [super init];
    if (self)
    {
        pauseSprite = [Picture fromFile:@"pause_menu.png"];
        
    }
    return self;
}

- (void) draw: (CGContextRef) context
{
    [pauseSprite draw:context at:CGPointMake(self.x , self.y)];
}

- (bool) pointIsInside: (CGPoint)pt withScreenScale: (float)scale
{
    if (pt.x > (self->x + pauseSprite.width)*scale)
        return false;
    else if (pt.x < (self->x * scale))
        return false;
    
    float top = self->y *scale+pauseSprite.height*scale;
    float bottom = self->y * scale;
    if (scale == 2.36619711f)
    {
        top = self->y+pauseSprite.height*scale;
        bottom = self->y;
    }
    if (pt.y > top)
        return false;
    else if (pt.y < bottom)
        return false;
    return true;
}

- (bool) pointIsInsidePlay: (CGPoint)pt withScreenScale: (float)scale
{
    if (pt.x > (self->x + pauseSprite.width)*scale)
        return false;
    else if (pt.x < (self->x * scale))
        return false;
    
    float top = (self->y+pauseSprite.height*3/4)*scale;
    float bottom = (self->y + pauseSprite.height*2/4) * scale;
    if (scale == 2.36619711f)
    {
        top = self->y+(pauseSprite.height*3/4)*scale;
        bottom = self->y + (pauseSprite.height*2/4)*scale;
    }
    if (pt.y > top)
        return false;
    else if (pt.y < bottom)
        return false;
    return true;
}
@end
