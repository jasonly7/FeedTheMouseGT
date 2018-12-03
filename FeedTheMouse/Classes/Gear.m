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
    if (c == [UIColor blueColor])
        gearSprite = [Picture fromFile:@"gear_blue.png"];
    else if (c == [UIColor greenColor])
        gearSprite = [Picture fromFile:@"gear_green.png"];
    else if (c == [UIColor magentaColor])
        gearSprite = [Picture fromFile:@"gear_magenta.png"];
    else if (c == [UIColor purpleColor])
        gearSprite = [Picture fromFile:@"gear_purple.png"];
    //else if (c == [UIColor yellowColor])
       // gearSprite = [Picture fromFile:@"gear_yellow.png"];
    else
        gearSprite = [Picture fromFile:@"gear_orange.png"];
    [self setX:gx];
    [self setY:gy];
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
    else if (color == [UIColor magentaColor])
        return @"magenta";
    else if (color == [UIColor purpleColor])
        return @"purple";
    else if (color == [UIColor yellowColor])
        return @"yellow";
    else
        return @"orange";
}

- (void) rotate
{
    
    rotateAngle+=0.015;
    gearSprite.rotation=rotateAngle;
}


- (void) draw:(CGContextRef)context
{
    [gearSprite draw:context];
}

- (void) dealloc
{
 //   [gearSprite release];
    [super dealloc];
}
@end
