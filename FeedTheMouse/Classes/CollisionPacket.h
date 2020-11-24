//
//  CollisionPacket.h
//  Feed The Mouse
//
//  Created by Jason Ly on 2013-10-25.
//  Copyright (c) 2013 Jason Ly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Vector.h"
#import "TeeterTotter.h"

typedef enum {
    COLLISION_NONE = 0,
    COLLISION_BOUNCE,
    COLLISION_SLIDE,
    COLLISION_SLIDING_OFF
} COLLISION_STATE;

@interface CollisionPacket : NSObject
{
@public
    float eRadius; // ellipsoid radius
    
    // Information about the move being requested: (in R3)
    Vector *R3Velocity;
    Vector *R3Position;
    
    // Information about the move being requested: (in eSpace)
    Vector *velocity;
    Vector *normalizedVelocity;
    Vector *basePoint;
    
    // Hit information
    bool foundCollision;
    float nearestDistance;
    Vector *intersectionPoint;
    NSObject *collidedObj;
    COLLISION_STATE state;
    bool isSlidingOff;
    int collisionRecursionDepth;
    TeeterTotter *collidedTotter;
    Vector *closestPt;
    Vector *closestPoint;
    int collisionCount;
};

@end
