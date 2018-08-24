//
//  Sprite.m
//  Asteroids
//
//  Created by Jason Ly on 2012-10-13.
//  Copyright (c) 2012 Jason Ly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Sprite.h"

#define kScreenWidth 320
#define kScreenHeight 480
#define kFPS 60.0

@implementation Sprite
@synthesize x,y,speed,angle,width,height,scale, frame, box, rotation, wrap, render;
@synthesize r,g,b,alpha,offScreen;

- (id) init
{
    self = [super init];
    if (self) {
        wrap = NO;
        x = y = 0.0;
        width = height = 1.0;
        scale = 1.0;
        speed = 0.0;
        angle = 0.0;
        rotation = 0;
        cosTheta = 1.0;
        sinTheta = 0.0;
        r = 1.0;
        g = 1.0;
        b = 1.0;
        alpha = 1.0;
        offScreen = NO;
        box = CGRectMake(0,0,0,0);
        frame = 0;
        render = YES;
    }
    return self;
}

- (void) setRotation:(CGFloat)degrees
{
    rotation = degrees * 3.141592/180.0;
}

- (CGFloat) rotation
{
    return rotation * 180.0/3.141592;
}

- (void)setAngle: (CGFloat) degrees
{
    rotation = degrees * 3.141592/180.0;
    cosTheta = cos(rotation);
    sinTheta = sin(rotation);
}

- (CGFloat) angle
{
    return rotation*180.0/3.141592;
}

- (void) outlinePath: (CGContextRef) context
{
    // By default, just draw our box outline, assuming our center is at (0,0)
    
    CGFloat w2 = box.size.width*0.5;
    CGFloat h2 = box.size.height*0.5;
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, -w2, h2);
    CGContextAddLineToPoint(context, w2, h2);
    CGContextAddLineToPoint(context, w2, -h2);
    CGContextAddLineToPoint(context, -w2, -h2);
    CGContextAddLineToPoint(context, -w2, h2);
    CGContextClosePath(context);
}

- (void) drawBody: (CGContextRef) context 
{
    CGContextSetRGBFillColor(context, r, g, b, alpha);
    [self outlinePath: (context)];
    CGContextDrawPath(context, kCGPathFill);
}

- (void) draw: (CGContextRef) context at:(CGPoint)pt
{
    CGContextSaveGState(context);
    
    // Position the sprite
    CGAffineTransform t = CGAffineTransformIdentity;
    //t = CGAffineTransformTranslate(t,x,y);
    //t = CGAffineTransformRotate(t, rotation);
    //t = CGAffineTransformScale(t, scale, scale);
    
    //t = CGAffineTransformTranslate(t,y,480-x);
    //t = CGAffineTransformRotate(t,rotation - 3.141592*0.5);
    //t = CGAffineTransformScale(t,scale,scale);
    
    // origin at center
    x = pt.x;
    y = pt.y;
    t = CGAffineTransformTranslate(t, pt.x, pt.y);
   // t = CGAffineTransformRotate(t,rotation - 3.141592*0.5);
   // t = CGAffineTransformScale(t,scale,scale);
    CGContextConcatCTM(context,t);
    
    // Draw our body
    [self drawBody:context];
    
    CGContextRestoreGState(context);
}

- (void) draw: (CGContextRef) context 
{
    CGContextSaveGState(context);
    
    // Position the sprite
    CGAffineTransform t = CGAffineTransformIdentity;
       
    // origin at center
    t = CGAffineTransformTranslate(t, x, y);

    CGContextConcatCTM(context,t);
    
    // Draw our body
    [self drawBody:context];
    
    CGContextRestoreGState(context);
}

/*
- (void) updateBox
{
	CGFloat w = width*scale;
	CGFloat h = height*scale;
	CGFloat w2 = w*0.5;
	CGFloat h2 = h*0.5;
	CGPoint origin = box.origin;
	CGSize bsize = box.size;
	CGFloat left = -480*0.5;
	CGFloat right = -left;
	CGFloat top = 320*0.5;
	CGFloat bottom = -top;
	
	offScreen = NO;
	if (wrap) {
		if ((x+w2) < left) x = right + w2;
		else if ((x-w2) > right) x = left - w2;
		else if ((y+h2) < bottom) y = top + h2;
		else if ((y-h2) > top) y = bottom - h2;
	}
	else {
		offScreen =
		((x+w2) < left) ||
		((x-w2) > right) ||
		((y+h2) < bottom) ||
		((y-h2) > top);
	}
    
	origin.x = x-w2*scale;
	origin.y = y-h2*scale;
	bsize.width = w;
	bsize.height = h;
	box.origin = origin;
	box.size = bsize;
}*/

/*- (void) tic: (NSTimeInterval) dt
{
    if (!render) return;
    
    CGFloat sdt = speed*dt;
    x += sdt*cosTheta;
    y += sdt*sinTheta;
//    if (sdt)
        [self updateBox];
}*/

- (void) gradientFill: (CGContextRef) myContext
{
	CGGradientRef myGradient;
	CGColorSpaceRef myColorspace;
    
	CGPoint myStartPoint, myEndPoint;
	CGFloat myStartRadius, myEndRadius;
	
	CGFloat w2 = box.size.width*0.5;
	CGFloat h2 = box.size.height*0.5;
	myStartPoint.x = 0;
	myStartPoint.y = 0;
	myEndPoint.x = 0;
	myEndPoint.y = 0;
	myStartRadius = 0.0;
	myEndRadius = (w2 > h2) ? w2*1.5 : h2*1.5;
	size_t num_locations = 2;
	CGFloat locations[2] = { 0, 1.0 };
	CGFloat components[8] = {
		r,g,b, 1.0,
		r,g,b, 0.1,
	};
	myColorspace = CGColorSpaceCreateDeviceRGB();
	myGradient = CGGradientCreateWithColorComponents (myColorspace, components,
													  locations, num_locations);
	CGContextDrawRadialGradient (myContext, myGradient, myStartPoint,
								 myStartRadius, myEndPoint, myEndRadius,
								 kCGGradientDrawsAfterEndLocation);
}

- (NSString *)getFileName
{
    return filename;
}
@end
