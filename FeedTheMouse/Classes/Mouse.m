//
//  Mouse.m
//  Feed The Mouse
//
//  Created by Jason Ly on 2012-12-13.
//  Copyright (c) 2012 Jason Ly. All rights reserved.
//

#import "Mouse.h"

@implementation Mouse
static int kWait[] = {0};
//static int kWaitOpen[] = {0};
static int kBlink[] = {0,1,2,3,4,5,6};
static int kOpenMouth[] = {0,1,2,3,4,5,6,7,8,9,10,11};
//static int kCloseMouth[] = {0,1,2,3,4,5,6,7,8,9,10,11};
//static int kSad[] = {0,1,2,3,4,5};
static int kChew[] = {0,1,2,3,4,5,6,7,8,9,10,11};

- (id) init
{
    self = [super init];
    if (self)
    {
        steps = kSteps;
        mouseSprite = [[AtlasSprite alloc] init];
        [mouseSprite fromFile: @"MouseWait.png" withRows: 1 withColumns: 1];
        mouseSprite.angle = 0;
		mouseSprite.speed = kSpeed;
        startBlinkDate = [[NSDate date] retain];
        state = MOUSE_WAIT;
    }
    return self;
}

- (Mouse*) initializeMouseAtX:(float) xLocation andY: (float)yLocation
{
    x = xLocation;
    y = yLocation;
    return self;
}

- (int)getX
{
    return x;
}

- (int)getY
{
    return y;
}

- (void) setX: (int) value
{
    mouseSprite->x = value;
    x = value;
    
    
}

- (void) setY: (int) value
{
    mouseSprite->y = value;
    y = value;
}

- (void) updateWait
{
    steps = 1;
    
    mouseSprite.frame = kWait[frame];
    thisFrameStartTime = [[NSDate date] timeIntervalSince1970];
    deltaTime = thisFrameStartTime - lastFrameStartTime;
    lastFrameStartTime = thisFrameStartTime;
    timeSinceLastBlink += deltaTime;
    if (timeSinceLastBlink >= 20)
    {
        state = MOUSE_BLINK;
        [mouseSprite fromFile: @"MouseBlink.png" withRows: 1 withColumns: MOUSE_BLINK_FRAMES];
    }
    frame = (frame+1)%steps;
}

- (void) updateBlink
{
    int lastFrame = MOUSE_BLINK_FRAMES-1;
    if (mouseSprite.frame >= lastFrame)
    {
        state = MOUSE_WAIT;
        
        //printf("mouseSprite retainCount is %d\n",[mouseSprite retainCount]);
        [mouseSprite fromFile: @"MouseWait.png" withRows: 1 withColumns: 1];
        
        timeSinceLastBlink = 0;
        
    }
    steps = MOUSE_BLINK_FRAMES;
    mouseSprite.frame = kBlink[frame];
    
   // printf("frame %d on blink\n",mouseSprite.frame);
    frame = (frame+1)%steps;
}

- (void) updateOpenMouth
{
    steps = MOUSE_OPENMOUTH_FRAMES;
    int lastFrame = MOUSE_OPENMOUTH_FRAMES - 1;
    if (mouseSprite.frame < lastFrame)
    {
        frame = (frame+1)%steps;
        mouseSprite.frame = kOpenMouth[frame];
    }
}

- (void) updateMouthChew
{
    steps = MOUSE_CHEW_FRAMES;
    int lastFrame = MOUSE_CHEW_FRAMES - 1;
    if (mouseSprite.frame < lastFrame)
    {
        frame = (frame+1)%steps;
        mouseSprite.frame = kChew[frame];
    }
}

- (bool) isDoneChewing
{
    if (state == MOUSE_CHEW && frame == MOUSE_CHEW_FRAMES-1)
    {
        state = MOUSE_WAIT;
        return true;
    }
    else
    {
        return false;
    }
}

- (void) update
{
    if (state==MOUSE_WAIT)
    {
        [self updateWait];
    }
    else if (state==MOUSE_BLINK)
    {
        [self updateBlink];
    }
    else if (state == MOUSE_OPEN_MOUTH)
    {
        [self updateOpenMouth];
    }
    else if (state == MOUSE_CHEW)
    {
        [self updateMouthChew];
    }
}

- (void) draw:(CGContextRef)context
{
    [mouseSprite draw: context];
}

- (void) openMouth
{
    state = MOUSE_OPEN_MOUTH;
    steps = MOUSE_OPENMOUTH_FRAMES;
    [mouseSprite fromFile: @"MouseOpenMouth.png" withRows: 1 withColumns: steps];
}

- (void) chew
{
    state = MOUSE_CHEW;
    steps = MOUSE_CHEW_FRAMES;
    mouseSprite.frame = 0;
    [mouseSprite fromFile: @"MouseChew.png" withRows: 1 withColumns: steps ];

}

- (MOUSE_STATE)getState
{
    return state;
}

- (void) dealloc
{
    [mouseSprite release];
    [startBlinkDate release];
    [super dealloc];
}
@end
