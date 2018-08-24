//
//  Line.m
//  Feed The Mouse
//
//  Created by Jason Ly on 2013-10-09.
//  Copyright (c) 2013 Jason Ly. All rights reserved.
//

#import "Line.h"

@implementation Line

- (id) init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

- (Line*) initializeLineWithPoint1:(CGPoint)pt1 andPoint2:(CGPoint)pt2
{
    p1 = pt1;
    p2 = pt2;
    dx = p2.x - p1.x;
    dy = p2.y - p1.y;
    m = dy/dx;
    normal = [self normal];
    [normal normalize];
    origin = [[Vector alloc] init];
    [origin initializeVectorX:pt1.x andY:pt1.y];
    lineConstant = - [normal dotProduct:origin];
    length = sqrt(dx*dx +dy*dy);
    return self;
}

- (Line*) initializeLineWithVectorOrigin:(Vector*)o andVectorNormal:(Vector*) n
{
    normal = [[Vector alloc] init];
    normal = n;
    normal->length = [normal length];
    origin = [[Vector alloc] init];
    origin = o;
   // [normal normalize];

    lineConstant = - [normal dotProduct:origin];

    return self;
}

- (bool) isFrontFacingTo:(Vector *) direction
{
    double dot = [normal dotProduct:direction];
    return (dot<=0);
}

- (Vector*) normal
{
    Vector *n = [[Vector alloc] init];
    [n initializeVectorX:dy andY:-dx];
    [n normalize];
    return n;
}

- (void) setNormal: (Vector *) n
{
    normal = [[Vector alloc] init];
    [normal initializeVectorX:0.0f andY:0.0f];
    normal = n;
    normal->length = [normal length];
}

- (double) signedDistanceTo:(Vector *) point
{
    
    //lineConstant = - [normal dotProduct:origin];
    return [point dotProduct:normal]+lineConstant;
}

- (float) getOriginX
{
    return origin->x;
}

- (float) getOriginY
{
    return origin->y;
}

- (float) getNormalX
{
    return normal->x;
}

- (float) getNormalY
{
    return normal->y;
}

@end
