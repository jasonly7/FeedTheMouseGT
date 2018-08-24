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
    @public
        Sprite *gearSprite;
        float rotateAngle;
}

- (NSString*) getStringColor;
- (void) initializeGearWithX :(int)gx andY:(int) gy andColor:(UIColor*)c;
- (void) draw: (CGContextRef) context;
- (void) rotate;
- (void) setX: (int) x;
- (void) setY: (int) y;
- (void) setColor: (UIColor*) value;
- (int) getX;
- (int) getY;
- (UIColor*) getColor;
@end
