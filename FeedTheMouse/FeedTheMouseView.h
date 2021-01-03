//
//  FeedTheMouseView.h
//  FeedTheMouse
//
//  Created by Jason Ly on 2012-10-28.
//  Copyright (c) 2012 Jason Ly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Sprite.h"
#import "AtlasSprite.h"
#import "Picture.h"
#import "Cheese.h"
#import "Mouse.h"
#import "Gear.h"
#import "Drum.h"
#import "Coin.h"
#import "VectorSprite.h"
//#import "Obstacles.h"
#import "XMLParser.h"
#import "Level.h" 
#import "TitleViewController.h"

#import "FinishGameViewController.h"
#import "TitleView.h"
#import "TextSprite.h"
#import "Utility.h"
#import "ChatBubble.h"
//const int MOUSE_HEIGHT = 322;
//const int MOUSE_WIDTH = 256;

@interface FeedTheMouseView : UIView {
    IBOutlet UILabel *fpsLabel;
    
    Sprite *mouseSprite;
    Sprite *backgroundSprite;
    
    Cheese *cheese;
    Mouse *mouse;
    Gear *gear;
    Drum *drum;
    Bomb *bomb;
    TeeterTotter *teeterTotter;
    Flipper *flipper;
    Coin *coin;
    
    NSTimer *timer;

	int direction;
    float t;
    int animationNumber;
    CGContextRef context;

    XMLParser *parser;
    NSMutableArray *coins;
    
    NSMutableArray *gears;
    NSMutableArray *drums;
    NSMutableArray *bombs;
    NSMutableArray *teeterTotters;
    NSMutableArray *flippers;
    NSMutableArray *levels;
    int currentLevelNumber;
    Level *curLevel;

    NSDate * levelStartDate;
    NSDate *lastDate;
    double next_tick;
    double next_game_tick;
    double cur_game_tick;
    double delta_tick;
    double time;
    double sleep_time;
    int frame;
    bool game_is_running;
    int loops;
    float interpolation;
    TitleView *titleView;
    CGFloat sx,sy;
    float screenWidth, screenHeight;
    CGFloat screenScale;
    CGPoint mousePt;
    CGPoint mouseTouchedPoint;
    bool isTouched;
    //FeedTheMouseViewController *feedTheMouseViewController;
    //TitleViewController *titleViewController;
    NSString *pathForMusicFile;
    NSURL *musicFile;
    AVAudioPlayer *musicPlayer;
    NSString *message;
    NSMutableArray *cheeseArrayOfLives;
    ChatBubble *chatBubble;
    @public
        NSString *playerName;
}



- (void) doParse:(NSData *) data;
- (void) gameLoop;
- (void) update_game;
- (void) display_game;
@end
