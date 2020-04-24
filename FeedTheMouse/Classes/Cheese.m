
//
//  Cheese.m
//  Feed The Mouse
//
//  Created by Jason Ly on 2012-12-02.
//  Copyright (c) 2012 Jason Ly. All rights reserved.
//

#import "Cheese.h"
#define UNIT 30
#define SCALE 30
@implementation Cheese

- (id) init
{
    self = [super init];
    if (self)
    {
        vel = [[Vector alloc] init];
        justTouchVelocity = [[Vector alloc] init];
        accel = -10*UNIT;
        cheeseSprite = [Picture fromFile:@"cheese.png"];
        x = cheeseSprite.x + cheeseSprite.width/2;
        y = cheeseSprite.y + cheeseSprite.height/2;
        r = cheeseSprite.width/2;
        
        Vector *accelVector = [[Vector alloc] init];
        [accelVector initializeVectorX:0 andY:accel];

        gravityForce = [[Force alloc] init];
        gravityForce->a = accelVector;
        gravityForce->m = 1;
        gravity = [[Vector alloc] init];
        [gravity initializeVectorX:0 andY:(-10*UNIT) ];
        
        normalForce = [[Force alloc] init];
        normalForce->m = 1;
        Vector *nAccelVector = [[Vector alloc] init];
        [nAccelVector initializeVectorX:0 andY:0];
        normalForce->a = nAccelVector;
        
        acceleration = [[Vector alloc] init];
        [acceleration initializeVectorX:0 andY:0];
        
        initVel = [[Vector alloc] init];
        [initVel initializeVectorX:0 andY:0];
        
        bounceVel = [[Vector alloc] init];
        [bounceVel initializeVectorX:0 andY:0];
        bounceForce = [[Force alloc] init];
        bounceForce->a = bounceVel;
        bounceForce->m = 1;
    
        
        slidingLine = [[Line alloc] init];
        zeroVector = [[Vector alloc] init];
        [zeroVector initializeVectorX:0 andY:0];
        [slidingLine initializeLineWithVectorOrigin:zeroVector andVectorNormal:zeroVector];
        time = 0;
       // time = 1;
        
        
        angularAcceleration = 0.1;
        angularDisplacement = angularVelocity = 0;
        collisionPoint = [[Vector alloc] init];
        colPackage = [[[CollisionPacket alloc] init] retain];
        colPackage->foundCollision = false;
        colPackage->eRadius = cheeseSprite.width/2;
        eSpaceIntersectionPt = [[Vector alloc] init];
        destinationPoint = [[Vector alloc] init];
        destinationPointR3 = [[Vector alloc] init];
        newDestinationPoint = [[Vector alloc] init];
        world = [[World alloc] init];
    }
    return self;
}

- (void) dropAt: (CGPoint) pt
{
    vel->x = 0;
    vel->y = 0;
    acceleration->x = 0;
    acceleration->y = gravity->y;
    cheeseSprite.x = pt.x - cheeseSprite.width/2;
    cheeseSprite.y = pt.y - cheeseSprite.height/2;
    x = pt.x;
    y = pt.y;
    pos->x = x;
    pos->y = y;
    
    time = 0;
    initVel->x = 0;
    initVel->y = 0;
    bounceForce->a->x = 0;
    bounceForce->a->y = 0;
    normalForce->a->x = 0;
    normalForce->a->y = 0;
}

- (void) fall:(float) interpolation
{
    if ( cheeseSprite.y + cheeseSprite.height > 0)
    {
       // colPackage->velocity = vel;
        if (!colPackage->foundCollision && collisionRecursionDepth == 0)
        {
            time = interpolation;
            
            
      
            //Nvel->y += acceleration->y*t;//gravity->y;
           // Vector *accel = [[Vector alloc] init];
           // [accel initializeVectorX:acceleration->x andY:(acceleration->y)];
            //vel = [vel add:accel];
            
           // vel = [initVel add:at];
           // [accel release];
            float vxt = vel->x*time;
            float vyt = vel->y*time;
            x = pos->x + vxt;
            y = pos->y + vyt;
            
            NSLog(@"vel->y: %f", vel->y);
            
            NSLog(@"time: %f",time);
            colPackage->R3Velocity = vel;
        }
        else
        {
            if (colPackage->state == COLLISION_BOUNCE)
            {
                [vel initializeVectorX:initVel->x andY:initVel->y];
               //vel->x = initVel->x;
                
                [acceleration initializeVectorX:0 andY:gravity->y];
            }
            // set x and y to just touch the object
            if (colPackage->collidedObj!=nil)
            {
                if ([colPackage->collidedObj class] == [Gear class])
                {
                    x = pos->x + justTouchVelocity->x*time;
                    y = pos->y + justTouchVelocity->y*time;
                    vel->y = initVel->y;
                  /*  if (vel->x <= 1 && vel->x >=-1)
                    {
                        vel->x = vel->y;
                    }*/
                }
                else if ([colPackage->collidedObj class] == [TeeterTotter class])
                {
                    // if not near vertex or sliding
                    
                    int vxt = 0;
                    int vyt = 0;
                    if (!colPackage->foundCollision || colPackage->isSlidingOff)
                    {
                        time = interpolation;
                        vxt = roundf(vel->x*time);
                        vyt = roundf(vel->y*time);
                        x = pos->x + vxt;
                        y = pos->y + vyt;
                    }
                   
                    //x = pos->x;
                    //y = pos->y;
                   // vel->x += -1;
                    //vel->y += 1;
                   // vel->x += -[acceleration length]*tanf(0.785f); // 1.41
                    //vel->y += [acceleration length]; // 1.41
                    //vel->x += [acceleration length]*colPackage->collidedTotter->normal->x;
                    //vel->y += [acceleration length]*colPackage->collidedTotter->normal->y;
                }
                else if ([colPackage->collidedObj class] == [Drum class] ||
                         [colPackage->collidedObj class] == [Flipper class])
                {
                    if (colPackage->state == COLLISION_SLIDE)
                    {
                        vel->x += acceleration->x*time;// initVel->x;
                        x = pos->x + vel->x*time;
                        vel->y += acceleration->y;//initVel->y + acceleration->y*t;
                        y = pos->y + vel->y*time;
                    }
                    else
                    {
                        vel->x = initVel->x+acceleration->x*time;
                        x = pos->x + vel->x*time;
                        pos->x = x;
                        vel->y = initVel->y + acceleration->y*time;
                        y = pos->y + vel->y*time;
                        pos->y = y;
                    }
                }
                else
                {
                   /* if (vel->x <= 1 && vel->x >=-1)
                    {
                        vel->x = vel->y;
                    }*/
                    x = pos->x + vel->x*acceleration->x*time;
                    vel->y = initVel->y + acceleration->y*time;
                    y = pos->y + vel->y*time;
                }
                colPackage->collidedObj = nil;
            }
            else
            {
               /* if (vel->x <= 1 && vel->x >=-1)
                {
                    vel->x = vel->y;
                }*/
                x = pos->x + vel->x*time;
                vel->y = initVel->y + acceleration->y*time;
                y = pos->y + vel->y*time;
               // [vel initializeVectorX:initVel->x andY:initVel->y];
            }
            time = interpolation;
            //Vector *v = [[Vector alloc]init];
            //[v initializeVectorX:vel->x andY:vel->y];
            //[v normalize];
           // x = pos->x + colPackage->nearestDistance*v.length;
            //y = pos->y + colPackage->nearestDistance*v.length;
        }
        angularVelocity=-angularAcceleration;
        
        
       // printf("vel->y: %f\n", vel->y);
        angularDisplacement+=angularVelocity;
        
        
        // if (angularDisplacement<0)
        //   angularDisplacement+=360;
        // cheeseSprite.x+=vel->x;
        //cheeseSprite.y+=vel->y;
        
       
        
       // x = cheeseSprite.x - cheeseSprite.width/2;
        //y = cheeseSprite.y - cheeseSprite.height/2;
        
    }
    else
    {
        vel->x = 0;
        vel->y = 0;
        time = interpolation;
        angularVelocity = 0;
        angularDisplacement = 0;
    }
    
    // if on the edge and not recently dropped
    if (pos->y > (960-cheeseSprite.width/2))
    {
        pos->y = 960-cheeseSprite.width/2;
        y = pos->y;
    }
    if (pos->x > (640 - cheeseSprite.width/2))
    {
        pos->x = 640 - cheeseSprite.width/2;
        x = pos->x;
    }
    else if (pos->x < (cheeseSprite.width/2))
    {
        pos->x = cheeseSprite.width/2;
        x = pos->x;
    }
    
    if (!colPackage->foundCollision || colPackage->isSlidingOff)
    {
       
       cheeseSprite.x = x - cheeseSprite.width/2;
       cheeseSprite.y = y - cheeseSprite.height/2;
       pos->x = x;
       pos->y = y;
       colPackage->R3Position = pos;
    }
}

- (void) draw: (CGContextRef) context
{
    [cheeseSprite draw:context];
}

- (bool) checkCoin:(Coin *)c
{
   // Vector *coinPosition = [[Vector alloc] init];
    //[coinPosition initializeVectorX:->x andY:c->pos->y];
    double dist = [c->pos subtract:pos]->length;
    double sumRadii = (c->r + r);
    dist -= sumRadii;
   // NSLog(@"Distance from cheese to coin: %f", dist);
  //  NSLog(@"vel length: %f", [vel length]);
    if( [vel length] < dist){
        return false;
    }
    
   // NSLog(@"vel: (%f,%f)", vel->x, vel->y);
    // Normalize the movevec
    Vector *N = [[Vector alloc] init];
    [N initializeVectorX:vel->x andY:vel->y];
    [N normalize];
   // NSLog(@"vel normalized: (%f,%f)", N->x, N->y);
    
    // Find C, the vector from the center of the moving
    // circle A to the center of B
    Vector *C = [[[Vector alloc] init] autorelease];
    [C initializeVectorX:0 andY:0];
    C = [c->pos subtract:pos];
   // NSLog(@"C: (%f,%f)", C->x, C->y);
    
    /* Vector *Friction = [[Vector alloc] init];
     [Friction initializeVectorX:-C->x andY:C->y];
     [Friction normalize];
     bounceVel = [bounceVel add:Friction];*/
    
    // D = N . C = ||C|| * cos(angle between N and C)
    // D, the distance between the center of A and the closest point on V to B
    double D = [N dotProduct:C];
   // NSLog(@"D: %f", D);
    [N release];
    
    // Another early escape: Make sure that A is moving
    // towards B! If the dot product between the movevec and
    // B.center - A.center is less that or equal to 0,
    // A isn't moving towards B
    if(D <= 0){
        return false;
    }
    // Find the length of the vector C
    double lengthC = C->length;
    //NSLog(@"C length: %f", lengthC);
    
    // C^2 = F^2 + D^2
    double F = (lengthC * lengthC) - (D * D);
   // NSLog(@"F: %f", F);
    // Escape test: if the closest that A will get to B
    // is more than the sum of their radii, there's no
    // way they are going collide
    double sumRadiiSquared = sumRadii * sumRadii;
    NSLog(@"Sum of the Radii^2: %f", sumRadiiSquared);
    if(F >= sumRadiiSquared){
        return false;
    }
    
    // We now have F and sumRadii, two sides of a right triangle.
    // Use these to find the third side, sqrt(T)
    double T = sumRadiiSquared - F;
    //NSLog(@"T: %f", T);
    // If there is no such right triangle with sides length of
    // sumRadii and sqrt(f), T will probably be less than 0.
    // Better to check now than perform a square root of a
    // negative number.
    if(T < 0){
        return false;
    }
    
    // Therefore the distance the circle has to travel along
    // movevec is D - sqrt(T)
    double distance = D - sqrt(T);
   // NSLog(@"distance: %f", distance);
    
    // Get the magnitude of the movement vector
    double mag = [vel length];
   // NSLog(@"magnitude: %f", mag);
    
    // Finally, make sure that the distance A has to move
    // to touch B is not greater than the magnitude of the
    // movement vector.
    if(mag < distance){
        return false;
    }
    
    // Set the length of the movevec so that the circles will just
    // touch
    justTouchVelocity = [[Vector alloc] init];
    [justTouchVelocity initializeVectorX:vel->x andY:vel->y];
    [justTouchVelocity normalize];
    justTouchVelocity = [justTouchVelocity multiply:distance];
   // NSLog(@"justTouchVelocity: %f,%f", justTouchVelocity->x, justTouchVelocity->y);
    return true;
}

- (bool) checkGear:(Gear *)g
{    // Early Escape test: if the length of the movevec is less
    // than distance between the centers of these circles minus
    // their radii, there's no way they can hit.
    
    double dist = [g->pos subtract:pos]->length;
    double sumRadii = (g->r + r);
    dist -= sumRadii;
    if( [vel length]*time < dist){
        return false;
    }
    
    // Normalize the movevec
    Vector *N = [[Vector alloc] init];
    [N initializeVectorX:vel->x andY:vel->y];
    [N normalize];
    
    // Find C, the vector from the center of the moving
    // circle A to the center of B
    Vector *C = [[[Vector alloc] init] autorelease];
    [C initializeVectorX:0 andY:0];
    C = [g->pos subtract:pos];

   
    
    // D = N . C = ||C|| * cos(angle between N and C)
    double D = [N dotProduct:C];
    [N release];
    
    // Another early escape: Make sure that A is moving
    // towards B! If the dot product between the movevec and
    // B.center - A.center is less that or equal to 0,
    // A isn't moving towards B
    if(D <= 0){
        return false;
    }
    // Find the length of the vector C
    double lengthC = C->length;
    
    double F = (lengthC * lengthC) - (D * D);
    
    // Escape test: if the closest that A will get to B
    // is more than the sum of their radii, there's no
    // way they are going collide
    double sumRadiiSquared = sumRadii * sumRadii;
    if(F >= sumRadiiSquared){
        return false;
    }
    
    // We now have F and sumRadii, two sides of a right triangle.
    // Use these to find the third side, sqrt(T)
    double T = sumRadiiSquared - F;
    
    // If there is no such right triangle with sides length of
    // sumRadii and sqrt(f), T will probably be less than 0.
    // Better to check now than perform a square root of a
    // negative number.
    if(T < 0){
        return false;
    }
    
    // Therefore the distance the circle has to travel along
    // movevec is D - sqrt(T)
    double distance = D - sqrt(T);
    
    // Get the magnitude of the movement vector
    double mag = [vel length];
    
    // Finally, make sure that the distance A has to move
    // to touch B is not greater than the magnitude of the 
    // movement vector. 
    if(mag < distance){
        return false;
    }
    
    // Set the length of the movevec so that the circles will just 
    // touch
    justTouchVelocity = [[Vector alloc] init];
    [justTouchVelocity initializeVectorX:vel->x andY:vel->y];
    [justTouchVelocity normalize];
    justTouchVelocity = [justTouchVelocity multiply:distance];
    
    bounceVel = [[Vector alloc] init];
    bounceVel->x = (x - g->x);
    bounceVel->y = (y - g->y);
    //printf("bounceVel retain count: %lu", (unsigned long)[bounceVel length]);
   // printf("bounceVel retain count: %lu", (unsigned long)[bounceVel retainCount]);
    [bounceVel normalize];
    
   /* Vector *normal = [[Vector alloc] init];
    [normal initializeVectorX:0 andY:0];
    [C normalize];
    normal = [[C multiply:-1] multiply:gravity->length];*/
    double length = [vel length];
    bounceVel = [bounceVel multiply:length];// add:gravity] add:normal];
    /*double theta = M_PI_2;
    double fx = C->x * cos(theta) - C->y * sin(theta);
    double fy = C->x * sin(theta) - C->y * cos(theta);
    Vector *Friction = [[Vector alloc] init];
    [Friction initializeVectorX:fx andY:fy];
    [Friction normalize];
    Friction = [Friction multiply:(UNIT*10)];
    bounceVel = [bounceVel add:Friction];*/
    return true;
}

