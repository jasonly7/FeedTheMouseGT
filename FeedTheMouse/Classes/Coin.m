//
//  Coin.m
//  Feed The Mouse Level Editor
//
//  Created by Jason Ly on 2015-01-24.
//  Copyright (c) 2015 Jason Ly. All rights reserved.
//

#import "Coin.h"

@implementation Coin

- (id) init
{
    self = [super init];
    if (self)
    {
        coinSprite = [Picture fromFile:@"coin.png"];
        [self setX:0];
        [self setY:0];
        /* coinSprite.x = 0;
         x = coinSprite.x + coinSprite.width/2;
         coinSprite.y = 0;
         y = coinSprite.y + coinSprite.height/2;*/
        r = coinSprite.width/2;
        pos->x = x;
        pos->y = y;
    }
    return self;
}

- (Coin*) initializeCoinAtX:(float)xLocation andY:(float)yLocation
{
    coinSprite = [Picture fromFile:@"coin.png"];
    [self setX:0];
    [self setY:0];
    /* coinSprite.x = 0;
     x = coinSprite.x + coinSprite.width/2;
     coinSprite.y = 0;
     y = coinSprite.y + coinSprite.height/2;*/
    r = coinSprite.width/2;
    [self setX:xLocation];
    [self setY:yLocation];
    pos->x = x;
    pos->y = y;

   
  //  x = xLocation;
   // y = yLocation;
    r = 29;
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

- (void)setX:(int)value
{
    coinSprite.x = value;
    x = value;
}

- (void)setY:(int)value
{
    coinSprite.y = value;
    y = value;
}

- (int)getRadius
{
    return r;
}


- (void) draw:(CGContextRef)context
{
    [coinSprite draw:context];
}

@end
