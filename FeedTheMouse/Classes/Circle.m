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

- (bool) collideWithLine: (Line *) line
{
    // get distance from the center of the circle to the two ends of the line
    Line *lineA = [[Line alloc] init];
    //lineA =
    return false;
}

@end
