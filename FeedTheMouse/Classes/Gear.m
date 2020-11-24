//
//  Gear.m
//  Feed The Mouse
//
//  Created by Jason Ly on 2012-12-24.
//  Copyright (c) 2012 Jason Ly. All rights reserved.
//

#import "Gear.h"

@implementation Gear


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
    screenWidth = [UIScreen.mainScreen bounds].size.width * [UIScreen.mainScreen scale];
    screenHeight = [UIScreen.mainScreen bounds].size.height * [UIScreen.mainScreen scale];
    self = [super init];
    if (self)
    {
        gearSprite = [Picture fromFile:@"gear_blue.png"];
        [self setX:0];
        [self setY:0];
       /* gearSprite.x = 0;
        x = gearSprite.x + gearSprite.width/2;
        gearSprite.y = 0;
        y = gearSprite.y + gearSprite.height/2;*/
        r = gearSprite.width/2;
        pos->x = x;
        pos->y = y;
        rotateAngle = 0;
    }
    return self;
}

- (void) initializeGearWithX :(int)gx andY:(int) gy andColor:(UIColor *)c
{
    //screenWidth = [UIScreen.mainScreen bounds].size.width * [UIScreen.mainScreen scale];
    //screenHeight = [UIScreen.mainScreen bounds].size.height * [UIScreen.mainScreen scale];
    float sx = screenWidth/640.0f;
    float sy = screenHeight/1136.0f;
    if (screenWidth == 1242)
    {
        if (c == [UIColor blueColor])
            gearSprite = [Picture fromFile:@"big_gear_blue.png"];
        else if (c == [UIColor redColor])
            gearSprite = [Picture fromFile:@"big_gear_red.png"];
        else if (c == [UIColor purpleColor])
            gearSprite = [Picture fromFile:@"big_gear_purple.png"];
        else
            gearSprite = [Picture fromFile:@"big_gear_orange.png"];
    }
    else
    {
        if (c == [UIColor blueColor])
            gearSprite = [Picture fromFile:@"gear_blue.png"];
        else if (c == [UIColor redColor])
            gearSprite = [Picture fromFile:@"gear_red.png"];
        else if (c == [UIColor purpleColor])
            gearSprite = [Picture fromFile:@"gear_purple.png"];
        else
            gearSprite = [Picture fromFile:@"gear_orange.png"];
    }
    if (screenWidth == 1242)
    {
        gx = gx * sx;
        gy = gy * sy;
    }
    [self setX:gx];
    [self setY:gy];
     r = gearSprite.width/2;
    [self setColor:c];
}

- (int) getX
{
    return x;
}

- (int) getY
{
    return y;
}

- (UIColor*) getColor
{
    return color;
}

- (void) setX: (int) value;
{
    gearSprite.x = value;
    x = gearSprite.x + gearSprite.width/2;
   // printf("gearSprite's x is %f\n",gearSprite.x);
    pos->x = x;
}

- (void) setY: (int) value
{
    gearSprite.y = value;
    y = gearSprite.y + gearSprite.height/2;
   // printf("gearSprite's y is %f\n",gearSprite.y);
    pos->y = y;
}

- (void) setColor: (UIColor*) value
{
    color = value;
}

- (NSString*) getStringColor
{
    if (color == [UIColor blueColor])
        return @"blue";
    else if (color == [UIColor greenColor])
        return @"green";
    else if (color == [UIColor redColor])
        return @"red";
    else if (color == [UIColor purpleColor])
        return @"purple";
    else if (color == [UIColor yellowColor])
        return @"yellow";
    else
        return @"orange";
}

- (void) rotateClockWise
{
    rotateAngle-=0.1;
    gearSprite.rotation=rotateAngle;
    isRotatingItselfClockwise = true;
}

- (void) rotateCounterClockWise
{
    rotateAngle+=0.1;
    gearSprite.rotation=rotateAngle;
    isRotatingItselfClockwise = false;
}

- (void) draw:(CGContextRef)context
{
    [gearSprite draw:context];
}

- (bool) pointIsInside: (CGPoint)pt
{
    float dist = 0;
    if (screenWidth == 1242)
        dist = (pt.x - x) * (pt.x - x) + (pt.y - y) * (pt.y - y);// sqrt((pt.x - x) * (pt.x - x) + (pt.y - y) * (pt.y - y));
    else
        dist = (pt.x - sx*x) * (pt.x - sx*x) + (pt.y - sy*y) * (pt.y - sy*y);//sqrt((pt.x - sx*x) * (pt.x - sx*x) + (pt.y - sy*y) * (pt.y - sy*y));
    if ( dist < (r*r))
        return true;
    return false;
}

- (void) dealloc
{
 //   [gearSprite release];
    [super dealloc];
}
- (bool)isRotatingClockwise {
    return isRotatingItselfClockwise;
}

@end
