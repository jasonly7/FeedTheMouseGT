//
//  TeeterTotter.h
//  Feed The Mouse Level Editor
//
//  Created by Jason Ly on 2014-03-06.
//  Copyright (c) 2014 Jason Ly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Picture.h"
#import "Vector.h"
#import "Line.h"

typedef enum {
    TEETER_TOTTER_WAIT = 0,
    TEETER_TOTTER_RESET,
    TEETER_TOTTER_ROTATING
} TEETER_TOTTER_STATE;

@interface TeeterTotter : NSObject
{
    UIColor *color;
    @public
    int x,y;
    Sprite *totterSprite;
    float angle;
    TEETER_TOTTER_STATE state;
    float angularVelocity, angularAcceleration;
    Vector *normal;
    float time;
    Line *topLine;
    Line *topLineRotated;
}
- (UIColor*) getColor;
- (TeeterTotter*) initializeTeeterTotterAtX:(float) tx andY: (float)ty andColor: (UIColor*)c;
- (void) draw: (CGContextRef) context;
- (int)getX;
- (int)getY;
- (void) setX: (int) value;
- (void) setY: (int) value;
- (float)getAngle;
- (void) setAngle: (float) value;
- (void) setColor:(UIColor *)value;
- (void) rotateClockwise: (float) value;
- (void) rotateCounterClockwise: (float) value;
- (void) update;

@end
