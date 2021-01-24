//
//  Picture.h
//  Feed The Mouse
//
//  Created by Jason Ly on 2012-11-23.
//  Copyright (c) 2012 Jason Ly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIkit.h>
#import <Accelerate/Accelerate.h>
#import "Sprite.h"

@interface Picture : Sprite {
   
    
@public
    CGLayerRef layerReference;
    CGContextRef *contextReference;
    CGContextRef layerContext;
    CGImageRef image;       // a Quartz reference to the image
    CGRect clipRect;        // a clip rectangle
    UIImage *picture;

}

@property (retain, nonatomic) UIImage *picture;
@property (assign) CGImageRef image;

+ (Picture *) fromFile: (NSString *) fname;
//+ (CGImageRef *) fromImageFile: (NSString *) fname;
+ (NSMutableDictionary *) sharedSpriteAtlas;
+ (UIImage *) getPictureImage: (NSString *) name;
- (void) draw: (CGContextRef) context resizeTo: (CGSize) scale;
@end
