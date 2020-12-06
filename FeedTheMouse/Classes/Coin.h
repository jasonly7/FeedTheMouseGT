//
//  Coin.h
//  Feed The Mouse Level Editor
//
//  Created by Jason Ly on 2015-01-24.
//  Copyright (c) 2015 Jason Ly. All rights reserved.
//
#import "Circle.h"
#import "Picture.h"

#define COIN_FRAMES 16

@interface Coin : Circle
{
    @public
        Sprite *coinSprite;
        
        float lifespan;

}

- (void) initializeCoinAtX:(float) xLocation andY: (float)yLocation;
- (int)getX;
- (int)getY;
- (int)getRadius;
- (void) setX: (int) value;
- (void) setY: (int) value;
- (void) draw: (CGContextRef) context;
@end

