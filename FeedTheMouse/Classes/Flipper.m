//
//  Flipper.m
//  Feed The Mouse Level Editor
//
//  Created by Jason Ly on 2014-04-26.
//  Copyright (c) 2014 Jason Ly. All rights reserved.
//

#import "Flipper.h"

@implementation Flipper

- (id) init
{
    screenWidth = [UIScreen.mainScreen bounds].size.width * [UIScreen.mainScreen scale];
    screenHeight = [UIScreen.mainScreen bounds].size.height * [UIScreen.mainScreen scale];
    self = [super init];
    if (self)
    {
        sprite = [Picture fromFile:@"flipper_blue.png"];
        [self setX:0];
        [self setY:0];
        [self setAngle:0];
        angularAccel = 0;
    }
    return self;
}

- (Flipper*) initializeFlipperAtX:(float) fx andY: (float)fy andAngle: (float)newAngle andColor:(UIColor *)c
{
    screenWidth = [UIScreen.mainScreen bounds].size.width * [UIScreen.mainScreen scale];
    screenHeight = [UIScreen.mainScreen bounds].size.height * [UIScreen.mainScreen scale];
    sx = screenWidth/640.0f;
    sy = screenHeight/1136.0f;
    if (screenWidth == 1242)
    {
        if (c == [UIColor blueColor])
            sprite = [Picture fromFile:@"big/big_flipper_blue.png"];
        else if (c == [UIColor greenColor])
            sprite = [Picture fromFile:@"big/big_flipper_green.png"];
        else if (c == [UIColor magentaColor])
            sprite = [Picture fromFile:@"big/big_flipper_magenta.png"];
        else if (c == [UIColor purpleColor])
            sprite = [Picture fromFile:@"big/big_flipper_purple.png"];
        else if (c == [UIColor yellowColor])
            sprite = [Picture fromFile:@"big/big_flipper_yellow.png"];
        else
            sprite = [Picture fromFile:@"big/big_flipper_orange.png"];
        
    }
    else {
        if (c == [UIColor blueColor])
            sprite = [Picture fromFile:@"flipper_blue_game.png"];
        else if (c == [UIColor greenColor])
            sprite = [Picture fromFile:@"flipper_green_game.png"];
        else if (c == [UIColor magentaColor])
            sprite = [Picture fromFile:@"flipper_magenta_game.png"];
        else if (c == [UIColor purpleColor])
            sprite = [Picture fromFile:@"flipper_purple_game.png"];
        else if (c == [UIColor yellowColor])
            sprite = [Picture fromFile:@"flipper_yellow_game.png"];
        else
            sprite = [Picture fromFile:@"flipper_orange_game.png"];
    }
    if (screenWidth == 1242)
    {
        fx = fx * sx;
        fy = fy * sy;
    }
    [self setX:fx];
    [self setY:fy];
    originalAngle = newAngle;
    if ( angle > 90 && originalAngle < 180)
    {
        limitAngle = newAngle + 30;
    }
    if (newAngle <= 90)
        limitAngle = newAngle - 30;
    else
        limitAngle = newAngle + 30;
    if (limitAngle < 0)
        limitAngle+=360;
    if (limitAngle > 360)
        limitAngle-=360;
    [self setAngle:newAngle];
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

- (UIColor*) getColor
{
    return color;
}

- (float)getAngle
{
    return angle;
}

- (void) setX: (int) value
{
    sprite.x = value;
    x = sprite.x + sprite.width/2;

}

- (void) setY: (int) value
{
    sprite.y = value;
    y = sprite.y + sprite.height/2;
}

- (void) setAngle: (float) value
{
    angle = value;
    sprite.rotation = angle;
}

- (void) setColor: (UIColor*) value
{
    color = value;
}

- (bool) pointIsInside: (CGPoint)pt
{
    if (screenWidth == 1242)
    {
        if (pt.x < (x - sprite->width/2))
            return false;
        if (pt.x > (x + sprite->width/2))
            return false;
        if (pt.y > (y + sprite->width/2))
            return false;
        if (pt.y < (y - sprite->width/2))
            return false;
    }
    else
    {
        if (pt.x < sx*(x - 84))
            return false;
        if (pt.x > sx*(x + 84))
            return false;
        if (pt.y > sy*(y + 84))
            return false;
        if (pt.y < sy*(y - 84))
            return false;
    }
    return true;
}

- (void) draw: (CGContextRef) context
{
    [sprite draw:context];
}

- (void) rotate
{
    float curAngle = angle;
    if (originalAngle > 180 ) {
        if (angle > 0 && angle < 180)
            curAngle = angle + 360;
        if (curAngle >= limitAngle)
        {
            curAngle = limitAngle;
            [self setAngle:curAngle];
        }
        else
        {
            angularAccel+=5;
            angle+=angularAccel;
            [self setAngle:angle];
        }
        
    }
    else if ( originalAngle > 90 && originalAngle < 180)
    {
        if ( angle >= limitAngle)
        {
            angle = limitAngle;
            [self setAngle:angle];
        }
        else if (angle <= limitAngle)
        {
            angularAccel+=5;
            angle+=angularAccel;
            [self setAngle:angle];
        }
    }
    else if (originalAngle <= 90)
    {
        if ( angle <= limitAngle || (angle < 360 && angle > 270))
        {
            angle = limitAngle;
        }
        else
        {
            angularAccel+=5;
            angle-=angularAccel;
        }
        [self setAngle:angle];
    }
}

- (void) unrotate
{
    if (originalAngle < 0)
        originalAngle+=360;
    if (originalAngle > 180 ) {
        if (angle<=originalAngle)
        {
            angularAccel = 0;
            [self setAngle:originalAngle];
            
        }
        else
        {
            if (angularAccel > 1)
                angularAccel-=1;
            else
                angularAccel = 1;
            angle-=angularAccel;
            [self setAngle:angle];
        }
    }
    else if ( originalAngle > 90 && originalAngle < 180)
    {
        if (angle<=originalAngle)
        {
            angularAccel = 0;
            [self setAngle:originalAngle];
            
        }
        else
        {
            if (angularAccel > 1)
                angularAccel-=1;
            else
                angularAccel = 1;
            angle-=angularAccel;
            [self setAngle:angle];
        }
    }
    else
    {
        if (angle>=originalAngle)
        {
            angularAccel = 0;
            [self setAngle:angle];
        }
        else
        {
            if (angularAccel > 1)
                angularAccel-=1;
            else
                angularAccel = 1;
            angle+=angularAccel;
            [self setAngle:angle];
        }
        
    }
}

@end
