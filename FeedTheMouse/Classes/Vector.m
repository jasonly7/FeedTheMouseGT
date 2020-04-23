//
//  Vector.m
//  Feed The Mouse
//
//  Created by Jason Ly on 2012-12-28.
//  Copyright (c) 2012 Jason Ly. All rights reserved.
//

#import "Vector.h"

@implementation Vector

- (id) init
{
    self = [super init];
    if (self)
    {
        x = 0;
        y = 0;
        length = 0;
    }
    return self;
}

- (void)initializeVectorX : (double) floatX andY : (double) floatY
{
    x = floatX;
    y = floatY;
    length = [self length];
}

- (Vector*) add:(Vector*) v
{
    Vector *result = [[Vector alloc] init];
    double x = self->x + v->x;;
    double y = self->y + v->y;;
    [result initializeVectorX:x andY:y];

    self = result;
   // [result release];
    return self;// [result autorelease];
}

- (Vector*) subtract:(Vector*) v
{
    Vector *result = [[Vector alloc] init];
    result->x = self->x - v->x;
    result->y = self->y - v->y;
    result.length = [result length];
  
    self = result;
    //[result release];
    return self;
}

- (Vector*) multiply:(float) scale
{
    Vector *result = [[Vector alloc] init];
    double x = self->x * scale;
    double y = self->y * scale;
    [result initializeVectorX:x andY:y];

    
    //result.length = [result length];
    self = result;
   
    return self;
}

- (double) length
{
    length = sqrtf(x*x+y*y);
    return length;
}

- (void) setLength:(float) l
{
    [self normalize];
    x = x * l;
    y = y * l;
    length = l;
}

- (void) normalize
{
    length = [self length];
    x = x/length;
    y = y/length;
    length = 1;
}

- (double) dotProduct: (Vector*) v
{
    double res = (self->x * v->x + self->y * v->y);
    return res;
}

- (Vector*) project: (Vector*) b onto: (Vector*)a
{
    Vector *res = [[Vector alloc] init];
    double numerator = [b dotProduct:a];
    [a normalize];
    double denominator = ([a length]*[a length]);
    float num = numerator/denominator;
    [res setVector:[a multiply:num]];
    return [res autorelease];
}

- (void) setVector:(Vector*)v
{
    x = v->x;
    y = v->y;
    length = [self length];
}

@end
