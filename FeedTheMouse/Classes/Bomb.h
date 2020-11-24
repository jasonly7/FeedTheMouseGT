//
//  Bomb.h
//  FeedTheMouse
//
//  Created by Jason Ly on 2020-10-03.
//  Copyright © 2020 Jason Ly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AtlasSprite.h"
#import "Picture.h"
#import "Circle.h"

#define kSteps 1
#define kSpeed 0
#define BOMB_FRAMES 8

typedef enum {
    BOMB_WAIT = 0,
    BOMB_EXPLODE,
    BOMB_GONE
} BOMB_STATE;

@interface Bomb : Circle
{
@public
    Sprite *bombSprite;
    AtlasSprite *explosionSprite;
    //int x,y;
    float angle;
    BOMB_STATE state;
    int steps;
    int frame;
    float screenWidth;
    float screenHeight;
}

- (Bomb*) initializeBombAtX:(float) xLocation andY: (float)yLocation andAngle: (float)newAngle;
- (int)getX;
- (int)getY;
- (float)getAngle;
- (void) setX: (int) value;
- (void) setY: (int) value;
- (void) setAngle: (float) value;
- (void) draw: (CGContextRef) context;
- (void) update;
- (void) explode;
- (BOMB_STATE) getState;
- (void) updateWait;
- (void) updateExplosion;
@end


