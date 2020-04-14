//
//  Circle.h
//  Feed The Mouse
//
//  Created by Jason Ly on 2012-12-24.
//  Copyright (c) 2012 Jason Ly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sprite.h"
#import "Vector.h"
#import "Drum.h"
#import "Line.h"

@interface Circle : NSObject
{
@public
    int x,y;
    Vector *pos;
    float r; // radius
    float angularDisplacement;
    float angularVelocity;
    float angularAcceleration;
}

- (void) initializeWithX: (int) x andY: (int)y andRadius: (float)r;
- (bool) collideWithCircle : (Circle *) circle;
- (bool) collideWithSprite :(Sprite *)sprite;
- (bool) collideWithRectangle: (CGRect ) rect andAngle: (float) angle;
- (bool) collideWithLine: (Line *) line andSpeed: (double) speed andRoot:(NSNumber**) root;

@end
