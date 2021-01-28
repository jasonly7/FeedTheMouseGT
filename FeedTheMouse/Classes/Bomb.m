//
//  Bomb.m
//  FeedTheMouse
//
//  Created by Jason Ly on 2020-10-03.
//  Copyright © 2020 Jason Ly. All rights reserved.
//

#import "Bomb.h"

@implementation Bomb
static int kWait[] = {0};
static int kExplosion[] = {0,1,2,3,4,5,6,7};

- (id) init
{
    screenWidth = [UIScreen.mainScreen bounds].size.width * [UIScreen.mainScreen scale];
    screenHeight = [UIScreen.mainScreen bounds].size.height * [UIScreen.mainScreen scale];
    self = [super init];
    if (self)
    {
        
        bombSprite = [[Picture alloc] init];
        if (screenWidth == 1242)
            bombSprite = [Picture fromFile:@"big_bomb.png"];
        else
            bombSprite = [Picture fromFile:@"bomb.png"];
        
        explosionSprite = [[AtlasSprite alloc] init];
        if (screenWidth == 1242)
            [explosionSprite fromFile:@"bomb_explosion/smoke_sprite_sheet_big.png" withRows: 1 withColumns: 8];
        else
            [explosionSprite fromFile:@"bomb_explosion/smoke_sprite_sheet.png" withRows: 1 withColumns: 8];
        
        //[drumSprite setAngle:1.57];
        r = bombSprite.width/2;
        [self setX:0];
        [self setY:0];
        angle = 0;
        state = BOMB_WAIT;
    }
    return self;
}

- (Bomb *)initializeBombAtX:(float)xLocation andY:(float)yLocation andAngle:(float)newAngle {
    float screenWidth = [UIScreen.mainScreen bounds].size.width * [UIScreen.mainScreen scale];
    float screenHeight = [UIScreen.mainScreen bounds].size.height * [UIScreen.mainScreen scale];
    float sx = screenWidth/640.0f;
    float sy = screenHeight/1136.0f;
    if (screenWidth == 1242)
    {
        xLocation = xLocation * sx - 109;
        yLocation = yLocation * sy - 109;
    }
    [self setX:xLocation];
    [self setY:yLocation];
    [self setAngle:newAngle];
    
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

- (float)getAngle
{
    return angle;
}

- (void) setX: (int) value
{
    bombSprite.x = value;
    explosionSprite.x = value + bombSprite.width/2;
    x = bombSprite.x + bombSprite.width/2;
    pos->x = x;
}

- (void) setY: (int) value
{
    bombSprite.y = value;
    explosionSprite.y = value + bombSprite.height/2;
    y = bombSprite.y + bombSprite.height/2;
    pos-> y = y;
}

- (void) setAngle: (float) value
{
    angle = value;
    bombSprite.rotation = angle;
    explosionSprite.rotation = 0;
}

- (void) draw:(CGContextRef)context{
    if (state == BOMB_WAIT)
        [bombSprite draw:context];
    else if (state == BOMB_EXPLODE)
    {
        [explosionSprite draw:context];
    }
}

- (void) updateWait
{
    steps = 1;
    
    bombSprite.frame = kWait[frame];
        
    frame = (frame+1)%steps;
}

- (void)update
{
    if (state == BOMB_WAIT)
        [self updateWait];
    else if (state == BOMB_EXPLODE)
        [self updateExplosion];
   
        
}

- (void) updateExplosion
{
    steps = BOMB_FRAMES;
    explosionSprite.frame = kExplosion[frame];
    int lastFrame = BOMB_FRAMES - 1;
    if (explosionSprite.frame < lastFrame)
    {
        explosionSprite.rotation = 0;
        frame = (frame+1)%steps;
    }
    else if (explosionSprite.frame == lastFrame)
    {
        frame = 0;
        state = BOMB_GONE;
        
    }
}

- (void)explode
{
    state = BOMB_EXPLODE;
    [self setAngle:0];
}

- (void) dealloc
{
    [bombSprite release];
    [explosionSprite release];
    [super dealloc];
}

- (BOMB_STATE)getState
{
    return state;
}
@end
