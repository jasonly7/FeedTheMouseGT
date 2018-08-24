//
//  Line.h
//  Feed The Mouse
//
//  Created by Jason Ly on 2013-10-09.
//  Copyright (c) 2013 Jason Ly. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import <UIKit/UIkit.h>
#import "Vector.h"

@interface Line : NSObject {
@public
    double dx, dy, m;
    CGPoint p1, p2;

    Vector *normal,*origin;
    
    double lineConstant;
    float length;
}
- (Line*) initializeLineWithVectorOrigin:(Vector*)o andVectorNormal:(Vector*) n;
- (Line*) initializeLineWithPoint1:(CGPoint)pt1 andPoint2:(CGPoint)pt2;
- (Vector*) normal;
- (double) signedDistanceTo:(Vector *) point;
- (bool) isFrontFacingTo:(Vector *) direction;
- (float) getOriginX;
- (float) getOriginY;
- (float) getNormalX;
- (float) getNormalY;
- (void) setNormal: (Vector *) n;
@end
