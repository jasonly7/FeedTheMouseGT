//
//  Cheese.h
//  Feed The Mouse
//
//  Created by Jason Ly on 2012-12-02.
//  Copyright (c) 2012 Jason Ly. All rights reserved.
//

#import "Picture.h"
#import "Circle.h"
#import "Mouse.h"
#import "Vector.h"
#import "Gear.h"
#import "Drum.h"
#import "TeeterTotter.h"
#import "Flipper.h"
#import "Force.h"
#import "Vector.h"
#import "Matrix.h"
#import "Quadratic.h"
#import "CollisionPacket.h"
#import "World.h"
@class World;

@interface Cheese : Circle
{
    
    float accel;
    float timeOfCollision;
    
    Force *gravityForce;
    Force *normalForce;
    Force *bounceForce;

    NSNumber *x1;
    
   // bool flag;

 //   Vector *newPosition;
    Vector *eSpaceIntersectionPt;
    float eSpaceNearestDist;
    int collisionRecursionDepth;
    @public
        Vector *collisionPoint;
        Vector *initVel;
        Vector *bounceVel;
        Line *slidingLine;
        Sprite *cheeseSprite;
        NSMutableArray *gears;
        NSMutableArray *drums;
        NSMutableArray *teeterTotters;
        NSMutableArray *flippers;
        NSMutableArray *coins;
      //  Gear *gear;
       // Drum *drum;
        //TeeterTotter *teeterTotter;
      //  Mouse *mouse;
        CollisionPacket *colPackage;
        Vector *vel; // velocity in R2
        Vector *acceleration;
        Vector *zeroVector;
        Vector *justTouchVelocity; // temporary velocity to just touch the gear
        //float t;
        float time;
        //float distance;
        float timeUntilImpact;
        World *world;
        Vector *gravity;
        double initVelX;
        Vector *newDestinationPoint;
        Vector *destinationPoint;
        Vector *destinationPointR3;
        Vector *slideLineNormal;
        Vector *topLineNormal;
        Vector *velocityInESpace; // velocity in espace
        Vector *lineToCheese;
        bool isPastTopLine;
        float diff;
}

- (bool) pastLine: (Line *)line;
- (void) draw: (CGContextRef) context;
- (void) dropAt: (CGPoint) pt;
- (void) fall: (float) interpolation;
- (void) update;//
- (bool) collideWith: (Mouse*) mouse;
//- (void) onCollide: (NSObject *) obj;
- (void) bounceOffGear: (Gear*) gear;
- (void) bounceOffDrum;
- (void) bounceOffTeeterTotter;
- (void) bounceOffFlipper;
- (void) bounceOffTopWall;
- (void) bounceOffLeftWall;
- (void) bounceOffRightWall;
- (void) slideOffTeeterTotter:(TeeterTotter *)totter;
- (bool) checkCoin: (Coin*) c;
- (bool) checkGear: (Gear*) g;
- (bool) checkDrum: (Drum*) d;
- (bool) checkTeeterTotter: (TeeterTotter*) totter;
- (bool) checkFlipper: (Flipper*)flipper;
- (bool) collideWithLine: (Line *)line;
- (float) collideWithLineF: (Line *)line;
- (bool) nearLine: (Line *)line;
- (bool) nearVertex: (CGPoint) pt;
- (bool) collideWithVertex: (CGPoint) pt;
- (float) collideWithVertexF: (CGPoint) pt;
- (void) collideAndSlide: (double) lerp;
- (Vector*) collideWithWorldPosition: (const Vector*)position andVelocity: (const Vector*) velocity;
- (void) moveTo: (Vector*) position;
- (void) dealloc;
@end
