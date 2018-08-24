//
//  Drum.h
//  Feed The Mouse Level Editor
//
//  Created by Jason Ly on 2013-04-20.
//  Copyright (c) 2013 Jason Ly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AtlasSprite.h"
//#import "Picture.h"
#define kSteps 1
#define kSpeed 0
#define DRUM_FRAMES 8



typedef enum {
    DRUM_WAIT = 0,
    DRUM_VIBRATE
} DRUM_STATE;

@interface Drum : NSObject
{
@public
    AtlasSprite *drumSprite;
    int x,y;
    float angle;
    DRUM_STATE state;
    int steps;
    int frame;
}

- (Drum*) initializeDrumAtX:(float) xLocation andY: (float)yLocation andAngle: (float)newAngle;
- (int)getX;
- (int)getY;
- (float)getAngle;
- (void) setX: (int) value;
- (void) setY: (int) value;
- (void) setAngle: (float) value;
- (void) draw: (CGContextRef) context;
- (void) update;
- (void) vibrate;
- (DRUM_STATE) getState;
- (void) updateWait;
- (void) updateVibration;
@end
