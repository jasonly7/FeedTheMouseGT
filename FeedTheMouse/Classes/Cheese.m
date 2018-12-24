
//
//  Cheese.m
//  Feed The Mouse
//
//  Created by Jason Ly on 2012-12-02.
//  Copyright (c) 2012 Jason Ly. All rights reserved.
//

#import "Cheese.h"
#define UNIT 0.1
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
        t = 0;
        time = 1;
        
        
        angularAcceleration = 0.1;
        angularDisplacement = angularVelocity = 0;
        collisionPoint = [[Vector alloc] init];
        colPackage = [[[CollisionPacket alloc] init] retain];
        colPackage->foundCollision = false;
        colPackage->eRadius = cheeseSprite.width/2;
        eSpaceIntersectionPt = [[Vector alloc] init];
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
    
    t = 0;
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
        
        if (!colPackage->foundCollision)
        {
            t=interpolation*SCALE;
            
            x = pos->x + vel->x*t;
      
            vel->y += acceleration->y;//gravity->y;
            y = pos->y + vel->y*t;
            
            NSLog(@"vel->y: %f", vel->y);
            colPackage->R3Velocity = vel;
        }
        else
        {
            if (colPackage->state== COLLISION_BOUNCE)
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
                    x = pos->x + justTouchVelocity->x;
                    y = pos->y + justTouchVelocity->y;
                    vel->y = initVel->y;
                  /*  if (vel->x <= 1 && vel->x >=-1)
                    {
                        vel->x = vel->y;
                    }*/
                }
                else if ([colPackage->collidedObj class] == [TeeterTotter class])
                {
                    x = pos->x;
                    y = pos->y;
                    vel->x += acceleration->x;
                }
                else if ([colPackage->collidedObj class] == [Drum class] ||
                         [colPackage->collidedObj class] == [Flipper class])
                {
                    if (colPackage->state == COLLISION_SLIDE)
                    {
                        vel->x += acceleration->x;// initVel->x;
                        x = pos->x + vel->x*t;
                        vel->y += acceleration->y;//initVel->y + acceleration->y*t;
                        y = pos->y + vel->y*t;
                    }
                    else
                    {
                        vel->x = initVel->x;
                        x = pos->x + vel->x;
                        vel->y = initVel->y + acceleration->y*t;
                        y = pos->y + vel->y;
                    }
                }
                else
                {
                   /* if (vel->x <= 1 && vel->x >=-1)
                    {
                        vel->x = vel->y;
                    }*/
                    x = pos->x + vel->x;
                    vel->y = initVel->y + gravity->y*t;
                    y = pos->y + vel->y;
                }
            }
            else
            {
               /* if (vel->x <= 1 && vel->x >=-1)
                {
                    vel->x = vel->y;
                }*/
                x = pos->x + vel->x;
                vel->y = initVel->y + gravity->y*t;
                y = pos->y + vel->y;
            }
           // Vector *v = [[Vector alloc]init];
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
        t = interpolation;
        angularVelocity = 0;
        angularDisplacement = 0;
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
    if( [vel length] < dist){
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
    bounceVel = [bounceVel multiply:[vel length]];
    
    Vector *Friction = [[Vector alloc] init];
    [Friction initializeVectorX:-C->x andY:C->y];
    [Friction normalize];
    bounceVel = [bounceVel add:Friction];
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
  
    if (!colPackage->foundCollision)
    {
        CGPoint topLeft = CGPointMake(topLeftX, topLeftY);
        CGPoint topRight = CGPointMake(topRightX, topRightY);
        CGPoint bottomLeft = CGPointMake(bottomLeftX, bottomLeftY);
        CGPoint bottomRight = CGPointMake(bottomRightX, bottomRightY);
        colPackage->state = COLLISION_NONE;
        Vector *normal = [[[Vector alloc] init] autorelease];
        Vector *normal1 = [[[Vector alloc] init] autorelease];
        Vector *normal2 = [[[Vector alloc] init] autorelease];
        Vector *I = [[[Vector alloc] init] autorelease];
        Vector *negativeI = [[[Vector alloc] init] autorelease];
        Vector *N = [[[Vector alloc] init] autorelease];
        [I initializeVectorX:vel->x andY:vel->y];
        [negativeI initializeVectorX:-vel->x andY:-vel->y];
        [N initializeVectorX:0 andY:0];
        
        if ([self collideWithLine:topLine] )
        {
            if ([topLine isFrontFacingTo:vel])
            {
                normal = [topLine normal];
            }
            else
            {
                [normal initializeVectorX:-topLine->normal->x andY: -topLine->normal->y];
            }
            [normal normalize];
            // projection of the normal along I (initial velocity vector going towards the line)
            // double nx = [normal multiply:[I dotProduct:normal]]->x;
            // double ny = ->y;
            //[N initializeVectorX:nx andY:ny];
            [N setVector: [normal multiply:[negativeI dotProduct:normal]]];
            bounceVel = [[N multiply:2] add:I];
            [bounceVel normalize];
            bounceVel = [bounceVel multiply:vel.length];
          //  [I release];
          //  [N release];
            foundCollision = true;
           // slidingLine->normal = normal;
            colPackage->state = COLLISION_SLIDE;
        }
        else if ([self collideWithVertex:topLeft])
        {
            /*if ([topLine isFrontFacingTo:vel])
            {
                normal1 = topLine->normal = [topLine normal];
            }
            else
            {
                [normal1 initializeVectorX:-topLine->normal->x andY: -topLine->normal->y];
            }
            if ([leftLine isFrontFacingTo:vel])
            {
                normal2 = [leftLine normal];
            }
            else
            {
                [normal2 initializeVectorX:-leftLine->normal->x andY: -leftLine->normal->y];
            }
            normal = [[normal1 add:normal2] multiply:0.5]; // average out lines to get vertex normal
            [normal normalize];
            foundCollision = true;
            slidingLine->normal = normal;
            colPackage->state = COLLISION_SLIDE;*/
        }
        else if ([self collideWithVertex:topRight])
        {
            /*if ([topLine isFrontFacingTo:vel])
            {
                normal1 = [topLine normal];
            }
            else
            {
                [normal1 initializeVectorX:-topLine->normal->x andY: -topLine->normal->y];
            }
            if ([rightLine isFrontFacingTo:vel])
            {
                normal2 = [rightLine normal];
            }
            else
            {
                [normal2 initializeVectorX:-rightLine->normal->x andY: -rightLine->normal->y];
            }
            normal = [[normal1 add:normal2] multiply:0.5]; // average out lines to get vertex normal
            [normal normalize];
            foundCollision = true;
            slidingLine->normal = normal;
            colPackage->state = COLLISION_SLIDE;*/
        }
        else if ([self collideWithLine:leftLine])
        {
           /* if ([leftLine isFrontFacingTo:vel])
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
            bounceVel = [bounceVel multiply:vel.length];
            foundCollision = true;
            colPackage->state = COLLISION_BOUNCE;*/
        }
        else if ([self collideWithLine:rightLine])
        {
           /* Vector *I = [[[Vector alloc] init] autorelease];
            [I initializeVectorX:vel->x andY:vel->y];
            Vector *negativeI = [[[Vector alloc] init] autorelease];
            [negativeI initializeVectorX:-vel->x andY:-vel->y];
            if ([rightLine isFrontFacingTo:vel])
            {
                normal = rightLine->normal = [rightLine normal];
            }
            else
            {
                [normal initializeVectorX:-rightLine->normal->x andY: -rightLine->normal->y];
                rightLine->normal = normal;
            }
            [normal normalize];
            // projection of the normal along I (initial velocity vector going towards the line)
            N = [normal multiply:[negativeI dotProduct:normal]];
            bounceVel = [[N multiply:2] add:I];
            [bounceVel normalize];
            bounceVel = [bounceVel multiply:vel.length];
            foundCollision = true;
            colPackage->state = COLLISION_BOUNCE;*/
        }
        else if ([self collideWithVertex:bottomLeft])
        {
            if ([bottomLine isFrontFacingTo:vel])
            {
               normal1 = [bottomLine normal];
            }
            else
            {
                [normal1 initializeVectorX:-bottomLine->normal->x andY: -bottomLine->normal->y];
            }
            if ([leftLine isFrontFacingTo:vel])
            {
                normal2 = [leftLine normal];
            }
            else
            {
                [normal2 initializeVectorX:-leftLine->normal->x andY: -leftLine->normal->y];
            }
            [normal1 normalize];
            [normal2 normalize];
            normal = [[normal1 add: normal2] multiply:0.5]; // average out lines to get vertex normal
            // projection of the normal along I (initial velocity vector going towards the line)
            N = [normal multiply:[negativeI dotProduct:normal]];
            foundCollision = false;
            colPackage->state = COLLISION_BOUNCE;
            slidingLine->normal = normal;
        }
        else if ([self collideWithVertex:bottomRight])
        {
            if ([bottomLine isFrontFacingTo:vel])
            {
                normal1 = [bottomLine normal];
            }
            else
            {
                [normal1 initializeVectorX:-bottomLine->normal->x andY: -bottomLine->normal->y];
            }
            if ([rightLine isFrontFacingTo:vel])
            {
                normal2 = [rightLine normal];
            }
            else
            {
                [normal2 initializeVectorX:-rightLine->normal->x andY: -rightLine->normal->y];
            }
            [normal1 normalize];
            [normal2 normalize];
            normal = [[normal1 add: normal2] multiply:0.5]; // average out lines to get vertex normal
            // projection of the normal along I (initial velocity vector going towards the line)
            N = [normal multiply:[negativeI dotProduct:normal]];
            foundCollision = false;
            colPackage->state = COLLISION_BOUNCE;
            slidingLine->normal = normal;
        }
        else if ([self collideWithLine:bottomLine])
        {
         
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
           // double nx = [normal multiply:[I dotProduct:normal]]->x;
           // double ny = ->y;
            //[N initializeVectorX:nx andY:ny];
            [N setVector: [normal multiply:[negativeI dotProduct:normal]]];
            bounceVel = [[N multiply:2] add:I];
            [bounceVel normalize];
            bounceVel = [bounceVel multiply:vel.length];
            foundCollision = true;
            slidingLine->normal = normal;
            colPackage->state = COLLISION_BOUNCE;
        }
        else
        {
            totter->angularVelocity-=1;
            if (totter->angularVelocity < 0)
            {
                totter->angularVelocity = 0;
                totter->angle = 0;
            }
            if (totter->angle>0 && totter->angle<90)
            {
                totter->angle-=totter->angularVelocity;
            }
            else if (totter->angle>270 && totter->angle<360)
            {
                totter->angle+=totter->angularVelocity;
            }
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
        bool collidedWithTop = [self collideWithLine:topLine];
        bool collidedWithBottom = [self collideWithLine:bottomLine];
        bool collidedWithLeft = [self collideWithLine:leftLine];
        bool collidedWithRight = [self collideWithLine:rightLine];
       // NSLog(@"Checking topline from (%f,%f) to (%f,%f)", topLine->p1.x, topLine->p1.y, topLine->p2.x, topLine->p2.y);
        
       if ([self collideWithVertex:topLeft])
        {
            //if ([topLine isFrontFacingTo:vel])
            //{
                normal1 = [topLine normal];
            /*}
            else
            {
               [normal1 initializeVectorX:-topLine->normal->x andY: -topLine->normal->y];
            }
            if ([leftLine isFrontFacingTo:vel])
            {*/
               normal2 = [leftLine normal];
            /*}
            else
            {
                [normal2 initializeVectorX:-leftLine->normal->x andY: -leftLine->normal->y];
            }*/
            double Ix = topLeft.x - pos->x;
            double Iy = topLeft.y - pos->y;
            Vector *I = [[[Vector alloc] init] autorelease];
            Vector *negativeI = [[[Vector alloc] init] autorelease];
            
            [I initializeVectorX:Ix andY:Iy];
            [negativeI initializeVectorX:-I->x andY:-I->y];
            /*for (int i=0; i <= 1; i++)
            {
                normal = [[normal1 add:normal2] multiply:0.5]; // average out lines to get vertex normal
                [normal normalize];

                // projection of the normal along I (initial velocity vector going towards the line)
                N = [normal multiply:[negativeI dotProduct:normal]];
                bounceVel = [[N multiply:2] add:I];
                if (bounceVel->x < 0.01)
                {
                    [I initializeVectorX:vel->x andY:vel->y];
                    [negativeI initializeVectorX:-vel->x andY:-vel->y];
                    continue;
                }
                else
                    break;
            }*/
            bounceVel = negativeI;
            [bounceVel normalize];
            bounceVel = [bounceVel multiply:vel.length];
            foundCollision = true;
            slidingLine->normal = normal;
        }
        else if ([self collideWithVertex:topRight])
        {
            //if ([topLine isFrontFacingTo:vel])
            //{
                normal1 = [topLine normal];
            /*}
            else
            {
                [normal1 initializeVectorX:-topLine->normal->x andY: -topLine->normal->y];
            }
            if ([rightLine isFrontFacingTo:vel])
            {*/
                normal2 = [rightLine normal];
            /*}
            else
            {
                [normal2 initializeVectorX:-rightLine->normal->x andY: -rightLine->normal->y];
            }*/
            
            Vector *I = [[[Vector alloc] init] autorelease];
            Vector *negativeI = [[[Vector alloc] init] autorelease];
            
            double Ix = topRight.x - pos->x;
            double Iy = topRight.y - pos->y;
            
            [I initializeVectorX:Ix andY:Iy];
            [negativeI initializeVectorX:-Ix andY:-Iy];
            
            /*for (int i=0; i <= 1; i++)
            {
                normal = [[normal1 add:normal2] multiply:0.5]; // average out lines to get vertex normal
              //  [normal1 normalize];
               // [normal2 normalize];
                [normal normalize];
                // projection of the normal along I (initial velocity vector going towards the line)
                N = [normal multiply:[negativeI dotProduct:normal]];
                bounceVel = [[N multiply:2] add:I];
                if (bounceVel->x < 0.01)
                {
                    [I initializeVectorX:vel->x andY:vel->y];
                    [negativeI initializeVectorX:-vel->x andY:-vel->y];
                    continue;
                }
                else
                    break;
            }*/
            bounceVel = negativeI;
            [bounceVel normalize];
            bounceVel = [bounceVel multiply:vel.length];
            foundCollision = true;
            slidingLine->normal = normal;
        }
        else if ([self collideWithVertex:bottomLeft])
        {
            double Ix = bottomLeft.x - pos->x;
            double Iy = bottomLeft.y - pos->y;
            Vector *I = [[[Vector alloc] init] autorelease];
            Vector *negativeI = [[[Vector alloc] init] autorelease];
            [I initializeVectorX:Ix andY:Iy];
            [negativeI initializeVectorX:-Ix andY:-Iy];
           // if ([bottomLine isFrontFacingTo:vel])
            //{
                normal1 = [bottomLine normal];
           /* }
            else
            {
                [normal1 initializeVectorX:-bottomLine->normal->x andY: -bottomLine->normal->y];
            }
            if ([leftLine isFrontFacingTo:vel])
            {*/
                normal2 = [leftLine normal];
            /*}
            else
            {
                [normal2 initializeVectorX:-leftLine->normal->x andY: -leftLine->normal->y];
            }*/
            
            /*Vector *I = [[[Vector alloc] init] autorelease];
            [I initializeVectorX:vel->x andY:vel->y];
            Vector *negativeI = [[[Vector alloc] init] autorelease];
            [negativeI initializeVectorX:-vel->x andY:-vel->y];*/
            [normal1 normalize];
            [normal2 normalize];
            normal = [[normal1 add:normal2] multiply:0.5]; // average out lines to get vertex normal
            [normal normalize];
            // projection of the normal along I (initial velocity vector going towards the line)
            N = [normal multiply:[negativeI dotProduct:normal]];
            bounceVel = negativeI;//[[N multiply:2] add:I];
            [bounceVel normalize];
            bounceVel = [bounceVel multiply:vel.length];
            foundCollision = true;
            slidingLine->normal = normal;
        }
        else if ([self collideWithVertex:bottomRight])
        {
            double Ix = bottomRight.x - pos->x;
            double Iy = bottomRight.y - pos->y;
            Vector *I = [[[Vector alloc] init] autorelease];
            Vector *negativeI = [[[Vector alloc] init] autorelease];
            [I initializeVectorX:Ix andY:Iy];
            [negativeI initializeVectorX:-Ix andY:-Iy];
            /*if ([bottomLine isFrontFacingTo:vel])
            {*/
                normal1 = [bottomLine normal];
            /*}
            else
            {
                [normal1 initializeVectorX:-bottomLine->normal->x andY: -bottomLine->normal->y];
            }
            if ([rightLine isFrontFacingTo:vel])
            {*/
                normal2 = [rightLine normal];
            /*}
            else
            {
                [normal2 initializeVectorX:-rightLine->normal->x andY: -rightLine->normal->y];
            }*/
            
           /* Vector *I = [[[Vector alloc] init] autorelease];
            [I initializeVectorX:vel->x andY:vel->y];
            Vector *negativeI = [[[Vector alloc] init] autorelease];
            [negativeI initializeVectorX:-vel->x andY:-vel->y];*/
            [normal1 normalize];
            [normal2 normalize];
            normal = [[normal1 add:normal2] multiply:0.5]; // average out lines to get vertex normal
            [normal normalize];
            // projection of the normal along I (initial velocity vector going towards the line)
            N = [normal multiply:[negativeI dotProduct:normal]];
            bounceVel = negativeI;//[[N multiply:2] add:I];
            [bounceVel normalize];
            bounceVel = [bounceVel multiply:vel.length];
            foundCollision = true;
            slidingLine->normal = normal;
        }
        else if ([self collideWithLine:rightLine])
        {
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
        else if ([self collideWithLine:leftLine])
        {
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
        else if (collidedWithTop || collidedWithBottom)
        {
            Vector *I = [[[Vector alloc] init] autorelease];
            [I initializeVectorX:vel->x andY:vel->y];
            Vector *negativeI = [[[Vector alloc] init] autorelease];
            [negativeI initializeVectorX:-vel->x andY:-vel->y];
            if (vel->y <= 0 && collidedWithTop)
            {
                if ([topLine isFrontFacingTo:vel])
                {
                    normal = [topLine normal];
                }
                else
                {
                    [normal initializeVectorX:-topLine->normal->x andY: -topLine->normal->y];
                }
            }
            else if (vel->y >= 0 && collidedWithBottom)
            {
                if ([bottomLine isFrontFacingTo:vel])
                {
                    normal = [bottomLine normal];
                }
                else
                {
                   [normal initializeVectorX:-bottomLine->normal->x andY: -bottomLine->normal->y];
                }
            }
            else if (collidedWithTop)
            {
                if ([topLine isFrontFacingTo:vel])
                {
                    normal = [topLine normal];
                }
                else
                {
                    [normal initializeVectorX:-topLine->normal->x andY: -topLine->normal->y];
                }
            }
            else if (collidedWithBottom)
            {
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
        
        bool collidedWithTop = [self collideWithLine:topLine];
        bool collidedWithBottom = [self collideWithLine:bottomLine];
        
        if ( collidedWithTop || collidedWithBottom)
        {
            Vector *I = [[[Vector alloc] init] autorelease];
            [I initializeVectorX:vel->x andY:vel->y];
            Vector *negativeI = [[[Vector alloc] init] autorelease];
            [negativeI initializeVectorX:-vel->x andY:-vel->y];
            if (collidedWithTop && vel->y < 0)
            {
                if ([topLine isFrontFacingTo:vel])
                {
                    normal = [topLine normal];
                }
                else
                {
                    [normal initializeVectorX:-topLine->normal->x andY: -topLine->normal->y];
                }
            }
            else if (collidedWithBottom && vel->y > 0)
            {
                if ([bottomLine isFrontFacingTo:vel])
                {
                    normal = [bottomLine normal];
                }
                else
                {
                    [normal initializeVectorX:-bottomLine->normal->x andY: -bottomLine->normal->y];
                }
            }
            else if (collidedWithTop)
            {
                if ([topLine isFrontFacingTo:vel])
                {
                    normal = [topLine normal];
                }
                else
                {
                    [normal initializeVectorX:-topLine->normal->x andY: -topLine->normal->y];
                }
            }
            else if (collidedWithBottom)
            {
                if ([bottomLine isFrontFacingTo:vel])
                {
                    normal = [bottomLine normal];
                }
                else
                {
                    [normal initializeVectorX:-bottomLine->normal->x andY: -bottomLine->normal->y];
                }
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
        else if ([self collideWithVertex:topLeft])
        {
           // if ([topLine isFrontFacingTo:vel])
            //{
                normal1 = [topLine normal];
            /*}
            else
            {
               [normal1 initializeVectorX:-topLine->normal->x andY: -topLine->normal->y];
            }
            if ([leftLine isFrontFacingTo:vel])
            {*/
                normal2 = [leftLine normal];
            /*}
            else
            {
               [normal2 initializeVectorX:-leftLine->normal->x andY: -leftLine->normal->y];
            }*/
            
            Vector *I = [[[Vector alloc] init] autorelease];
            Vector *negativeI = [[[Vector alloc] init] autorelease];
            double Ix = topLeft.x - pos->x;
            double Iy = topLeft.y - pos->y;
            
            [I initializeVectorX:Ix andY:Iy];
            [negativeI initializeVectorX:-Ix andY:-Iy];
            
           /* for (int i=0; i <= 1; i++)
            {
                normal = [[normal1 add:normal2] multiply:0.5]; // average out lines to get vertex normal
                [normal normalize];
                // projection of the normal along I (initial velocity vector going towards the line)
                N = [normal multiply:[negativeI dotProduct:normal]];
                bounceVel = [[N multiply:2] add:I];
                if (bounceVel->x < 0.01)
                {
                    [I initializeVectorX:vel->x andY:vel->y];
                    [negativeI initializeVectorX:-vel->x andY:-vel->y];
                    continue;
                }
               else
                   break;
           }*/
            bounceVel = negativeI;
            [bounceVel normalize];
            bounceVel = [bounceVel multiply:vel.length];
            slidingLine->normal = normal;
            foundCollision = true;
        }
        else if ([self collideWithVertex:topRight])
        {
            //if ([topLine isFrontFacingTo:vel])
            //{
                normal1 = [topLine normal];
            /*}
            else
            {
                [normal1 initializeVectorX:-topLine->normal->x andY: -topLine->normal->y];
            }
            if ([rightLine isFrontFacingTo:vel])
            {*/
                normal2 = [rightLine normal];
            /*}
            else
            {
                [normal2 initializeVectorX:-rightLine->normal->x andY: -rightLine->normal->y];
            }*/
            
            Vector *I = [[[Vector alloc] init] autorelease];
            Vector *negativeI = [[[Vector alloc] init] autorelease];
            double Ix = topRight.x - pos->x;
            double Iy = topRight.y - pos->y;
            
            [I initializeVectorX:Ix andY:Iy];
            [negativeI initializeVectorX:-Ix andY:-Iy];
            
            /*for (int i=0; i <= 1; i++)
            {
                normal = [[normal1 add:normal2] multiply:0.5]; // average out lines to get vertex normal
                [normal normalize];
                // projection of the normal along I (initial velocity vector going towards the line)
                N = [normal multiply:[negativeI dotProduct:normal]];
                bounceVel = [[N multiply:2] add:I];
                if (bounceVel->x < 0.01)
                {
                    [I initializeVectorX:vel->x andY:vel->y];
                    [negativeI initializeVectorX:-vel->x andY:-vel->y];
                    continue;
                }
                else
                    break;
            }*/
            bounceVel = negativeI;
            [bounceVel normalize];
            bounceVel = [bounceVel multiply:vel.length];
            slidingLine->normal = normal;
            foundCollision = true;
        }
        else if ([self collideWithVertex:bottomLeft])
        {
            Vector *I = [[[Vector alloc] init] autorelease];
            Vector *negativeI = [[[Vector alloc] init] autorelease];
            double Ix = bottomLeft.x - pos->x;
            double Iy = bottomLeft.y - pos->y;
            
            [I initializeVectorX:Ix andY:Iy];
            [negativeI initializeVectorX:-Ix andY:-Iy];
            //Vector *velNormalized = [[Vector alloc] init];
            //velNormalized = vel;
            //[velNormalized normalize];
           // if ([bottomLine isFrontFacingTo:velNormalized])
            //{
                normal1 = [bottomLine normal];
            /*}
            else
            {
               [normal1 initializeVectorX:-bottomLine->normal->x andY: -bottomLine->normal->y];
            }*/
            //if ([leftLine isFrontFacingTo:velNormalized])
            //{
                normal2 = [leftLine normal];
            /*}
            else
            {
                [normal2 initializeVectorX:-leftLine->normal->x andY: -leftLine->normal->y];
            }
            
            Vector *I = [[[Vector alloc] init] autorelease];
            [I initializeVectorX:vel->x andY:vel->y];
            Vector *negativeI = [[[Vector alloc] init] autorelease];
            [negativeI initializeVectorX:-vel->x andY:-vel->y];*/
            [normal1 normalize];
            [normal2 normalize];
            normal = [[normal1 add:normal2] multiply:0.5]; // average out lines to get vertex normal
            [normal normalize];
            // projection of the normal along I (initial velocity vector going towards the line)
            N = [normal multiply:[negativeI dotProduct:normal]];
            bounceVel = negativeI;//[[N multiply:2] add:I];
            [bounceVel normalize];
            bounceVel = [bounceVel multiply:vel.length];
            slidingLine->normal = normal;
            foundCollision = true;
        }
        else if ([self collideWithVertex:bottomRight])
        {
            Vector *I = [[[Vector alloc] init] autorelease];
            Vector *negativeI = [[[Vector alloc] init] autorelease];
            double Ix = bottomRight.x - pos->x;
            double Iy = bottomRight.y - pos->y;
            [I initializeVectorX:Ix andY:Iy];
            [negativeI initializeVectorX:-Ix andY:-Iy];
            //if ([bottomLine isFrontFacingTo:vel])
          //  {
                normal1 = [bottomLine normal];
          //  }
           // else
           // {
                //[normal1 initializeVectorX:-bottomLine->normal->x andY: -bottomLine->normal->y];
           // }
           // if ([rightLine isFrontFacingTo:vel])
            //{
                normal2 = [rightLine normal];
            //}
           // else
           // {
              // [normal2 initializeVectorX:-rightLine->normal->x andY: -rightLine->normal->y];
                
           // }
            
           /* Vector *I = [[[Vector alloc] init] autorelease];
            [I initializeVectorX:vel->x andY:vel->y];
            Vector *negativeI = [[[Vector alloc] init] autorelease];
            [negativeI initializeVectorX:-vel->x andY:-vel->y];*/
            [normal1 normalize];
            [normal2 normalize];
            normal = [[normal1 add:normal2] multiply:0.5]; // average out lines to get vertex normal
            [normal normalize];
            // projection of the normal along I (initial velocity vector going towards the line)
            N = [normal multiply:[negativeI dotProduct:normal]];
            bounceVel = negativeI;//[[N multiply:2] add:I];
            [bounceVel normalize];
            bounceVel = [bounceVel multiply:vel.length];
            slidingLine->normal = normal;
            foundCollision = true;
        }
        else if ([self collideWithLine:rightLine])
        {
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
        else if ([self collideWithLine:leftLine])
        {
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
            bounceVel =[[N multiply:2] add:I];
            [bounceVel normalize];
            bounceVel = [bounceVel multiply:vel.length];
            foundCollision = true;
            slidingLine->normal = normal;
        }
        
    }
    
    return foundCollision;
}

- (void) update: (double) lerp
{
    NSNumber *numX, *numY;
    float M11, M12;
   
    
    //time = tick;
    
    /*Matrix *CBM = [[Matrix alloc] init]; // multiply this to get into eSpace
    NSNumber *num11 = [NSNumber numberWithDouble:1/r];
    NSNumber *num12 = [NSNumber numberWithDouble:0.0];
    NSNumber *num21 = [NSNumber numberWithDouble:0.0];
    NSNumber *num22 = [NSNumber numberWithDouble:1/r];
    CBM = [CBM initWithWidth:2 andHeight:2];
    [[CBM->M objectAtIndex:0] addObject:num11];
    [[CBM->M objectAtIndex:0] addObject:num12];
    [[CBM->M objectAtIndex:1] addObject:num21];
    [[CBM->M objectAtIndex:1] addObject:num22];
    
    // convert velocity to espace
    Matrix *matrixVelocity = [[Matrix alloc] init];
    matrixVelocity = [matrixVelocity initWithWidth:2 andHeight:1];
    numX = [NSNumber numberWithFloat:vel->x];
    numY = [NSNumber numberWithFloat:vel->y];
    [[matrixVelocity->M objectAtIndex:0] addObject:numX];
    [[matrixVelocity->M objectAtIndex:0] addObject:numY];
    matrixVelocity = [Matrix matrixA:matrixVelocity multiplyMatrixB:CBM];
    M11 = [[[matrixVelocity->M objectAtIndex:0] objectAtIndex:0] floatValue];
    M12 = [[[matrixVelocity->M objectAtIndex:0] objectAtIndex:1] floatValue];
    [colPackage->velocity initializeVectorX:M11 andY:M12];
    
    // convert position to espace
    Matrix *matrixPosition = [[Matrix alloc] init];
    matrixPosition = [matrixPosition initWithWidth:2 andHeight:1];
    numX = [NSNumber numberWithFloat:x];
    numY = [NSNumber numberWithFloat:y];
    [[matrixPosition->M objectAtIndex:0] addObject:numX];
    [[matrixPosition->M objectAtIndex:0] addObject:numY];
    //printf("matrix position: %f %f\n", [[[matrixPosition->M objectAtIndex:0] objectAtIndex:0] floatValue], [[[matrixPosition->M objectAtIndex:0] objectAtIndex:1] floatValue]);
    //    [[matrixPosition->M objectAtIndex:0] initWithObjects:numX,numY, nil];
    matrixPosition = [Matrix matrixA:matrixPosition multiplyMatrixB:CBM];
    M11 = [[[matrixPosition->M objectAtIndex:0] objectAtIndex:0] floatValue];
    M12 = [[[matrixPosition->M objectAtIndex:0] objectAtIndex:1] floatValue];
    [colPackage->basePoint initializeVectorX:M11 andY:M12];*/
    
    [self collideAndSlide];
    [self fall:lerp];
    if (!colPackage->foundCollision)
    {
        
        cheeseSprite.x = x - cheeseSprite.width/2;
        cheeseSprite.y = y - cheeseSprite.height/2;
        pos->x = x;
        pos->y = y;
        colPackage->R3Position = pos;
    }

}

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
    // projection of the normal along I (initial velocity vector going towards the line)
    N = [normal multiply:[negativeI dotProduct:normal]];
    bounceVel = [[N multiply:2] add:I];
    [bounceVel normalize];
    bounceVel = [bounceVel multiply:vel.length];
    colPackage->foundCollision = true;
    self->pos->x = 35;
    self->x = 35;
    [initVel initializeVectorX:bounceVel->x andY:bounceVel->y];
    t = 0;
    colPackage->state = COLLISION_BOUNCE;
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
    // projection of the normal along I (initial velocity vector going towards the line)
    N = [normal multiply:[negativeI dotProduct:normal]];
    bounceVel = [[N multiply:2] add:I];
    [bounceVel normalize];
    bounceVel = [bounceVel multiply:vel.length];
    colPackage->foundCollision = true;
    [initVel initializeVectorX:bounceVel->x andY:bounceVel->y];
    t = 0;
    colPackage->state = COLLISION_BOUNCE;
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
        t = 0;
        cheeseSprite.rotation +=1;
        //colPackage->foundCollision = false;
    }
}

- (void) bounceOffFlipper
{
    if (colPackage->foundCollision)
    {
       
        [initVel initializeVectorX:bounceVel->x andY:bounceVel->y];
        
        t = 0;
        cheeseSprite.rotation +=1;
        //colPackage->foundCollision = false;
    }
}

- (void) bounceOffTeeterTotter
{
    initVel->x = bounceVel->x;
    initVel->y = bounceVel->y;
    t = 0;
   // colPackage->foundCollision = false;

}

- (void) slideOffTeeterTotter:(TeeterTotter *)totter
{
    initVel->x = 0;
    initVel->y = 0;
    totter->angularVelocity+=1;
    if (totter->angle == 0)
        totter->angle = 360;
    if (pos->x > totter->x && totter->angle > 316 && totter->angle <= 360 )
        totter->angle-=totter->angularVelocity;
    if (totter->angle == 360)
        totter->angle = 0;
    if (pos->x < totter->x && totter->angle < 44 && totter->angle >= 0)
        totter->angle+=totter->angularVelocity;
}

- (void) bounceOffGear:(Gear *) gear
{
    initVel->x = bounceVel->x;
    initVel->y = bounceVel->y;
    initVel->length = [initVel length];
    t = 0;
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

- (bool) collideWithLine: (Line *)line
{
   // NSLog(@"Checking line from (%f,%f) to (%f,%f)", line->p1.x, line->p1.y, line->p2.x, line->p2.y);
    Vector *velocityInESpace; // velocity in espace
    Vector *positionInESpace; // position in espace
    float f0;
    double numerator, denominator;
    double M11, M12;
    NSNumber *numX, *numY;
    
    positionInESpace = [[Vector alloc] init];
    velocityInESpace = [[Vector alloc] init];
    
    [positionInESpace initializeVectorX:colPackage->basePoint->x andY:colPackage->basePoint->y];
    [velocityInESpace initializeVectorX:colPackage->velocity->x andY:colPackage->velocity->y];
    
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

    NSLog(@"t: %f", t);
    NSLog(@"vEspace: %f", velocityInESpace->y);
    NSLog(@"v normalized: (%f,%f)", colPackage->normalizedVelocity->x, colPackage->normalizedVelocity->y);
    if (![Quadratic getLowestRootA:A andB:B andC:C andThreshold:(1) andRoot:&x1])
    {
      return false;
    }
        Line *cheeseLine = [[[Line alloc] init] autorelease];
      //  Line *boundLine = [[[Line alloc] init] autorelease];
        CGPoint pt0, pt1,pt2,pt3;
       // pt0 = CGPointMake(colPackage->R3Position->x , colPackage->R3Position->y  );
        /*pt1 = CGPointMake(pt0.x + 34.0f * colPackage->normalizedVelocity->x + colPackage->R3Velocity->x*t ,
                          pt0.y + 34.0f * colPackage->normalizedVelocity->y + colPackage->R3Velocity->y*t);*/
    pt0 = CGPointMake(positionInESpace->x, positionInESpace->y);
    pt1 = CGPointMake(positionInESpace->x + velocityInESpace->x*t, positionInESpace->y + velocityInESpace->y*t);
        cheeseLine = [cheeseLine initializeLineWithPoint1:pt0 andPoint2:pt1];
       //pt2 = CGPointMake(line->p1.x, line->p1.y);
        // pt3 = CGPointMake(line->p2.x, line->p2.y);
          pt2 = CGPointMake(line->p1.x/r, line->p1.y/r);
        pt3 = CGPointMake(line->p2.x/r, line->p2.y/r);
       // boundLine = [boundLine initializeLineWithPoint1:pt2 andPoint2:pt3];
    
        //if (![cheeseLine intersect:boundLine andRoot:&x1])
           // return false;
   
    
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
    numerator = ([edge dotProduct:velocityInESpace])*[x1 floatValue] - ([edge dotProduct:baseToVertex]);
    denominator = edge.length*edge.length;
    f0 = numerator/denominator;
    Circle *futureCheese = [[Circle alloc] init];
    float futureX = x + vel->x*t;
    float futureY = y + vel->y*t;
    
    [futureCheese initializeWithX:futureX andY:futureY andRadius:r];
    //NSLog(@"f0: %f", f0);
    if (f0 >= 0.0 && f0 <=1) {
   // if ([futureCheese collideWithLine:line]) {
        collisionPoint = [[Vector alloc] init];
        [collisionPoint initializeVectorX:0 andY:0];
        collisionPoint = [p1 add:[edge multiply:f0]];
        t = [x1 floatValue]; //no need since in collideWithWorldPostionAndVelocity is going to move the cheese very close to intersection point
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
        [collisionPoint initializeVectorX:M11 andY:M12];
       // NSLog(@"collisionPoint(x,y): (%f,%f)", collisionPoint->x, collisionPoint->y);
        colPackage->intersectionPoint = collisionPoint;
        colPackage->R3Velocity = vel;
        colPackage->nearestDistance = [x1 floatValue] * [vel length];
      //   NSLog(@"eSpaceIntersectionPt: %p", eSpaceIntersectionPt);
       // [eSpaceIntersectionPt initializeVectorX:0 andY:0];
       // NSLog(@"eSpaceIntersectionPt(x,y): (%f,%f)", eSpaceIntersectionPt->x, eSpaceIntersectionPt->y);
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
    
    [positionInESpace initializeVectorX:colPackage->basePoint->x andY:colPackage->basePoint->y];
    [velocityInESpace initializeVectorX:colPackage->velocity->x andY:colPackage->velocity->y];
    
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
    if (![Quadratic getLowestRootA:A andB:B andC:C andThreshold:(1) andRoot:&x1])
        return false;
    t =[x1 floatValue];
   // p->x = pos->x + vel->x*t;//pt.x;
    //p->y = pos->y + vel->y*t;//pt.y;
    collisionPoint = p;
    colPackage->intersectionPoint = collisionPoint;
    colPackage->R3Velocity = vel;
    colPackage->nearestDistance = [x1 floatValue] * [vel length];
    eSpaceIntersectionPt = [colPackage->intersectionPoint multiply:1/r];
    eSpaceNearestDist = colPackage->nearestDistance * 1/r;
    
    return true;
}

- (void) collideAndSlide
{
    colPackage->R3Position = pos;
    colPackage->R3Velocity = [vel add:gravity];//[vel add:[vel add:[gravity multiply:0.00033]]];
    //velocityInESpace = colPackage->R3Velocity;
    
    // calculate position and velocity in eSpace
    Vector *eSpacePosition = [[[Vector alloc] init] autorelease];
    Vector *eSpaceVelocity = [[[Vector alloc] init] autorelease];
    [eSpacePosition initializeVectorX:0 andY:0];
    [eSpaceVelocity initializeVectorX:0 andY:0];
    eSpacePosition = [colPackage->R3Position multiply:(1.0f/(colPackage->eRadius))];
    eSpaceVelocity = [colPackage->R3Velocity multiply:(1.0f/(colPackage->eRadius))];
    // Iterate until we have our final position
    collisionRecursionDepth = 0;
    Vector *finalPosition = [[[Vector alloc] init] autorelease];
    [finalPosition initializeVectorX:0 andY:0];
    //NSLog(@"pos: (%f,%f)", eSpacePosition->x, eSpacePosition->y);
    //NSLog(@"velocity: (%f,%f)", eSpaceVelocity->x, eSpaceVelocity->y);
    finalPosition = [self collideWithWorldPosition:eSpacePosition andVelocity:eSpaceVelocity];
    
    // keep cheese from bouncing straight up, because found collision is set to false because of recursion in collideWithWorld
    if (collisionRecursionDepth>0 && ([colPackage->collidedObj class] == [Drum class] ||
        [colPackage->collidedObj class] == [Flipper class]))
        colPackage->foundCollision = true;
    
   // set the new r3 position (convert back from espace to r3)
   /* colPackage->R3Position = [finalPosition multiply: colPackage->eRadius];
    colPackage->R3Velocity = gravity;
    
    eSpaceVelocity = [gravity multiply:(1/colPackage->eRadius)];
    collisionRecursionDepth = 0;
    
    finalPosition = [self collideWithWorldPosition:finalPosition andVelocity:eSpaceVelocity];*/
    // convert final result back to R3
   // printf("radius: %f\n", colPackage->eRadius);
    //printf("finalPosition: %f,%f\n", finalPosition->x, finalPosition->y);
    float radius = colPackage->eRadius;
    finalPosition = [finalPosition multiply:radius];
    if (colPackage->foundCollision ) {
        // move the entity
        [self moveTo:finalPosition];
    }
    
}



// application scale
const float unitsPerMeter = 10000.0f;
- (Vector*) collideWithWorldPosition: (Vector*)position andVelocity: (Vector*) velocity
{
    float unitScale = unitsPerMeter / 100.0f;
    float veryCloseDistance = 0.01f * unitScale;
    
    // do we need to worry?
    if (collisionRecursionDepth>5)
        return position;
    
    // Ok, we need to worry
    colPackage->velocity = velocity;
    
    [colPackage->normalizedVelocity initializeVectorX:velocity->x andY:velocity->y];
    [colPackage->normalizedVelocity normalize];
    colPackage->basePoint = position;
    
   // NSLog(@"World checking collisions...");
    [world checkCollision:&(colPackage)];
    
    if (colPackage->foundCollision == false) {
        return position;
    }
    
    // *** Collision occured ***
   // NSLog(@"Collision occured");
    // the original destination point
    Vector *destinationPoint = [[Vector alloc] init];
    [destinationPoint initializeVectorX:0 andY:0];
    destinationPoint = [position add: velocity];
    Vector *newBasePoint = position;
    
    // only update if we are not already very close
    // and if so we only move very close to intersection..not
    // to the exact spot
   // NSLog(@"eSpaceNearestDist: %f ", eSpaceNearestDist);
   // NSLog(@"veryCloseDistance: %f ", veryCloseDistance);
    if (eSpaceNearestDist >= veryCloseDistance
        //&&
        //eSpaceIntersectionPt->x!= 0 && eSpaceIntersectionPt->y!=0 &&
        //!isnan(eSpaceIntersectionPt->x) && !isnan(eSpaceIntersectionPt->y) &&
        //!isnan(velocity->x) && !isnan(velocity->y)
        )
    {
        
        Vector *V = [[[Vector alloc] init] autorelease];
        Vector *v = [[[Vector alloc] init] autorelease];
        [v initializeVectorX:0 andY:0];
        [V initializeVectorX:velocity->x andY:velocity->y];
        float length = eSpaceNearestDist-veryCloseDistance;
        [V setLength:length];
       // NSLog(@"V: (%f,%f)", V->x,V->y);
        newBasePoint = [colPackage->basePoint add:V];
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
        if (eSpaceIntersectionPt->length!=0)
            eSpaceIntersectionPt = [eSpaceIntersectionPt subtract: v];
      //  NSLog(@"eSpaceIntersectionPt - a little bit: (%f,%f)", eSpaceIntersectionPt->x, eSpaceIntersectionPt->y);
      //  [V release];
        
    }
    
    // determine the sliding line
    Vector *slideLineOrigin = [[Vector alloc] init];
    slideLineNormal = [[Vector alloc] init];
    // we already have the intersection point from the colliding with line/vertex function
    [slideLineOrigin initializeVectorX:eSpaceIntersectionPt->x andY:eSpaceIntersectionPt->y];
    [slideLineNormal initializeVectorX:0 andY:0];
   // [slideLineNormal initializeVectorX:slidingLine->normal->x andY:slidingLine->normal->y];
   // Vector *newBasePoint = [[Vector alloc] init];
   // newBasePoint = [newBasePoint multiply:1/r];
    slideLineNormal = [position subtract: eSpaceIntersectionPt]; // probably wrong, set normal perpendicular to line
    [slideLineNormal normalize];
   
    slidingLine->origin = slideLineOrigin;
    slidingLine->normal = slideLineNormal;
    slidingLine = [slidingLine initializeLineWithVectorOrigin:slideLineOrigin andVectorNormal:slideLineNormal];
    
    float distance =  [slidingLine signedDistanceTo:destinationPoint]; // distance from original destination point to sliding line
    
    // project the original velocity vector to the sliding line to get a new destination
    Vector *slideLineNormalTimesDistance = [[[Vector alloc] init] autorelease];
    slideLineNormalTimesDistance = [ slideLineNormal multiply:distance];
    Vector *newDestinationPoint = [[Vector alloc] init];
    //if (colPackage->state == COLLISION_SLIDE)
   // {
        newDestinationPoint = [destinationPoint subtract: slideLineNormalTimesDistance];
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

     // Generate the slide vector, which will become our new veocity vector for the next iteration
    Vector *newVelocityVector = [newDestinationPoint subtract:eSpaceIntersectionPt];
    Vector *newVelVecNorm = [[Vector alloc] init];
    [newVelVecNorm  initializeVectorX:newVelocityVector->x andY:newVelocityVector->y];
    [newVelVecNorm normalize];
    
    if (colPackage->state == COLLISION_SLIDE)
    {
        double ax = newVelVecNorm->x*gravity->length;
        double ay = newVelVecNorm->y*gravity->length;
        [acceleration initializeVectorX:ax andY:ay];
    }
    // Recurse
    //NSLog(@"newVelocityVector length: %f", [newVelocityVector length]);
    // dont recurse if the new velocity is very small or bouncing
    float newVelocityLength = [newVelocityVector length];
    //vel = [vel add:acceleration];
    if ( newVelocityLength < veryCloseDistance || colPackage->state == COLLISION_BOUNCE) {
        return [newBasePoint add:newVelocityVector];
    }

    
    collisionRecursionDepth++;
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



@end
