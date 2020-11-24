//
//  Level.m
//  Feed The Mouse Level Editor
//
//  Created by Jason Ly on 2013-03-24.
//  Copyright (c) 2013 Jason Ly. All rights reserved.
//

#import "Level.h"

@implementation Level
- (void) initializeLevel:(int) number
{
    num = number;
    coins = [[NSMutableArray alloc] initWithCapacity:10];
    gears = [[NSMutableArray alloc] initWithCapacity:10];
    bombs = [[NSMutableArray alloc] initWithCapacity:10];
    drums = [[NSMutableArray alloc] initWithCapacity:10];
    teeterTotters = [[NSMutableArray alloc] initWithCapacity:10];
    flippers = [[NSMutableArray alloc] initWithCapacity:10];
    mouse = [[Mouse alloc] init];
    [mouse initializeMouseAtX:500 andY:150];
    backgroundFilename = [[NSString alloc] init];
}

-(void) setMouse:(Mouse *)m
{
    mouse = m;
}

-(void) addCoin:(Coin*) c
{
    [coins addObject:c];
}

-(void) addGear:(Gear*) g
{
    [gears addObject:g];
}

-(void) addDrum:(Drum*) d
{
    [drums addObject:d];
}

-(void) addBomb:(Bomb*) b
{
    [bombs addObject:b];
}

-(void) addTeeterTotter:(TeeterTotter *)t
{
    [teeterTotters addObject:t];
}

-(void) addFlipper:(Flipper *)f
{
    [flippers addObject:f];
}
-(NSMutableArray*) getBombs
{
    return bombs;
}
-(NSMutableArray*) getCoins
{
    return coins;
}

-(NSMutableArray*) getGears
{
    return gears;
}

-(NSMutableArray*) getDrums
{
    return drums;
}

-(NSMutableArray*) getTeeterTotters
{
    return teeterTotters;
}

-(NSMutableArray*) getFlippers
{
    return flippers;
}

@end
