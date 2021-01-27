//
//  AtlasSprite.h
//  Asteroids
//
//  Created by Jason Ly on 2012-10-21.
//  Copyright (c) 2012 Jason Ly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Sprite.h"

@interface AtlasSprite : Sprite {
    CGFloat w2;             // half width, for caching
    CGFloat h2;             // half height, for caching
    CGFloat atlasWidth;     // width of the whole spritesheet
    CGFloat atlasHeight;
    UIImage *atlas;         // atlas containing all images of this sprite
    
    CGRect clipRect;        // a clip rectangle
    int rows;               // how many rows are in the atlas
    int columns;            // how many columns are in the atlas
    @public
        CGImageRef image;       // a Quartz reference to the image
}

@property (assign) CGFloat w2, h2, atlasWidth, atlasHeight;
@property (assign) CGRect clipRect;
@property (assign) int rows, columns;
@property (retain, nonatomic) UIImage *atlas;
@property (assign) CGImageRef image;

+ (AtlasSprite *) fromFile: (NSString *) fname withRows: (int) rows withColumns: (int) columns;
- (void) fromFile: (NSString *) fname withRows: (int) rws withColumns: (int) cols;
+ (NSMutableDictionary *) sharedSpriteAtlas;
+ (UIImage *) getSpriteAtlas: (NSString *) name;

@end
