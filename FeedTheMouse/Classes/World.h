//
//  World.h
//  Feed The Mouse
//
//  Created by Jason Ly on 2014-03-26.
//  Copyright (c) 2014 Jason Ly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CollisionPacket.h"
#import "Level.h"
#import "Cheese.h"
#import "Wall.h"

@class Cheese;

@interface World : NSObject
{
@public
    Level *lvl;
    Cheese *cheese;
    Mouse *mouse;
    NSMutableArray *removedCoins;
    CGFloat sx,sy;
    CGFloat screenScale;
    float screenWidth, screenHeight;
    int score;
}

- (void)checkCollision :( CollisionPacket **) colPackage;
- (void)setLevel :(Level **)level;
- (void)setMouse :(Mouse **)m;
- (void)setCheese :(Cheese **)c;
@end
