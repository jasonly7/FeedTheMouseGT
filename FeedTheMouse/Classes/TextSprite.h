//
//  TextSprite.h
//  FeedTheMouse
//
//  Created by Jason Ly on 2020-11-15.
//  Copyright © 2020 Jason Ly. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import <UIKit/UIKit.h>
#import "Sprite.h"


NS_ASSUME_NONNULL_BEGIN

@interface TextSprite : Sprite
{
    NSString *text;
    NSString *font;
    uint fontSize;
    uint textLength;
    @public
        CGColorRef color;
}

@property (assign) NSString *text;
@property (assign) NSString *font;
@property (assign) uint fontSize;

+ (TextSprite *) withString: (NSString *) label;
- (void) moveUpperLeftTo: (CGPoint) p;
- (void) newText: (NSString *) val;
- (void) drawBody: (CGContextRef) context on:(CGRect) rect;
- (void) computeWidth: (CGContextRef) context on: (CGRect) rect;
@end

NS_ASSUME_NONNULL_END
