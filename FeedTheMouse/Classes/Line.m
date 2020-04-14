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

- (bool) collideWithPtX: (int) x andY: (int) y
{
    Line *line1 = [[Line alloc] init];
    CGPoint pt = CGPointMake(x, y);
    [line1 initializeLineWithPoint1:p1 andPoint2:pt];
    double d1 = line1->length;
    Line *line2 = [[Line alloc] init];
    
    [line2 initializeLineWithPoint1:p2 andPoint2:pt];
    double d2 = line2->length;
    
    double buffer = 0.1;
    if (d1+d2 >= length-buffer && d1+d2 <= length+buffer)
    {
        return true;
    }
    return false;
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
    /*Vector *U = [[Vector alloc] init];
    Vector *V = [[Vector alloc] init];
    // center of circle
    double cx = point->x;
    double cy = point->y;
    
    // end points of the line
    double x1 = p1.x;
    double y1 = p1.y;
    double x2 = p2.x;
    double y2 = p2.y;
    
    double ux = cx - x1;
    double uy = cy - y1;
    [U initializeVectorX:ux andY:uy];
    //  [U normalize];
    double vx = dx;
    double vy = dy;
    [V initializeVectorX:vx andY:vy];
    [V normalize];
    
    double dot = [U dotProduct:V];
    Vector *projUonV = [[Vector alloc] init];
    
    projUonV = [V multiply:dot];
    double closestX = x1 + projUonV->x;
    double closestY = y1 + projUonV->y;
    Vector *perpUonV = [U subtract:projUonV]; // distance from circle to the line
    
   // if (![line collideWithPtX:closestX andY:closestY])
     //   return false;
    
    double distX = closestX - cx;
    double distY = closestY - cy;
    double distance = sqrt( (distX*distX) + (distY*distY) );
    return distance;*/
   /* double distX = point->x - origin->x;
    double distY = point->y - origin->y;
    double distance = sqrt( (distX*distX) + (distY*distY) );
    return distance;*/
    
    //lineConstant = - [normal dotProduct:origin];
    [normal normalize];
    double dotProd = [point dotProduct:normal];
    double d = dotProd +lineConstant;
    if (d < 0)
        d = -d;
    //d = d / [normal length];
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
       // double x = (p1.x + t*s1->y);
        //double y = (p1.y + t*s1->y);
      //  [point initializeVectorX: x andY: y];
      //  point.x = p1.x + t*s1->x;
     //   point->y = p1.y + t*s1->y;
        *root = [NSNumber numberWithDouble:s];
        return true;
    }
    return false;
}

@end