- (bool) checkTeeterTotter: (TeeterTotter*) totter
{
    float topLeftX, topLeftY, topRightX, topRightY;
    float bottomLeftX, bottomLeftY, bottomRightX, bottomRightY;
    CGPoint topLeftPt,topRightPt,bottomLeftPt,bottomRightPt;
    Line *topLine = [[[Line alloc] init] autorelease];
    Line *bottomLine = [[[Line alloc] init] autorelease];
    Line *leftLine = [[[Line alloc] init] autorelease];
    Line *rightLine = [[[Line alloc] init] autorelease];

    double radAngle = totter->angle*M_PI/180.0f;
    bool foundCollision = false;
    while (totter->angle < 0 || totter->angle > 360) {
        if (totter->angle < 0)
            totter->angle+=360;
        else if (totter->angle >360)
            totter->angle-=360;
    }
    
    // get top left of rectangle
    topLeftX = totter->x - cos(radAngle)*totter->totterSprite.width/2 + cos(radAngle+M_PI_2)*totter->totterSprite.height/2;
    topLeftY = totter->y - sin(radAngle)*totter->totterSprite.width/2 + sin(radAngle+M_PI_2)*totter->totterSprite.height/2;
    topLeftPt = CGPointMake(topLeftX, topLeftY);
    // get top right of rectangle
    topRightX = totter->x + cos(radAngle)*totter->totterSprite.width/2 + cos(radAngle+M_PI_2)*totter->totterSprite.height/2;
    topRightY = totter->y + sin(radAngle)*totter->totterSprite.width/2 + sin(radAngle+M_PI_2)*totter->totterSprite.height/2;
    topRightPt = CGPointMake(topRightX,topRightY);
    // get bottom left of rectangle
    bottomLeftX = totter->x - cos(radAngle)*totter->totterSprite.width/2 + cos(radAngle-M_PI_2)*totter->totterSprite.height/2;
    bottomLeftY = totter->y - sin(radAngle)*totter->totterSprite.width/2 + sin(radAngle-M_PI_2)*totter->totterSprite.height/2;
    bottomLeftPt = CGPointMake(bottomLeftX, bottomLeftY);
    // get bottom right of rectangle
    bottomRightX = totter->x + cos(radAngle)*totter->totterSprite.width/2 + cos(radAngle-M_PI_2)*totter->totterSprite.height/2;
    bottomRightY = totter->y + sin(radAngle)*totter->totterSprite.width/2 + sin(radAngle-M_PI_2)*totter->totterSprite.height/2;
    bottomRightPt = CGPointMake(bottomRightX,bottomRightY);
    
    topLine = [topLine initializeLineWithPoint1:topLeftPt andPoint2:topRightPt];
    bottomLine = [bottomLine initializeLineWithPoint1:bottomRightPt andPoint2:bottomLeftPt];
    leftLine = [leftLine initializeLineWithPoint1:bottomLeftPt andPoint2:topLeftPt];
    rightLine = [rightLine initializeLineWithPoint1:topRightPt andPoint2:bottomRightPt];
    //totter->topLineRotated = topLine;
    if (!colPackage->foundCollision)
    {
        CGPoint topLeft = CGPointMake(topLeftX, topLeftY);
        CGPoint topRight = CGPointMake(topRightX, topRightY);
        CGPoint bottomLeft = CGPointMake(bottomLeftX, bottomLeftY);
        CGPoint bottomRight = CGPointMake(bottomRightX, bottomRightY);
       // colPackage->state = COLLISION_NONE;
        Vector *normal = [[[Vector alloc] init] autorelease];
        //Vector *normal1 = [[[Vector alloc] init] autorelease];
        //Vector *normal2 = [[[Vector alloc] init] autorelease];
        Vector *I = [[[Vector alloc] init] autorelease];
        Vector *negativeI = [[[Vector alloc] init] autorelease];
        Vector *N = [[[Vector alloc] init] autorelease];
        [I initializeVectorX:vel->x andY:vel->y];
        [negativeI initializeVectorX:-vel->x andY:-vel->y];
        [N initializeVectorX:0 andY:0];
        
        bool isCollidedWithTopLeft = [self collideWithVertex:topLeft];
        
        bool isCollidedWithTopRight = [self collideWithVertex:topRight];
        
        bool isNearTopLeft = [self nearVertex:topLeft];
        bool isNearTopRight = [self nearVertex:topRight];
        bool isNearTopLine = [self nearLine:topLine];
        float collidedWithTop = [self collideWithLineF:topLine];
        float collidedWithBottom = [self collideWithLineF:bottomLine];
        float collidedWithLeft = [self collideWithLineF:leftLine];
        float collidedWithRight = [self collideWithLineF:rightLine];
        float collidedWithTopLeft = [self collideWithVertexF:topLeft];
        float collidedWithTopRight = [self collideWithVertexF:topRight];
        float collidedWithBottomLeft = [self collideWithVertexF:bottomLeft];
        float collidedWithBottomRight = [self collideWithVertexF:bottomRight];

        float shortestDistance = FLT_MAX;
        if (collidedWithTop < shortestDistance && collidedWithTop > 0)
            shortestDistance = collidedWithTop;
        if (collidedWithBottom < shortestDistance && collidedWithBottom > 0)
            shortestDistance = collidedWithBottom;
        if (collidedWithLeft < shortestDistance && collidedWithLeft > 0)
            shortestDistance = collidedWithLeft;
        if (collidedWithRight < shortestDistance && collidedWithRight > 0)
            shortestDistance = collidedWithRight;
        if (collidedWithTopLeft < shortestDistance && collidedWithTopLeft > 0)
            shortestDistance = collidedWithTopLeft;
        if (collidedWithTopRight < shortestDistance && collidedWithTopRight > 0)
            shortestDistance = collidedWithTopRight;
        if (collidedWithBottomLeft < shortestDistance && collidedWithBottomLeft > 0)
            shortestDistance = collidedWithBottomLeft;
        if (collidedWithBottomRight < shortestDistance && collidedWithBottomRight > 0)
            shortestDistance = collidedWithBottomRight;
        
        if ( collidedWithTopLeft == shortestDistance || isNearTopLeft)
        {
            [self collideWithVertex:topLeft];
            Vector *topLeftVector = [[[Vector alloc] init] autorelease];
            [topLeftVector initializeVectorX:topLeft.x andY:topLeft.y];
              
            normal = [self->pos subtract:topLeftVector];
            [normal normalize];
           
            foundCollision = true;
            slidingLine->normal = normal;
            colPackage->state = COLLISION_SLIDE;
            
            
            if (isNearTopLeft && !isCollidedWithTopLeft)
            {
                if (vel->x <0)
                {
                    colPackage->isSlidingOff = true;
                    /*normal = [self->pos subtract:topLeftVector];
                    [normal normalize];
                    totter->normal = normal;*/
                }
                else if (vel->x >= 0)
                {
                   // isPastTopRight = [self pastLine:leftLine];
                    
                    colPackage->state = COLLISION_BOUNCE;
                    Vector *I = [[[Vector alloc] init] autorelease];
                    [I initializeVectorX:vel->x andY:vel->y];
                    Vector *negativeI = [[[Vector alloc] init] autorelease];

                    [negativeI initializeVectorX:-I->x andY:-I->y];

                    Vector *topLeftVector = [[[Vector alloc] init] autorelease];
                    [topLeftVector initializeVectorX:topLeft.x andY:topLeft.y];

                    normal = [self->pos subtract:topLeftVector];
                    [normal normalize];
                    double scaler = [negativeI dotProduct:normal];
                    if (scaler < 0)
                        scaler = -scaler;
                    // projection of the normal along I (initial velocity vector going towards the line)
                    N = [normal multiply:scaler];
                    //[I normalize];
                    bounceVel = [[N multiply:2] add:I];
                            
                    [bounceVel normalize];
                    bounceVel = [[bounceVel multiply:vel.length] add:gravity];

                    slidingLine->normal = normal;
                }
            }
            else
            {
                if (vel->x > 0)
                {
                    colPackage->state = COLLISION_BOUNCE;
                    Vector *I = [[[Vector alloc] init] autorelease];
                    [I initializeVectorX:vel->x andY:vel->y];
                    Vector *negativeI = [[[Vector alloc] init] autorelease];

                    [negativeI initializeVectorX:-I->x andY:-I->y];

                    Vector *topLeftVector = [[[Vector alloc] init] autorelease];
                    [topLeftVector initializeVectorX:topLeft.x andY:topLeft.y];

                    normal = [self->pos subtract:topLeftVector];
                    [normal normalize];
                    double scaler = [negativeI dotProduct:normal];
                    if (scaler < 0)
                     scaler = -scaler;
                    // projection of the normal along I (initial velocity vector going towards the line)
                    N = [normal multiply:scaler];
                    [I normalize];
                    bounceVel = [[N multiply:2] add:I];
                               
                    [bounceVel normalize];
                    bounceVel = [[normal multiply:vel.length] add:gravity];
                   
                    slidingLine->normal = normal;
                }
                else if (vel->x < 0)
                {
                     colPackage->isSlidingOff = true;
                }
            }
            
            
        }
        else if (collidedWithTopRight == shortestDistance || isNearTopRight)
        {
            Vector *topRightVector = [[[Vector alloc] init] autorelease];
            [topRightVector initializeVectorX:topRight.x andY:topRight.y];
            
            
            normal = [self->pos subtract:topRightVector];
            [normal normalize];
            slidingLine->normal = normal;
            colPackage->state = COLLISION_SLIDE;
            
            if (isNearTopRight && !isCollidedWithTopRight)
            {
                if (vel->x > 0)
                {
                    colPackage->isSlidingOff = true;
                }
                else if (vel->x <= 0)
                {
                    isPastTopRight = [self pastVertex:topRightVector];                    //isPastRightLine = [self pastLine:rightLine];
                    
                    colPackage->state = COLLISION_BOUNCE;
                    foundCollision = true;
                    Vector *I = [[[Vector alloc] init] autorelease];
                    Vector *negativeI = [[[Vector alloc] init] autorelease];
                    /*if (abs(vel->x) < 0.00000001)
                    {
                        int roundedVelX = (int)(1000000000000000 * vel->x);
                        vel->x = roundedVelX/1000000000000000.0f;
                    }
                    if (vel->y < 0.000000001)
                    {
                        int roundedVelY = (int)(10000000000 * vel->y);
                        vel->y = roundedVelY/10000000000.0f;
                    }*/
                    [I initializeVectorX: vel->x andY:vel->y];
                    [negativeI initializeVectorX:-I->x andY:-I->y];

                    Vector *topRightVector = [[[Vector alloc] init] autorelease];
                    [topRightVector initializeVectorX:topRight.x andY:topRight.y];

                    normal = [self->pos subtract:topRightVector];
                    [normal normalize];
                    double scaler = [negativeI dotProduct:normal];
                    if (scaler < 0)
                       scaler = -scaler;
                    // projection of the normal along I (initial velocity vector going towards the line)
                    N = [normal multiply:scaler];
                  //  [I normalize];
                    bounceVel = [[N multiply:2] add:I];
                    [bounceVel normalize];
                    bounceVel = [bounceVel multiply:vel.length];
                    //double diff = self->x - topRight.x;
                    //lineToCheese = [self->pos subtract:rightLine];
                    //if (bounceVel->x < diff)
                      //  [bounceVel initializeVectorX:diff andY:bounceVel->y];
                    slidingLine->normal = normal;
                    
                }
            }
            else
            {
                if (vel->x < 0)
                {
                    colPackage->state = COLLISION_BOUNCE;
                    double Ix = vel->x;
                    double Iy = vel->y;
                    Vector *I = [[[Vector alloc] init] autorelease];
                    Vector *negativeI = [[[Vector alloc] init] autorelease];
                    [I initializeVectorX:Ix andY:Iy];
                    [negativeI initializeVectorX:-Ix andY:-Iy];

                    Vector *bottomRightVector = [[[Vector alloc] init] autorelease];
                    [bottomRightVector initializeVectorX:bottomRight.x andY:bottomRight.y];

                    normal = [self->pos subtract:bottomRightVector];
                    [normal normalize];
                    double scaler = [negativeI dotProduct:normal];
                    if (scaler < 0)
                       scaler = -scaler;
                    // projection of the normal along I (initial velocity vector going towards the line)
                    N = [normal multiply:scaler];
                    [I normalize];
                    bounceVel = [[N multiply:2] add:I];
                    [bounceVel normalize];
                    bounceVel = [[bounceVel multiply:vel.length] add:gravity];
    
                    slidingLine->normal = normal;
                }
                else if (vel->x > 0)
                {
                    colPackage->isSlidingOff = true;
                }
            }
            //foundCollision = true;
            
        }
        else if (collidedWithTop == shortestDistance || isNearTopLine)
        {
            if (collidedWithTop == shortestDistance)
            {
                [self collideWithLine:topLine];
                if ([topLine isFrontFacingTo:vel])
               {
                   normal = [topLine normal];
               }
               else
               {
                   [normal initializeVectorX:-topLine->normal->x andY: -topLine->normal->y];
               }
            }
            else
            {
                normal = [topLine normal];
            }
            
           
            [normal normalize];
            totter->normal = normal;
            // projection of the normal along I (initial velocity vector going towards the line)
            // double nx = [normal multiply:[I dotProduct:normal]]->x;
            // double ny = ->y;
            //[N initializeVectorX:nx andY:ny];
           // [N setVector: [normal multiply:[negativeI dotProduct:normal]]];
           // bounceVel = [[N multiply:2] add:I];
            //[bounceVel normalize];
            //bounceVel = [bounceVel multiply:vel.length];
            slidingLine->normal = normal;
            slidingLine->p1 = CGPointMake( topLine->p1.x/r, topLine->p1.y/r);
            slidingLine->p2 = CGPointMake( topLine->p2.x/r, topLine->p2.y/r);
               
            if (collidedWithTop == shortestDistance)
                foundCollision = true;
            
            colPackage->state = COLLISION_SLIDE;
        }
        else if (collidedWithLeft == shortestDistance)
        {
            [self collideWithLine:leftLine];
            if ([leftLine isFrontFacingTo:vel])
            {
                normal = leftLine->normal = [leftLine normal];
            }
            else
            {
                [normal initializeVectorX:-leftLine->normal->x andY: -leftLine->normal->y];
                leftLine->normal = normal;
            }
            [normal normalize];
            // projection of the normal along I (initial velocity vector going towards the line)
            N = [normal multiply:[negativeI dotProduct:normal]];
            bounceVel = [[N multiply:2] add:I];
            [bounceVel normalize];
            bounceVel = [[bounceVel multiply:vel.length] add:gravity];
            foundCollision = true;
            colPackage->state = COLLISION_BOUNCE;
        }
        else if (collidedWithRight == shortestDistance)
        {
            [self collideWithLine:rightLine];
            Vector *I = [[[Vector alloc] init] autorelease];
            [I initializeVectorX:vel->x andY:vel->y];
            Vector *negativeI = [[[Vector alloc] init] autorelease];
            [negativeI initializeVectorX:-vel->x andY:-vel->y];
            //if ([rightLine isFrontFacingTo:vel])
           // {
                normal = rightLine->normal = [rightLine normal];
           // }
           // else
           // {
              //  [normal initializeVectorX:-rightLine->normal->x andY: -rightLine->normal->y];
             //   rightLine->normal = normal;
          // }
            [normal normalize];
            // projection of the normal along I (initial velocity vector going towards the line)
            N = [normal multiply:[negativeI dotProduct:normal]];
            bounceVel = [[N multiply:2] add:I];
            [bounceVel normalize];
            bounceVel = [[bounceVel multiply:vel.length] add:gravity];
            foundCollision = true;
            colPackage->state = COLLISION_BOUNCE;
        }
        else if (collidedWithBottomLeft == shortestDistance)
        {
            [self collideWithVertex:bottomLeft];
            Vector *bottomLeftVector = [[[Vector alloc] init] autorelease];
            [bottomLeftVector initializeVectorX:bottomLeft.x andY:bottomLeft.y];
            
            normal = [self->pos subtract:bottomLeftVector];
            
            
            double scaler = [negativeI dotProduct:normal];
            if (scaler < 0)
                scaler = -scaler;
            [normal normalize];
            // projection of the normal along I (initial velocity vector going towards the line)
            N = [normal multiply:scaler];
            [I normalize];
            bounceVel = [[N multiply:2] add:I];
            [bounceVel normalize];
            bounceVel = [[bounceVel multiply:vel.length] add:gravity];
            foundCollision = true;
            colPackage->state = COLLISION_BOUNCE;
            slidingLine->normal = normal;
        }
        else if (collidedWithBottomRight == shortestDistance)
        {
            [self collideWithVertex:bottomRight];
            Vector *bottomRightVector = [[[Vector alloc] init] autorelease];
            [bottomRightVector initializeVectorX:bottomRight.x andY:bottomRight.y];
           
            normal = [self->pos subtract:bottomRightVector];
            // projection of the normal along I (initial velocity vector going towards the line)
            
           
            double scaler = [negativeI dotProduct:normal];
            if (scaler < 0)
                scaler = -scaler;
            N = [normal multiply:scaler];
            [I normalize];
            bounceVel = [[N multiply:2] add:I];
            [bounceVel normalize];
            bounceVel = [[bounceVel multiply:vel.length] add:gravity];
            foundCollision = true;
            colPackage->state = COLLISION_BOUNCE;
            slidingLine->normal = normal;
        }
        else if (collidedWithBottom == shortestDistance)
        {
            [self collideWithLine:bottomLine];
            if ([bottomLine isFrontFacingTo:vel])
            {
                normal = [bottomLine normal];
            }
            else
            {
                [normal initializeVectorX:-bottomLine->normal->x andY: -bottomLine->normal->y];
            }
            [normal normalize];
            // projection of the normal along I (initial velocity vector going towards the line)
           
            [N setVector: [normal multiply:[negativeI dotProduct:normal]]];
            [I normalize];
            bounceVel = [[N multiply:2] add:I];
            [bounceVel normalize];
            bounceVel = [[bounceVel multiply:vel.length] add:gravity];
            foundCollision = true;
            slidingLine->normal = normal;
            colPackage->state = COLLISION_BOUNCE;
        }
    }

    return foundCollision;
}

