//
//  Level.h
//  Feed The Mouse Level Editor
//
//  Created by Jason Ly on 2013-03-24.
//  Copyright (c) 2013 Jason Ly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Gear.h"
#import "Drum.h"
#import "TeeterTotter.h"
#import "Flipper.h"
#import "Coin.h"
#import "Mouse.h"
#import "Bomb.h"

@interface Level : NSObject
{
@public
    int num;
    NSMutableArray *gears;
    NSMutableArray *drums;
    NSMutableArray *bombs;
    NSMutableArray *teeterTotters;
    NSMutableArray *flippers;
    NSMutableArray *coins;
    Mouse *mouse;
    NSString *backgroundFilename;
}

-(void) initializeLevel:(int) num;
-(void) addCoin:(Coin*) c;
-(void) addGear:(Gear*) g;
-(void) addDrum:(Drum*) d;
-(void) addBomb:(Bomb*) b;
-(void) addTeeterTotter:(TeeterTotter*)t;
-(void) addFlipper:(Flipper*)f;
-(NSMutableArray*) getCoins;
-(NSMutableArray*) getGears;
-(NSMutableArray*) getDrums;
-(NSMutableArray*) getBombs;
-(NSMutableArray*) getTeeterTotters;
-(NSMutableArray*) getFlippers;
-(void) setMouse:(Mouse *)m;
@end
