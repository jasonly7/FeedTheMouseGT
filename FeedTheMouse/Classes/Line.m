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
    [n initializeVectorX:-dy andY:dx];
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
    double d = [point dotProduct:normal]+lineConstant;
    if (d < 0)
        d = -d;
    d = d / [normal length];
    return d;
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
- (bool) intersect: (Line *) line andRoot:(NSNumber **)root// andIntersection:(Vector *)point
{
    Vector *s1 = [[Vector alloc] init];
    Vector *s2 = [[Vector alloc] init];
    [s1 initializeVectorX:(p2.x - p1.x) andY: (p2.y -p1.y)];
    [s2 initializeVectorX:(line->p2.x - line->p1.x) andY: (line->p2.y - line->p1.y)];
    
    double s = (-s1->y * (p1.x - line->p1.x) + s1->x * (p1.y - line->p1.y)) / ( -s2->x*s1->y + s1->x * s2->y);
    double t = (s2->x * (p1.y - line->p1.y) - s2->y * (p1.x - line->p1.x)) / ( -s2->x*s1->y + s1->x * s2->y);
    if (s >=0 && s <= 1 && t >= 0 && t <= 1)
    {
     /*  Vector *v = [[Vector alloc] init];
       [v initializeVectorX:(p1.x + t*s1->y)*34 andY:(p1.y + t*s1->y)*34];
       *point = v;*/
        double x = (p1.x + t*s1->y);
        double y = (p1.y + t*s1->y);
      //  [point initializeVectorX: x andY: y];
      //  point.x = p1.x + t*s1->x;
     //   point->y = p1.y + t*s1->y;
        *root = [NSNumber numberWithDouble:s];
        return true;
    }
    return false;
}

@end