- (bool) checkDrum: (Drum*) d
{
    float topLeftX, topLeftY, topRightX, topRightY;
    float bottomLeftX, bottomLeftY, bottomRightX, bottomRightY;
    CGPoint topLeftPt,topRightPt,bottomLeftPt,bottomRightPt;
    Line *topLine = [[[Line alloc] init] autorelease];
    Line *bottomLine = [[[Line alloc] init] autorelease];
    Line *leftLine = [[[Line alloc] init] autorelease];
    Line *rightLine = [[[Line alloc] init] autorelease];
    double radAngle = d->angle*M_PI/180.0f;
    bool foundCollision = false;
    double scaler;
    while (d->angle < 0 || d->angle > 360) {
        if (d->angle < 0)
            d->angle+=360;
        else if (d->angle >360)
            d->angle-=360;
    }
    
    // get top left of rectangle
    topLeftX = d->x - cos(radAngle)*d->drumSprite.width/2 + cos(radAngle+M_PI_2)*d->drumSprite.height/2;
    topLeftY = d->y - sin(radAngle)*d->drumSprite.width/2 + sin(radAngle+M_PI_2)*d->drumSprite.height/2;
    topLeftPt = CGPointMake(topLeftX, topLeftY);
    // get top right of rectangle
    topRightX = d->x + cos(radAngle)*d->drumSprite.width/2 + cos(radAngle+M_PI_2)*d->drumSprite.height/2;
    topRightY = d->y + sin(radAngle)*d->drumSprite.width/2 + sin(radAngle+M_PI_2)*d->drumSprite.height/2;
    topRightPt = CGPointMake(topRightX,topRightY);
    // get bottom left of rectangle
    bottomLeftX = d->x - cos(radAngle)*d->drumSprite.width/2 + cos(radAngle-M_PI_2)*d->drumSprite.height/2;
    bottomLeftY = d->y - sin(radAngle)*d->drumSprite.width/2 + sin(radAngle-M_PI_2)*d->drumSprite.height/2;
    bottomLeftPt = CGPointMake(bottomLeftX, bottomLeftY);
    // get bottom right of rectangle
    bottomRightX = d->x + cos(radAngle)*d->drumSprite.width/2 + cos(radAngle-M_PI_2)*d->drumSprite.height/2;
    bottomRightY = d->y + sin(radAngle)*d->drumSprite.width/2 + sin(radAngle-M_PI_2)*d->drumSprite.height/2;
    bottomRightPt = CGPointMake(bottomRightX,bottomRightY);
    
    topLine = [topLine initializeLineWithPoint1:topLeftPt andPoint2:topRightPt];
    bottomLine = [bottomLine initializeLineWithPoint1:bottomRightPt andPoint2:bottomLeftPt];
    leftLine = [leftLine initializeLineWithPoint1:bottomLeftPt andPoint2:topLeftPt];
    rightLine = [rightLine initializeLineWithPoint1:topRightPt andPoint2:bottomRightPt];
    
    
    if (!colPackage->foundCollision)
    {
        colPackage->state = COLLISION_NONE;
        CGPoint topLeft = CGPointMake(topLeftX, topLeftY);
        CGPoint topRight = CGPointMake(topRightX, topRightY);
        CGPoint bottomLeft = CGPointMake(bottomLeftX, bottomLeftY);
        CGPoint bottomRight = CGPointMake(bottomRightX, bottomRightY);
        
        Vector *normal = [[[Vector alloc] init] autorelease];
        Vector *normal1 = [[[Vector alloc] init] autorelease];
        Vector *normal2 = [[[Vector alloc] init] autorelease];
        Vector *N = [[[Vector alloc] init] autorelease];
        [N initializeVectorX:0 andY:0];
        
        isPastTopLine = [self pastLine:topLine];
        bool isNearTopLine = [self nearLine:topLine];
        float collidedWithTop = [self collideWithLineF:topLine];
        float collidedWithBottom = [self collideWithLineF:bottomLine];
        float collidedWithLeft = [self collideWithLineF:leftLine];
        float collidedWithRight = [self collideWithLineF:rightLine];
        float collidedWithTopLeft = [self collideWithVertexF:topLeft];
        float collidedWithTopRight = [self collideWithVertexF:topRight];
        float collidedWithBottomLeft = [self collideWithVertexF:bottomLeft];
        float collidedWithBottomRight = [self collideWithVertexF:bottomRight];

        float shortestDistance = FLT_MAX;
        if (collidedWithTop < shortestDistance && collidedWithTop > 0)
            shortestDistance = collidedWithTop;
        if (collidedWithBottom < shortestDistance && collidedWithBottom > 0)
            shortestDistance = collidedWithBottom;
        if (collidedWithLeft < shortestDistance && collidedWithLeft > 0)
            shortestDistance = collidedWithLeft;
        if (collidedWithRight < shortestDistance && collidedWithRight > 0)
            shortestDistance = collidedWithRight;
        if (collidedWithTopLeft < shortestDistance && collidedWithTopLeft > 0)
            shortestDistance = collidedWithTopLeft;
        if (collidedWithTopRight < shortestDistance && collidedWithTopRight > 0)
            shortestDistance = collidedWithTopRight;
        if (collidedWithBottomLeft < shortestDistance && collidedWithBottomLeft > 0)
            shortestDistance = collidedWithBottomLeft;
        if (collidedWithBottomRight < shortestDistance && collidedWithBottomRight > 0)
            shortestDistance = collidedWithBottomRight;
        if (shortestDistance != FLT_MAX || shortestDistance!=-1)
            colPackage->state == COLLISION_BOUNCE;
            
        if (isPastTopLine && (shortestDistance != FLT_MAX || shortestDistance!=-1))
        {
            Vector *I = [[[Vector alloc] init] autorelease];
            [I initializeVectorX:vel->x andY:vel->y];
            Vector *negativeI = [[[Vector alloc] init] autorelease];
            [negativeI initializeVectorX:-vel->x andY:-vel->y];
            colPackage->state = COLLISION_BOUNCE;
            CGPoint p1 = CGPointMake( topLine->p1.x/r, topLine->p1.y/r);
            CGPoint p2 = CGPointMake( topLine->p2.x/r, topLine->p2.y/r);
            [slidingLine initializeLineWithPoint1:p1 andPoint2:p2];
            normal = [topLine normal];
            colPackage->collidedObj = d;
            foundCollision = true;
            //colPackage->foundCollision = true;
            slidingLine->normal = normal;
            [normal normalize];
            N = [normal multiply:[negativeI dotProduct:normal]];
            bounceVel = [[N multiply:2] add:I];
            // initVel = bounceVel; will be done in bounceoffdrum
            [bounceVel normalize];
            bounceVel = [bounceVel multiply:vel.length];
        }
        else if (collidedWithTopLeft == shortestDistance)
        {
            [self collideWithVertex:topLeft];
            Vector *I = [[[Vector alloc] init] autorelease];
            [I initializeVectorX:vel->x andY:vel->y];
            Vector *negativeI = [[[Vector alloc] init] autorelease];
            
            [negativeI initializeVectorX:-I->x andY:-I->y];
           
            Vector *topLeftVector = [[[Vector alloc] init] autorelease];
            [topLeftVector initializeVectorX:topLeft.x andY:topLeft.y];
              
            normal = [self->pos subtract:topLeftVector];
            [normal normalize];
            double scaler = [negativeI dotProduct:normal];
            if (scaler < 0)
                scaler = -scaler;
            // projection of the normal along I (initial velocity vector going towards the line)
            N = [normal multiply:scaler];
            [I normalize];
            bounceVel = [[N multiply:2] add:I];
                          
            [bounceVel normalize];
            bounceVel = [normal multiply:vel.length];
            foundCollision = true;
            slidingLine->normal = normal;
        }
        else if (collidedWithTopRight == shortestDistance)
        {
            [self collideWithVertex:topRight];
            Vector *I = [[[Vector alloc] init] autorelease];
            Vector *negativeI = [[[Vector alloc] init] autorelease];
            
            double Ix = vel->x;
            double Iy = vel->y;
            
            [I initializeVectorX:Ix andY:Iy];
            [negativeI initializeVectorX:-Ix andY:-Iy];
                     
            Vector *topRightVector = [[[Vector alloc] init] autorelease];
            [topRightVector initializeVectorX:topRight.x andY:topRight.y];
            
            normal = [self->pos subtract:topRightVector];
            [normal normalize];
            double scaler = [negativeI dotProduct:normal];
            if (scaler < 0)
                scaler = -scaler;
            // projection of the normal along I (initial velocity vector going towards the line)
            N = [normal multiply:scaler];
            [I normalize];
            bounceVel = [[N multiply:2] add:I];

            [bounceVel normalize];
            bounceVel = [bounceVel multiply:vel.length];
            foundCollision = true;
            slidingLine->normal = normal;
        }
        else if (collidedWithBottomLeft == shortestDistance)//([self collideWithVertex:bottomLeft])
        {
            [self collideWithVertex:bottomLeft];
            double Ix = vel->x;
            double Iy = vel->y;
            Vector *I = [[[Vector alloc] init] autorelease];
     
            Vector *negativeI = [[[Vector alloc] init] autorelease];
            [I initializeVectorX:Ix andY:Iy];
            [negativeI initializeVectorX:-Ix andY:-Iy];
          
            Vector *bottomLeftVector = [[[Vector alloc] init] autorelease];
            [bottomLeftVector initializeVectorX:bottomLeft.x andY:bottomLeft.y];
           
            normal = [self->pos subtract:bottomLeftVector];
            [normal normalize];
            // projection of the normal along I (initial velocity vector going towards the line)
            double scaler = [negativeI dotProduct:normal];
            if (scaler < 0)
                scaler = -scaler;
            N = [normal multiply:scaler];
            [I normalize];
            bounceVel = [[N multiply:2] add:I];
            [bounceVel normalize];
            bounceVel = [bounceVel multiply:vel.length];
            foundCollision = true;
            slidingLine->normal = normal;
        }
        else if (collidedWithBottomRight == shortestDistance)//([self collideWithVertex:bottomRight])
        {
            [self collideWithVertex:bottomRight];
            double Ix = vel->x;//bottomRight.x - pos->x;
            double Iy = vel->y; //bottomRight.y - pos->y;
            Vector *I = [[[Vector alloc] init] autorelease];
            Vector *negativeI = [[[Vector alloc] init] autorelease];
            [I initializeVectorX:Ix andY:Iy];
            [negativeI initializeVectorX:-Ix andY:-Iy];
           
            Vector *bottomRightVector = [[[Vector alloc] init] autorelease];
            [bottomRightVector initializeVectorX:bottomRight.x andY:bottomRight.y];
            
            normal = [self->pos subtract:bottomRightVector];
            [normal normalize];
            double scaler = [negativeI dotProduct:normal];
            if (scaler < 0)
                scaler = -scaler;
            // projection of the normal along I (initial velocity vector going towards the line)
            N = [normal multiply:scaler];
            [I normalize];
            bounceVel = [[N multiply:2] add:I];
            [bounceVel normalize];
            bounceVel = [bounceVel multiply:vel.length];
            foundCollision = true;
            slidingLine->normal = normal;
        }
        else if (collidedWithRight == shortestDistance)//([self collideWithLine:rightLine])
        {
            [self collideWithLine:rightLine];
            Vector *I = [[[Vector alloc] init] autorelease];
            [I initializeVectorX:vel->x andY:vel->y];
            Vector *negativeI = [[[Vector alloc] init] autorelease];
            [negativeI initializeVectorX:-vel->x andY:-vel->y];
            if ([rightLine isFrontFacingTo:vel])
            {
                normal = [rightLine normal];
            }
            else
            {
                [normal initializeVectorX:-rightLine->normal->x andY: -rightLine->normal->y];
            }
            [normal normalize];
            // projection of the normal along I (initial velocity vector going towards the line)
            N = [normal multiply:[negativeI dotProduct:normal]];
            bounceVel = [[N multiply:2] add:I];
            [bounceVel normalize];
            bounceVel = [bounceVel multiply:vel.length];
            foundCollision = true;
            slidingLine->normal = normal;
        }
        else if (collidedWithLeft == shortestDistance)//([self collideWithLine:leftLine])
        {
            [self collideWithLine:leftLine];
            Vector *I = [[[Vector alloc] init] autorelease];
            [I initializeVectorX:vel->x andY:vel->y];
            Vector *negativeI = [[[Vector alloc] init] autorelease];
            [negativeI initializeVectorX:-vel->x andY:-vel->y];
            if ([leftLine isFrontFacingTo:vel])
            {
                normal = [leftLine normal];
            }
            else
            {
                [normal initializeVectorX:-leftLine->normal->x andY: -leftLine->normal->y];
            }
            [normal normalize];
            // projection of the normal along I (initial velocity vector going towards the line)
            N = [normal multiply:[negativeI dotProduct:normal]];
            bounceVel = [[N multiply:2] add:I];
            [bounceVel normalize];
            bounceVel = [bounceVel multiply:vel.length];
            foundCollision = true;
            slidingLine->normal = normal;
        }
        else if (collidedWithTop==shortestDistance || collidedWithBottom== shortestDistance)// || isNearTopLine)
        {
            
            Vector *I = [[[Vector alloc] init] autorelease];
            [I initializeVectorX:vel->x andY:vel->y];
            Vector *negativeI = [[[Vector alloc] init] autorelease];
            [negativeI initializeVectorX:-vel->x andY:-vel->y];
            /*if (vel->y < 0 && collidedWithTop == shortestDistance)
            {
                [self collideWithLine:topLine];
                if ([topLine isFrontFacingTo:vel])
                {
                    normal = [topLine normal];
                }
                else
                {
                    [normal initializeVectorX:-topLine->normal->x andY: -topLine->normal->y];
                }
            }
            else if (vel->y > 0 && collidedWithBottom == shortestDistance)
            {
                [self collideWithLine:bottomLine];
                if ([bottomLine isFrontFacingTo:vel])
                {
                    normal = [bottomLine normal];
                }
                else
                {
                   [normal initializeVectorX:-bottomLine->normal->x andY: -bottomLine->normal->y];
                }
            }
            else */if (collidedWithTop == shortestDistance)// || isNearTopLine)
            {
                if (collidedWithTop == shortestDistance)
                {
                    [self collideWithLine:topLine];
                    if ([topLine isFrontFacingTo:vel])
                    {
                        normal = [topLine normal];
                    }
                    else
                    {
                        [normal initializeVectorX:-topLine->normal->x andY: -topLine->normal->y];
                    }
                }
                else
                {
                    normal = [topLine normal];
                }
                slidingLine->p1 = CGPointMake( topLine->p1.x/r, topLine->p1.y/r);
                slidingLine->p2 = CGPointMake( topLine->p2.x/r, topLine->p2.y/r);
                colPackage->state = COLLISION_BOUNCE;
            }
            else if (collidedWithBottom == shortestDistance)
            {
                [self collideWithLine:bottomLine];
                if ([bottomLine isFrontFacingTo:vel])
                {
                    normal = [bottomLine normal];
                }
                else
                {
                    [normal initializeVectorX:-bottomLine->normal->x andY: -bottomLine->normal->y];
                }
            }
            // projection of the normal along I (initial velocity vector going towards the line)
            [normal normalize];
            N = [normal multiply:[negativeI dotProduct:normal]];
            bounceVel = [[N multiply:2] add:I];
            // initVel = bounceVel; will be done in bounceoffdrum
            [bounceVel normalize];
            bounceVel = [bounceVel multiply:vel.length];
            //if (collidedWithTop == shortestDistance && isNearTopLine)
                foundCollision = true;
            
            slidingLine->normal = normal;
            //    [slidingLine setNormal:normal];
        }
    }
        
    return foundCollision;
}

