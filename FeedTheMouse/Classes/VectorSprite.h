//
//  VectorSprite.h
//  Asteroids
//
//  Created by Jason Ly on 2012-10-20.
//  Copyright (c) 2012 Jason Ly. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "Sprite.h"

@interface VectorSprite : Sprite {
    CGFloat *points;
    int count;
    CGFloat vectorScale;
}

@property (assign) int count;
@property (assign) CGFloat vectorScale;
@property (assign) CGFloat *points;
+ (VectorSprite *) withPoints: (CGFloat *) rawPoints count: (int) count;
- (void) updateSize;
@end
