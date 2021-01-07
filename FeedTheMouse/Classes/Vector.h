//
//  Vector.h
//  Feed The Mouse
//
//  Created by Jason Ly on 2012-12-28.
//  Copyright (c) 2012 Jason Ly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Vector : NSObject
{
@public
    double x,y;
    float length;
}

- (void)initializeVectorX : (double) floatX andY : (double) floatY;
- (Vector*) add:(Vector*) v;
- (Vector*) subtract:(Vector*) v;
- (Vector*) multiply:(float) scale;
- (double) length;
- (void) normalize;
- (double) dotProduct: (Vector*) v;
- (void) setLength:(float) length;
- (void) setVector:(Vector*)v;
- (Vector*) project: (Vector*) b onto: (Vector*)a;
- (float) getAngle;
- (float) crossProduct: (Vector*) v;
@end
