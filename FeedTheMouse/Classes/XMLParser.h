//
//  XMLParser.h
//  Feed The Mouse
//
//  Created by Jason Ly on 2013-02-02.
//  Copyright (c) 2013 Jason Ly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Gear;
@class Level;
@class Drum;
@class TeeterTotter;
@class Flipper;
@class Mouse;
@class Coin;
@class Bomb;

#define DRUM_WIDTH 200;
#define DRUM_HEIGHT = 37;
#define FLIPPER_HEIGHT = 56;
#define FLIPPER_WIDTH = 168;
#define GEAR_HEIGHT = 174;
#define GEAR_WIDTH = 174;
#define TEETER_TOTTER_HEIGHT = 72;
#define TEETER_TOTTER_WIDTH = 180;
#define COIN_WIDTH 58
#define COIN_HEIGHT 58
@interface XMLParser : NSObject
{
    NSMutableString *currentElementValue;
    NSString *currentElementName;
    NSString *currentObject;
    UIColor *color;
    Coin *coin;
    Gear *gear;
    Drum *drum;
    Bomb *bomb;
    TeeterTotter *teeterTotter;
    Flipper *flipper;
    NSString *backgroundFilename;
    Mouse *mouse;
    Level *level;
    int x, y;
    float angle;
    bool isFlipped;
    int lvlNum;
@public
    NSMutableArray *coins;
    NSMutableArray *gears;
    NSMutableArray *drums;
    NSMutableArray *bombs;
    NSMutableArray *teeterTotters;
    NSMutableArray *flippers;
    NSMutableArray *levels;

}
@property (nonatomic, retain) Bomb *bomb;
@property (nonatomic, retain) Gear *gear;
@property (nonatomic, retain) Drum *drum;
@property (nonatomic, retain) TeeterTotter *teeterTotter;
@property (nonatomic, retain) Mouse *m;
@property (nonatomic, retain) Level *level;
@property (nonatomic, retain) NSMutableArray *gears;
@property (nonatomic, retain) NSMutableArray *levels;

- (XMLParser *) initXMLParser;
@end