- (bool) checkFlipper: (Flipper*) f
{
    float topLeftX, topLeftY, topRightX, topRightY;
    float bottomLeftX, bottomLeftY, bottomRightX, bottomRightY;
    CGPoint topLeftPt,topRightPt,bottomLeftPt,bottomRightPt;
    Line *topLine = [[[Line alloc] init] autorelease];
    Line *bottomLine = [[[Line alloc] init] autorelease];
    Line *leftLine = [[[Line alloc] init] autorelease];
    Line *rightLine = [[[Line alloc] init] autorelease];
    double radAngle = f->angle*M_PI/180.0f;
    bool foundCollision = false;
    double scaler; // for dot product
    while (f->angle < 0 || f->angle > 360) {
        if (f->angle < 0)
            f->angle+=360;
        else if (f->angle >360)
            f->angle-=360;
    }
    
    // get top left of rectangle
    topLeftX = f->x - cos(radAngle)*f->sprite.width/2 + cos(radAngle+M_PI_2)*f->sprite.height/2;
    topLeftY = f->y - sin(radAngle)*f->sprite.width/2 + sin(radAngle+M_PI_2)*f->sprite.height/2;
    topLeftPt = CGPointMake(topLeftX, topLeftY);
    // get top right of rectangle
    printf("top right radangle: %f \n", radAngle);
    topRightX = f->x + cos(radAngle)*f->sprite.width/2 + cos(radAngle+M_PI_2)*f->sprite.height/2;
    topRightY = f->y + sin(radAngle)*f->sprite.width/2 + sin(radAngle+M_PI_2)*f->sprite.height/2;
    topRightPt = CGPointMake(topRightX,topRightY);
    // get bottom left of rectangle
    bottomLeftX = f->x - cos(radAngle)*f->sprite.width/2 + cos(radAngle-M_PI_2)*f->sprite.height/2;
    bottomLeftY = f->y - sin(radAngle)*f->sprite.width/2 + sin(radAngle-M_PI_2)*f->sprite.height/2;
    bottomLeftPt = CGPointMake(bottomLeftX, bottomLeftY);
    // get bottom right of rectangle
    bottomRightX = f->x + cos(radAngle)*f->sprite.width/2 + cos(radAngle-M_PI_2)*f->sprite.height/2;
    bottomRightY = f->y + sin(radAngle)*f->sprite.width/2 + sin(radAngle-M_PI_2)*f->sprite.height/2;
    bottomRightPt = CGPointMake(bottomRightX,bottomRightY);
    
    topLine = [topLine initializeLineWithPoint1:topLeftPt andPoint2:topRightPt];
    bottomLine = [bottomLine initializeLineWithPoint1:bottomRightPt andPoint2:bottomLeftPt];
    leftLine = [leftLine initializeLineWithPoint1:bottomLeftPt andPoint2:topLeftPt];
    rightLine = [rightLine initializeLineWithPoint1:topRightPt andPoint2:bottomRightPt];
    
    
    if (!colPackage->foundCollision)
    {
        colPackage->state = COLLISION_NONE;
        CGPoint topLeft = CGPointMake(topLeftX, topLeftY);
        CGPoint topRight = CGPointMake(topRightX, topRightY);
        CGPoint bottomLeft = CGPointMake(bottomLeftX, bottomLeftY);
        CGPoint bottomRight = CGPointMake(bottomRightX, bottomRightY);
        
        Vector *normal = [[[Vector alloc] init] autorelease];
        Vector *normal1 = [[[Vector alloc] init] autorelease];
        Vector *normal2 = [[[Vector alloc] init] autorelease];
        Vector *N = [[[Vector alloc] init] autorelease];
        
        isPastTopLine = [self pastLine:topLine];
        isPastBottomLine = [self pastLine:bottomLine];
        isPastLeftLine = [self pastLine:leftLine];
        isPastRightLine = [self pastLine:rightLine];
        bool collidedWithTop = [self collideWithLine:topLine]; // self->y < 910 && self->y > 100
        bool collidedWithBottom = [self collideWithLine:bottomLine];
        float collidedWithLeft = [self collideWithLineF:leftLine];
        float collidedWithRight = [self collideWithLineF:rightLine];
        float collidedWithTopLeft = [self collideWithVertexF:topLeft];
        float collidedWithTopRight = [self collideWithVertexF:topRight];
        float collidedWithBottomLeft = [self collideWithVertexF:bottomLeft];
        float collidedWithBottomRight = [self collideWithVertexF:bottomRight];
        float shortestDistance = FLT_MAX;
        if (collidedWithTop < shortestDistance && collidedWithTop > 0)
            shortestDistance = collidedWithTop;
        if (collidedWithBottom < shortestDistance && collidedWithBottom > 0)
            shortestDistance = collidedWithBottom;
        if (collidedWithLeft < shortestDistance && collidedWithLeft > 0)
            shortestDistance = collidedWithLeft;
        if (collidedWithRight < shortestDistance && collidedWithRight > 0)
            shortestDistance = collidedWithRight;
        if (collidedWithTopLeft < shortestDistance && collidedWithTopLeft > 0)
            shortestDistance = collidedWithTopLeft;
        if (collidedWithTopRight < shortestDistance && collidedWithTopRight > 0)
            shortestDistance = collidedWithTopRight;
        if (collidedWithBottomLeft < shortestDistance && collidedWithBottomLeft > 0)
            shortestDistance = collidedWithBottomLeft;
        if (collidedWithBottomRight < shortestDistance && collidedWithBottomRight > 0)
            shortestDistance = collidedWithBottomRight;
        if (shortestDistance != FLT_MAX || shortestDistance!=-1)
            colPackage->state == COLLISION_BOUNCE;
        
        if (isPastTopLine  &&
            (shortestDistance != FLT_MAX || shortestDistance!=-1))
        {
            Vector *I = [[[Vector alloc] init] autorelease];
            [I initializeVectorX:vel->x andY:vel->y];
            Vector *negativeI = [[[Vector alloc] init] autorelease];
            [negativeI initializeVectorX:-vel->x andY:-vel->y];
            colPackage->state = COLLISION_BOUNCE;
            CGPoint p1 = CGPointMake( topLine->p1.x/r, topLine->p1.y/r);
            CGPoint p2 = CGPointMake( topLine->p2.x/r, topLine->p2.y/r);
            [slidingLine initializeLineWithPoint1:p1 andPoint2:p2];
            normal = [topLine normal];
            colPackage->collidedObj = f;
            foundCollision = true;
            slidingLine->normal = normal;
            [normal normalize];
            N = [normal multiply:[negativeI dotProduct:normal]];
            bounceVel = [[N multiply:2] add:I];
            // initVel = bounceVel; will be done in bounceoffdrum
            if (bounceVel->y < 0.000000001)
            {
                int roundedBounceVelY = (int)(10000000000 * bounceVel->y);
                bounceVel->y = roundedBounceVelY/10000000000.0f;
            }
            [bounceVel normalize]; // bounceVel->y E-7 need to round
            bounceVel = [bounceVel multiply:vel.length];
        }
        else if ( collidedWithTop == shortestDistance || collidedWithBottom == shortestDistance)
        {
            Vector *I = [[[Vector alloc] init] autorelease];
            [I initializeVectorX:vel->x andY:vel->y];
            Vector *negativeI = [[[Vector alloc] init] autorelease];
            [negativeI initializeVectorX:-vel->x andY:-vel->y];
           /* if (collidedWithTop == shortestDistance && vel->y < 0)
            {
                [self collideWithLine:topLine];
                if ([topLine isFrontFacingTo:vel])
                {
                    normal = [topLine normal];
                }
                else
                {
                    [normal initializeVectorX:-topLine->normal->x andY: -topLine->normal->y];
                }
            }
            else if (collidedWithBottom == shortestDistance && vel->y > 0)
            {
                [self collideWithLine:bottomLine];
                if ([bottomLine isFrontFacingTo:vel])
                {
                    normal = [bottomLine normal];
                }
                else
                {
                    [normal initializeVectorX:-bottomLine->normal->x andY: -bottomLine->normal->y];
                }
            }
            else*/ if (collidedWithTop == shortestDistance)
            {
                [self collideWithLine:topLine];
                if ([topLine isFrontFacingTo:vel])
                {
                    normal = [topLine normal];
                }
                else
                {
                    [normal initializeVectorX:-topLine->normal->x andY: -topLine->normal->y];
                }
            }
            else if (collidedWithBottom == shortestDistance)
            {
                [self collideWithLine:bottomLine];
                //if ([bottomLine isFrontFacingTo:vel])
                //{
                    normal = [bottomLine normal];
                //}
               //else
                //{
                   // [normal initializeVectorX:-bottomLine->normal->x andY: -bottomLine->normal->y];
               // }
            }
            [normal normalize];
            // projection of the normal along I (initial velocity vector going towards the line)
            N = [normal multiply:[negativeI dotProduct:normal]];
            bounceVel = [[N multiply:2] add:I];
            [bounceVel normalize];
            bounceVel = [bounceVel multiply:vel.length];
            foundCollision = true;
            slidingLine->normal = normal;
            
        }
        else if (collidedWithTopLeft == shortestDistance)
        {
            [self collideWithVertex:topLeft];
            Vector *I = [[[Vector alloc] init] autorelease];
            Vector *negativeI = [[[Vector alloc] init] autorelease];
            double Ix = vel->x;
            double Iy = vel->y;
            
            [I initializeVectorX:Ix andY:Iy];
            [negativeI initializeVectorX:-Ix andY:-Iy];
            
            Vector *topLeftVector = [[[Vector alloc] init] autorelease];
            [topLeftVector initializeVectorX:topLeft.x andY:topLeft.y];
               
            normal = [self->pos subtract:topLeftVector];
            [normal normalize];
            scaler = [negativeI dotProduct:normal];
            if (scaler < 0)
               scaler = -scaler;
            // projection of the normal along I (initial velocity vector going towards the line)
            N = [normal multiply:scaler];
            [I normalize];
            bounceVel = [[N multiply:2] add:I];

            [bounceVel normalize];
            bounceVel = [bounceVel multiply:vel.length];
            slidingLine->normal = normal;
            foundCollision = true;
        }
        else if (collidedWithTopRight == shortestDistance)
        {
            [self collideWithVertex:topRight];
            Vector *I = [[[Vector alloc] init] autorelease];
            Vector *negativeI = [[[Vector alloc] init] autorelease];
            double Ix = vel->x;//topRight.x - pos->x;
            double Iy = vel->y;//topRight.y - pos->y;
            
            [I initializeVectorX:Ix andY:Iy];
            [negativeI initializeVectorX:-Ix andY:-Iy];
                    
            Vector *topRightVector = [[[Vector alloc] init] autorelease];
            [topRightVector initializeVectorX:topRight.x andY:topRight.y];
            
            normal = [self->pos subtract:topRightVector];
            [normal normalize];
            scaler = [negativeI dotProduct:normal];
            if (scaler < 0)
               scaler = -scaler;
            // projection of the normal along I (initial velocity vector going towards the line)
            N = [normal multiply:scaler];
            [I normalize];
            bounceVel = [[N multiply:2] add:I];
               
            [bounceVel normalize];
            bounceVel = [bounceVel multiply:vel.length];
            slidingLine->normal = normal;
            foundCollision = true;
        }
        else if (collidedWithBottomLeft == shortestDistance)
        {
            [self collideWithVertex:bottomLeft];
            Vector *I = [[[Vector alloc] init] autorelease];
            Vector *negativeI = [[[Vector alloc] init] autorelease];
            double Ix = vel->x;//bottomLeft.x - pos->x;
            double Iy = vel->y;//bottomLeft.y - pos->y;
            
            [I initializeVectorX:Ix andY:Iy];
            [negativeI initializeVectorX:-Ix andY:-Iy];
           
            Vector *bottomLeftVector = [[[Vector alloc] init] autorelease];
            [bottomLeftVector initializeVectorX:bottomLeft.x andY:bottomLeft.y];
            
            normal = [self->pos subtract:bottomLeftVector];
            scaler = [negativeI dotProduct:normal];
            if (scaler < 0)
              scaler = -scaler;
            [normal normalize];
            // projection of the normal along I (initial velocity vector going towards the line)
            N = [normal multiply:scaler];
            //[I normalize];
            bounceVel = [[N multiply:2] add:I];//negativeI;
            [bounceVel normalize];
            bounceVel = [bounceVel multiply:vel.length];
            slidingLine->normal = normal;
            foundCollision = true;
        }
        else if (collidedWithBottomRight == shortestDistance)
        {
            [self collideWithVertex:bottomRight];
            Vector *I = [[[Vector alloc] init] autorelease];
            Vector *negativeI = [[[Vector alloc] init] autorelease];
            double Ix = vel->x;
            double Iy = vel->y;
            [I initializeVectorX:Ix andY:Iy];
            [negativeI initializeVectorX:-Ix andY:-Iy];
           
            Vector *bottomRightVector = [[[Vector alloc] init] autorelease];
            [bottomRightVector initializeVectorX:bottomRight.x andY:bottomRight.y];
            
            normal = [self->pos subtract:bottomRightVector];
            scaler = [negativeI dotProduct:normal];
            if (scaler < 0)
              scaler = -scaler;
            [normal normalize];
            // projection of the normal along I (initial velocity vector going towards the line)
            N = [normal multiply:scaler];
            //[I normalize];
            bounceVel = [[N multiply:2] add:I];
            [bounceVel normalize];
            bounceVel = [bounceVel multiply:vel.length];
            slidingLine->normal = normal;
            foundCollision = true;
        }
        else if (collidedWithRight == shortestDistance)
        {
            [self collideWithLine:rightLine];
            Vector *I = [[[Vector alloc] init] autorelease];
            [I initializeVectorX:vel->x andY:vel->y];
            Vector *negativeI = [[[Vector alloc] init] autorelease];
            [negativeI initializeVectorX:-vel->x andY:-vel->y];
            //if ([rightLine isFrontFacingTo:vel])
            //{
                normal = [rightLine normal];
            //}
           // else
            //{
             //   [normal initializeVectorX:-rightLine->normal->x andY: -rightLine->normal->y];
           // }
            [normal normalize];
            // projection of the normal along I (initial velocity vector going towards the line)
            N = [normal multiply:[negativeI dotProduct:normal]];
            bounceVel = [[N multiply:2] add:I];
            [bounceVel normalize];
            bounceVel = [bounceVel multiply:vel.length];
            foundCollision = true;
            slidingLine->normal = normal;
        }
        else if (collidedWithLeft == shortestDistance)
        {
            ([self collideWithLine:leftLine]);
            Vector *I = [[[Vector alloc] init] autorelease];
            [I initializeVectorX:vel->x andY:vel->y];
            Vector *negativeI = [[[Vector alloc] init] autorelease];
            [negativeI initializeVectorX:-vel->x andY:-vel->y];
           // if ([leftLine isFrontFacingTo:vel])
           // {
                normal = [leftLine normal];
           // }
            //else
            //{
            //    [normal initializeVectorX:-leftLine->normal->x andY: -leftLine->normal->y];
           // }
            [normal normalize];
            // projection of the normal along I (initial velocity vector going towards the line)
            N = [normal multiply:[negativeI dotProduct:normal]];
            bounceVel =[[N multiply:2] add:I];
            [bounceVel normalize];
            bounceVel = [bounceVel multiply:vel.length];
            foundCollision = true;
            slidingLine->normal = normal;
        }
        
    }
    
    return foundCollision;
}

