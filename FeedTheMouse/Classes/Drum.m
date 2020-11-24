//
//  Drum.m
//  Feed The Mouse Level Editor
//
//  Created by Jason Ly on 2013-04-20.
//  Copyright (c) 2013 Jason Ly. All rights reserved.
//

#import "Drum.h"

@implementation Drum
static int kWait[] = {0};
static int kVibration[] = {0,1,2,3,4,5,6,7};

- (id) init
{
    float screenWidth = [UIScreen.mainScreen bounds].size.width * [UIScreen.mainScreen scale];
    float screenHeight = [UIScreen.mainScreen bounds].size.height * [UIScreen.mainScreen scale];
    self = [super init];
    if (self)
    {
        
        drumSprite = [[AtlasSprite alloc] init];
        if (screenWidth == 1242)
            [drumSprite fromFile:@"bigDrumsSheet.png" withRows: 1 withColumns: 8];
        else
            [drumSprite fromFile:@"DrumsSheet.png" withRows: 1 withColumns: 8];
        //[drumSprite setAngle:1.57];
        [self setX:0];
        [self setY:0];
        angle = 0;
        state = DRUM_WAIT;
    }
    return self;
}

- (Drum*) initializeDrumAtX:(float) xLocation andY: (float)yLocation andAngle: (float)newAngle
{
    float screenWidth = [UIScreen.mainScreen bounds].size.width * [UIScreen.mainScreen scale];
    float screenHeight = [UIScreen.mainScreen bounds].size.height * [UIScreen.mainScreen scale];
    float sx = screenWidth/640.0f;
    float sy = screenHeight/1136.0f;
    if (screenWidth == 1242)
    {
        xLocation = xLocation * sx;
        yLocation = yLocation * sy;
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
    //printf("value is %d\n", value);
    drumSprite.x = value;
   // printf("drumSprite's x is %f\n",drumSprite.x);
    x = drumSprite.x;// + drumSprite.width/2;
   // printf("drum's x is %d", x);
    //drumSprite.box = CGRectMake(value, drumSprite.box.origin.y, drumSprite.box.size.width, drumSprite.box.size.height);
 
}

- (void) setY: (int) value
{
    drumSprite.y = value;
    //drumSprite.box = CGRectMake(drumSprite.box.origin.x, value, drumSprite.box.size.width, drumSprite.box.size.height);
    
    y = drumSprite.y;// + drumSprite.height/2;
}

- (void) setAngle: (float) value
{
    angle = value;
    drumSprite.rotation = angle;
}

- (void) draw:(CGContextRef)context{
    [drumSprite draw:context];
}

- (void) updateWait
{
    steps = 1;
    
    drumSprite.frame = kWait[frame];
        
    frame = (frame+1)%steps;

}

- (void) updateVibration
{
    steps = DRUM_FRAMES;
    drumSprite.frame = kVibration[frame];
    int lastFrame = DRUM_FRAMES - 1;
    if (drumSprite.frame < lastFrame)
    {
        frame = (frame+1)%steps;
    }
    else if (drumSprite.frame == lastFrame)
    {
        frame = 0;
        state = DRUM_WAIT;
       // [drumSprite fromFile:@"DrumsSheet.png" withRows: 1 withColumns: 8];
    }
}

- (void)update
{
   // [drumSprite tic:(1/60.0)];
    if (state == DRUM_WAIT)
        [self updateWait];
    else if (state == DRUM_VIBRATE)
        [self updateVibration];
}

- (void)vibrate
{
    //[drumSprite fromFile:@"DrumsSheet.png" withRows: 1 withColumns: 8];
    state = DRUM_VIBRATE;
}

- (void) dealloc
{
    [drumSprite release];
    [super dealloc];
}

- (DRUM_STATE)getState
{
    return state;
}
@end
