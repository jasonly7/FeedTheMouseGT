        //
//  Circle.m
//  Feed The Mouse
//
//  Created by Jason Ly on 2012-12-24.
//  Copyright (c) 2012 Jason Ly. All rights reserved.
//

#import "Circle.h"

@implementation Circle

- (id) init
{
    self = [super init];
    if (self)
    {
        pos = [[Vector alloc] init];
    }
    return self;
}

- (void) initializeWithX: (int) x andY: (int) y andRadius:(float)r
{
    self->x = x;
    self->y = y;
    self->r = r;
}

- (bool) collideWithCircle : (Circle *) circle
{
    if ( (circle->x - x) * (circle->x - x) + (circle->y - y) * (circle->y - y) < (circle->r + r) * (circle->r + r))
        return true;
    return false;
}

- (bool) collideWithSprite: (Sprite *) sprite
{
  /*  printf("y: %d r: %f ", y, r);

     printf( "height: %f spritey: %f\n",sprite->height , sprite->y);
    
    if (y<=140)
        printf("blah\n");
    float a = y;
    float b = */
   // printf("a: %f b: %f\n", a , b);
    if ( x + r < sprite->x - sprite->width/2 )
        return false;
    else if ( x - r > sprite->x + sprite->width/2)
        return false;
    if ( y + r < sprite->y - sprite->height/2)
        return false;
    else if ( y > sprite->y + sprite->height/2)
        return false;

    return true;
}

- (bool) collideWithRectangle: (CGRect) rect andAngle: (float) degree
{
    if (degree<0)
        degree+=360;
    float angle = degree * M_PI/180.0f;
    float originX = rect.origin.x;// + rect.size.width/2;
    float originY = rect.origin.y;// + rect.size.height/2;
    int unrotatedX = cosf(-angle) * (x - originX) - sinf(-angle) * (y - originY) + originX;
    int unrotatedY = sinf(-angle) * (x - originX) + cosf(-angle) * (y - originY) + originY;
    Rect rectangle;
    rectangle.left = rect.origin.x - rect.size.width/2;
    rectangle.right = rect.origin.x + rect.size.width/2;
    rectangle.bottom = rect.origin.y - rect.size.height/2;
    rectangle.top = rect.origin.y + rect.size.height/2;
    CGPoint closestPt = CGPointZero;
    if (unrotatedX < rectangle.left)
        closestPt.x = rect.origin.x - rect.size.width/2;
    else if (unrotatedX > rectangle.right)
        closestPt.x = rect.origin.x + rect.size.width/2;
    else
        closestPt.x = unrotatedX;
    if (unrotatedY < rectangle.bottom)
        closestPt.y = rect.origin.y - rect.size.height/2;
    else if (unrotatedY > rectangle.top)
        closestPt.y = rect.origin.y + rect.size.height/2;
    else
        closestPt.y = unrotatedY;
    
    Vector *v1 = [[[Vector alloc] init] autorelease];
    [v1 initializeVectorX:unrotatedX andY:unrotatedY];
    Vector *v2 = [[[Vector alloc] init] autorelease];
    [v2 initializeVectorX:-closestPt.x andY:-closestPt.y];
    float distance = [v1 add:v2].length;
    if (distance < r)
        return true;
    else
        return false;
}

- (bool) collideWithLine: (Line *) line andSpeed:(double) speed andRoot:(NSNumber **)root
{
   
    Vector *U = [[Vector alloc] init];
    Vector *V = [[Vector alloc] init];
    // center of circle
    double cx = x;
    double cy = y;
    
    // end points of the line
    double x1 = line->p1.x;
    double y1 = line->p1.y;
   // double x2 = line->p2.x;
    //double y2 = line->p2.y;
    
    double ux = cx - x1;
    double uy = cy - y1;
    [U initializeVectorX:ux andY:uy];
  //  [U normalize];
    double vx = line->dx;
    double vy = line->dy;
    [V initializeVectorX:vx andY:vy];
   [V normalize];
    
    double dot = [U dotProduct:V];
    Vector *projUonV = [[Vector alloc] init];
   
    projUonV = [V multiply:dot];
    double closestX = x1 + projUonV->x;
    double closestY = y1 + projUonV->y;
    
    
    if (![line collideWithPtX:closestX andY:closestY])
        return false;
    
    double distX = closestX - cx;
    double distY = closestY - cy;
    double distance = sqrt( (distX*distX) + (distY*distY) );
    //if (perpUonV.length < r)
    if (distance <= r)
    {
        Vector *perpUonV = [U subtract:projUonV]; // distance from circle to the line
        double rt = [perpUonV length];// / speed; // divide by time
        *root = [NSNumber numberWithDouble:rt];
        return true;
    }
    //vel* t = perpUonV
    // t = perpUonV/vel
    return false;
}

@end
