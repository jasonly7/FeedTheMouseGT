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
        angularVelocity = 0;
        [self setX:0];
        [self setY:0];
        [self setAngle:0];
    }
    return self;
}

- (TeeterTotter*) initializeTeeterTotterAtX:(float) tx andY: (float)ty andColor:(id)c
{
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
    else
        totterSprite = [Picture fromFile:@"teeter_totter_orange.png"];
    [self setX:tx];
    [self setY:ty];
    [self setAngle:0];
    [self setColor:c];
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
@end
