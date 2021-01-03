//
//  Picture.m
//  Feed The Mouse
//
//  Created by Jason Ly on 2012-11-23.
//  Copyright (c) 2012 Jason Ly. All rights reserved.
//

#import "Picture.h"


@implementation Picture
@synthesize image, picture;



+(NSMutableDictionary *) sharedSpriteAtlas
{
    static NSMutableDictionary *sharedSpriteDictionary;
    @synchronized(self)
    {
        if (!sharedSpriteDictionary) {
            sharedSpriteDictionary = [[NSMutableDictionary alloc] init];
            return sharedSpriteDictionary;
        }
    }
    return sharedSpriteDictionary;
}

+ (UIImage *) getPictureImage:(NSString *)name
{
    NSMutableDictionary *d = [Picture sharedSpriteAtlas];
    UIImage *img = [d objectForKey:name];
    if (!img) {
        img = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:nil]];
        [d setObject: img forKey:name];
    }
    return img;
}

+ (Picture *) fromFile: (NSString *)fname
{
    Picture *pic = [[Picture alloc] init];
    pic->picture = [[Picture getPictureImage:fname] retain];
    CGImageRef img = [pic->picture CGImage];
    pic->image = img;
    pic->width = CGImageGetWidth(pic->image);
    pic->height = CGImageGetHeight(pic->image);
    pic->box = CGRectMake(0, 0, pic->width, pic->height);
    pic->filename = fname;
    pic->clipRect = pic->box;
    
    return pic;
}

- (void) drawBody: (CGContextRef) context //onLayer: (CALayer *) layer
{
    CGContextSaveGState(context);
    // clip our image from the atlas
    CGContextBeginPath(context);
    CGContextAddRect(context, clipRect);
    
    CGContextClip(context);

    if (layerReference==nil)
    {
        layerReference = CGLayerCreateWithContext(context, box.size, NULL);

        layerContext = CGLayerGetContext(layerReference);
        CGContextSetInterpolationQuality(context, kCGInterpolationNone);
        CGContextDrawImage(layerContext, box, image);
    }
    CGContextDrawLayerAtPoint(context, CGPointZero, layerReference);
    CGContextRestoreGState(context);
}

- (void) draw: (CGContextRef) context at:(CGPoint)pt
{
    CGContextSaveGState(context);
    
    // Position the sprite
    CGAffineTransform t = CGAffineTransformIdentity;

    
    // origin at center    
    t = CGAffineTransformTranslate(t, pt.x, pt.y);

    CGContextConcatCTM(context,t);
    
    // Draw our body
    [self drawBody:context];
    
    CGContextRestoreGState(context);
}

- (void) draw: (CGContextRef) context 
{
    CGContextSaveGState(context);
    
    // Position the sprite
    CGAffineTransform t = CGAffineTransformIdentity;
    

    // origin at center
    t = CGAffineTransformTranslate(t, x, y);
    
    CGContextConcatCTM(context,t);
    
    // Draw our body
    [self drawBody:context];
    
    CGContextRestoreGState(context);
}

- (void) draw: (CGContextRef) context resizeTo: (CGSize) scale
{
    CGContextSaveGState(context);
    
    // Position the sprite
    CGAffineTransform t = CGAffineTransformIdentity;
    t= CGAffineTransformScale(t, scale.width, scale.height);

    // origin at center
    t = CGAffineTransformTranslate(t, x/scale.width, y/scale.height);
    
    CGContextConcatCTM(context,t);
    
    // Draw our body
    [self drawBody:context];
    
    CGContextRestoreGState(context);
}

- (void) dealloc
{
    [picture release];
    CGImageRelease(image);
    [super dealloc];
}
@end
