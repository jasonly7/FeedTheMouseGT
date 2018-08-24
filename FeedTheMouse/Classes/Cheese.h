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
    Vector *collisionPoint;
   // bool flag;

 //   Vector *newPosition;
    Vector *eSpaceIntersectionPt;
    float eSpaceNearestDist;
    int collisionRecursionDepth;
    @public
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
        Vector *zeroVector;
        Vector *justTouchVelocity; // temporary velocity to just touch the gear
        float t;
        float time;
        float timeUntilImpact;
        World *world;
        Vector *gravity;
        double initVelX;
    
        Vector *slideLineNormal;
}

- (void) draw: (CGContextRef) context;
- (void) dropAt: (CGPoint) pt;
- (void) fall: (float) interpolation;
- (void) display: (double) lerp;
- (bool) collideWith: (Mouse*) mouse;
//- (void) onCollide: (NSObject *) obj;
- (void) bounceOffGear: (Gear*) gear;
- (void) bounceOffDrum;
- (void) bounceOffTeeterTotter;
- (void) bounceOffFlipper;
- (void) slideOffTeeterTotter:(TeeterTotter *)totter;
- (bool) checkCoin: (Coin*) c;
- (bool) checkGear: (Gear*) g;
- (bool) checkDrum: (Drum*) d;
- (bool) checkTeeterTotter: (TeeterTotter*) totter;
- (bool) checkFlipper: (Flipper*)flipper;
- (bool) collideWithLine: (Line *)line;
- (bool) collideWithVertex: (CGPoint) pt;
- (void) collideAndSlide;
- (Vector*) collideWithWorldPosition: (const Vector*)position andVelocity: (const Vector*) velocity;
- (void) moveTo: (Vector*) position;
- (void) dealloc;
@end