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
        coinSprite = [[AtlasSprite alloc] init];//[Picture fromFile:@"coin.png"];
        [self setX:0];
        [self setY:0];
        /* coinSprite.x = 0;
         x = coinSprite.x + coinSprite.width/2;
         coinSprite.y = 0;
         y = coinSprite.y + coinSprite.height/2;*/
        r = coinSprite.width/2;
        pos->x = x;
        pos->y = y;
        lifespan = 2;
    }
    return self;
}


- (void) setIconX: (int) xLocation andY: (int) yLocation
{
    float screenWidth = [UIScreen.mainScreen bounds].size.width * [UIScreen.mainScreen scale];
    float screenHeight = [UIScreen.mainScreen bounds].size.height * [UIScreen.mainScreen scale];
    float sx = screenWidth/640.0f;
    float sy = screenHeight/1136.0f;
    if (screenWidth == 1242)
    {
        xLocation = xLocation * sx;
        yLocation = yLocation * sy;
    }
    [self setX:xLocation];
    [self setY:yLocation];
}

- (void) initializeCoinAtX:(float)xLocation andY:(float)yLocation andImage:(NSString*) file
{
    float screenWidth = [UIScreen.mainScreen bounds].size.width * [UIScreen.mainScreen scale];
    float screenHeight = [UIScreen.mainScreen bounds].size.height * [UIScreen.mainScreen scale];
    float sx = screenWidth/640.0f;
    float sy = screenHeight/1136.0f;
    
    [coinSprite fromFile:file withRows:1 withColumns:16];
        //coinSprite = [Picture fromFile:@"coin.png"];
    
        
    [self setX:0];
    [self setY:0];
    /* coinSprite.x = 0;
     x = coinSprite.x + coinSprite.width/2;
     coinSprite.y = 0;
     y = coinSprite.y + coinSprite.height/2;*/
    r = coinSprite.width/2;
    if (screenWidth == 1242)
    {
        xLocation = xLocation * sx;
        yLocation = yLocation * sy;
    }
    [self setX:xLocation];
    [self setY:yLocation];
    //pos->x = x;
    //pos->y = y;
    
    
  //  x = xLocation;
   // y = yLocation;
   // r = 29;
  //  return self;
}

- (void) initializeCoinAtX:(float)xLocation andY:(float)yLocation
{
    float screenWidth = [UIScreen.mainScreen bounds].size.width * [UIScreen.mainScreen scale];
    float screenHeight = [UIScreen.mainScreen bounds].size.height * [UIScreen.mainScreen scale];
    float sx = screenWidth/640.0f;
    float sy = screenHeight/1136.0f;
    if (screenWidth == 1242)
    {
        //coinSprite = [Picture fromFile:@"bigCoin.png"];
        [coinSprite fromFile:@"large_coins/largecoin.png" withRows:1 withColumns:16];
    }
    else
    {
        [coinSprite fromFile:@"mediumlargecoins.png" withRows:1 withColumns:16];
        //coinSprite = [Picture fromFile:@"coin.png"];
    }
        
    [self setX:0];
    [self setY:0];
    /* coinSprite.x = 0;
     x = coinSprite.x + coinSprite.width/2;
     coinSprite.y = 0;
     y = coinSprite.y + coinSprite.height/2;*/
    r = coinSprite.width/2;
    if (screenWidth == 1242)
    {
        xLocation = xLocation * sx;
        yLocation = yLocation * sy;
    }
    [self setX:xLocation];
    [self setY:yLocation];
    //pos->x = x;
    //pos->y = y;
    
    
  //  x = xLocation;
   // y = yLocation;
   // r = 29;
  //  return self;
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
    x = coinSprite.x + coinSprite.width/2;
    pos->x = x;
}

- (void)setY:(int)value
{
    coinSprite.y = value;
    y = coinSprite.y + coinSprite.height/2;
    pos->y = y;
}

- (int)getRadius
{
    return r;
}


- (void) draw:(CGContextRef)context
{
    [coinSprite setRotation:90];
    [coinSprite draw:context];
}

- (void) update
{
    float screenWidth = [UIScreen.mainScreen bounds].size.width * [UIScreen.mainScreen scale];
    int lastframe = COIN_FRAMES-1;
    steps = COIN_FRAMES;
    coinSprite.frame = (coinSprite.frame+1)%steps;    
}

@end
