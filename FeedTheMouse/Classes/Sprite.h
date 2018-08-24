//
//  Sprite.h
//  Asteroids
//
//  Created by Jason Ly on 2012-10-13.
//  Copyright (c) 2012 Jason Ly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>
@interface Sprite : NSObject
{
    CGFloat r;                  // red tint
    CGFloat g;                  // green tint
    CGFloat b;                  // blue tint
    CGFloat alpha;              // alpha value, for transparency
    CGFloat speed;              // speed of movement in pixels/frame
    CGFloat angle;              // angle of movement in degrees
    CGFloat rotation;           // rotation of our sprite in degrees, about the center
 
    CGFloat scale;              // uniform scaling factor for size
    int frame;                  // current frame for animation
    
    CGFloat cosTheta;           // precomputed for speed
    CGFloat sinTheta;
    
    
    BOOL render;                // true when we're rendering
    BOOL offScreen;             // true when we're off the screeen
    BOOL wrap;                  // true if you want the motion to wrap on the screen
    
    NSString *filename;
    @public
    CGFloat x;                  // x location
    CGFloat y;                  // y location
    CGFloat width;              // width of sprite in pixels
    CGFloat height;             // height of sprite in pixels
    CGRect box;                 // our bounding box
    
    NSTimer *timer;
}

@property (assign) BOOL wrap, render, offScreen;
@property (assign) CGFloat x, y, r, g, b, alpha;
@property (assign) CGFloat speed, angle, rotation;
@property (assign) CGFloat width, height, scale;
@property (assign) CGRect box;
@property (assign) int frame;

- (void) draw: (CGContextRef) context at:(CGPoint) pt;
- (void) draw: (CGContextRef) context;
//- (void) updateBox;
- (void) gradientFill: (CGContextRef) myContext;
- (NSString*) getFileName;
//- (void) tic: (NSTimeInterval) dt;
@end