- (void) update
{
    //NSNumber *numX, *numY;
    //float M11, M12;
   
   //time = lerp;
    //time = tick;
    
    
    
    //d[self collideAndSlide];
    /*[self fall:lerp];
    if (!colPackage->foundCollision || colPackage->isSlidingOff)
    {
        
        cheeseSprite.x = x - cheeseSprite.width/2;
        cheeseSprite.y = y - cheeseSprite.height/2;
        pos->x = x;
        pos->y = y;
        colPackage->R3Position = pos;
    }*/

}
-(void) bounceOffTopWall
{
    Vector *N = [[[Vector alloc] init] autorelease];
    Vector *normal = [[[Vector alloc] init] autorelease];
    Vector *I = [[[Vector alloc] init] autorelease];
    [I initializeVectorX:vel->x andY:vel->y];
    Vector *negativeI = [[[Vector alloc] init] autorelease];
    [negativeI initializeVectorX:-vel->x andY:-vel->y];
    [normal initializeVectorX:0 andY:-1];
    [normal normalize];
    double scaler = [negativeI dotProduct:normal];
    if (scaler < 0)
     scaler = -scaler;
    // projection of the normal along I (initial velocity vector going towards the line)
    N = [normal multiply:scaler];
    [I normalize];
    bounceVel = [[N multiply:2] add:I];
    [bounceVel normalize];
    bounceVel = [[bounceVel multiply:vel.length] add:gravity];
    colPackage->foundCollision = true;
    self->pos->x = 35;
    self->x = 35;
    [initVel initializeVectorX:bounceVel->x andY:bounceVel->y];
    //vel->x = 0;
    //vel->y = 0;
    colPackage->state = COLLISION_BOUNCE;
    slidingLine->normal = normal;}

- (void) bounceOffLeftWall
{
    Vector *N = [[[Vector alloc] init] autorelease];
    Vector *normal = [[[Vector alloc] init] autorelease];
    Vector *I = [[[Vector alloc] init] autorelease];
    [I initializeVectorX:vel->x andY:vel->y];
    Vector *negativeI = [[[Vector alloc] init] autorelease];
    [negativeI initializeVectorX:-vel->x andY:-vel->y];
    [normal initializeVectorX:1 andY:0];
    [normal normalize];
    double scaler = [negativeI dotProduct:normal];
    if (scaler < 0)
        scaler = -scaler;
    // projection of the normal along I (initial velocity vector going towards the line)
    N = [normal multiply:scaler];
    [I normalize];
    bounceVel = [[N multiply:2] add:I];
    [bounceVel normalize];
    bounceVel = [[bounceVel multiply:vel.length] add:gravity];
    bounceVel = [bounceVel multiply:0.5];
    colPackage->foundCollision = true;
    self->pos->x = 35;
    self->x = 35;
    [initVel initializeVectorX:bounceVel->x andY:bounceVel->y];
   // t = 0;
    colPackage->state = COLLISION_BOUNCE;
    slidingLine->normal = normal;
}

- (void) bounceOffRightWall
{
    Vector *N = [[[Vector alloc] init] autorelease];
    Vector *normal = [[[Vector alloc] init] autorelease];
    Vector *I = [[[Vector alloc] init] autorelease];
    [I initializeVectorX:vel->x andY:vel->y];
    Vector *negativeI = [[[Vector alloc] init] autorelease];
    [negativeI initializeVectorX:-vel->x andY:-vel->y];
    [normal initializeVectorX:-1 andY:0];
    [normal normalize];
    double scaler = [negativeI dotProduct:normal];
    if (scaler < 0)
        scaler = -scaler;
    // projection of the normal along I (initial velocity vector going towards the line)
    N = [normal multiply:scaler];
    [I normalize];
    bounceVel = [[N multiply:2] add:I];
    [bounceVel normalize];
    bounceVel = [[bounceVel multiply:vel.length] add:gravity];
    bounceVel = [bounceVel multiply:0.5];
    colPackage->foundCollision = true;
    [initVel initializeVectorX:bounceVel->x andY:bounceVel->y];
   // t = 0;
    colPackage->state = COLLISION_BOUNCE;
    slidingLine->normal = normal;
}

- (void) bounceOffDrum
{
    if (colPackage->foundCollision)
    {
      //  pos = colPackage->R3Position;
      //  initVel->x = bounceVel->x;
       // initVel->y = bounceVel->y;
        
        [initVel initializeVectorX:bounceVel->x andY:bounceVel->y];
        //initVel = [initVel add:gravityForce->a];
        //initVel = [initVel add:normalForce->a];
      //  t = 0;
        cheeseSprite.rotation +=1;
        //colPackage->foundCollision = false;
    }
}

- (void) bounceOffFlipper
{
    if (colPackage->foundCollision)
    {
       
        [initVel initializeVectorX:bounceVel->x andY:bounceVel->y];
        colPackage->state = COLLISION_BOUNCE;
      //  t = 0;
        
        cheeseSprite.rotation +=1;
        //colPackage->foundCollision = false;
    }
}

- (void) bounceOffTeeterTotter
{
    initVel->x = bounceVel->x;
    initVel->y = bounceVel->y;
 //   t = 0;

}

- (void) slideOffTeeterTotter:(TeeterTotter *)totter
{
    initVel->x = 0;
    initVel->y = 0;
//  totter->angularVelocity+=1;
   /* if (totter->angle == 0)
        totter->angle = 360;
    if (pos->x > totter->x && ((totter->angle > 316 && totter->angle <= 360) || (totter->angle < 44 && totter->angle >= 0)))
    {
        totter->angle-=totter->angularVelocity;
    }
    else
    {
        if (totter->angle == 360)
            totter->angle = 0;
        if (pos->x < totter->x && ((totter->angle < 44 && totter->angle >= 0) || (totter->angle > 316 && totter->angle <= 360)))
        {
            totter->angle+=totter->angularVelocity;
        }
    }
    NSLog(@"totter angle: %f", totter->angularVelocity);
    double radAngle = totter->angle*M_PI/180.0f;
    double yVal = [vel length]*sin(radAngle);
    NSLog(@"y val: %f", yVal);
    double finalVelY = vel->y - yVal;
    [vel initializeVectorX:vel->x andY:finalVelY];*/
}

- (void) bounceOffGear:(Gear *) gear
{
    initVel->x = bounceVel->x;
    initVel->y = bounceVel->y;
    initVel->length = [initVel length];
   // t = 0;
    cheeseSprite.rotation +=1;
    colPackage->state = COLLISION_BOUNCE;
   // vel = initVel;
     // printf("initial velocity is (%f,%f)\n",initVel->x,initVel->y);
}

- (bool) collideWith: (Mouse*) mouse
{
    if (mouse->mouseSprite->x!=0 && mouse->mouseSprite->y!=0)
    {
        if ( x + r < mouse->mouseSprite->x - mouse->mouseSprite->width/2 )
            return false;
        else if ( x - r > mouse->mouseSprite->x + mouse->mouseSprite->width/2)
            return false;
        if ( y + r < mouse->mouseSprite->y - mouse->mouseSprite->height/4)
            return false;
        else if ( y - r > mouse->mouseSprite->y + mouse->mouseSprite->height/4)
            return false;
    }
    else
        return false;
    return true;
}

- (bool) nearVertex: (CGPoint) pt
{
    Vector *vertex = [[Vector alloc] init];
    [vertex initializeVectorX:pt.x andY:pt.y];
    Vector *distanceVector = [[Vector alloc] init];
    distanceVector = [self->pos subtract:vertex];
    float nearDist = self->r + (veryCloseDistance*self->r);
    return distanceVector.length < nearDist;
}

- (bool) pastVertex:(Vector *)vertex
{
    Vector *distanceVector = [[Vector alloc] init];
    distanceVector = [self->pos subtract:vertex];
    diff = self->r - distanceVector->length;
    diff = diff/self->r;
    return distanceVector->length < self->r;
}

- (bool) pastLine: (Line *)line
{
     Vector *cheeseToP1 = [[Vector alloc] init];
       Vector *pt1 = [[Vector alloc] init];
       Vector *pt2 = [[Vector alloc] init];
       Vector *vecLine = [[Vector alloc] init];
       
       float eSpaceP1X = line->p1.x/r;
       float eSpaceP1Y = line->p1.y/r;
       float eSpaceP2X = line->p2.x/r;
       float eSpaceP2Y = line->p2.y/r;
       CGPoint p1 = CGPointMake(eSpaceP1X, eSpaceP1Y);
       CGPoint p2 = CGPointMake(eSpaceP2X, eSpaceP2Y);
       [pt1 initializeVectorX:eSpaceP1X andY:eSpaceP1Y];
       [pt2 initializeVectorX:eSpaceP2X andY:eSpaceP2Y];
       Line *eLine = [[Line alloc] init];
       [eLine initializeLineWithPoint1:p1 andPoint2:p2];
       float cx = self->x/r;
       float cy = self->y/r;
       [cheeseToP1 initializeVectorX:cx-p1.x andY:cy-p1.y];
       vecLine = [pt2 subtract:pt1];
      // [vecLine normalize];
       float dot = [cheeseToP1 dotProduct:vecLine]/(eLine->length*eLine->length);
       if (dot>1)
           dot = 1;
       if (dot<0)
           dot = 0;
       Vector *closestPt = [[Vector alloc] init];
       float closestX = p1.x + dot * (p2.x - p1.x);
       float closestY = p1.y + dot * (p2.y - p1.y);
       [closestPt initializeVectorX:closestX andY:closestY];
       colPackage->closestPt = closestPt;
       Vector *cheeseToLine = [[Vector alloc] init];
       //lineToCheese = [[Vector alloc] init];
       //[lineToCheese initializeVectorX:0 andY:0];
       float x = closestPt->x - cx;
       float y = closestPt->y - cy;
       [cheeseToLine initializeVectorX:x andY:y];
       float nearDist = 1;// + veryCloseDistance;
       Vector *edge = [[Vector alloc] init];
       [edge initializeVectorX:(p2.x-p1.x) andY:(p2.y-p1.y)];
       float dot2 = [cheeseToLine dotProduct:edge];
       int roundRadius = (int)(10 * (cheeseToLine.length));
       float cheeseRadius = roundRadius/10.0f;
       printf("near line radius: %f ",cheeseRadius);
       if (cheeseToLine.length <= nearDist && dot2 <= veryCloseDistance) // perpendicular = 0
       {
           diff = nearDist - cheeseToLine.length;
        //   lineToCheese = [cheeseToLine multiply:-1];
           
           return true;
       }
       return false;
    
}


- (bool) nearLine:(Line *)line
{
    Vector *cheeseToP1 = [[Vector alloc] init];
    Vector *pt1 = [[Vector alloc] init];
    Vector *pt2 = [[Vector alloc] init];
    Vector *vecLine = [[Vector alloc] init];
    
    float eSpaceP1X = line->p1.x/r;
    float eSpaceP1Y = line->p1.y/r;
    float eSpaceP2X = line->p2.x/r;
    float eSpaceP2Y = line->p2.y/r;
    CGPoint p1 = CGPointMake(eSpaceP1X, eSpaceP1Y);
    CGPoint p2 = CGPointMake(eSpaceP2X, eSpaceP2Y);
    [pt1 initializeVectorX:eSpaceP1X andY:eSpaceP1Y];
    [pt2 initializeVectorX:eSpaceP2X andY:eSpaceP2Y];
    Line *eLine = [[Line alloc] init];
    [eLine initializeLineWithPoint1:p1 andPoint2:p2];
    float cx = self->x/r;
    float cy = self->y/r;
    [cheeseToP1 initializeVectorX:cx-p1.x andY:cy-p1.y];
    vecLine = [pt2 subtract:pt1];
   // [vecLine normalize];
    float dot = [cheeseToP1 dotProduct:vecLine]/(eLine->length*eLine->length);
    if (dot>1)
        dot = 1;
    if (dot<0)
        dot = 0;
    Vector *closestPt = [[Vector alloc] init];
    float closestX = p1.x + dot * (p2.x - p1.x);
    float closestY = p1.y + dot * (p2.y - p1.y);
    [closestPt initializeVectorX:closestX andY:closestY];
    colPackage->closestPt = closestPt;
    Vector *cheeseToLine = [[Vector alloc] init];
    float x = closestPt->x - cx;
    float y = closestPt->y - cy;
    [cheeseToLine initializeVectorX:x andY:y];
    float nearDist = 1 + veryCloseDistance;
    Vector *edge = [[Vector alloc] init];
    [edge initializeVectorX:(p2.x-p1.x) andY:(p2.y-p1.y)];
    float dot2 = [cheeseToLine dotProduct:edge];
    int roundRadius = (int)(10 * (cheeseToLine.length));
    float cheeseRadius = roundRadius/10.0f;
    printf("near line radius: %f ",cheeseRadius);
    if (cheeseToLine.length <= nearDist && dot2 <= veryCloseDistance) // perpendicular = 0
        return true;
    return false;
}

