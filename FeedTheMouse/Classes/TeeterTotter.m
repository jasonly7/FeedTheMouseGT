//
//  TeeterTotter.m
//  Feed The Mouse Level Editor
//
//  Created by Jason Ly on 2014-03-06.
//  Copyright (c) 2014 Jason Ly. All rights reserved.
//

#import "TeeterTotter.h"

@implementation TeeterTotter


+(NSMutableDictionary *) sharedSpriteAtlas
{
    static NSMutableDictionary *sharedSpriteDictionary;
    @synchronized(self)
    {
        if (!sharedSpriteDictionary) {
            sharedSpriteDictionary = [[NSMutableDictionary alloc] init];
            return sharedSpriteDictionary;
        }
    }
    return sharedSpriteDictionary;
}

- (id) init
{
    self = [super init];
    if (self)
    {
        totterSprite = [Picture fromFile:@"teeter_totter.png"];
        angularAcceleration = 3;
        angularVelocity = angularAcceleration;
        [self setX:0];
        [self setY:0];
        //[self setAngle:-45];
        [self setAngle:0];
        time = 0;
        topLine = [[Line alloc] init];
    }
    return self;
}

- (TeeterTotter*) initializeTeeterTotterAtX:(float) tx andY: (float)ty andColor:(id)c
{
    float topLeftX, topLeftY, topRightX, topRightY;
    CGPoint topLeftPt,topRightPt;
    if (c == [UIColor blueColor])
        totterSprite = [Picture fromFile:@"teeter_totter_blue.png"];
    else if (c == [UIColor greenColor])
        totterSprite = [Picture fromFile:@"teeter_totter_green.png"];
    else if (c == [UIColor magentaColor])
        totterSprite = [Picture fromFile:@"teeter_totter_magenta.png"];
    else if (c == [UIColor purpleColor])
        totterSprite = [Picture fromFile:@"teeter_totter_purple.png"];
    else if (c == [UIColor yellowColor])
        totterSprite = [Picture fromFile:@"teeter_totter_yellow.png"];
    else if (c == [UIColor redColor])
        totterSprite = [Picture fromFile:@"teeter_totter_red.png"];
    else if (c == [UIColor orangeColor])
        totterSprite = [Picture fromFile:@"teeter_totter_orange.png"];
    else
        totterSprite = [Picture fromFile:@"teeter_totter.png"];
    [self setX:tx];
    [self setY:ty];
   // [self setAngle:45];
    [self setAngle:0];
    [self setColor:c];
    topLine = [[Line alloc] init];
    double radAngle = angle*M_PI/180.0f;
    topLeftX = x - cos(radAngle)*totterSprite.width/2 + cos(radAngle+M_PI_2)*totterSprite.height/2;
    topLeftY = y - sin(radAngle)*totterSprite.width/2 + sin(radAngle+M_PI_2)*totterSprite.height/2;
    topLeftPt = CGPointMake(0, 0);
    topLeftPt.x = topLeftX;
    topLeftPt.y = topLeftY;
    // get top right of rectangle
    topRightX = x + cos(radAngle)*totterSprite.width/2 + cos(radAngle+M_PI_2)*totterSprite.height/2;
    topRightY = y + sin(radAngle)*totterSprite.width/2 + sin(radAngle+M_PI_2)*totterSprite.height/2;
    topRightPt = CGPointMake(0,0);
    topRightPt.x = topRightX;
    topRightPt.y = topRightY;
    topLine = [topLine initializeLineWithPoint1:topLeftPt andPoint2:topRightPt];
    return self;
}

- (int)getX
{
    return x;
}

- (int)getY
{
    return y;
}

- (void) setX: (int) value
{
    totterSprite.x = value;
    x = totterSprite.x + totterSprite.width/2;
}

- (void) setY: (int) value
{
    totterSprite.y = value;
    y = totterSprite.y + totterSprite.height/2;
}

- (float)getAngle
{
    return angle;
}

- (UIColor*) getColor
{
    return color;
}

- (void) setAngle: (float) value
{
    angle = value;
    totterSprite.rotation = angle;
}

- (void) rotateClockwise: (float) value
{
    angle-=value;
}

- (void) rotateCounterClockwise:(float)value
{
    angle+=value;
}

- (void) update
{
    
}

- (void) setColor:(UIColor *)value
{
    color = value;
}

- (void) draw:(CGContextRef)context
{
    [totterSprite draw:context];
}

- (void) dealloc
{
    [super dealloc];
    [topLine release];
}
@end
