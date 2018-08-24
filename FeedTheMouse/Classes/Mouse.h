//
//  Mouse.h
//  Feed The Mouse
//
//  Created by Jason Ly on 2012-12-13.
//  Copyright (c) 2012 Jason Ly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AtlasSprite.h"
#define kSteps 1
#define kSpeed 0
#define MOUSE_BLINK_FRAMES 7
#define MOUSE_OPENMOUTH_FRAMES 12
#define MOUSE_CHEW_FRAMES 11



typedef enum {
    MOUSE_WAIT = 0,
    MOUSE_WAIT_OPEN,
    MOUSE_BLINK,
    MOUSE_CHEW,
    MOUSE_OPEN_MOUTH,
    MOUSE_CLOSE_MOUTH,
    MOUSE_SAD
} MOUSE_STATE;

@interface Mouse : NSObject
{
    
    int steps;
    int frame;
    MOUSE_STATE state;
    NSDate *startBlinkDate;
    NSDate *dateSinceLastBlink;
    NSTimeInterval deltaTime;
	NSTimeInterval lastFrameStartTime;
	NSTimeInterval thisFrameStartTime;
    NSTimeInterval timeSinceLastBlink;
   
    @public
        AtlasSprite *mouseSprite;
    int x,y;
}
- (Mouse*) initializeMouseAtX:(float) xLocation andY: (float)yLocation;
- (int)getX;
- (int)getY;
- (void) setX: (int) value;
- (void) setY: (int) value;
- (void) draw: (CGContextRef) context;
- (void) update;
- (void) updateBlink;
- (void) updateWait;
- (void) updateOpenMouth;
- (void) updateMouthChew;
- (void) blink;
- (void) openMouth;
- (void) chew;
- (bool) isDoneChewing;
- (MOUSE_STATE)getState;
@end