- (bool) collideWithLine: (Line *)line
{
   // NSLog(@"Checking line from (%f,%f) to (%f,%f)", line->p1.x, line->p1.y, line->p2.x, line->p2.y);
    
    Vector *positionInESpace; // position in espace
    float f0;
    double numerator, denominator;
    double M11, M12;
    NSNumber *numX, *numY;
    
    positionInESpace = [[Vector alloc] init];
    velocityInESpace = [[Vector alloc] init];
    
    //double eVx = (colPackage->velocity->x+acceleration->x)/r;
    //double eVy = (colPackage->velocity->y+acceleration->y)/r;
    double eVx = (colPackage->velocity->x)/r;
    double eVy = (colPackage->velocity->y)/r;
    [positionInESpace initializeVectorX:colPackage->basePoint->x andY:colPackage->basePoint->y];
    [velocityInESpace initializeVectorX:eVx andY:eVy];
    
    Matrix *CBM = [[[Matrix alloc] init] autorelease]; // multiply this to get into eSpace
    NSNumber *num11 = [NSNumber numberWithDouble:1/r];
    NSNumber *num12 = [NSNumber numberWithDouble:0.0];
    NSNumber *num21 = [NSNumber numberWithDouble:0.0];
    NSNumber *num22 = [NSNumber numberWithDouble:1/r];
    CBM = [CBM initWithWidth:2 andHeight:2];
    [[CBM->M objectAtIndex:0] addObject:num11];
    [[CBM->M objectAtIndex:0] addObject:num12];
    [[CBM->M objectAtIndex:1] addObject:num21];
    [[CBM->M objectAtIndex:1] addObject:num22];
    
    float detCBM = [num11 floatValue] * [num22 floatValue] - [num12 floatValue] * [num21 floatValue];
    Matrix *CBMInverse = [[Matrix alloc] init]; // multiply this to get back to R2 space
    CBMInverse = [CBMInverse initWithWidth:2 andHeight:2];
    CBMInverse = [Matrix scale:(1/detCBM) multiplyMatrix:CBM];
    
    /*Matrix *CBM2 = [[[Matrix alloc] init] autorelease]; // multiply this to get into eSpace
    num11 = [NSNumber numberWithDouble:2/3];
    num12 = [NSNumber numberWithDouble:0.0];
    num21 = [NSNumber numberWithDouble:0.0];
    num22 = [NSNumber numberWithDouble:2/3];
    CBM2 = [CBM2 initWithWidth:2 andHeight:2];
    [[CBM2->M objectAtIndex:0] addObject:num11];
    [[CBM2->M objectAtIndex:0] addObject:num12];
    [[CBM2->M objectAtIndex:1] addObject:num21];
    [[CBM2->M objectAtIndex:1] addObject:num22];*/
        
    Vector *p1 = [[Vector alloc] init];
    [p1 initializeVectorX:line->p1.x andY:line->p1.y];
    // convert p1 to espace
    Matrix *matrixP1 = [[[Matrix alloc] init] autorelease];
    matrixP1 = [matrixP1 initWithWidth:2 andHeight:1];
    numX = [NSNumber numberWithFloat:p1->x];
    numY = [NSNumber numberWithFloat:p1->y];
    [[matrixP1->M objectAtIndex:0] addObject:numX];
    [[matrixP1->M objectAtIndex:0] addObject:numY];
    matrixP1 = [Matrix matrixA:matrixP1 multiplyMatrixB:CBM];
   // matrixP1 = [Matrix matrixA:matrixP1 multiplyMatrixB:CBM2];
    M11 = [[[matrixP1->M objectAtIndex:0] objectAtIndex:0] floatValue];
    M12 = [[[matrixP1->M objectAtIndex:0] objectAtIndex:1] floatValue];
    [p1 initializeVectorX:M11 andY:M12];
   // NSLog(@"p1: (%f,%f): ", p1->x, p1->y);

    Vector *p2 = [[[Vector alloc] init] autorelease];
    [p2 initializeVectorX:line->p2.x andY:line->p2.y];
    
    // convert p2 to espace
    Matrix *matrixP2 = [[[Matrix alloc] init] autorelease];
    matrixP2 = [matrixP2 initWithWidth:2 andHeight:1];
    numX = [NSNumber numberWithFloat:p2->x];
    numY = [NSNumber numberWithFloat:p2->y];
    [[matrixP2->M objectAtIndex:0] addObject:numX];
    [[matrixP2->M objectAtIndex:0] addObject:numY];
    matrixP2 = [Matrix matrixA:matrixP2 multiplyMatrixB:CBM];
    M11 = [[[matrixP2->M objectAtIndex:0] objectAtIndex:0] floatValue];
    M12 = [[[matrixP2->M objectAtIndex:0] objectAtIndex:1] floatValue];
    [p2 initializeVectorX:M11 andY:M12];
   // NSLog(@"p2: (%f,%f): ", p2->x, p2->y);
    
    Vector *baseToVertex = [[[Vector alloc] init] autorelease];
    baseToVertex = [p1 subtract:positionInESpace];
    //NSLog(@"baseToVertex: (%f,%f)", baseToVertex->x, baseToVertex->y);
    
    Vector *edge = [[[Vector alloc] init] autorelease];
    edge = [p2 subtract:p1];
   // NSLog(@"edge (x,y): (%f,%f)", edge->x, edge->y);
   // NSLog(@"edge's length: %f", [edge length]);
  //  NSLog(@"edge.length: %f", edge.length);
  //  NSLog(@"baseToVertex's length: %f", [baseToVertex length]);
  //  NSLog(@"edge.baseToVertex: %f", [edge dotProduct:baseToVertex] );
    
    double edgeSquared = [edge length]*[edge length];
    //NSLog(@"edge squared: %f", edgeSquared);
    double A = edgeSquared*(-([velocityInESpace length]*[velocityInESpace length]))+[edge dotProduct:velocityInESpace]*[edge dotProduct:velocityInESpace];
    double B = edgeSquared*(2*([velocityInESpace dotProduct:baseToVertex])) - 2*(([edge dotProduct:velocityInESpace])*([edge dotProduct:baseToVertex]));
    double C = edgeSquared * (1 - [baseToVertex length]*[baseToVertex length]) + ([edge dotProduct:baseToVertex])*([edge dotProduct:baseToVertex]);
    
    x1 = [[NSNumber alloc] init];

    NSLog(@"t: %f", time);
    NSLog(@"vEspace: %f", velocityInESpace->y);
    NSLog(@"v normalized: (%f,%f)", colPackage->normalizedVelocity->x, colPackage->normalizedVelocity->y);

    Line *cheeseLine = [[[Line alloc] init] autorelease];
    Line *boundLine = [[[Line alloc] init] autorelease];
    float max = 1/30.0f;
    //bool quadraticSuccess = [Quadratic getLowestRootA:A andB:B andC:C andMinThreshold:(0) andMaxThreshold:time andRoot:&x1];
    bool quadraticSuccess = [Quadratic getLowestRootA:A andB:B andC:C andMinThreshold:(0) andMaxThreshold:time andRoot:&x1];
    bool lineIntersects = false;
    CGPoint pt0, pt1,pt2,pt3;
    
  
     double speed = [vel length];
   
    if (!quadraticSuccess)
        return false;

    Vector *posInR3 = [[[Vector alloc] init] autorelease];
    Matrix *matrixPosInR3 = [[[Matrix alloc] init] autorelease];
    matrixPosInR3 = [matrixPosInR3 initWithWidth:2 andHeight:1];
    numX = [NSNumber numberWithFloat:positionInESpace->x];
    numY = [NSNumber numberWithFloat:positionInESpace->y];
    [[matrixPosInR3->M objectAtIndex:0] addObject:numX];
    [[matrixPosInR3->M objectAtIndex:0] addObject:numY];
    matrixPosInR3 = [Matrix matrixA:matrixPosInR3 multiplyMatrixB:CBMInverse];
    M11 = [[[matrixPosInR3->M objectAtIndex:0] objectAtIndex:0] floatValue];
    M12 = [[[matrixPosInR3->M objectAtIndex:0] objectAtIndex:1] floatValue];
   // NSLog(@"posInR3: %p", posInR3);
    [posInR3 initializeVectorX:M11 andY:M12];
   // NSLog(@"posInR3(x,y): (%f,%f)", posInR3->x, posInR3->y);
   
    NSLog(@"x1: %f", [x1 floatValue]);
    numerator = ([edge dotProduct:velocityInESpace])*[x1 floatValue] - ([edge dotProduct:baseToVertex]);
    denominator = edge.length*edge.length;
    f0 = numerator/denominator;
    
    
    //NSLog(@"f0: %f", f0);
    if ( f0 >= -0 && f0 <=1)  {

        collisionPoint = [[Vector alloc] init];
        [collisionPoint initializeVectorX:0 andY:0];
        collisionPoint = [p1 add:[edge multiply:f0]];
       
        time = [x1 floatValue];
        
        // convert collision point back to r3
        Matrix *matrixCollisionPoint = [[[Matrix alloc] init] autorelease];
        matrixCollisionPoint = [matrixCollisionPoint initWithWidth:2 andHeight:1];
        numX = [NSNumber numberWithFloat:collisionPoint->x];
        numY = [NSNumber numberWithFloat:collisionPoint->y];
        [[matrixCollisionPoint->M objectAtIndex:0] addObject:numX];
        [[matrixCollisionPoint->M objectAtIndex:0] addObject:numY];
        matrixCollisionPoint = [Matrix matrixA:matrixCollisionPoint multiplyMatrixB:CBMInverse];
        M11 = [[[matrixCollisionPoint->M objectAtIndex:0] objectAtIndex:0] floatValue];
        M12 = [[[matrixCollisionPoint->M objectAtIndex:0] objectAtIndex:1] floatValue];
        //NSLog(@"collisionPoint: %p", collisionPoint);
        collisionPoint = [collisionPoint multiply:r];
       // [collisionPoint initializeVectorX:M11 andY:M12];
       // NSLog(@"collisionPoint(x,y): (%f,%f)", collisionPoint->x, collisionPoint->y);
        colPackage->intersectionPoint = collisionPoint;
        colPackage->R3Velocity = vel;
        colPackage->nearestDistance = [vel length] * time;
    
        eSpaceIntersectionPt = [colPackage->intersectionPoint multiply:1/r];
        eSpaceNearestDist = colPackage->nearestDistance * 1/r;

        
        return true;
    }
    return false;
    
}



- (bool) collideWithVertex: (CGPoint) pt
{
    Vector *velocityInESpace; // velocity in espace
    Vector *positionInESpace; // position in espace
    Vector *p = [[[Vector alloc] init] autorelease];
    
    positionInESpace = [[[Vector alloc] init] autorelease];
    velocityInESpace = [[[Vector alloc] init] autorelease];
    [p initializeVectorX:pt.x andY:pt.y];
    
    //double eVx = (colPackage->velocity->x+acceleration->x)/r;
    //double eVy = (colPackage->velocity->y+acceleration->y)/r;
    double eVx = (colPackage->velocity->x)/r;
    double eVy = (colPackage->velocity->y)/r;
    [positionInESpace initializeVectorX:colPackage->basePoint->x andY:colPackage->basePoint->y];
    [velocityInESpace initializeVectorX:eVx andY:eVy];
    
    Matrix *CBM = [[Matrix alloc] init]; // multiply this to get into eSpace
    NSNumber *num11 = [NSNumber numberWithDouble:1/r];
    NSNumber *num12 = [NSNumber numberWithDouble:0.0];
    NSNumber *num21 = [NSNumber numberWithDouble:0.0];
    NSNumber *num22 = [NSNumber numberWithDouble:1/r];
    CBM = [[CBM initWithWidth:2 andHeight:2] autorelease];
    [[CBM->M objectAtIndex:0] addObject:num11];
    [[CBM->M objectAtIndex:0] addObject:num12];
    [[CBM->M objectAtIndex:1] addObject:num21];
    [[CBM->M objectAtIndex:1] addObject:num22];

    // convert p to espace
    Matrix *matrixP = [[Matrix alloc] init];
    matrixP = [matrixP initWithWidth:2 andHeight:1];
    NSNumber *numX = [NSNumber numberWithFloat:p->x];
    NSNumber *numY = [NSNumber numberWithFloat:p->y];
    [[matrixP->M objectAtIndex:0] addObject:numX];
    [[matrixP->M objectAtIndex:0] addObject:numY];
    matrixP = [Matrix matrixA:matrixP multiplyMatrixB:CBM];
    float M11 = [[[matrixP->M objectAtIndex:0] objectAtIndex:0] floatValue];
    float M12 = [[[matrixP->M objectAtIndex:0] objectAtIndex:1] floatValue];
    [p initializeVectorX:M11 andY:M12];

    float A = [velocityInESpace dotProduct:velocityInESpace];
    float B = 2 * ([velocityInESpace dotProduct:[positionInESpace subtract: p]]);
    
    Vector *vecP1MinusBasePt = [[[Vector alloc] init] autorelease];
    [vecP1MinusBasePt initializeVectorX:0 andY:0];
    vecP1MinusBasePt = [p subtract:positionInESpace];
    float p1MinusBasePt = [vecP1MinusBasePt length];
    float C = p1MinusBasePt * p1MinusBasePt - 1;
    
    
    if (![Quadratic getLowestRootA:A andB:B andC:C andMinThreshold:0 andMaxThreshold:time andRoot:&x1])
        return false;
    time =[x1 floatValue];
    p->x = pos->x + vel->x*time;//pt.x;
    p->y = pos->y + vel->y*time;//pt.y;
    collisionPoint = p;
    colPackage->intersectionPoint = collisionPoint;
    colPackage->R3Velocity = vel;
    colPackage->nearestDistance = [x1 floatValue] * [vel length];
    eSpaceIntersectionPt = [colPackage->intersectionPoint multiply:1/r];
    eSpaceNearestDist = colPackage->nearestDistance * 1/r;
    
    return true;
}

- (void) collideAndSlide: (double) lerp
{
    colPackage->R3Position = pos;
    bool nearTeeterTotter = false;
    colPackage->isSlidingOff = false;
    time = lerp;
    NSLog(@"time in collideAndSlide: %.20g\n", time );
    for (int i=0; i < [teeterTotters count]; i++)
    {
        TeeterTotter *teeterTotter = [[TeeterTotter alloc] init];
        teeterTotter = [teeterTotters objectAtIndex:i];
    }
    
    if (!colPackage->foundCollision)
    {
        if (colPackage->state == COLLISION_SLIDE)
        {
            //Vector *velocityNormalized = [[Vector alloc] init];
            //[velocityNormalized initializeVectorX:vel->x andY:vel->y];
            //[velocityNormalized normalize];
            //Vector *accel = [[Vector alloc] init];
            //accel = [[velocityNormalized multiply:gravity->length] multiply:lerp];
            //colPackage->R3Velocity = [vel add: accel];
        }
        else
            colPackage->R3Velocity = [vel add:[gravity multiply:lerp]];//[vel add:[vel add:[gravity multiply:0.00033]]];
    }
    /*else if (colPackage->state == COLLISION_SLIDE)
    {
        Vector *velocityNormalized = [[Vector alloc] init];
       [velocityNormalized initializeVectorX:vel->x andY:vel->y];
        [velocityNormalized normalize];
        Vector *accel = [[Vector alloc] init];
        Vector *totterN = [[Vector alloc] init];
        Vector *at = [[Vector alloc] init];
        Vector *collidedTotterN = [[Vector alloc] init];
        Vector *N = [[Vector alloc] init];
        Vector *roundedN = [[Vector alloc] init];
        
        [totterN initializeVectorX:0 andY:0];
        [collidedTotterN initializeVectorX:0 andY:0];
        [N initializeVectorX:0 andY:0];
       
        float a = acceleration->length;
        
        if (colPackage->collidedTotter != nil) {
            N = colPackage->collidedTotter->normal;
            int roundNX = (int) (N->x * 10);
            int roundNY = (int) (N->y * 10);
            double NX = roundNX/10.0f;
            double NY = roundNY/10.0f;
            [roundedN initializeVectorX:NX andY:NY];
            totterN = [ N multiply:a];
            bool isNearTopLine = [self nearLine:colPackage->collidedTotter->topLine];
            if (colPackage->collidedTotter->normal != nil || isNearTopLine)
            {
                collidedTotterN = [gravity add:totterN];
                accel = [ collidedTotterN multiply:lerp];
                colPackage->R3Velocity = [vel add:accel];
            }
        }
    }*/
    vel = colPackage->R3Velocity;
    colPackage->velocity = vel;
    
    // calculate position and velocity in eSpace
    Vector *eSpacePosition = [[[Vector alloc] init] autorelease];
    Vector *eSpaceVelocity = [[[Vector alloc] init] autorelease];
    [eSpacePosition initializeVectorX:0 andY:0];
    [eSpaceVelocity initializeVectorX:0 andY:0];
    eSpacePosition = [colPackage->R3Position multiply:(1.0f/(colPackage->eRadius))];
    eSpaceVelocity = [colPackage->R3Velocity multiply:(1.0f/(colPackage->eRadius))];
    // Iterate until we have our final position
    colPackage->collisionRecursionDepth = collisionRecursionDepth = 0;
    Vector *finalPosition = [[[Vector alloc] init] autorelease];
    [finalPosition initializeVectorX:0 andY:0];
    //NSLog(@"pos: (%f,%f)", eSpacePosition->x, eSpacePosition->y);
    //NSLog(@"velocity: (%f,%f)", eSpaceVelocity->x, eSpaceVelocity->y);
    finalPosition = [self collideWithWorldPosition:eSpacePosition andVelocity:eSpaceVelocity];

    // keep cheese from bouncing straight up, because found collision is set to false because of recursion in collideWithWorld
    if (collisionRecursionDepth>0 && ([colPackage->collidedObj class] == [Drum class] ||
        [colPackage->collidedObj class] == [Flipper class] || colPackage->collidedObj == [TeeterTotter class]) )
        colPackage->foundCollision = true;

    float radius = colPackage->eRadius;
    finalPosition = [finalPosition multiply:radius];
    if (colPackage->foundCollision && !colPackage->isSlidingOff ) {
        // move the entity
        [self moveTo:finalPosition];
    }
    
}



