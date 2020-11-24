//
//  Flipper.h
//  Feed The Mouse Level Editor
//
//  Created by Jason Ly on 2014-04-26.
//  Copyright (c) 2014 Jason Ly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Picture.h"


@interface Flipper : NSObject
{
    UIColor *color;
    float screenWidth; 
    float screenHeight;
@public
    int x,y;
    float angle;
    float originalAngle;
    float limitAngle;
    Sprite *sprite;
    bool isImgFlipped;
    CGFloat sx, sy;
    int angularAccel;
}

- (Flipper*) initializeFlipperAtX:(float) fx andY: (float)fy andAngle: (float)newAngle andColor: (UIColor*)c;
- (int)getX;
- (int)getY;
- (float)getAngle;
- (UIColor*) getColor;
- (void) setX: (int) value;
- (void) setY: (int) value;
- (void) setAngle: (float) value;
- (void) setColor: (UIColor*) value;
- (bool) pointIsInside: (CGPoint)pt;
- (void) draw: (CGContextRef) context;
- (void) rotate;
- (void) unrotate;
@end
