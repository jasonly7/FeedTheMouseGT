//
//  Gear.h
//  Feed The Mouse
//
//  Created by Jason Ly on 2012-12-24.
//  Copyright (c) 2012 Jason Ly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Picture.h"
#import "Circle.h"



@interface Gear : Circle
{
    UIColor *color;
    bool isRotatingItselfClockwise;
    float screenWidth;
    float screenHeight;
    @public
        Sprite *gearSprite;
        float rotateAngle;
        CGFloat sx,sy;
}

- (NSString*) getStringColor;
- (void) initializeGearWithX :(int)gx andY:(int) gy andColor:(UIColor*)c;
- (void) draw: (CGContextRef) context;
- (bool) isRotatingClockwise;
- (void) rotateClockWise;
- (void) rotateCounterClockWise;
- (void) setX: (int) x;
- (void) setY: (int) y;
- (void) setColor: (UIColor*) value;
- (int) getX;
- (int) getY;
- (UIColor*) getColor;
- (bool) pointIsInside: (CGPoint)pt;
@end