// application scale
const float unitsPerMeter = 1000.0f;
- (Vector*) collideWithWorldPosition: (Vector*)position andVelocity: (Vector*) velocity
{
   // float unitScale = unitsPerMeter / 100.0f;
    //float veryCloseDistance = 0.01f * unitScale;
    float originalSpeed = [vel length];
    if (collisionRecursionDepth == 0)
        originalSpeed += [acceleration length];
    // do we need to worry?
    if (collisionRecursionDepth > 0 || (colPackage->collisionRecursionDepth > 0 && colPackage->state == COLLISION_BOUNCE))
    {
        return position;
    }
    
    // Ok, we need to worry
    
    float radius = self->cheeseSprite->width/2;
   // [vel initializeVectorX:velocity->x*radius andY:velocity->y*radius];
    
    
    [colPackage->normalizedVelocity initializeVectorX:velocity->x andY:velocity->y];
    [colPackage->normalizedVelocity normalize];
    colPackage->basePoint = position;
    
   // NSLog(@"World checking collisions...");
    
    [world checkCollision:&(colPackage)];
    
    if (colPackage->foundCollision == false ) {
        if (colPackage->state== COLLISION_SLIDE) {
             double angle = 0;
             if (colPackage->collidedTotter!= nil){
                 /*Vector *velocityNormalized = [[Vector alloc] init];
                  [velocityNormalized initializeVectorX:vel->x andY:vel->y];
                   [velocityNormalized normalize];
                   Vector *accel = [[Vector alloc] init];
                   Vector *totterN = [[Vector alloc] init];
                   Vector *at = [[Vector alloc] init];
                   Vector *collidedTotterN = [[Vector alloc] init];
                   Vector *N = [[Vector alloc] init];
                   Vector *roundedN = [[Vector alloc] init];
                   
                   [totterN initializeVectorX:0 andY:0];
                   [collidedTotterN initializeVectorX:0 andY:0];
                   [N initializeVectorX:0 andY:0];
                  
                   float a = acceleration->length;
                   
                   if (colPackage->collidedTotter != nil) {
                       if (colPackage->collidedTotter->normal!=nil)
                       {
                           N = colPackage->collidedTotter->normal;
                           int roundNX = (int) (N->x * 10);
                           int roundNY = (int) (N->y * 10);
                           double NX = roundNX/10.0f;
                           double NY = roundNY/10.0f;
                           [roundedN initializeVectorX:NX andY:NY];
                           totterN = [ roundedN multiply:a];
                           bool isNearTopLine = [self nearLine:colPackage->collidedTotter->topLine];
                       
                           if (colPackage->collidedTotter->normal != nil || isNearTopLine)
                           {
                               //collidedTotterN = [gravity add:totterN];
                               accel = [ totterN multiply:time];
                               vel = [vel add:accel];
                           }
                       }
                   }*/
                 
                 angle = colPackage->collidedTotter->angle;
                 angle = angle * M_PI/180;
                 
                 NSLog(@"cos value %f",cos(angle));
                 NSLog(@"sin value %f",sin(angle));
                 double v2x = 0;
                 double v2y = 0;
                 float length = 0;
                 if (self->x < colPackage->collidedTotter->x )
                 {
                     /*if (vel->y < 0)
                     {
                         float PI_4 = M_PI/4;
                         if (angle > 0 && angle < PI_4)
                         {
                             v2x = -vel->length*cos(angle);
                             v2y = -vel->length*sin(angle);
                         }
                         else
                         {
                             v2x = -vel->length*cos(angle);
                             v2y = -vel->length*sin(angle);
                         }
                     }
                     else if (vel->y >= 0)
                     {*/
                     length =acceleration->length*sin(angle);
                      v2x = -length*cos(angle);
                      v2y = -length*sin(angle);
                      [vel initializeVectorX:v2x andY:v2y];
                    // }
                 }
                 else if (self->x > colPackage->collidedTotter->x )
                 {
                     double theta = 2*M_PI - angle;
                     length =acceleration->length*sin(theta);
                     v2x = length*cos(angle);
                     v2y = length*sin(angle);
                      [vel initializeVectorX:v2x andY:v2y];
                     
                 }
                 else if (self->x == colPackage->collidedTotter->x)
                 {
                     //if (vel->y < 0)
                     //{
                         v2x = vel->length*cos(angle);
                         v2y = vel->length*sin(angle);
                         [vel initializeVectorX:v2x andY:v2y];
                     //}
                     
                 }
                // else if (vel->x!=0)
                  //   [vel initializeVectorX:v2x andY:v2y];
             }
         
            colPackage->R3Velocity = vel;
            colPackage->velocity = vel;
            
        }
        else
            return position;
    }
    else if (colPackage->state == COLLISION_SLIDE && [colPackage->collidedObj class] == [TeeterTotter class] && isPastTopRight)
    {
        lineToCheese = [slidingLine->normal multiply:diff];
        return [position add:lineToCheese];
    }
    else if (colPackage->state == COLLISION_BOUNCE &&
             ([colPackage->collidedObj class] == [Drum class] || [colPackage->collidedObj class] == [Flipper class]) &&
             isPastTopLine)
    {
        initVel = bounceVel;
        vel = bounceVel;
        colPackage->R3Velocity = vel;
        colPackage->velocity = vel;
        //vel = [vel multiply:(1+veryCloseDistance)];
        //return [position add:vel];
        //colPackage->foundCollision = true;
        //[lineToCheese normalize];
        lineToCheese = [slidingLine->normal multiply:diff];
        return [position add:lineToCheese];
    }
    /*if (colPackage->state== COLLISION_SLIDE) {
         double angle = 0;
         if (colPackage->collidedTotter!= nil){
             //if (colPackage->collidedTotter->angle<0)
            // if (colPackage->collidedTotter->angle==0)
              //   [vel setLength:initVel->length];
            
             angle = colPackage->collidedTotter->angle;
             angle = angle * M_PI/180;
             
             NSLog(@"cos value %f",cos(angle));
             NSLog(@"sin value %f",sin(angle));
             double v2x = 0;
             double v2y = 0;
             if (self->x < colPackage->collidedTotter->x)
             {
                 v2x = -vel->length*cos(angle);
                 v2y = -vel->length*sin(angle);
             }
             else
             {
                 v2x = vel->length*cos(angle);
                 v2y = vel->length*sin(angle);
             }

              //   Vector *newVelocityVector
             [vel initializeVectorX:v2x andY:v2y];
         }
        return position;
    }*/
   // if (collisionRecursionDepth == 0 && colPackage->state ==  COLLISION_BOUNCE)
   // {
       // [vel initializeVectorX:initVel->x andY:initVel->y];
      //  Vector *gravityX3 = [[Vector alloc] init];
       // gravityX3 = [gravity multiply:3];
       // vel = [vel add:gravity];
   // }
    /*Vector *newPos = [[Vector alloc] init];
    Vector *newVelocity = [[Vector alloc] init];
    [newVelocity initializeVectorX:velocity->x andY:velocity->y];
    [newVelocity normalize];
    //double lengthOfVelocity = [velocity length];
    [newPos initializeVectorX:position->x andY:position->y];
    newPos = [newPos add:newVelocity]; // add 1 for radius*/
    // *** Collision occured ***
   // NSLog(@"Collision occured");
    // the original destination point
    //Vector *destinationPoint = [[Vector alloc] init];
    [destinationPoint initializeVectorX:0 andY:0];
    float t = 0;//0.33;//time; // 30.0f;
   /* if (colPackage->state == COLLISION_SLIDE && !colPackage->isSlidingOff)
    {
        t = time;
    }
    else
    {
        t = 0.33;
    }*/
    
    //if (colPackage->state == COLLISION_SLIDE && !colPackage->isSlidingOff)
    //{
    float tick = 1/30.0f;
    t = time;
   // }
    //else
    //{
    //    t = time;
   // }
    Vector *vr = [[Vector alloc] init];
    Vector *velocityNormalized = [[Vector alloc] init];
    [velocityNormalized initializeVectorX:velocity->x andY:velocity->y];
    [velocityNormalized normalize];
    //[vr initializeVectorX:0 andY:0];
    //vr = [velocityNormalized multiply:2];
    
    Vector *vt = [[Vector alloc] init];
    [vt initializeVectorX:0 andY:0];
    
  //  velocity = [velocity add: acceleration];
    vt = [velocityInESpace multiply:t];
   // vt = [vt add: velocityNormalized];
    //vt = [vt add:vr];
   // Vector *one = [[Vector alloc] init];
    //[one initializeVectorX:0 andY:-1];
   // Vector *times2 = [[Vector alloc] init];
    //[times2 initializeVectorX:0 andY:0];
    //times2 = [[vt add:velocityNormalized] multiply:2];
    //destinationPoint = [position add: times2];
    Vector *ePos = [[Vector alloc] init];
    [ePos initializeVectorX:0 andY:0];
    ePos = [position add: velocityNormalized];
    destinationPoint = [ePos add: vt];
   // destinationPointR3 = [destinationPoint add: vr];
   /* Vector *p1 = [[Vector alloc] init];
    [p1 initializeVectorX:slidingLine->p1.x/radius andY:slidingLine->p1.y/radius];
    Vector *p2 = [[Vector alloc] init];
    [p2 initializeVectorX:slidingLine->p2.x/radius andY:slidingLine->p2.y/radius];
    Vector *b = [destinationPoint subtract:p1];
    Vector *a = [p2 subtract:p1];
    Vector *projBoA = [[Vector alloc] project:b onto:a];
    Vector *closestPt = [[Vector alloc] init];
    Vector *p1ToClosestPt = [[Vector alloc] init];
    p1ToClosestPt = [p1 add:projBoA];
    Vector *p1AddB = [[Vector alloc] init];
    p1AddB = [p1 add:b];
    closestPt = [p1AddB subtract:p1ToClosestPt];
    Vector *destToClosestPt = [[Vector alloc] init];
    destToClosestPt = [destinationPoint subtract:p1ToClosestPt];*/
    //[destToClosestPt normalize];
    
    //destinationPoint = [destinationPoint add: destToClosestPt];
    
    Vector *newBasePoint = position;
   
    // only update if we are not already very close
    // and if so we only move very close to intersection..not
    // to the exact spot
   // NSLog(@"eSpaceNearestDist: %f ", eSpaceNearestDist);
   // NSLog(@"veryCloseDistance: %f ", veryCloseDistance);
   // if (eSpaceNearestDist<0)
     //   eSpaceNearestDist = -eSpaceNearestDist;
    if (eSpaceNearestDist >= veryCloseDistance && colPackage->state != COLLISION_BOUNCE
        //&&
        //eSpaceIntersectionPt->x!= 0 && eSpaceIntersectionPt->y!=0 &&
        //!isnan(eSpaceIntersectionPt->x) && !isnan(eSpaceIntersectionPt->y) &&
        //!isnan(velocity->x) && !isnan(velocity->y)
        )
    {
        
        Vector *V = [[Vector alloc] init];
        Vector *v = [[Vector alloc] init];
        Vector *vt = [[Vector alloc] init];
        [v initializeVectorX:0 andY:0];
        [V initializeVectorX:velocity->x andY:velocity->y];
        [vt initializeVectorX:0 andY:0];
       
        float length = eSpaceNearestDist-veryCloseDistance;
        [V setLength:length];
        // vt = [V multiply:t];
       // NSLog(@"V: (%f,%f)", V->x,V->y);
        newBasePoint = [colPackage->basePoint add: V];
       // NSLog(@"new base point: (%f,%f)", newBasePoint->x, newBasePoint->y);
        //t = 0;
        // Adjust polygon intersection point (so sliding
        // plane will be unaffected by the fact that we
        // move slightly less than collision tells us)
        [V normalize];
       // NSLog(@"V normalized: (%f,%f)", V->x, V->y);
       // NSLog(@"eSpaceIntersectionPt: (%f,%f)", eSpaceIntersectionPt->x, eSpaceIntersectionPt->y);
       // NSLog(@"eSpaceintersectionPt->length: %f", eSpaceIntersectionPt->length);
        v = [V multiply:veryCloseDistance]; // fix this
      //  NSLog(@"tiny V: (%f,%f)", v->x, v->y);
      //  NSLog(@"eSpaceIntersectionPt instance: %p", eSpaceIntersectionPt);
      //  NSLog(@"v instance: %p", v);
      //  eSpaceIntersectionPt = [[Vector alloc] init];
        if (eSpaceIntersectionPt->length!=0 && [colPackage->collidedObj class] != [Gear class])
            eSpaceIntersectionPt = [eSpaceIntersectionPt subtract: v];
        
      //  NSLog(@"eSpaceIntersectionPt - a little bit: (%f,%f)", eSpaceIntersectionPt->x, eSpaceIntersectionPt->y);
      //  [V release];
        
    }
    topLineNormal = [[Vector alloc] init];
    [topLineNormal initializeVectorX:slidingLine->normal->x andY:slidingLine->normal->y];
   
    // determine the sliding line
    Vector *slideLineOrigin = [[Vector alloc] init];
    slideLineNormal = [[Vector alloc] init];
    // we already have the intersection point from the colliding with line/vertex function
    [slideLineOrigin initializeVectorX:eSpaceIntersectionPt->x andY:eSpaceIntersectionPt->y];
    [slideLineNormal initializeVectorX:slidingLine->normal->x andY:slidingLine->normal->y];
   // [slideLineNormal initializeVectorX:slidingLine->normal->x andY:slidingLine->normal->y];
   // Vector *newBasePoint = [[Vector alloc] init];
   // newBasePoint = [newBasePoint multiply:1/r];
    //slideLineNormal = [position subtract: eSpaceIntersectionPt];
    //[slideLineNormal normalize];
    
    //slideLineOrigin = [slideLineOrigin add: slideLineNormal];
    slidingLine->origin = slideLineOrigin;
    slidingLine->normal = slideLineNormal;

    slidingLine = [slidingLine initializeLineWithVectorOrigin:slideLineOrigin andVectorNormal:slideLineNormal];
    
    float distance =  [slidingLine signedDistanceTo:destinationPoint]; // distance from original destination point to sliding line
    
    // project the original velocity vector to the sliding line to get a new destination
    Vector *slideLineNormalTimesDistance = [[[Vector alloc] init] autorelease];
    slideLineNormalTimesDistance = [ slideLineNormal multiply:distance];
    //Vector *newDestinationPoint = [[Vector alloc] init];
    //if (colPackage->state == COLLISION_SLIDE)
   // {
    /*if ([slidingLine isFrontFacingTo:destToClosestPt]) {
        newDestinationPoint = [destinationPoint add: destToClosestPt];
    }
    else {*/
        newDestinationPoint = [destinationPoint add: slideLineNormalTimesDistance];
    
    /*if (colPackage->state == COLLISION_BOUNCE && [colPackage->collidedObj class] == [Drum class] ) {
        if (![slidingLine isFrontFacingTo:vel])
        {
            distance =  [slidingLine signedDistanceTo:position];
            slideLineNormalTimesDistance = [ slideLineNormal multiply:distance];
            newBasePoint = [position add:slideLineNormalTimesDistance];
        }
       // colPackage->foundCollision = true;
        return newBasePoint;
    }*/
    //}
   // }
    //else
    //{
    //    newDestinationPoint = destinationPoint;
   // }
   
    /*Vector *b = [position subtract:destinationPoint];
   
    if ([colPackage->collidedObj class] == [Gear class])
    {
         // prevent cheese from getting stuck on the object
        if (b->x==0 && collisionRecursionDepth==0)
        {
            //Vector *normalImpulse = [[Vector alloc] project:b onto:slideLineNormal];
           // Vector *normalImpulse = [[[Vector alloc] project:b onto:slideLineNormal] multiply:2.0f];
            return position;//[[destinationPoint add:normalImpulse] subtract:slideLineOrigin];
        }
    }*/
    
    if (colPackage->state == COLLISION_BOUNCE)
   {
       return newBasePoint;
   }    

     // Generate the slide vector, which will become our new veocity vector for the next iteration
    Vector *newVelocityVector = [newDestinationPoint subtract:eSpaceIntersectionPt];
    
    
    //[vel initializeVectorX:80 andY:-80];
   
    /*if (colPackage->state == COLLISION_SLIDE)
    {
        double ax = newVelVecNorm->x*gravity->length;
        double ay = newVelVecNorm->y*gravity->length;
        [acceleration initializeVectorX:ax andY:ay];
    }*/
    // Recurse
    //NSLog(@"newVelocityVector length: %f", [newVelocityVector length]);
    if (fabs(newVelocityVector->x) < 0.000000001)
        newVelocityVector->x = (int)(10000000000*(newVelocityVector->x))/100.0f;
   // newVelocityVector->y = (int)(10000000000*(newVelocityVector->y))/100.0f;
    float newVelocityLength = [newVelocityVector length];
    //newVelocityVector = [newVelocityVector multiply:originalSpeed];
    //[vel initializeVectorX:newVelocityVector->x andY:newVelocityVector->y];
    //vel = [vel add:gravity];
   // [vel normalize];
   // vel = [vel multiply:originalSpeed];
    //vel = [vel add:acceleration];
    // dont recurse if the new velocity is very small
    if ( newVelocityLength < veryCloseDistance) {
        return newBasePoint;
    }
    else if (!colPackage->isSlidingOff && colPackage->state!=COLLISION_SLIDE)
    {
        vel = [newVelocityVector multiply:colPackage->eRadius]; // set velocity to slide vector
    }
    
    /*if (colPackage->state== COLLISION_SLIDE) {
         double angle = 0;
         if (colPackage->collidedTotter!= nil){
             //if (colPackage->collidedTotter->angle<0)
            // if (colPackage->collidedTotter->angle==0)
              //   [vel setLength:initVel->length];
            
             angle = colPackage->collidedTotter->angle;
             angle = angle * M_PI/180;
             
             NSLog(@"cos value %f",cos(angle));
             NSLog(@"sin value %f",sin(angle));
             double v2x = 0;
             double v2y = 0;
             if (vel->x < 0)//(self->x < colPackage->collidedTotter->x )
             {
                 v2x = -vel->length*cos(angle);
                 v2y = -vel->length*sin(angle);
             }
             else if (vel->x > 0)//(self->x > colPackage->collidedTotter->x )
             {
                 v2x = vel->length*cos(angle);
                 v2y = vel->length*sin(angle);
             }

              //   Vector *newVelocityVector
             [vel initializeVectorX:v2x andY:v2y];
         }
        colPackage->R3Velocity = vel;
        colPackage->velocity = vel;
        return position;
    }*/
    colPackage->R3Velocity = vel;
    colPackage->velocity = vel;
    //if (collisionRecursionDepth == 0 && colPackage->state == COLLISION_BOUNCE)
    //{
      //  [vel initializeVectorX:initVel->x andY:initVel->y];
        //  Vector *gravityX3 = [[Vector alloc] init];
        // gravityX3 = [gravity multiply:3];
        // vel = [vel add:gravity];
    //}
    collisionRecursionDepth++;
    colPackage->collisionRecursionDepth = collisionRecursionDepth;
   // NSLog(@"collision recursion depth %d", collisionRecursionDepth);
    return [self collideWithWorldPosition:newBasePoint andVelocity:newVelocityVector];
}

