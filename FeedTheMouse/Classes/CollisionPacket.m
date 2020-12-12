//
//  CollisionPacket.m
//  Feed The Mouse
//
//  Created by Jason Ly on 2013-10-25.
//  Copyright (c) 2013 Jason Ly. All rights reserved.
//

#import "CollisionPacket.h"


@implementation CollisionPacket

- (id) init
{
    self = [super init];
    if (self)
    {
        basePoint = [[Vector alloc] init];
        velocity = [[Vector alloc] init];
        intersectionPoint = [[Vector alloc] init];
        normalizedVelocity = [[Vector alloc] init];
        closestPt = [[Vector alloc] init];
        collisionCount = 0;
        
    }
    return self;
}
@end
