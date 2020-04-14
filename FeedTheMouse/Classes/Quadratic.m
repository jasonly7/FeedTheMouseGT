//
//  Quadratic.m
//  Feed The Mouse
//
//  Created by Jason Ly on 2013-10-22.
//  Copyright (c) 2013 Jason Ly. All rights reserved.
//

#import "Quadratic.h"

@implementation Quadratic

+ (bool) getLowestRootA: (double) a andB: (double) b andC: (double) c andMinThreshold: (double)minR andMaxThreshold: (double) maxR andRoot: (NSNumber **) root
{
   // NSLog(@"(a,b,c): (%f,%f,%f)", a, b, c);
    // Check if a solution exists
    double determinant = b*b - 4.0f*a*c;
    
    //NSLog(@"determinant: %f", determinant);
    // if determinant is negative it means no solutions
    if (determinant < 0.0f)
        return false;
    
    // calculate the two roots: (if determinant == 0 then
    // x1==x2 but let's disregard that slight optimization)
    double sqrtD = sqrtf(determinant);
    //NSLog(@"sqrtD: %f",sqrt);
    double r1 = (-b - sqrtD) / (2*a);
    double r2 = (-b + sqrtD) / (2*a);
   // NSLog(@"r1: %f", r1);
  //  NSLog(@"r2: %f", r2);
    // Sort so x1 <= x2
    if (r1 > r2)
    {
        double temp = r2;
        r2 = r1;
        r1 = temp;
    }
    
    // Get lowest root
    if (r1 >= minR && r1 <= maxR ) {
        *root = [NSNumber numberWithDouble:r1];
    //    printf("root : %f", [*root doubleValue]);
        return true;
    }
    
    // It is possible that we want x2 - this can happen
    // if x1 < 0
    if (r2 >= minR && r2 <= maxR ) {
        *root = [NSNumber numberWithDouble:r2];
     //   printf("root : %f", [*root doubleValue]);
        return true;
    }
    
    // N (valid) solutions
    return false;
}
@end