- (void) moveTo: (Vector*) position
{
    if (isnan(position->x) || isnan(position->y) )
        return;
    cheeseSprite.x = position->x - cheeseSprite.width/2;
    cheeseSprite.y = position->y - cheeseSprite.height/2;
    x = pos->x = position->x;
    y = pos->y = position->y;

}

- (void) dealloc
{
    [cheeseSprite release];
    [colPackage release];
    [vel release];
    [justTouchVelocity release];
    [gravity release];
    [normalForce release];
    [initVel release];
    [bounceVel release];
    [collisionPoint release];
    [world release];
    [super dealloc];
}



- (float)collideWithLineF:(Line *)line { 
    // NSLog(@"Checking line from (%f,%f) to (%f,%f)", line->p1.x, line->p1.y, line->p2.x, line->p2.y);
      
      Vector *positionInESpace; // position in espace
      float f0;
      double numerator, denominator;
      double M11, M12;
      NSNumber *numX, *numY;
      
      positionInESpace = [[Vector alloc] init];
      velocityInESpace = [[Vector alloc] init];
      
      //double eVx = (colPackage->velocity->x+acceleration->x)/r;
      //double eVy = (colPackage->velocity->y+acceleration->y)/r;
      double eVx = (colPackage->velocity->x)/r;
      double eVy = (colPackage->velocity->y)/r;
      [positionInESpace initializeVectorX:colPackage->basePoint->x andY:colPackage->basePoint->y];
      [velocityInESpace initializeVectorX:eVx andY:eVy];
      
      Matrix *CBM = [[[Matrix alloc] init] autorelease]; // multiply this to get into eSpace
      NSNumber *num11 = [NSNumber numberWithDouble:1/r];
      NSNumber *num12 = [NSNumber numberWithDouble:0.0];
      NSNumber *num21 = [NSNumber numberWithDouble:0.0];
      NSNumber *num22 = [NSNumber numberWithDouble:1/r];
      CBM = [CBM initWithWidth:2 andHeight:2];
      [[CBM->M objectAtIndex:0] addObject:num11];
      [[CBM->M objectAtIndex:0] addObject:num12];
      [[CBM->M objectAtIndex:1] addObject:num21];
      [[CBM->M objectAtIndex:1] addObject:num22];
      
      float detCBM = [num11 floatValue] * [num22 floatValue] - [num12 floatValue] * [num21 floatValue];
      Matrix *CBMInverse = [[Matrix alloc] init]; // multiply this to get back to R2 space
      CBMInverse = [CBMInverse initWithWidth:2 andHeight:2];
      CBMInverse = [Matrix scale:(1/detCBM) multiplyMatrix:CBM];
          
      Vector *p1 = [[Vector alloc] init];
      [p1 initializeVectorX:line->p1.x andY:line->p1.y];
      // convert p1 to espace
      Matrix *matrixP1 = [[[Matrix alloc] init] autorelease];
      matrixP1 = [matrixP1 initWithWidth:2 andHeight:1];
      numX = [NSNumber numberWithFloat:p1->x];
      numY = [NSNumber numberWithFloat:p1->y];
      [[matrixP1->M objectAtIndex:0] addObject:numX];
      [[matrixP1->M objectAtIndex:0] addObject:numY];
      matrixP1 = [Matrix matrixA:matrixP1 multiplyMatrixB:CBM];
     // matrixP1 = [Matrix matrixA:matrixP1 multiplyMatrixB:CBM2];
      M11 = [[[matrixP1->M objectAtIndex:0] objectAtIndex:0] floatValue];
      M12 = [[[matrixP1->M objectAtIndex:0] objectAtIndex:1] floatValue];
      [p1 initializeVectorX:M11 andY:M12];
     // NSLog(@"p1: (%f,%f): ", p1->x, p1->y);

      Vector *p2 = [[[Vector alloc] init] autorelease];
      [p2 initializeVectorX:line->p2.x andY:line->p2.y];
      
      // convert p2 to espace
      Matrix *matrixP2 = [[[Matrix alloc] init] autorelease];
      matrixP2 = [matrixP2 initWithWidth:2 andHeight:1];
      numX = [NSNumber numberWithFloat:p2->x];
      numY = [NSNumber numberWithFloat:p2->y];
      [[matrixP2->M objectAtIndex:0] addObject:numX];
      [[matrixP2->M objectAtIndex:0] addObject:numY];
      matrixP2 = [Matrix matrixA:matrixP2 multiplyMatrixB:CBM];
      M11 = [[[matrixP2->M objectAtIndex:0] objectAtIndex:0] floatValue];
      M12 = [[[matrixP2->M objectAtIndex:0] objectAtIndex:1] floatValue];
      [p2 initializeVectorX:M11 andY:M12];
     // NSLog(@"p2: (%f,%f): ", p2->x, p2->y);
      
      Vector *baseToVertex = [[[Vector alloc] init] autorelease];
      baseToVertex = [p1 subtract:positionInESpace];
      //NSLog(@"baseToVertex: (%f,%f)", baseToVertex->x, baseToVertex->y);
      
      Vector *edge = [[[Vector alloc] init] autorelease];
      edge = [p2 subtract:p1];
     // NSLog(@"edge (x,y): (%f,%f)", edge->x, edge->y);
     // NSLog(@"edge's length: %f", [edge length]);
    //  NSLog(@"edge.length: %f", edge.length);
    //  NSLog(@"baseToVertex's length: %f", [baseToVertex length]);
    //  NSLog(@"edge.baseToVertex: %f", [edge dotProduct:baseToVertex] );
      
      double edgeSquared = [edge length]*[edge length];
      //NSLog(@"edge squared: %f", edgeSquared);
      double A = edgeSquared*(-([velocityInESpace length]*[velocityInESpace length]))+[edge dotProduct:velocityInESpace]*[edge dotProduct:velocityInESpace];
      double B = edgeSquared*(2*([velocityInESpace dotProduct:baseToVertex])) - 2*(([edge dotProduct:velocityInESpace])*([edge dotProduct:baseToVertex]));
      double C = edgeSquared * (1 - [baseToVertex length]*[baseToVertex length]) + ([edge dotProduct:baseToVertex])*([edge dotProduct:baseToVertex]);
      
      x1 = [[NSNumber alloc] init];

      NSLog(@"t: %f", time);
      NSLog(@"vEspace: %f", velocityInESpace->y);
      NSLog(@"v normalized: (%f,%f)", colPackage->normalizedVelocity->x, colPackage->normalizedVelocity->y);

      Line *cheeseLine = [[[Line alloc] init] autorelease];
      Line *boundLine = [[[Line alloc] init] autorelease];
      float max = 1/30.0f;
      //bool quadraticSuccess = [Quadratic getLowestRootA:A andB:B andC:C andMinThreshold:(0) andMaxThreshold:time andRoot:&x1];
    bool quadraticSuccess = [Quadratic getLowestRootA:A andB:B andC:C andMinThreshold:(0) andMaxThreshold:time andRoot:&x1];
      bool lineIntersects = false;
      CGPoint pt0, pt1,pt2,pt3;
      
     // float futureX = x + vel->x*t;
      //float futureY = y + vel->y*t;
      //Circle *futureCheese = [[Circle alloc] init];
      //NSNumber *distFromFutureCheeseToLine;
       double speed = [vel length];
      //[futureCheese initializeWithX:futureX andY:futureY andRadius:r];
      //if (![futureCheese collideWithLine:line andSpeed:speed andRoot:&distFromFutureCheeseToLine])
        //  return false;
      if (!quadraticSuccess)
          return -1;
      


      Vector *posInR3 = [[[Vector alloc] init] autorelease];
      Matrix *matrixPosInR3 = [[[Matrix alloc] init] autorelease];
      matrixPosInR3 = [matrixPosInR3 initWithWidth:2 andHeight:1];
      numX = [NSNumber numberWithFloat:positionInESpace->x];
      numY = [NSNumber numberWithFloat:positionInESpace->y];
      [[matrixPosInR3->M objectAtIndex:0] addObject:numX];
      [[matrixPosInR3->M objectAtIndex:0] addObject:numY];
      matrixPosInR3 = [Matrix matrixA:matrixPosInR3 multiplyMatrixB:CBMInverse];
      M11 = [[[matrixPosInR3->M objectAtIndex:0] objectAtIndex:0] floatValue];
      M12 = [[[matrixPosInR3->M objectAtIndex:0] objectAtIndex:1] floatValue];
     // NSLog(@"posInR3: %p", posInR3);
      [posInR3 initializeVectorX:M11 andY:M12];
     // NSLog(@"posInR3(x,y): (%f,%f)", posInR3->x, posInR3->y);
     
      NSLog(@"x1: %f", [x1 floatValue]);
      numerator = ([edge dotProduct:velocityInESpace])*[x1 floatValue] - ([edge dotProduct:baseToVertex]);
      denominator = edge.length*edge.length;
      f0 = numerator/denominator;
      
      
      //NSLog(@"f0: %f", f0);
      float t = time;
      if ( f0 >= 0 && f0 <=1)  {
      //if ([futureCheese collideWithLine:line]) {
          collisionPoint = [[Vector alloc] init];
          [collisionPoint initializeVectorX:0 andY:0];
          collisionPoint = [p1 add:[edge multiply:f0]];
          //if ([x1 floatValue] < 0)
            //  time = -[x1 floatValue];
          //else
          t = [x1 floatValue];
          
          // convert collision point back to r3
          Matrix *matrixCollisionPoint = [[[Matrix alloc] init] autorelease];
          matrixCollisionPoint = [matrixCollisionPoint initWithWidth:2 andHeight:1];
          numX = [NSNumber numberWithFloat:collisionPoint->x];
          numY = [NSNumber numberWithFloat:collisionPoint->y];
          [[matrixCollisionPoint->M objectAtIndex:0] addObject:numX];
          [[matrixCollisionPoint->M objectAtIndex:0] addObject:numY];
          matrixCollisionPoint = [Matrix matrixA:matrixCollisionPoint multiplyMatrixB:CBMInverse];
          M11 = [[[matrixCollisionPoint->M objectAtIndex:0] objectAtIndex:0] floatValue];
          M12 = [[[matrixCollisionPoint->M objectAtIndex:0] objectAtIndex:1] floatValue];
          //NSLog(@"collisionPoint: %p", collisionPoint);
          collisionPoint = [collisionPoint multiply:r];
         // [collisionPoint initializeVectorX:M11 andY:M12];
         // NSLog(@"collisionPoint(x,y): (%f,%f)", collisionPoint->x, collisionPoint->y);
          colPackage->intersectionPoint = collisionPoint;
          colPackage->R3Velocity = vel;
          colPackage->nearestDistance = [vel length] * t;
        //   NSLog(@"eSpaceIntersectionPt: %p", eSpaceIntersectionPt);
         // [eSpaceIntersectionPt initializeVectorX:0 andY:0];
         // NSLog(@"eSpaceIntersectionPt(x,y): (%f,%f)", eSpaceIntersectionPt->x, eSpaceIntersectionPt->y);
          eSpaceIntersectionPt = [colPackage->intersectionPoint multiply:1/r];
          eSpaceNearestDist = colPackage->nearestDistance * 1/r;

          
          return eSpaceNearestDist;
      }
      return -1;
    
}

- (float)collideWithVertexF:(CGPoint)pt { 
    Vector *velocityInESpace; // velocity in espace
    Vector *positionInESpace; // position in espace
    Vector *p = [[[Vector alloc] init] autorelease];
    
    positionInESpace = [[[Vector alloc] init] autorelease];
    velocityInESpace = [[[Vector alloc] init] autorelease];
    [p initializeVectorX:pt.x andY:pt.y];
    
   // double eVx = (colPackage->velocity->x+acceleration->x)/r;
  //  double eVy = (colPackage->velocity->y+acceleration->y)/r;
    double eVx = (colPackage->velocity->x)/r;
    double eVy = (colPackage->velocity->y)/r;
    [positionInESpace initializeVectorX:colPackage->basePoint->x andY:colPackage->basePoint->y];
    [velocityInESpace initializeVectorX:eVx andY:eVy];
    
    Matrix *CBM = [[Matrix alloc] init]; // multiply this to get into eSpace
    NSNumber *num11 = [NSNumber numberWithDouble:1/r];
    NSNumber *num12 = [NSNumber numberWithDouble:0.0];
    NSNumber *num21 = [NSNumber numberWithDouble:0.0];
    NSNumber *num22 = [NSNumber numberWithDouble:1/r];
    CBM = [[CBM initWithWidth:2 andHeight:2] autorelease];
    [[CBM->M objectAtIndex:0] addObject:num11];
    [[CBM->M objectAtIndex:0] addObject:num12];
    [[CBM->M objectAtIndex:1] addObject:num21];
    [[CBM->M objectAtIndex:1] addObject:num22];

    // convert p to espace
    Matrix *matrixP = [[Matrix alloc] init];
    matrixP = [matrixP initWithWidth:2 andHeight:1];
    NSNumber *numX = [NSNumber numberWithFloat:p->x];
    NSNumber *numY = [NSNumber numberWithFloat:p->y];
    [[matrixP->M objectAtIndex:0] addObject:numX];
    [[matrixP->M objectAtIndex:0] addObject:numY];
    matrixP = [Matrix matrixA:matrixP multiplyMatrixB:CBM];
    float M11 = [[[matrixP->M objectAtIndex:0] objectAtIndex:0] floatValue];
    float M12 = [[[matrixP->M objectAtIndex:0] objectAtIndex:1] floatValue];
    [p initializeVectorX:M11 andY:M12];

    float A = [velocityInESpace dotProduct:velocityInESpace];
    float B = 2 * ([velocityInESpace dotProduct:[positionInESpace subtract: p]]);
    
    Vector *vecP1MinusBasePt = [[[Vector alloc] init] autorelease];
    [vecP1MinusBasePt initializeVectorX:0 andY:0];
    vecP1MinusBasePt = [p subtract:positionInESpace];
    float p1MinusBasePt = [vecP1MinusBasePt length];
    float C = p1MinusBasePt * p1MinusBasePt - 1;
    
    
    if (![Quadratic getLowestRootA:A andB:B andC:C andMinThreshold:0 andMaxThreshold:time andRoot:&x1])
        return -1;
    float t = time;
    t = [x1 floatValue];
    //time =[x1 floatValue];
    p->x = pos->x + vel->x*time;//pt.x;
    p->y = pos->y + vel->y*time;//pt.y;
    collisionPoint = p;
    colPackage->intersectionPoint = collisionPoint;
    colPackage->R3Velocity = vel;
    colPackage->nearestDistance = [x1 floatValue] * [vel length];
    eSpaceIntersectionPt = [colPackage->intersectionPoint multiply:1/r];
    eSpaceNearestDist = colPackage->nearestDistance * 1/r;
    
    return eSpaceNearestDist;
    
}

@end
