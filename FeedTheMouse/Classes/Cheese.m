
//
//  Cheese.m
//  Feed The Mouse
//
//  Created by Jason Ly on 2012-12-02.
//  Copyright (c) 2012 Jason Ly. All rights reserved.
//

#import "Cheese.h"
#define UNIT 30
//#define SCALE 30
@implementation Cheese


- (NSString*) deviceName
{
   static NSDictionary* deviceNamesByCode = nil;
   static NSString* deviceName = nil;

   if (deviceName) {
     return deviceName;
   }

   deviceNamesByCode = @{
     @"i386"      :@"Simulator",
     @"iPod1,1"   :@"iPod Touch",      // (Original)
     @"iPod2,1"   :@"iPod Touch",      // (Second Generation)
     @"iPod3,1"   :@"iPod Touch",      // (Third Generation)
     @"iPod4,1"   :@"iPod Touch",      // (Fourth Generation)
     @"iPhone1,1" :@"iPhone",          // (Original)
     @"iPhone1,2" :@"iPhone",          // (3G)
     @"iPhone2,1" :@"iPhone",          // (3GS)
     @"iPad1,1"   :@"iPad",            // (Original)
     @"iPad2,1"   :@"iPad 2",          //
     @"iPad3,1"   :@"iPad",            // (3rd Generation)
     @"iPhone3,1" :@"iPhone 4",        //
     @"iPhone4,1" :@"iPhone 4S",       //
     @"iPhone5,1" :@"iPhone 5",        // (model A1428, AT&T/Canada)
     @"iPhone5,2" :@"iPhone 5",        // (model A1429, everything else)
     @"iPad3,4"   :@"iPad",            // (4th Generation)
     @"iPad2,5"   :@"iPad Mini",       // (Original)
     @"iPhone5,3" :@"iPhone 5c",       // (model A1456, A1532 | GSM)
     @"iPhone5,4" :@"iPhone 5c",       // (model A1507, A1516, A1526 (China), A1529 | Global)
     @"iPhone6,1" :@"iPhone 5s",       // (model A1433, A1533 | GSM)
     @"iPhone6,2" :@"iPhone 5s",       // (model A1457, A1518, A1528 (China), A1530 | Global)
     @"iPad4,1"   :@"iPad Air",        // 5th Generation iPad (iPad Air) - Wifi
     @"iPad4,2"   :@"iPad Air",        // 5th Generation iPad (iPad Air) - Cellular
     @"iPad4,4"   :@"iPad Mini",       // (2nd Generation iPad Mini - Wifi)
     @"iPad4,5"   :@"iPad Mini"        // (2nd Generation iPad Mini - Cellular)
   };

   struct utsname systemInfo;
   uname(&systemInfo);
   NSString* code = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];

   deviceName = [deviceNamesByCode objectForKey:code];

   if (!deviceName) {
     // Not found in database. At least guess main device type from string contents:

     if ([code rangeOfString:@"iPod"].location != NSNotFound) {
       deviceName = @"iPod Touch";
     } else if([code rangeOfString:@"iPad"].location != NSNotFound) {
       deviceName = @"iPad";
     } else if([code rangeOfString:@"iPhone"].location != NSNotFound){
       deviceName = @"iPhone";
     } else {
       deviceName = @"Simulator";
     }
   }

   return deviceName;
}

- (id) init
{
    self = [super init];
    if (self)
    {
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        screenScale = [[UIScreen mainScreen] scale];
        CGSize screenSize = CGSizeMake(screenBounds.size.width * screenScale, screenBounds.size.height * screenScale);
        screenWidth = screenSize.width;
        screenHeight = screenSize.height;
        sx = screenWidth/640.0f;
        sy = screenHeight/1136.0f;
        vel = [[Vector alloc] init];
        justTouchVelocity = [[Vector alloc] init];
        prevVel = [[Vector alloc] init];
        [prevVel initializeVectorX:0 andY:0];
        if (screenWidth == 1242)
        {
            cheeseSprite = [Picture fromFile:@"bigCheese.png"];
            accel = -10*UNIT*sy;
            x = (cheeseSprite.x + cheeseSprite.width/2);
            y = (cheeseSprite.y + cheeseSprite.height/2);
        }
        else
        {
            cheeseSprite = [Picture fromFile:@"cheese.png"];
            accel = -10*UNIT*sy;
            x = sx * (cheeseSprite.x + cheeseSprite.width/2);
            y = sy * (cheeseSprite.y + cheeseSprite.height/2);
        }
        
        r = cheeseSprite.width/2;
        
        Vector *accelVector = [[Vector alloc] init];
        [accelVector initializeVectorX:0 andY:accel];

        gravityForce = [[Force alloc] init];
        gravityForce->a = accelVector;
        gravityForce->m = 1;
        gravity = [[Vector alloc] init];
        if (screenWidth == 1242)
            [gravity initializeVectorX:0 andY:(-10*UNIT*screenScale) ];
        else
            [gravity initializeVectorX:0 andY:(-10*UNIT*sy*screenScale) ];
        
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
        prevVelocity = [[Vector alloc] init];
        [prevVelocity initializeVectorX:0 andY:0];
        colPackage->closestPoint = [[Vector alloc] init];
        [colPackage->closestPoint initializeVectorX:0.0f andY:0.0f];
        colPackage->R3Velocity = [[Vector alloc] init];
        
        prevVelocities = [[NSMutableArray alloc] init];
        numOfLives = 5;
    }
    return self;
}

- (void) placeAt: (CGPoint) pt
{
    if (screenWidth == 1242)
    {
        cheeseSprite.x = pt.x - cheeseSprite.width/2;
        cheeseSprite.y = pt.y - cheeseSprite.height/2;
    }
    else
    {
        cheeseSprite.x = pt.x - cheeseSprite.width/2;
        cheeseSprite.y = pt.y - cheeseSprite.height/2;
    }
    x = pt.x;
    y = pt.y;
    pos->x = x;
    pos->y = y;
}

- (void) dropAt: (CGPoint) pt
{
    //vel->x = 0;
    //vel->y = 0;
    [vel initializeVectorX:0 andY:0];
    acceleration->x = 0;
    acceleration->y = gravity->y;
    if (screenWidth == 1242)
    {
        cheeseSprite.x = pt.x - cheeseSprite.width/2;
        cheeseSprite.y = pt.y - cheeseSprite.height/2;
    }
    else
    {
        cheeseSprite.x = pt.x/screenScale - cheeseSprite.width/2;
        cheeseSprite.y = pt.y/screenScale - cheeseSprite.height/2;
    }
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
    angularVelocity = angularDisplacement = 1.4;
}

- (void) fall:(float) interpolation
{
    double leftLimitX = 0;
    double rightLimitX = 0;
    bool isBouncingOffWall = false;
   
    if ( cheeseSprite.y + cheeseSprite.height > 0)
    {
        if (screenWidth == 1242)
        {
            leftLimitX = cheeseSprite.width/2;
            rightLimitX = screenWidth - cheeseSprite.width/2;
        }
        else
        {
            leftLimitX = cheeseSprite.width/2*sx;
            rightLimitX = 640*sx - cheeseSprite.width/2*sx;
        }
        if (pos->x > rightLimitX)
        {
            pos->x = rightLimitX;
            x = pos->x;
            [self bounceOffRightWall];
            
        }
        else if (pos->x < leftLimitX)
        {
            pos->x = leftLimitX;
            x = pos->x;
            [self bounceOffLeftWall];
        }
        if (!colPackage->foundCollision && collisionRecursionDepth == 0)
        {
            time = interpolation;
            
           // NSString *device = [self deviceName];
            
            float vxt = 0;
            float vyt = 0;
            //if (screenWidth == 750)
                vxt = vel->x*time;
           // else
            //    vxt = vel->x*time;
           // if (screenHeight == 1334)
                vyt = vel->y*time;
           // else
            //    vyt = vel->y*time;
            
            x = pos->x + vxt;
            y = pos->y + vyt;
            
            if (DEBUG)
            {
                NSLog(@"vel->y: %f", vel->y);
                NSLog(@"time: %f",time);
            }
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
                /*if ([colPackage->collidedObj class] == [Wall class])
                {
                    x = pos->x + justTouchVelocity->x;
                    y = pos->y + justTouchVelocity->y;
                }
                else*/ if ([colPackage->collidedObj class] == [Gear class])
                {
                    x = pos->x;// + justTouchVelocity->x;//*time;
                    y = pos->y;// + justTouchVelocity->y;//*time;
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
                    if (!colPackage->foundCollision || colPackage->isSlidingOff || colPackage->state == COLLISION_BOUNCE)
                    {
                        time = interpolation;
                       
                        vxt = lroundf(vel->x*time);
                        vyt = lroundf(vel->y*time);
                        
                        x = pos->x + vxt;
                        y = pos->y + vyt;
                    }
                   
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
                        //vel->x = initVel->x+acceleration->x*time;
                        x = pos->x + vel->x*time;
                        pos->x = x;
                       //vel->y = initVel->y + acceleration->y*time;
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
    /*if (pos->y > (960*sy-cheeseSprite.height/2) && vel->y > 0)
    {
        pos->y = 960*sy-cheeseSprite.height/2;
        y = pos->y;
    }*/
    
    
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

- (void) draw: (CGContextRef) context resizeTo: (CGSize) scale
{
    [cheeseSprite draw:context resizeTo:scale];
}

- (bool) checkCoin:(Coin *)c
{
    float cx = 0;
    float cy = 0;
    Vector *coinPosition = [[Vector alloc] init];
    if (screenWidth == 1242)
    {
        cx = c->pos->x - c->coinSprite.width/2;
        cy = c->pos->y - c->coinSprite.height/2;
    }
    else
    {
        cx = c->pos->x * sx - c->coinSprite.width/2*sx;
        cy = c->pos->y * sy - c->coinSprite.height/2*sy;
    }
    [coinPosition initializeVectorX:cx andY:cy];
    double dist = [coinPosition subtract:pos]->length;
    double sumRadii = (c->r*sy + r*sy);
    
    if (screenWidth == 1242)
        sumRadii = c->r + r;
    dist -= sumRadii;
   // NSLog(@"Distance from cheese to coin: %f", dist);
  //  NSLog(@"vel length: %f", [vel length]);
    if( [vel length]*time < dist){
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
    C = [coinPosition subtract:pos];//[c->pos subtract:pos];
   // NSLog(@"C: (%f,%f)", C->x, C->y);
    
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
    if (DEBUG)
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
    float screenWidth = [UIScreen.mainScreen bounds].size.width * [UIScreen.mainScreen scale];
    float screenHeight = [UIScreen.mainScreen bounds].size.height * [UIScreen.mainScreen scale];
    Vector *gearPosition = [[[Vector alloc] init] autorelease];
    float gx = g->pos->x * sx;
    float gy = g->pos->y * sy;
    if (screenWidth == 1242)
    {
        gx = g->pos->x;
        gy = g->pos->y;
    }
    [gearPosition initializeVectorX:gx andY:gy];
    double dist = [gearPosition subtract:pos]->length;
    double sumRadii = (g->r*sy + r*sy);
    if (screenWidth == 1242)
    {
        sumRadii = g->r + r;
    }
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
    C = [gearPosition subtract:pos];

   
    
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
    double cSquared = lengthC * lengthC;
    double F = cSquared - (D * D);
    
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
    if (screenWidth == 1242)
    {
        bounceVel->x = (x - gearPosition->x);
        bounceVel->y = (y - gearPosition->y);
    }
    else
    {
        bounceVel->x = sx*(x - gearPosition->x);//(x - g->x);
        bounceVel->y = sy*(y - gearPosition->y);//(y - g->y);
    }
    //printf("bounceVel retain count: %lu", (unsigned long)[bounceVel length]);
   // printf("bounceVel retain count: %lu", (unsigned long)[bounceVel retainCount]);
    [bounceVel normalize];
    
    
    
   /* Vector *normal = [[Vector alloc] init];
    [normal initializeVectorX:0 andY:0];
    [C normalize];
    normal = [[C multiply:-1] multiply:gravity->length];*/
    double length = [vel length];
    bounceVel = [bounceVel multiply:length];// add:gravity] add:normal];
    
    if (cSquared < sumRadiiSquared) // if cheese goes into the gear
    {
        
        justTouchVelocity = bounceVel;
        [justTouchVelocity normalize];
        distance = sumRadii - lengthC;
        justTouchVelocity = [justTouchVelocity multiply:distance];
        /*if (x + justTouchVelocity->x > screenWidth - cheeseSprite.width/2)
        {
            double newPosX = x + justTouchVelocity->x;
            double diffX = newPosX - (screenWidth - cheeseSprite.width/2);
            justTouchVelocity->x -= diffX;
            double newPosY = y + justTouchVelocity->y;
            double diffY =  y + (sumRadii) - newPosY;
            justTouchVelocity->y += diffY;
        }*/
    }
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


- (bool) checkBomb:(Bomb *)b
{    // Early Escape test: if the length of the movevec is less
    // than distance between the centers of these circles minus
    // their radii, there's no way they can hit.
    float screenWidth = [UIScreen.mainScreen bounds].size.width * [UIScreen.mainScreen scale];
    float screenHeight = [UIScreen.mainScreen bounds].size.height * [UIScreen.mainScreen scale];
    Vector *bombPosition = [[[Vector alloc] init] autorelease];
    float bx = b->pos->x * sx;
    float by = b->pos->y * sy;
    if (screenWidth == 1242)
    {
        bx = b->pos->x;
        by = b->pos->y;
    }
    [bombPosition initializeVectorX:bx andY:by];
    double dist = [bombPosition subtract:pos]->length;
    double sumRadii = (b->r*sy + r*sy);
    if (screenWidth == 1242)
    {
        sumRadii = b->r + r;
    }
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
    C = [bombPosition subtract:pos];

   
    
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
    double cSquared = lengthC * lengthC;
    double F = cSquared - (D * D);
    
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
    
    /*bounceVel = [[Vector alloc] init];
    if (screenWidth == 1242)
    {
        bounceVel->x = (x - bombPosition->x);
        bounceVel->y = (y - bombPosition->y);
    }
    else
    {
        bounceVel->x = sx*(x - bombPosition->x);//(x - g->x);
        bounceVel->y = sy*(y - bombPosition->y);//(y - g->y);
    }*/
    //printf("bounceVel retain count: %lu", (unsigned long)[bounceVel length]);
   // printf("bounceVel retain count: %lu", (unsigned long)[bounceVel retainCount]);
   // [bounceVel normalize];
    
    
    
   /* Vector *normal = [[Vector alloc] init];
    [normal initializeVectorX:0 andY:0];
    [C normalize];
    normal = [[C multiply:-1] multiply:gravity->length];*/
    double length = [vel length];
   // bounceVel = [bounceVel multiply:length];// add:gravity] add:normal];
    
    if (cSquared < sumRadiiSquared)
    {
        
       // justTouchVelocity = bounceVel;
        [justTouchVelocity normalize];
        distance = sumRadii - lengthC;
        justTouchVelocity = [justTouchVelocity multiply:distance];
    }
    /*double theta = M_PI_2;
    double fx = C->x * cos(theta) - C->y * sin(theta);
    double fy = C->x * sin(theta) - C->y * cos(theta);
    Vector *Friction = [[Vector alloc] init];
    [Friction initializeVectorX:fx andY:fy];
    [Friction normalize];
    Friction = [Friction multiply:(UNIT*10)];
    bounceVel = [bounceVel add:Friction];*/
    numOfLives--;
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


    bool foundCollision = false;
    while (totter->angle <= 0 || totter->angle > 360) {
        if (totter->angle <= 0)
            totter->angle+=360;
        else if (totter->angle >360)
            totter->angle-=360;
    }
    double radAngle = totter->angle*M_PI/180.0f;    // get top left of rectangle
    
    if (screenWidth == 1242)
    {
        topLeftX = (totter->x - cos(radAngle)*totter->totterSprite.width/2 + cos(radAngle+M_PI_2)*totter->totterSprite.height/2);
        topLeftY = (totter->y - sin(radAngle)*totter->totterSprite.width/2 + sin(radAngle+M_PI_2)*totter->totterSprite.height/2);
    }
    else
    {
        topLeftX = sx * (totter->x - cos(radAngle)*totter->totterSprite.width/2 + cos(radAngle+M_PI_2)*totter->totterSprite.height/2);
        topLeftY = sy * (totter->y - sin(radAngle)*totter->totterSprite.width/2 + sin(radAngle+M_PI_2)*totter->totterSprite.height/2);
    }
    topLeftPt = CGPointMake(topLeftX, topLeftY);
    // get top right of rectangle
    if (screenWidth == 1242)
    {
        topRightX = (totter->x + cos(radAngle)*totter->totterSprite.width/2 + cos(radAngle+M_PI_2)*totter->totterSprite.height/2);
        topRightY = (totter->y + sin(radAngle)*totter->totterSprite.width/2 + sin(radAngle+M_PI_2)*totter->totterSprite.height/2);
    }
    else
    {
        topRightX = sx * (totter->x + cos(radAngle)*totter->totterSprite.width/2 + cos(radAngle+M_PI_2)*totter->totterSprite.height/2);
        topRightY = sy * (totter->y + sin(radAngle)*totter->totterSprite.width/2 + sin(radAngle+M_PI_2)*totter->totterSprite.height/2);
    }
    topRightPt = CGPointMake(topRightX,topRightY);
    // get bottom left of rectangle
    if (screenWidth == 1242)
    {
        bottomLeftX = (totter->x - cos(radAngle)*totter->totterSprite.width/2 + cos(radAngle-M_PI_2)*totter->totterSprite.height/2);
        bottomLeftY = (totter->y - sin(radAngle)*totter->totterSprite.width/2 + sin(radAngle-M_PI_2)*totter->totterSprite.height/2);
    }
    else
    {
        bottomLeftX = sx * (totter->x - cos(radAngle)*totter->totterSprite.width/2 + cos(radAngle-M_PI_2)*totter->totterSprite.height/2);
        bottomLeftY = sy * (totter->y - sin(radAngle)*totter->totterSprite.width/2 + sin(radAngle-M_PI_2)*totter->totterSprite.height/2);
    }
    bottomLeftPt = CGPointMake(bottomLeftX, bottomLeftY);
    // get bottom right of rectangle
    if (screenWidth == 1242)
    {
        bottomRightX = (totter->x + cos(radAngle)*totter->totterSprite.width/2 + cos(radAngle-M_PI_2)*totter->totterSprite.height/2);
        bottomRightY = (totter->y + sin(radAngle)*totter->totterSprite.width/2 + sin(radAngle-M_PI_2)*totter->totterSprite.height/2);
    }
    else
    {
        bottomRightX = sx * (totter->x + cos(radAngle)*totter->totterSprite.width/2 + cos(radAngle-M_PI_2)*totter->totterSprite.height/2);
        bottomRightY = sy * (totter->y + sin(radAngle)*totter->totterSprite.width/2 + sin(radAngle-M_PI_2)*totter->totterSprite.height/2);
    }
    bottomRightPt = CGPointMake(bottomRightX,bottomRightY);
    
    topLine = [topLine initializeLineWithPoint1:topLeftPt andPoint2:topRightPt];
    bottomLine = [bottomLine initializeLineWithPoint1:bottomRightPt andPoint2:bottomLeftPt];
    leftLine = [leftLine initializeLineWithPoint1:bottomLeftPt andPoint2:topLeftPt];
    rightLine = [rightLine initializeLineWithPoint1:topRightPt andPoint2:bottomRightPt];
    totter->topLine = topLine;
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
        
        //bool isCollidedWithTopLeft = [self collideWithVertex:topLeft];
        //bool isCollidedWithTopRight = [self collideWithVertex:topRight];
        Vector *topLeftVector = [[Vector alloc] init];
        [topLeftVector initializeVectorX:topLeft.x andY:topLeft.y];
        Vector *topRightVector = [[Vector alloc] init];
        [topRightVector initializeVectorX:topRight.x andY:topRight.y];
        Vector *bottomLeftVector = [[[Vector alloc] init] autorelease];
        [bottomLeftVector initializeVectorX:bottomLeft.x andY:bottomLeft.y];        
        Vector *bottomRightVector = [[[Vector alloc] init] autorelease];
        [bottomRightVector initializeVectorX:bottomRight.x andY:bottomRight.y];
        isPastTopLeft = [self pastVertex:topLeftVector];
        isPastTopRight = [self pastVertex:topRightVector];
        isPastBottomLeft = [self pastVertex:bottomLeftVector];
        isPastBottomRight = [self pastVertex:bottomRightVector];
        isPastBottomLeft = [self pastVertex:bottomLeftVector];
        isPastBottomRight = [self pastVertex:bottomRightVector];
        isPastTopLine = [self pastLine:topLine];
        isPastBottomLine = [self pastLine:bottomLine];
        isNearTopLeft = [self nearVertex:topLeft];
        isNearTopRight = [self nearVertex:topRight];
        isNearTopLine = [self nearLine:topLine];
        isNearRightLine = [self nearLine:rightLine];
        isNearLeftLine = [self nearLine:leftLine];
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
        
        float xRightCheese = pos->x + cheeseSprite->width/2.0f;
        float xLeftCheese = pos->x - cheeseSprite->width/2.0f;
        
        Vector *cheeseVector = [[Vector alloc] init];
        [cheeseVector initializeVectorX:x andY:y];
        Vector *cheesePtToTopLeft = [cheeseVector subtract:topLeftVector];
        Vector *topLineVector = [topRightVector subtract:topLeftVector];
        Vector *bottomLineVector = [bottomRightVector subtract:bottomLeftVector];
        if ( collidedWithTopLeft == shortestDistance || isNearTopLeft)
        {
            bool isCollidedWithTopLeft = [self collideWithVertex:topLeft];
            //Vector *topLeftVector = [[[Vector alloc] init] autorelease];
            //[topLeftVector initializeVectorX:topLeft.x andY:topLeft.y];
            normal = [[topLine->normal add:leftLine->normal] multiply:0.5f];
            //normal = [self->pos subtract:topLeftVector];
            [normal normalize];
           
            foundCollision = true;
            slidingLine->normal = normal;
            colPackage->state = COLLISION_SLIDE;
            
            /*if (isNearTopLeft && !isCollidedWithTopLeft)
            {
                
                if (vel->x >= 0 && x < totter->totterSprite.x )
                {
                    isPastTopLeft = [self pastVertex:topLeftVector];
                  //  isPastLeftLine = [self pastLine:leftLine];
                    if (!isPastTopLeft)
                        isPastLeftLine = [self pastLine:leftLine];
                    colPackage->state = COLLISION_BOUNCE;
                    foundCollision = true;
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
                    bounceVel = [[bounceVel multiply:vel.length] add:gravity];// [bounceVel multiply:(vel.length/screenScale)];//

                    slidingLine->normal = normal;
                }
                else//if (vel->x <0)
                {
                    colPackage->isSlidingOff = true;
                    //normal = [[topLine->normal add:leftLine->normal] multiply:0.5f];
                    
                    //[normal normalize];
                   // totter->normal = normal;
                }
            }
            else
            {
                if (vel->x > 0 && x < totter->totterSprite.x)
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
                    bounceVel = [[bounceVel multiply:vel.length] add:gravity];//[bounceVel multiply:(vel.length/screenScale)];// [[normal multiply:vel.length] add:gravity];
                   
                    slidingLine->normal = normal;
                }
                else //if (vel->x < 0)
                {*/

                     colPackage->isSlidingOff = true;
                //}
            //}
            
            
        }
        else if (collidedWithTopRight == shortestDistance || isNearTopRight)
        {
            bool isCollidedWithTopRight = [self collideWithVertex:topRight];
            Vector *topRightVector = [[[Vector alloc] init] autorelease];
            [topRightVector initializeVectorX:topRight.x andY:topRight.y];
            foundCollision = true;
            normal = [[topLine->normal add:rightLine->normal] multiply:0.5f];
           // normal = [self->pos subtract:topRightVector];
            [normal normalize];
            slidingLine->normal = normal;
            colPackage->state = COLLISION_SLIDE;
            
            if (isNearTopRight && !isCollidedWithTopRight)
            {
                if (vel->x > 0)
                {
                    colPackage->isSlidingOff = true;
                  // normal = [[topLine->normal add:rightLine->normal] multiply:0.5f];
                 
                  // [normal normalize];
                   //totter->normal = normal;
                  //  colPackage->isSlidingOff = true;
                }
                else if (vel->x <= 0)
                {
                    isPastTopRight = [self pastVertex:topRightVector];
                    if (!isPastTopRight)
                        isPastRightLine = [self pastLine:rightLine];
                    
                    colPackage->state = COLLISION_BOUNCE;
                    foundCollision = true;
                    Vector *I = [[[Vector alloc] init] autorelease];
                    Vector *negativeI = [[[Vector alloc] init] autorelease];
                    //if (abs(vel->x) < 0.00000001)
                    //{
                      //  int roundedVelX = (int)(1000000000000000 * vel->x);
                       // vel->x = roundedVelX/1000000000000000.0f;
                    //}
                    //if (vel->y < 0.000000001)
                    //{
                      //  int roundedVelY = (int)(10000000000 * vel->y);
                       // vel->y = roundedVelY/10000000000.0f;
                    //}
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
                    bounceVel = [bounceVel multiply:(vel.length/screenScale)];
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
                    bounceVel = [bounceVel multiply:(vel.length/screenScale)];// [[bounceVel multiply:vel.length] add:gravity];
    
                    slidingLine->normal = normal;
                }
                else if (vel->x > 0)
                {
                    colPackage->isSlidingOff = true;
                }
            }
            //foundCollision = true;
            
        }
        else if (collidedWithLeft == shortestDistance)// || isNearLeftLine) //commented to keep from getting stuck on top left
        {
            [self collideWithLine:leftLine];
            //if ([leftLine isFrontFacingTo:vel])
            //{
                normal = leftLine->normal = [leftLine normal];
            /*}
            else
            {
                [normal initializeVectorX:-leftLine->normal->x andY: -leftLine->normal->y];
                leftLine->normal = normal;
            }*/
            [normal normalize];
            // projection of the normal along I (initial velocity vector going towards the line)
            N = [normal multiply:[negativeI dotProduct:normal]];
            bounceVel = [[N multiply:2] add:I];
            [bounceVel normalize];
            bounceVel = [[bounceVel multiply:vel.length] add:gravity];//[bounceVel multiply:(vel.length/2.0f)];//
            foundCollision = true;
            colPackage->state = COLLISION_BOUNCE;
        }
        else if (collidedWithRight == shortestDistance)// || isNearRightLine)
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
            bounceVel = [[bounceVel multiply:vel.length] add:gravity];//[bounceVel multiply:(vel.length/screenScale)];
            foundCollision = true;
            colPackage->state = COLLISION_BOUNCE;
        }
        else if ((collidedWithTop == shortestDistance || (isNearTopLine && xRightCheese < topRightX && xLeftCheese > topLeftX)) && [cheesePtToTopLeft crossProduct:topLineVector] < 0) // y>topLine->origin->y)// || isPastTopLine)
        {
            if (collidedWithTop == shortestDistance)
            {
                isCollidedWithTop = [self collideWithLine:topLine];
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
            slidingLine->p1 = CGPointMake( topLine->p1.x/(r*sx), topLine->p1.y/(r*sy));
            slidingLine->p2 = CGPointMake( topLine->p2.x/(r*sx), topLine->p2.y/(r*sy));
            if (screenWidth == 1242)
            {
                slidingLine->p1 = CGPointMake( topLine->p1.x/(r), topLine->p1.y/(r));
                slidingLine->p2 = CGPointMake( topLine->p2.x/(r), topLine->p2.y/(r));
                
            }
               
            if (collidedWithTop == shortestDistance)
                foundCollision = true;
            
            colPackage->state = COLLISION_SLIDE;
        }
        else if (collidedWithBottomLeft == shortestDistance || isPastBottomLeft)
        {
            [self collideWithVertex:bottomLeft];
            Vector *bottomLeftVector = [[[Vector alloc] init] autorelease];
            [bottomLeftVector initializeVectorX:bottomLeft.x andY:bottomLeft.y];
            Vector *negativeI = [[[Vector alloc] init] autorelease];
            [negativeI initializeVectorX:-vel->x andY:-vel->y];
            normal = [self->pos subtract:bottomLeftVector];
            
            [normal normalize];
            double scaler = [negativeI dotProduct:normal];
            if (scaler < 0)
                scaler = -scaler;
            
            // projection of the normal along I (initial velocity vector going towards the line)
            N = [normal multiply:scaler];
           // [I normalize];
            bounceVel = [[N multiply:2] add:I];
            [bounceVel normalize];
            bounceVel = [bounceVel multiply:(vel.length/screenScale)];//[[bounceVel multiply:vel.length] add:gravity];
            foundCollision = true;
            colPackage->state = COLLISION_BOUNCE;
            slidingLine->normal = normal;
        }
        else if (collidedWithBottomRight == shortestDistance || isPastBottomRight)
        {
            [self collideWithVertex:bottomRight];
            Vector *bottomRightVector = [[[Vector alloc] init] autorelease];
            [bottomRightVector initializeVectorX:bottomRight.x andY:bottomRight.y];
           
            normal = [self->pos subtract:bottomRightVector];
            // projection of the normal along I (initial velocity vector going towards the line)
            
           
            double scaler = [negativeI dotProduct:normal];
            if (scaler < 0)
                scaler = -scaler;
            [normal normalize];
            N = [normal multiply:scaler];
         //  [I normalize];
            bounceVel = [[N multiply:2] add:I];
            [bounceVel normalize];
            bounceVel = [bounceVel multiply:(vel.length/screenScale)];// [[bounceVel multiply:vel.length] add:gravity];
            foundCollision = true;
            colPackage->state = COLLISION_BOUNCE;
            slidingLine->normal = normal;
        }
        else if (collidedWithBottom == shortestDistance && [cheesePtToTopLeft crossProduct:bottomLineVector] > 0) // y < totter->y)
        {
            [self collideWithLine:bottomLine];
           // if ([bottomLine isFrontFacingTo:vel])
            //{
                normal = [bottomLine normal];
            //}
            //else
           // {
             //   [normal initializeVectorX:-bottomLine->normal->x andY: -bottomLine->normal->y];
           // }
            double scaler = [negativeI dotProduct:normal];
            if (scaler < 0)
                scaler = -scaler;
            [normal normalize];
            // projection of the normal along I (initial velocity vector going towards the line)
            N = [normal multiply:scaler];
            //[N setVector: [normal multiply:[negativeI dotProduct:normal]]];
            [I normalize];
            bounceVel = [[N multiply:2] add:I];
            [bounceVel normalize];
            bounceVel = [bounceVel multiply:(vel.length/screenScale)];//[[bounceVel multiply:vel.length] add:gravity];
            foundCollision = true;
            slidingLine->normal = normal;
            colPackage->state = COLLISION_BOUNCE;
        }
        else if ((isPastTopLine || isPastBottomLine || isPastBottomRight || isPastBottomLeft || isPastTopLeft || isPastTopRight || isPastRightLine || isPastLeftLine)) //&& (shortestDistance == FLT_MAX || shortestDistance==-1))
        {
            if (diff < veryCloseDistance)
                diff = veryCloseDistance;
            Vector *I = [[[Vector alloc] init] autorelease];
            [I initializeVectorX:vel->x andY:vel->y];
            Vector *negativeI = [[[Vector alloc] init] autorelease];
            [negativeI initializeVectorX:-vel->x andY:-vel->y];
            colPackage->state = COLLISION_BOUNCE;
            double cheeseRadius = r*sy;
            if ( screenWidth == 1242)
                cheeseRadius = r;
            
            if (isPastTopLeft)
                normal = [self->pos subtract:topLeftVector];
            else if (isPastTopRight)
                normal = [self->pos subtract:topRightVector];
            else if (isPastBottomRight)
                normal = [self->pos subtract:bottomRightVector];
            else if (isPastBottomLeft)
                normal = [self->pos subtract:bottomLeftVector];
            else if (isPastLeftLine)
                normal = [leftLine normal];
            else if (isPastRightLine)
                normal = [rightLine normal];
            else if (isPastTopLine)
            {
                CGPoint p1 = CGPointMake( topLine->p1.x/cheeseRadius, topLine->p1.y/cheeseRadius);
                CGPoint p2 = CGPointMake( topLine->p2.x/cheeseRadius, topLine->p2.y/cheeseRadius);
                [slidingLine initializeLineWithPoint1:p1 andPoint2:p2];
                normal = [topLine normal];
            }
            else if (isPastBottomLine)
            {
                CGPoint p1 = CGPointMake( bottomLine->p1.x/cheeseRadius, bottomLine->p1.y/cheeseRadius);
                CGPoint p2 = CGPointMake( bottomLine->p2.x/cheeseRadius, bottomLine->p2.y/cheeseRadius);
                [slidingLine initializeLineWithPoint1:p1 andPoint2:p2];
                normal = [bottomLine normal];
            }
            colPackage->collidedObj = totter;
            foundCollision = true;
            //colPackage->foundCollision = true;
            [normal normalize];
            slidingLine->normal = normal;
            //[normal normalize];
            double scaler = [negativeI dotProduct:normal];
            if (scaler < 0)
               scaler = -scaler;
            N = [normal multiply:scaler];
            bounceVel = [[N multiply:2] add:I];
            // initVel = bounceVel; will be done in bounceoffdrum
            [bounceVel normalize];
            bounceVel = [bounceVel multiply:vel.length];
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
    if (screenWidth == 1242)
    {
        topLeftX = (d->x - cos(radAngle)*d->drumSprite.width/2 + cos(radAngle+M_PI_2)*d->drumSprite.height/2);
        topLeftY = (d->y - sin(radAngle)*d->drumSprite.width/2 + sin(radAngle+M_PI_2)*d->drumSprite.height/2);
    }
    else
    {
        topLeftX = sx * (d->x - cos(radAngle)*d->drumSprite.width/2 + cos(radAngle+M_PI_2)*d->drumSprite.height/2);
        topLeftY = sy * (d->y - sin(radAngle)*d->drumSprite.width/2 + sin(radAngle+M_PI_2)*d->drumSprite.height/2);
    }
    topLeftPt = CGPointMake(topLeftX, topLeftY);
    // get top right of rectangle
    if (screenWidth == 1242)
    {
        topRightX = (d->x + cos(radAngle)*d->drumSprite.width/2 + cos(radAngle+M_PI_2)*d->drumSprite.height/2);
        topRightY = (d->y + sin(radAngle)*d->drumSprite.width/2 + sin(radAngle+M_PI_2)*d->drumSprite.height/2);
    }
    else
    {
        topRightX = sx * (d->x + cos(radAngle)*d->drumSprite.width/2 + cos(radAngle+M_PI_2)*d->drumSprite.height/2);
        topRightY = sy * (d->y + sin(radAngle)*d->drumSprite.width/2 + sin(radAngle+M_PI_2)*d->drumSprite.height/2);
    }
    topRightPt = CGPointMake(topRightX,topRightY);
    // get bottom left of rectangle
    if (screenWidth == 1242)
    {
        bottomLeftX = (d->x - cos(radAngle)*d->drumSprite.width/2 + cos(radAngle-M_PI_2)*d->drumSprite.height/2);
        bottomLeftY = (d->y - sin(radAngle)*d->drumSprite.width/2 + sin(radAngle-M_PI_2)*d->drumSprite.height/2);
    }
    else
    {
        bottomLeftX = sx * (d->x - cos(radAngle)*d->drumSprite.width/2 + cos(radAngle-M_PI_2)*d->drumSprite.height/2);
        bottomLeftY = sy * (d->y - sin(radAngle)*d->drumSprite.width/2 + sin(radAngle-M_PI_2)*d->drumSprite.height/2);
    }
    bottomLeftPt = CGPointMake(bottomLeftX, bottomLeftY);
    // get bottom right of rectangle
    if (screenWidth == 1242)
    {
        bottomRightX = (d->x + cos(radAngle)*d->drumSprite.width/2 + cos(radAngle-M_PI_2)*d->drumSprite.height/2);
        bottomRightY = (d->y + sin(radAngle)*d->drumSprite.width/2 + sin(radAngle-M_PI_2)*d->drumSprite.height/2);
    }
    else
    {
        bottomRightX = sx * (d->x + cos(radAngle)*d->drumSprite.width/2 + cos(radAngle-M_PI_2)*d->drumSprite.height/2);
        bottomRightY = sy * (d->y + sin(radAngle)*d->drumSprite.width/2 + sin(radAngle-M_PI_2)*d->drumSprite.height/2);
    }
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
        isPastBottomLine = [self pastLine:bottomLine];
        Vector *bottomRightVector = [[Vector alloc] init];
        [bottomRightVector initializeVectorX:bottomRight.x andY:bottomRight.y];
        isPastBottomRight = [self pastVertex:bottomRightVector];
        Vector *bottomLeftVector = [[Vector alloc] init];
        [bottomLeftVector initializeVectorX:bottomLeft.x andY:bottomLeft.y];
        isPastBottomLeft = [self pastVertex:bottomLeftVector];
        Vector *topLeftVector = [[Vector alloc] init];
        [topLeftVector initializeVectorX:topLeft.x andY:topLeft.y];
        isPastTopLeft = [self pastVertex:topLeftVector];
        Vector *topRightVector = [[Vector alloc] init];
        [topRightVector initializeVectorX:topRight.x andY:topRight.y];
        isPastTopRight = [self pastVertex:topRightVector];
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
            
        if ((isPastTopLine || isPastBottomLine || isPastBottomRight || isPastBottomLeft || isPastTopLeft || isPastTopRight) && (shortestDistance == FLT_MAX || shortestDistance==-1))
        {
            if (diff < veryCloseDistance)
                diff = veryCloseDistance;
            Vector *I = [[[Vector alloc] init] autorelease];
            [I initializeVectorX:vel->x andY:vel->y];
            Vector *negativeI = [[[Vector alloc] init] autorelease];
            [negativeI initializeVectorX:-vel->x andY:-vel->y];
            colPackage->state = COLLISION_BOUNCE;
            double cheeseRadius = r*sy;
            if ( screenWidth == 1242)
                cheeseRadius = r;
            if (isPastTopLine)
            {
                CGPoint p1 = CGPointMake( topLine->p1.x/cheeseRadius, topLine->p1.y/cheeseRadius);
                CGPoint p2 = CGPointMake( topLine->p2.x/cheeseRadius, topLine->p2.y/cheeseRadius);
                [slidingLine initializeLineWithPoint1:p1 andPoint2:p2];
                normal = [topLine normal];
                [d vibrate];
            }
            else if (isPastBottomLine)
            {
                CGPoint p1 = CGPointMake( bottomLine->p1.x/cheeseRadius, bottomLine->p1.y/cheeseRadius);
                CGPoint p2 = CGPointMake( bottomLine->p2.x/cheeseRadius, bottomLine->p2.y/cheeseRadius);
                [slidingLine initializeLineWithPoint1:p1 andPoint2:p2];
                normal = [bottomLine normal];
            }
            else if (isPastTopLeft)
                normal = [self->pos subtract:topLeftVector];
            else if (isPastTopRight)
                normal = [self->pos subtract:topRightVector];
            else if (isPastBottomRight)
                normal = [self->pos subtract:bottomRightVector];
            else if (isPastBottomLeft)
                normal = [self->pos subtract:bottomLeftVector];
            colPackage->collidedObj = d;
            foundCollision = true;
            //colPackage->foundCollision = true;
            slidingLine->normal = normal;
            [normal normalize];
            double scaler = [negativeI dotProduct:normal];
            if (scaler < 0)
               scaler = -scaler;
            N = [normal multiply:scaler];
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
            bounceVel = [bounceVel multiply:(vel.length/screenScale)];
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
            bounceVel = [bounceVel multiply:(vel.length/screenScale)];
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
        else if (collidedWithTop==shortestDistance || collidedWithBottom== shortestDistance )// && isNearTopLine)
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
                    prevVelocity = vel;
                    if ([topLine isFrontFacingTo:vel])
                    {
                        normal = [topLine normal];
                    }
                    else
                    {
                        [normal initializeVectorX:-topLine->normal->x andY: -topLine->normal->y];
                    }
                    [d vibrate];
                }
                else
                {
                    normal = [topLine normal];
                }
                slidingLine->p1 = CGPointMake( topLine->p1.x/(r*sx), topLine->p1.y/(r*sy));
                slidingLine->p2 = CGPointMake( topLine->p2.x/(r*sx), topLine->p2.y/(r*sy));
                colPackage->state = COLLISION_BOUNCE;
                NSString *pathForDrumSoundFile = [[NSBundle mainBundle] pathForResource:@"sounds/Drum_Bounce" ofType:@"mp3"];
                [world->sndMan playSound:pathForDrumSoundFile];
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
    if (screenWidth == 1242)
    {
        topLeftX = (f->x - cos(radAngle)*f->sprite.width/2 + cos(radAngle+M_PI_2)*f->sprite.height/2);
        topLeftY = (f->y - sin(radAngle)*f->sprite.width/2 + sin(radAngle+M_PI_2)*f->sprite.height/2);
    }
    else
    {
        topLeftX = sx * (f->x - cos(radAngle)*f->sprite.width/2 + cos(radAngle+M_PI_2)*f->sprite.height/2);
        topLeftY = sy * (f->y - sin(radAngle)*f->sprite.width/2 + sin(radAngle+M_PI_2)*f->sprite.height/2);
    }
    topLeftPt = CGPointMake(topLeftX, topLeftY);
    // get top right of rectangle
    if (DEBUG)
        printf("flipper rad angle: %f \n", radAngle);
    if (screenWidth == 1242)
    {
        topRightX = (f->x + cos(radAngle)*f->sprite.width/2 + cos(radAngle+M_PI_2)*f->sprite.height/2);
        topRightY = (f->y + sin(radAngle)*f->sprite.width/2 + sin(radAngle+M_PI_2)*f->sprite.height/2);
    }
    else
    {
        topRightX = sx * (f->x + cos(radAngle)*f->sprite.width/2 + cos(radAngle+M_PI_2)*f->sprite.height/2);
        topRightY = sy * (f->y + sin(radAngle)*f->sprite.width/2 + sin(radAngle+M_PI_2)*f->sprite.height/2);
    }
    topRightPt = CGPointMake(topRightX,topRightY);
    double xHalfWidth,xHalfHeight,yHalfWidth,yHalfHeight;
    // get bottom left of rectangle
    if (radAngle > (M_PI_2 + M_PI))
    {
        xHalfWidth = cos(radAngle)*f->sprite.width/2;
        xHalfHeight = cos(radAngle+M_PI_2)*f->sprite.height/2;
        yHalfWidth = sin(radAngle)*f->sprite.width/2;
        yHalfHeight = sin(radAngle+M_PI_2)*f->sprite.height/2;
        if (screenWidth == 1242)
        {
            bottomLeftX = (f->x - xHalfWidth - xHalfHeight);
            bottomLeftY = (f->y - yHalfWidth - yHalfHeight);
        }
        else
        {
            bottomLeftX = sx * (f->x - xHalfWidth - xHalfHeight);
            bottomLeftY = sy * (f->y - yHalfWidth - yHalfHeight);
        }
    }
    else
    {
        if (screenWidth == 1242)
        {
            bottomLeftX = (f->x - cos(radAngle)*f->sprite.width/2 + cos(radAngle-M_PI_2)*f->sprite.height/2);
            bottomLeftY = (f->y - sin(radAngle)*f->sprite.width/2 + sin(radAngle-M_PI_2)*f->sprite.height/2);
        }
        else
        {
            bottomLeftX = sx * (f->x - cos(radAngle)*f->sprite.width/2 + cos(radAngle-M_PI_2)*f->sprite.height/2);
            bottomLeftY = sy * (f->y - sin(radAngle)*f->sprite.width/2 + sin(radAngle-M_PI_2)*f->sprite.height/2);
        }
    }
    bottomLeftPt = CGPointMake(bottomLeftX, bottomLeftY);
    
    // get bottom right of rectangle
    if (radAngle > (M_PI_2 + M_PI))
    {
        xHalfWidth = cos(radAngle)*f->sprite.width/2;
        xHalfHeight = cos(radAngle+M_PI_2)*f->sprite.height/2;
        yHalfWidth = sin(radAngle)*f->sprite.width/2;
        yHalfHeight = sin(radAngle+M_PI_2)*f->sprite.height/2;
        if (screenWidth == 1242)
        {
            bottomRightX = (f->x + xHalfWidth + xHalfHeight);
            bottomRightY = (f->y + yHalfWidth  - yHalfHeight);
        }
        else
        {
            bottomRightX = sx * (f->x + xHalfWidth + xHalfHeight);
            bottomRightY = sy * (f->y + yHalfWidth  - yHalfHeight);
        }
    }
    else
    {
        if (screenWidth == 1242)
        {
            bottomRightX = (f->x + cos(radAngle)*f->sprite.width/2 + cos(radAngle-M_PI_2)*f->sprite.height/2);
            bottomRightY = (f->y + sin(radAngle)*f->sprite.width/2 + sin(radAngle-M_PI_2)*f->sprite.height/2);
        }
        else
        {
            bottomRightX = sx * (f->x + cos(radAngle)*f->sprite.width/2 + cos(radAngle-M_PI_2)*f->sprite.height/2);
            bottomRightY = sy * (f->y + sin(radAngle)*f->sprite.width/2 + sin(radAngle-M_PI_2)*f->sprite.height/2);
        }
    }
    bottomRightPt = CGPointMake(bottomRightX,bottomRightY);
    
    topLine = [topLine initializeLineWithPoint1:topLeftPt andPoint2:topRightPt];
    bottomLine = [bottomLine initializeLineWithPoint1:bottomLeftPt andPoint2:bottomRightPt];
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
        Vector *topLeftVector = [[Vector alloc] init];
        [topLeftVector initializeVectorX:topLeft.x andY:topLeft.y];
        isPastTopLeft = [self pastVertex:topLeftVector];
        Vector *topRightVector = [[Vector alloc] init];
        [topRightVector initializeVectorX:topRight.x andY:topRight.y];
        isPastTopRight = [self pastVertex:topRightVector];
        Vector *bottomRightVector = [[Vector alloc] init];
        [bottomRightVector initializeVectorX:bottomRight.x andY:bottomRight.y];
        isPastBottomRight = [self pastVertex:bottomRightVector];
        Vector *bottomLeftVector = [[Vector alloc] init];
        [bottomLeftVector initializeVectorX:bottomLeft.x andY:bottomLeft.y];
        isPastBottomLeft = [self pastVertex:bottomLeftVector];
        float collidedWithTop = [self collideWithLineF:topLine]; // self->y < 910 && self->y > 100
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
        if (shortestDistance != FLT_MAX && shortestDistance!=-1)
            colPackage->state == COLLISION_BOUNCE;
        
        
        if ((isPastTopLine || isPastBottomLine || isPastLeftLine || isPastRightLine || isPastTopRight || isPastBottomRight || isPastTopLeft || isPastBottomLeft ) &&
            (shortestDistance == FLT_MAX || shortestDistance==-1))
        {
            if (diff < veryCloseDistance)
                diff = veryCloseDistance;
            Vector *I = [[[Vector alloc] init] autorelease];
            [I initializeVectorX:vel->x andY:vel->y];
            Vector *negativeI = [[[Vector alloc] init] autorelease];
            [negativeI initializeVectorX:-vel->x andY:-vel->y];
            colPackage->state = COLLISION_BOUNCE;
            CGPoint p1 = CGPointMake( topLine->p1.x/r, topLine->p1.y/r);
            CGPoint p2 = CGPointMake( topLine->p2.x/r, topLine->p2.y/r);
            [slidingLine initializeLineWithPoint1:p1 andPoint2:p2];
            if (isPastTopLine)
                normal = [topLine normal];
            else if (isPastLeftLine)
                normal = [leftLine normal];
            else if (isPastRightLine)
                normal = [rightLine normal];
            else if (isPastBottomLine)
                [normal initializeVectorX:-bottomLine->normal->x andY: -bottomLine->normal->y];
            else if (isPastTopLeft)
                normal = [self->pos  subtract:topLeftVector];
            else if (isPastTopRight)
                normal = [self->pos subtract:topRightVector];
            else if (isPastBottomRight)
                normal = [self->pos subtract:bottomRightVector];
            else if (isPastBottomLeft)
                normal = [self->pos subtract:bottomLeftVector];
            colPackage->collidedObj = f;
            foundCollision = true;
            slidingLine->normal = normal;
            [normal normalize];
            double scaler = [negativeI dotProduct:normal];
            if (scaler < 0)
                scaler = -scaler;
            N = [normal multiply:scaler];
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
               // if ([topLine isFrontFacingTo:vel])
               // {
                    normal = [topLine normal];
                /*}
                else
                {*/
                   // [normal initializeVectorX:-topLine->normal->x andY: -topLine->normal->y];
                //}
            }
            else if (collidedWithBottom == shortestDistance)
            {
                [self collideWithLine:bottomLine];
                //if ([bottomLine isFrontFacingTo:vel])
                //{
                  //  normal = [bottomLine normal];
                //}
               //else
                //{
                    [normal initializeVectorX:-bottomLine->normal->x andY: -bottomLine->normal->y];
               // }
            }
            [normal normalize];
            // projection of the normal along I (initial velocity vector going towards the line)
            double scaler = [negativeI dotProduct:normal];
            if (scaler < 0)
                scaler = -scaler;
            N = [normal multiply:scaler];
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
           // [I normalize];
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
            //[I normalize];
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
    Vector *gt = [[Vector alloc] init];
    [gt initializeVectorX:gravity->x*time andY:gravity->y*time];
    
    bounceVel = [[bounceVel multiply:vel.length] add:gt];
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
    bounceVel = [bounceVel multiply:(vel.length/screenScale)];
  //  bounceVel = [bounceVel multiply:0.5];
    colPackage->foundCollision = true;
    
    if (screenWidth == 1242)
    {
        self->pos->x = cheeseSprite->width/2 + 1;
        self->x = self->pos->x;
    }
    else
    {
        self->pos->x = 34*sx+1;
        self->x = 34*sx+1;
    }
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
    bounceVel = [bounceVel multiply:(vel.length/screenScale)];
   // bounceVel = [bounceVel multiply:0.1];
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
        [initVel initializeVectorX:bounceVel->x andY:bounceVel->y];
      
        cheeseSprite.rotation +=1;
    }
}

- (void) bounceOffBomb
{
    if (colPackage->foundCollision)
    {
        [initVel initializeVectorX:bounceVel->x andY:bounceVel->y];
      
        cheeseSprite.rotation +=1;
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
    [initVel initializeVectorX:bounceVel->x andY:bounceVel->y];

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
    Vector *tangent = [[Vector alloc] init];
    float x = gear->x - self->x;
    float y = gear->y - self->y;
    
    [tangent initializeVectorX:x andY:y];
    [tangent normalize];
    double radAngle = [tangent getAngle];
    if (radAngle < 0)
        radAngle+=2*M_PI;
    if ([gear isRotatingClockwise])
    {
        tangent->x = cos(radAngle-M_PI_2);
        tangent->y = sin(radAngle-M_PI_2);
    }
    else
    {
        tangent->x = cos(radAngle+M_PI_2);
        tangent->y = sin(radAngle+M_PI_2);
        
    }
    initVel->x = bounceVel->x + tangent->x*accel;
    initVel->y = bounceVel->y + tangent->y*accel;
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
        if (screenWidth == 1242)
        {
            if ( x + r < (mouse->mouseSprite->x - mouse->mouseSprite->width/2))
                return false;
            else if ( x - r > (mouse->mouseSprite->x + mouse->mouseSprite->width/2))
                return false;
            if ( y + r< (mouse->mouseSprite->y - mouse->mouseSprite->height/4))
                return false;
            else if ( y - r > (mouse->mouseSprite->y + mouse->mouseSprite->height/4))
                return false;
        }
        else
        {
            if ( x + r*sx < sx*(mouse->mouseSprite->x - mouse->mouseSprite->width/2))
                return false;
            else if ( x - r*sx > sx*(mouse->mouseSprite->x + mouse->mouseSprite->width/2))
                return false;
            if ( y + r*sy < sy*(mouse->mouseSprite->y - mouse->mouseSprite->height/4))
                return false;
            else if ( y - r*sy > sy*(mouse->mouseSprite->y + mouse->mouseSprite->height/4))
                return false;
        }
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
    if (screenWidth == 1242)
        nearDist = self->r + veryCloseDistance;
    return distanceVector.length < nearDist;
}

- (bool) pastVertex:(Vector *)vertex
{
    Vector *distanceVector = [[Vector alloc] init];
    distanceVector = [self->pos subtract:vertex];
    double cheeseRadius = sx*self->r;
    if (screenWidth == 1242)
        cheeseRadius = self->r;
    if (distanceVector->length < cheeseRadius)
    {
        diff = cheeseRadius - distanceVector->length;
        diff = diff/cheeseRadius;
        return true;
    }
    return false;
}

- (bool) pastLine: (Line *)line
{
        Vector *cheeseToP1 = [[Vector alloc] init];
        Vector *pt1 = [[Vector alloc] init];
        Vector *pt2 = [[Vector alloc] init];
        Vector *vecLine = [[Vector alloc] init];
        float scale = [[UIScreen mainScreen] scale];;
        float eSpaceP1X = line->p1.x/(sx*r);
        float eSpaceP1Y = line->p1.y/(sy*r);
        float eSpaceP2X = line->p2.x/(sx*r);
        float eSpaceP2Y = line->p2.y/(sy*r);
        if (screenWidth == 1242)
        {
            eSpaceP1X = line->p1.x/r;
            eSpaceP1Y = line->p1.y/r;
            eSpaceP2X = line->p2.x/r;
            eSpaceP2Y = line->p2.y/r;
        }
        CGPoint p1 = CGPointMake(eSpaceP1X, eSpaceP1Y);
        CGPoint p2 = CGPointMake(eSpaceP2X, eSpaceP2Y);
        [pt1 initializeVectorX:eSpaceP1X andY:eSpaceP1Y];
        [pt2 initializeVectorX:eSpaceP2X andY:eSpaceP2Y];
        Line *eLine = [[Line alloc] init];
        [eLine initializeLineWithPoint1:p1 andPoint2:p2];
        float cx = self->x/(sx*r);
        float cy = self->y/(sy*r);
        if (screenWidth == 1242)
        {
            cx = self->x/r;
            cy = self->y/r;
        }
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
       /* Line *edgeLine = [[Line alloc] init];
        [edgeLine initializeLineWithPoint1:p1 andPoint2:p2];
        Vector *edgeNormal = [[Vector alloc] init];
        [edgeNormal initializeVectorX:edgeLine->normal->x andY:edgeLine->normal->y];
        [edgeNormal normalize];
        [edge normalize];
        Vector *cheeseToLineNormalized = [[Vector alloc] init];
        [cheeseToLineNormalized initializeVectorX:cheeseToLine->x andY:cheeseToLine->y];
        [cheeseToLineNormalized normalize];*/
        float dot2 =[cheeseToLine dotProduct:edge];//[cheeseToLineNormalized dotProduct:edgeNormal];//
        int roundRadius = (int)(10 * (cheeseToLine.length));
        float cheeseRadius = roundRadius/10.0f;
        if (DEBUG)
            printf("near line radius: %f\n",cheeseRadius);
        
        float closeDistance = veryCloseDistance*scale;
        if (cheeseToLine.length < nearDist && dot2 < veryCloseDistance) // perpendicular = 0
        {
           diff = nearDist - cheeseToLine.length + veryCloseDistance;
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
    
    float eSpaceP1X = line->p1.x/(sx*r);
    float eSpaceP1Y = line->p1.y/(sy*r);
    float eSpaceP2X = line->p2.x/(sx*r);
    float eSpaceP2Y = line->p2.y/(sy*r);
    if (screenWidth == 1242)
    {
        eSpaceP1X = line->p1.x/r;
        eSpaceP1Y = line->p1.y/r;
        eSpaceP2X = line->p2.x/r;
        eSpaceP2Y = line->p2.y/r;
    }
    CGPoint p1 = CGPointMake(eSpaceP1X, eSpaceP1Y);
    CGPoint p2 = CGPointMake(eSpaceP2X, eSpaceP2Y);
    [pt1 initializeVectorX:eSpaceP1X andY:eSpaceP1Y];
    [pt2 initializeVectorX:eSpaceP2X andY:eSpaceP2Y];
    Line *eLine = [[Line alloc] init];
    [eLine initializeLineWithPoint1:p1 andPoint2:p2];
    float cx = self->x/(r*sx);
    float cy = self->y/(r*sy);
    if (screenWidth == 1242)
    {
        cx = self->x/r;
        cy = self->y/r;
    }
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
    if (DEBUG)
        printf("near line radius: %f\n",cheeseRadius);
    if (cheeseToLine.length <= nearDist && dot2 <= veryCloseDistance) // perpendicular = 0
        return true;
    return false;
}

- (bool) checkWall: (Line*)line
{
    Vector *positionInESpace; // position in espace
    float f0;
    double numerator, denominator;
    double M11, M12;
    NSNumber *numX, *numY;
    
    positionInESpace = [[[Vector alloc] init] autorelease];
    velocityInESpace = [[Vector alloc] init];
    
    //double eVx = (colPackage->velocity->x+acceleration->x)/r;
    //double eVy = (colPackage->velocity->y+acceleration->y)/r;
    double eVx = (colPackage->velocity->x)/(r*sx);
    double eVy = (colPackage->velocity->y)/(r*sy);
    if (screenWidth == 1242)
    {
        eVx = colPackage->velocity->x/r;
        eVy = colPackage->velocity->y/r;
    }
    [positionInESpace initializeVectorX:colPackage->basePoint->x andY:colPackage->basePoint->y];
    [velocityInESpace initializeVectorX:eVx andY:eVy];
    
    Matrix *CBM = [[[Matrix alloc] init] autorelease]; // multiply this to get into eSpace
    NSNumber *num11 = [NSNumber numberWithDouble:1/(r*sx)];
    NSNumber *num12 = [NSNumber numberWithDouble:0.0];
    NSNumber *num21 = [NSNumber numberWithDouble:0.0];
    NSNumber *num22 = [NSNumber numberWithDouble:1/(r*sy)];
    if (screenWidth == 1242)
    {
        num11 = [NSNumber numberWithDouble:1/(r)];
        num12 = [NSNumber numberWithDouble:0.0];
        num21 = [NSNumber numberWithDouble:0.0];
        num22 = [NSNumber numberWithDouble:1/(r)];
    }
    
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

    //NSLog(@"t: %f", time);
    //NSLog(@"vEspace: %f", velocityInESpace->y);
    //NSLog(@"v normalized: (%f,%f)", colPackage->normalizedVelocity->x, colPackage->normalizedVelocity->y);

    Line *cheeseLine = [[[Line alloc] init] autorelease];
    Line *boundLine = [[[Line alloc] init] autorelease];
    float max = time;
    bool quadraticSuccess = [Quadratic getLowestRootA:A andB:B andC:C andMinThreshold:(veryCloseDistance) andMaxThreshold:max andRoot:&x1];
    //bool quadraticSuccess = [Quadratic getLowestRootA:A andB:B andC:C andMinThreshold:(0) andMaxThreshold:time andRoot:&x1];
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
    if (DEBUG)
        NSLog(@"x1: %f", [x1 floatValue]);
    numerator = ([edge dotProduct:velocityInESpace])*[x1 floatValue] - ([edge dotProduct:baseToVertex]);
    denominator = edge.length*edge.length;
    f0 = numerator/denominator;
    
    
    //NSLog(@"f0: %f", f0);
    if ( f0 >= 0 && f0 <=1)  {

        collisionPoint = [[Vector alloc] init];
        [collisionPoint initializeVectorX:0 andY:0];
        collisionPoint = [p1 add:[edge multiply:f0]];
       
        time = [x1 floatValue];
        
        // convert collision point back to r3
       /* Matrix *matrixCollisionPoint = [[[Matrix alloc] init] autorelease];
        matrixCollisionPoint = [matrixCollisionPoint initWithWidth:2 andHeight:1];
        numX = [NSNumber numberWithFloat:collisionPoint->x];
        numY = [NSNumber numberWithFloat:collisionPoint->y];
        [[matrixCollisionPoint->M objectAtIndex:0] addObject:numX];
        [[matrixCollisionPoint->M objectAtIndex:0] addObject:numY];
        matrixCollisionPoint = [Matrix matrixA:matrixCollisionPoint multiplyMatrixB:CBMInverse];
        M11 = [[[matrixCollisionPoint->M objectAtIndex:0] objectAtIndex:0] floatValue];
        M12 = [[[matrixCollisionPoint->M objectAtIndex:0] objectAtIndex:1] floatValue];*/
        //NSLog(@"collisionPoint: %p", collisionPoint);
        
        double collisionPointX = collisionPoint->x;
        double collisionPointY = collisionPoint->y;
        [eSpaceIntersectionPt initializeVectorX:collisionPointX andY:collisionPointY];
        
        if (screenWidth == 1242)
        {
            collisionPointX = collisionPoint->x * r;
            collisionPointY = collisionPoint->y * r;
        }
        else
        {
            collisionPointX = collisionPoint->x * (r*sx);
            collisionPointY = collisionPoint->y * (r*sy);
        }
        //collisionPoint = [collisionPoint multiply:r];
        [collisionPoint initializeVectorX:collisionPointX andY:collisionPointY];
       // [collisionPoint initializeVectorX:M11 andY:M12];
       // NSLog(@"collisionPoint(x,y): (%f,%f)", collisionPoint->x, collisionPoint->y);
        colPackage->intersectionPoint = collisionPoint;
        colPackage->R3Velocity = vel;
        colPackage->nearestDistance = [vel length] * time;
    
        //double eSpaceIntersectionPtX = colPackage->intersectionPoint->x * (1.0f/(r*sx));
        //double eSpaceIntersectionPtY = colPackage->intersectionPoint->y * (1.0f/(r*sy));
        //eSpaceIntersectionPt->x = eSpaceIntersectionPtX;
       // eSpaceIntersectionPt->y = eSpaceIntersectionPtY;
       // [eSpaceIntersectionPt initializeVectorX:eSpaceIntersectionPtX andY:eSpaceIntersectionPtY];
        //eSpaceIntersectionPt = [colPackage->intersectionPoint multiply:1/(r*sy)];
       // eSpaceNearestDist = colPackage->nearestDistance * 1/(r*sy);
        double eNearestDistX = colPackage->nearestDistance * 1/(r*sx);
        double eNearestDistY = colPackage->nearestDistance * 1/(r*sy);
        if (screenWidth == 1242)
        {
            eNearestDistX = colPackage->nearestDistance * 1/(r);
            eNearestDistY = colPackage->nearestDistance * 1/(r);
        }
        Vector *eNearestDist = [[Vector alloc] init];
        [eNearestDist initializeVectorX:eNearestDistX andY:eNearestDistY];
        eSpaceNearestDist = [eNearestDist length];
        Vector *normal = [[[Vector alloc] init] autorelease];
        double cheeseRadius = r*sy;
        if ( screenWidth == 1242)
            cheeseRadius = r;
        CGPoint p1 = CGPointMake( line->p1.x/cheeseRadius, line->p1.y/cheeseRadius);
        CGPoint p2 = CGPointMake( line->p2.x/cheeseRadius, line->p2.y/cheeseRadius);
        [slidingLine initializeLineWithPoint1:p1 andPoint2:p2];
        normal = [line normal];
        slidingLine->normal = normal;
        return true;
    }
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
    double eVx = (colPackage->velocity->x)/(r*sx);
    double eVy = (colPackage->velocity->y)/(r*sy);
    if (screenWidth == 1242)
    {
        eVx = colPackage->velocity->x/r;
        eVy = colPackage->velocity->y/r;
    }
    [positionInESpace initializeVectorX:colPackage->basePoint->x andY:colPackage->basePoint->y];
    [velocityInESpace initializeVectorX:eVx andY:eVy];
    
   // Matrix *CBM = [[Matrix alloc] init]; // multiply this to get into eSpace
    NSNumber *num11 = [NSNumber numberWithDouble:1/(r*sx)];
    NSNumber *num12 = [NSNumber numberWithDouble:0.0];
    NSNumber *num21 = [NSNumber numberWithDouble:0.0];
    NSNumber *num22 = [NSNumber numberWithDouble:1/(r*sy)];
    if (screenWidth == 1242)
    {
        num11 = [NSNumber numberWithDouble:1/(r)];
        num12 = [NSNumber numberWithDouble:0.0];
        num21 = [NSNumber numberWithDouble:0.0];
        num22 = [NSNumber numberWithDouble:1/(r)];
    }
    
    Matrix *CBM = [[Matrix alloc] initWithWidth:2 andHeight:2];
   // CBM->name = @"CBM";
    //NSLog(@"M retain count after return from initWithWidth: %d", [CBM->M retainCount]);
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
    
    M11 = [[[matrixP1->M objectAtIndex:0] objectAtIndex:0] floatValue];
    M12 = [[[matrixP1->M objectAtIndex:0] objectAtIndex:1] floatValue];
    [p1 initializeVectorX:M11 andY:M12];
    //[matrixP1 release];
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
  //  [matrixP2 release];
   // NSLog(@"p2: (%f,%f): ", p2->x, p2->y);
   // NSLog(@"M retain count before return from collideWithLine: %d", [CBM->M retainCount]);
   // NSLog(@"CBM retain count: %d", [CBM retainCount]);
   //[CBM release];
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

    //NSLog(@"t: %f", time);
    //NSLog(@"vEspace: %f", velocityInESpace->y);
    //NSLog(@"v normalized: (%f,%f)", colPackage->normalizedVelocity->x, colPackage->normalizedVelocity->y);

    Line *cheeseLine = [[[Line alloc] init] autorelease];
    Line *boundLine = [[[Line alloc] init] autorelease];
    float max = time;
    bool quadraticSuccess = [Quadratic getLowestRootA:A andB:B andC:C andMinThreshold:(0) andMaxThreshold:max andRoot:&x1];
    //bool quadraticSuccess = [Quadratic getLowestRootA:A andB:B andC:C andMinThreshold:(0) andMaxThreshold:time andRoot:&x1];
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
   // [CBMInverse release];
    M11 = [[[matrixPosInR3->M objectAtIndex:0] objectAtIndex:0] floatValue];
    M12 = [[[matrixPosInR3->M objectAtIndex:0] objectAtIndex:1] floatValue];
   // NSLog(@"posInR3: %p", posInR3);
    [posInR3 initializeVectorX:M11 andY:M12];
   // NSLog(@"posInR3(x,y): (%f,%f)", posInR3->x, posInR3->y);
    if (DEBUG)
        NSLog(@"x1: %f", [x1 floatValue]);
    numerator = ([edge dotProduct:velocityInESpace])*[x1 floatValue] - ([edge dotProduct:baseToVertex]);
    denominator = edge.length*edge.length;
    f0 = numerator/denominator;
    
    
    //NSLog(@"f0: %f", f0);
    if ( f0 >= 0 && f0 <=1)  {

        collisionPoint = [[Vector alloc] init];
        [collisionPoint initializeVectorX:0 andY:0];
        collisionPoint = [p1 add:[edge multiply:f0]];
       
        time = [x1 floatValue];
        
        // convert collision point back to r3
       /* Matrix *matrixCollisionPoint = [[[Matrix alloc] init] autorelease];
        matrixCollisionPoint = [matrixCollisionPoint initWithWidth:2 andHeight:1];
        numX = [NSNumber numberWithFloat:collisionPoint->x];
        numY = [NSNumber numberWithFloat:collisionPoint->y];
        [[matrixCollisionPoint->M objectAtIndex:0] addObject:numX];
        [[matrixCollisionPoint->M objectAtIndex:0] addObject:numY];
        matrixCollisionPoint = [Matrix matrixA:matrixCollisionPoint multiplyMatrixB:CBMInverse];
        M11 = [[[matrixCollisionPoint->M objectAtIndex:0] objectAtIndex:0] floatValue];
        M12 = [[[matrixCollisionPoint->M objectAtIndex:0] objectAtIndex:1] floatValue];*/
        //NSLog(@"collisionPoint: %p", collisionPoint);
        
        double collisionPointX = collisionPoint->x;
        double collisionPointY = collisionPoint->y;
        [eSpaceIntersectionPt initializeVectorX:collisionPointX andY:collisionPointY];
        
        if (screenWidth == 1242)
        {
            collisionPointX = collisionPoint->x * r;
            collisionPointY = collisionPoint->y * r;
        }
        else
        {
            collisionPointX = collisionPoint->x * (r*sx);
            collisionPointY = collisionPoint->y * (r*sy);
        }
        //collisionPoint = [collisionPoint multiply:r];
        [collisionPoint initializeVectorX:collisionPointX andY:collisionPointY];
       // [collisionPoint initializeVectorX:M11 andY:M12];
       // NSLog(@"collisionPoint(x,y): (%f,%f)", collisionPoint->x, collisionPoint->y);
        colPackage->intersectionPoint = collisionPoint;
        colPackage->R3Velocity = vel;
        colPackage->nearestDistance = [vel length] * time;
    
        //double eSpaceIntersectionPtX = colPackage->intersectionPoint->x * (1.0f/(r*sx));
        //double eSpaceIntersectionPtY = colPackage->intersectionPoint->y * (1.0f/(r*sy));
        //eSpaceIntersectionPt->x = eSpaceIntersectionPtX;
       // eSpaceIntersectionPt->y = eSpaceIntersectionPtY;
       // [eSpaceIntersectionPt initializeVectorX:eSpaceIntersectionPtX andY:eSpaceIntersectionPtY];
        //eSpaceIntersectionPt = [colPackage->intersectionPoint multiply:1/(r*sy)];
       // eSpaceNearestDist = colPackage->nearestDistance * 1/(r*sy);
        double eNearestDistX = colPackage->nearestDistance * 1/(r*sx);
        double eNearestDistY = colPackage->nearestDistance * 1/(r*sy);
        if (screenWidth == 1242)
        {
            eNearestDistX = colPackage->nearestDistance * 1/(r);
            eNearestDistY = colPackage->nearestDistance * 1/(r);
        }
        Vector *eNearestDist = [[Vector alloc] init];
        [eNearestDist initializeVectorX:eNearestDistX andY:eNearestDistY];
        eSpaceNearestDist = [eNearestDist length];
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
    double eVx = (colPackage->velocity->x)/(r*sx);
    double eVy = (colPackage->velocity->y)/(r*sy);
    if (screenWidth == 1242)
    {
        eVx = (colPackage->velocity->x)/r;
        eVy = (colPackage->velocity->y)/r;
    }
    [positionInESpace initializeVectorX:colPackage->basePoint->x andY:colPackage->basePoint->y];
    [velocityInESpace initializeVectorX:eVx andY:eVy];
    
    Matrix *CBM = [[Matrix alloc] init]; // multiply this to get into eSpace
    NSNumber *num11 = [NSNumber numberWithDouble:1/(r*sx)];
    NSNumber *num12 = [NSNumber numberWithDouble:0.0f];
    NSNumber *num21 = [NSNumber numberWithDouble:0.0f];
    NSNumber *num22 = [NSNumber numberWithDouble:1/(r*sy)];
    if (screenWidth == 1242)
    {
        num11 = [NSNumber numberWithDouble:1/r];
        num22 = [NSNumber numberWithDouble:1/r];
    }
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
    time =[x1 floatValue]; // to get the shortest distance to a collision
    p->x = pos->x + vel->x*time;//pt.x;
    p->y = pos->y + vel->y*time;//pt.y;
    collisionPoint = p;
    colPackage->intersectionPoint = collisionPoint;
    colPackage->R3Velocity = vel;
    colPackage->nearestDistance = [x1 floatValue] * [vel length];
    double eSpaceIntersectionPtX = 0;
    double eSpaceIntersectionPtY = 0;
    if (screenWidth == 1242)
    {
        eSpaceIntersectionPtX = colPackage->intersectionPoint->x * (1.0f/(r));
        eSpaceIntersectionPtY = colPackage->intersectionPoint->y * (1.0f/(r));
    }
    else
    {
        eSpaceIntersectionPtX = colPackage->intersectionPoint->x * (1.0f/(r*sx));
        eSpaceIntersectionPtY = colPackage->intersectionPoint->y * (1.0f/(r*sy));
    }
    [eSpaceIntersectionPt initializeVectorX:eSpaceIntersectionPtX andY:eSpaceIntersectionPtY];
   // eSpaceIntersectionPt = [colPackage->intersectionPoint multiply:1/(r*sx)];
    eSpaceNearestDist = [x1 floatValue] * [velocityInESpace length];//colPackage->nearestDistance * 1/(r*sx);
    
    return true;
}

- (void) collideAndSlide: (double) lerp
{
    colPackage->R3Position = pos;
    bool nearTeeterTotter = false;
    colPackage->isSlidingOff = false;
    time = lerp;
    if (DEBUG)
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
           if (DEBUG)
               NSLog(@"cheese sliding");
           //Vector *velocityNormalized = [[Vector alloc] init];
           //[velocityNormalized initializeVectorX:vel->x andY:vel->y];
           //[velocityNormalized normalize];
           //Vector *accel = [[Vector alloc] init];
           //accel = [[velocityNormalized multiply:gravity->length] multiply:lerp];
           //colPackage->R3Velocity = [vel add: accel];
       }
       else
       {
           Vector *gt = [[Vector alloc] init];
           gt = [gravity multiply:lerp];
           colPackage->R3Velocity = [vel add:gt];//[vel add:[vel add:[gravity multiply:0.00033]]];
       }
    }

    vel = colPackage->R3Velocity;
    colPackage->velocity = vel;
    
    // calculate position and velocity in eSpace
    Vector *eSpacePosition = [[[Vector alloc] init] autorelease];
    Vector *eSpaceVelocity = [[[Vector alloc] init] autorelease];
    [eSpacePosition initializeVectorX:0 andY:0];
    [eSpaceVelocity initializeVectorX:0 andY:0];
    //eSpacePosition = [colPackage->R3Position multiply:(1.0f/(colPackage->eRadius*sy))];
    double ePosX = colPackage->R3Position->x * (1.0f/(colPackage->eRadius*sx));
    double ePosY = colPackage->R3Position->y * (1.0f/(colPackage->eRadius*sy));
    if (screenWidth == 1242)
    {
        ePosX = colPackage->R3Position->x * (1.0f/(colPackage->eRadius));
        ePosY = colPackage->R3Position->y * (1.0f/(colPackage->eRadius));
    }
    [eSpacePosition initializeVectorX:ePosX andY:ePosY];
    double eVelX = colPackage->R3Velocity->x * (1.0f/(colPackage->eRadius*sx));
    double eVelY = colPackage->R3Velocity->y * (1.0f/(colPackage->eRadius*sy));
    if (screenWidth == 1242)
    {
        eVelX = colPackage->R3Velocity->x * (1.0f/(colPackage->eRadius));
        eVelY = colPackage->R3Velocity->y * (1.0f/(colPackage->eRadius));
    }
    [eSpaceVelocity initializeVectorX:eVelX andY:eVelY];//= [colPackage->R3Velocity multiply:(1.0f/(colPackage->eRadius*sy))];
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

    //float radius = colPackage->eRadius*sy;
    double radiusX = finalPosition->x*colPackage->eRadius*sx;
    double radiusY = finalPosition->y*colPackage->eRadius*sy;
    if (screenWidth == 1242)
    {
        radiusX = finalPosition->x*colPackage->eRadius;
        radiusY = finalPosition->y*colPackage->eRadius;
    }
    [finalPosition initializeVectorX:radiusX andY:radiusY];
    //finalPosition = [finalPosition multiply:radius];
    bool isSlidingOffTetterTotter = false;
    if (colPackage->isSlidingOff)
    {
        
        if ([colPackage->collidedObj class] == [TeeterTotter class] )
        {
            isSlidingOffTetterTotter = true;
            NSString *pathForSlidingSoundFile = [[NSBundle mainBundle] pathForResource:@"sounds/Cheese_Sliding" ofType:@"mp3"];
            //[world->sndMan stopAllSounds];
            [world->sndMan stopSound:pathForSlidingSoundFile];
        }
    }
    if ( isSlidingOffTetterTotter || colPackage->foundCollision && !colPackage->isSlidingOff ) {
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
    if (collisionRecursionDepth == 0 )
    {
        if (colPackage->state == COLLISION_SLIDE)
        {
            if (colPackage->collisionCount < 2 )
                originalSpeed += [acceleration length]*time;// - veryCloseDistance*[gravity length];
        }
        else
            originalSpeed += [acceleration length]*time;
    }
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
    if (colPackage->state == COLLISION_EXPLODE)
    {
        Vector *offScreenVector = [[Vector alloc] init];
        [offScreenVector initializeVectorX:-cheeseSprite.width andY:-cheeseSprite.height];
        [position setVector:offScreenVector];
        return position;        
    }
    
    if (colPackage->foundCollision == false )
    {
        if (DEBUG)
            NSLog(@"slide velocity: %f", vel);
        if (colPackage->state== COLLISION_SLIDE) {
            if (DEBUG)
                NSLog(@"cheese sliding");
        }
        else
        {
            if (DEBUG)
                NSLog(@"cheese not sliding");
            return position;
        }
    }
    else if (colPackage->state == COLLISION_BOUNCE && [colPackage->collidedObj class] == [Gear class] )
    {
        double cheeseRadius = r*sy;
        if ( screenWidth == 1242)
            cheeseRadius = r;
        double eJustTouchVelocityX = justTouchVelocity->x/cheeseRadius;
        double eJustTouchVelocityY = justTouchVelocity->y/cheeseRadius;
        [justTouchVelocity initializeVectorX:eJustTouchVelocityX andY:eJustTouchVelocityY];
        position = [position add:justTouchVelocity];
        return position;
    }
    else if ((colPackage->state == COLLISION_SLIDE || colPackage->state == COLLISION_BOUNCE) && [colPackage->collidedObj class] == [TeeterTotter class] && (isPastTopLeft || isPastTopRight || isPastBottomLeft || isPastBottomRight || isPastRightLine || isPastLeftLine ))
    {
        if (diff < 0)
            diff = -diff;
        
        lineToCheese = [slidingLine->normal multiply:diff];
        return [position add:lineToCheese];
    }
    else if (colPackage->state == COLLISION_BOUNCE &&
             ([colPackage->collidedObj class] == [Drum class] || [colPackage->collidedObj class] == [Flipper class] ) &&
             (isPastTopLine || isPastBottomLine || isPastLeftLine || isPastRightLine || isPastTopRight || isPastBottomRight || isPastBottomLeft || isPastTopLeft))
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
    else if ([colPackage->collidedObj class] == [TeeterTotter class] &&
             (isPastTopLine || isPastBottomLine || isPastLeftLine || isPastRightLine || isPastTopRight || isPastBottomRight || isPastBottomLeft || isPastTopLeft))
    {
        if (colPackage->state == COLLISION_BOUNCE)
        {
            initVel = bounceVel;
            vel = bounceVel;
        }
        colPackage->R3Velocity = vel;
        colPackage->velocity = vel;
        
        lineToCheese = [slidingLine->normal multiply:diff];
        return [position add:lineToCheese];
    }
    
    [destinationPoint initializeVectorX:0 andY:0];
    float t = 0;//0.33;//time; // 30.0f;
   
    float tick = 1/30.0f;
    t = time;
   
    Vector *vr = [[Vector alloc] init];
    Vector *velocityNormalized = [[Vector alloc] init];
    [velocityNormalized initializeVectorX:velocity->x andY:velocity->y];
    [velocityNormalized normalize];
    [vr initializeVectorX:0 andY:0];
    vr = [velocityNormalized multiply:2]; // for the sliding line? to ensure it goes past the the top line
    
    Vector *vt = [[Vector alloc] init];
    [vt initializeVectorX:0 andY:0];
    
  
    vt = [velocityInESpace multiply:t];
  
    Vector *ePos = [[Vector alloc] init];
    [ePos initializeVectorX:0 andY:0];
    if (colPackage->state == COLLISION_BOUNCE || colPackage->state == COLLISION_NONE)
        ePos = position;
    else if (colPackage->state == COLLISION_SLIDE)
        ePos = [position add: vr];
    
    destinationPoint = [ePos add: vt];
    
    Vector *newBasePoint = position;
   
    // only update if we are not already very close
    // and if so we only move very close to intersection..not
    // to the exact spot
   // NSLog(@"eSpaceNearestDist: %f ", eSpaceNearestDist);
   // NSLog(@"veryCloseDistance: %f ", veryCloseDistance);
    if (eSpaceNearestDist >= veryCloseDistance  && colPackage->foundCollision 
       
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
        colPackage->closestPoint = newBasePoint;
        
    }
    topLineNormal = [[Vector alloc] init];
    [topLineNormal initializeVectorX:slidingLine->normal->x andY:slidingLine->normal->y];
   
    // determine the sliding line
    Vector *slideLineOrigin = [[Vector alloc] init];
    slideLineNormal = [[Vector alloc] init];
    // we already have the intersection point from the colliding with line/vertex function
    [slideLineOrigin initializeVectorX:eSpaceIntersectionPt->x andY:eSpaceIntersectionPt->y];
   
    slidingLine->origin = slideLineOrigin;
    slidingLine->normal = slideLineNormal;

    slidingLine = [slidingLine initializeLineWithVectorOrigin:slideLineOrigin andVectorNormal:slideLineNormal];
    Vector *closestPoint = [[Vector alloc] init];
    NSNumber *closestPtX = [[NSNumber alloc] init];
    NSNumber *closestPtY = [[NSNumber alloc] init];
    
    float distance =  [slidingLine signedDistanceTo:destinationPoint]; // distance from original destination point to sliding line
    float closestPointX = [closestPtX floatValue];
    float closestPointY = [closestPtY floatValue];
    [closestPoint initializeVectorX:closestPointX andY:closestPointY];
    colPackage->closestPoint = closestPoint;
    
    // project the original velocity vector to the sliding line to get a new destination
    Vector *slideLineNormalTimesDistance = [[[Vector alloc] init] autorelease];
    slideLineNormalTimesDistance = [ slideLineNormal multiply:distance];
   
    newDestinationPoint = [destinationPoint add: slideLineNormalTimesDistance];
    
    if (colPackage->state == COLLISION_BOUNCE)
   {
       return newBasePoint;
   }
    
    Vector *newVelocityVector = [[Vector alloc] init];
    if (colPackage->state== COLLISION_SLIDE) {
        double angle = 0;
        
        Vector *dirAlongTeeter = [[Vector alloc] init];
        [dirAlongTeeter initializeVectorX:0 andY:0];
         if (colPackage->collidedTotter!= nil){
             
             double accel = [gravity length];//originalSpeed;
             double eAccel = 0;
             
           
             angle = colPackage->collidedTotter->angle;
             angle = angle * M_PI/180;
             
             //NSLog(@"cos value %f",cos(angle));
             //NSLog(@"sin value %f",sin(angle));
             double v2x = 0;
             double v2y = 0;
             double collidedTotterX;
             if (screenWidth == 1242)
             {
                 collidedTotterX = colPackage->collidedTotter->x;
             }
             else
             {
                 collidedTotterX = colPackage->collidedTotter->x*sx;
             }
             if (self->x < collidedTotterX )//(vel->x < 0)
             {
                 
                 v2x = -vel->length*cos(angle);
                 v2y = -vel->length*sin(angle);
                 [dirAlongTeeter initializeVectorX:v2x andY:v2y];
             }
             else if (self->x > collidedTotterX)//vel->x > 0)
             {
                 v2x = vel->length*cos(angle);
                 v2y = vel->length*sin(angle);
                 [dirAlongTeeter initializeVectorX:v2x andY:v2y];
             }

             [newVelocityVector initializeVectorX:v2x andY:v2y];
             
            if (fabs(newVelocityVector->x) < 0.000000001)
              newVelocityVector->x = (int)(10000000000*(newVelocityVector->x))/100.0f;
            
            Line *slideLine = [[Line alloc] init];

            CGPoint pt1 = CGPointMake(slidingLine->p1.x, slidingLine->p1.y);
            CGPoint pt2 = CGPointMake(slidingLine->p2.x, slidingLine->p2.y);

            [slideLine initializeLineWithPoint1:pt1 andPoint2:pt2];
            
             [dirAlongTeeter normalize];
             
            if (angle > 2 * M_PI)
                angle-= 2 * M_PI;
            else if (angle < 0)
                angle+= 2 * M_PI;
                
            if (self->x < collidedTotterX )
                accel = accel * sin(angle);
            else if (self->x > collidedTotterX)
            {
                float beta = 2*M_PI - angle;
                float theta = M_PI/2 - beta;
                
                accel = accel * cos(theta);
            }
             
             for(int i=0; i < [teeterTotters count]; i++)
             {
                 if (colPackage->prevStates[i] == COLLISION_SLIDE)
                 {
                     vel = [prevVelocities[i] add:[dirAlongTeeter multiply:accel]];
                     prevVelocities[i] = vel;
                 }
                // else
                     //vel = [vel add:[dirAlongTeeter multiply:accel]];
             }
             
             if (screenWidth == 1242)
                 eAccel = accel/radius;
             else
                 eAccel = accel/(34.0f*sy);
                 
             newVelocityVector = [newVelocityVector multiply:eAccel];

        }
        
    }
    
   
    colPackage->R3Velocity = vel;
    colPackage->velocity = vel;

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
      //double eVx = colPackage->velocity->x/(r*sx);
      //double eVy = (colPackage->velocity->y)/(r*sy);
      double eVx = (colPackage->velocity->x)/(r*sx);
      double eVy = (colPackage->velocity->y)/(r*sy);
    
      if (screenWidth == 1242)
      {
          eVx = colPackage->velocity->x/r;
          eVy = colPackage->velocity->y/r;
      }
      [positionInESpace initializeVectorX:colPackage->basePoint->x andY:colPackage->basePoint->y];
      [velocityInESpace initializeVectorX:eVx andY:eVy];
      
      Matrix *CBM = [[[Matrix alloc] init] autorelease]; // multiply this to get into eSpace
      NSNumber *num11 = [NSNumber numberWithDouble:1/(r*sx)];
      NSNumber *num12 = [NSNumber numberWithDouble:0.0];
      NSNumber *num21 = [NSNumber numberWithDouble:0.0];
      NSNumber *num22 = [NSNumber numberWithDouble:1/(r*sy)];
      if (screenWidth == 1242)
      {
          num11 = [NSNumber numberWithDouble:1/(r)];
          num12 = [NSNumber numberWithDouble:0.0];
          num21 = [NSNumber numberWithDouble:0.0];
          num22 = [NSNumber numberWithDouble:1/(r)];
      }
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

     // NSLog(@"t: %f", time);
     // NSLog(@"vEspace: %f", velocityInESpace->y);
     // NSLog(@"v normalized: (%f,%f)", colPackage->normalizedVelocity->x, colPackage->normalizedVelocity->y);

      Line *cheeseLine = [[[Line alloc] init] autorelease];
      Line *boundLine = [[[Line alloc] init] autorelease];
 
    float max = time;
    //if (screenWidth == 1125)
   // max = time;//18.5f/25.0f;
      //bool quadraticSuccess = [Quadratic getLowestRootA:A andB:B andC:C andMinThreshold:(0) andMaxThreshold:time andRoot:&x1];
    bool quadraticSuccess = [Quadratic getLowestRootA:A andB:B andC:C andMinThreshold:(0) andMaxThreshold:max andRoot:&x1];
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
      if (DEBUG)
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
          t = [x1 floatValue]; // to get the shortest distance to a collision
          
          // convert collision point back to r3
          /*Matrix *matrixCollisionPoint = [[[Matrix alloc] init] autorelease];
          matrixCollisionPoint = [matrixCollisionPoint initWithWidth:2 andHeight:1];
          numX = [NSNumber numberWithFloat:collisionPoint->x];
          numY = [NSNumber numberWithFloat:collisionPoint->y];
          [[matrixCollisionPoint->M objectAtIndex:0] addObject:numX];
          [[matrixCollisionPoint->M objectAtIndex:0] addObject:numY];
          matrixCollisionPoint = [Matrix matrixA:matrixCollisionPoint multiplyMatrixB:CBMInverse];
          M11 = [[[matrixCollisionPoint->M objectAtIndex:0] objectAtIndex:0] floatValue];
          M12 = [[[matrixCollisionPoint->M objectAtIndex:0] objectAtIndex:1] floatValue];*/
          //NSLog(@"collisionPoint: %p", collisionPoint);
          double collisionPointX = collisionPoint->x;
          double collisionPointY = collisionPoint->y;
          [eSpaceIntersectionPt initializeVectorX:collisionPointX andY:collisionPointY];
          
          if (screenWidth == 1242)
          {
              collisionPointX = collisionPoint->x * (r);
              collisionPointY = collisionPoint->y * (r);
          }
          else
          {
              collisionPointX = collisionPoint->x * (r*sx);
              collisionPointY = collisionPoint->y * (r*sy);
          }
          //collisionPoint = [collisionPoint multiply:(r*sx)];
          [collisionPoint initializeVectorX:collisionPointX andY:collisionPointY];
         // NSLog(@"collisionPoint(x,y): (%f,%f)", collisionPoint->x, collisionPoint->y);
          colPackage->intersectionPoint = collisionPoint;
          colPackage->R3Velocity = vel;
          colPackage->nearestDistance = [vel length] * time;
        //   NSLog(@"eSpaceIntersectionPt: %p", eSpaceIntersectionPt);
         // [eSpaceIntersectionPt initializeVectorX:0 andY:0];
         // NSLog(@"eSpaceIntersectionPt(x,y): (%f,%f)", eSpaceIntersectionPt->x, eSpaceIntersectionPt->y);
          
         // eSpaceIntersectionPt = [colPackage->intersectionPoint multiply:1/(r*sx)];
          double eNearestDistX = 0;
          double eNearestDistY = 0;
          if (screenWidth == 1242)
          {
              eNearestDistX = colPackage->nearestDistance * 1/(r);
              eNearestDistY = colPackage->nearestDistance * 1/(r);
          }
          else
          {
              eNearestDistX = colPackage->nearestDistance * 1/(r*sx);
              eNearestDistY = colPackage->nearestDistance * 1/(r*sy);
          }
          Vector *eNearestDist = [[Vector alloc] init];
          [eNearestDist initializeVectorX:eNearestDistX andY:eNearestDistY];
          eSpaceNearestDist = [eNearestDist length];
          
          return eSpaceNearestDist;
      }
      return -1;
    
}

- (float)collideWithVertexF:(CGPoint)pt {
    double eVx = 0;
    double eVy = 0;
    Vector *velocityInESpace; // velocity in espace
    Vector *positionInESpace; // position in espace
    Vector *p = [[[Vector alloc] init] autorelease];
    
    positionInESpace = [[[Vector alloc] init] autorelease];
    velocityInESpace = [[[Vector alloc] init] autorelease];
    [p initializeVectorX:pt.x andY:pt.y];
    
    if (screenWidth == 1242)
    {
        eVx = (colPackage->velocity->x)/r;
        eVy = (colPackage->velocity->y)/r;
    }
    else
    {
        eVx = (colPackage->velocity->x)/(r*sx);
        eVy = (colPackage->velocity->y)/(r*sy);
    }
    [positionInESpace initializeVectorX:colPackage->basePoint->x andY:colPackage->basePoint->y];
    [velocityInESpace initializeVectorX:eVx andY:eVy];
    
    Matrix *CBM = [[Matrix alloc] init]; // multiply this to get into eSpace
    NSNumber *num11 = [NSNumber numberWithDouble:1/(r*sx)];
    NSNumber *num12 = [NSNumber numberWithDouble:0.0];
    NSNumber *num21 = [NSNumber numberWithDouble:0.0];
    NSNumber *num22 = [NSNumber numberWithDouble:1/(r*sy)];
    if (screenWidth == 1242)
    {
        num11 = [NSNumber numberWithDouble:1/(r)];
        num12 = [NSNumber numberWithDouble:0.0];
        num21 = [NSNumber numberWithDouble:0.0];
        num22 = [NSNumber numberWithDouble:1/(r)];
    }
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
    p->x = pos->x + vel->x*t;//pt.x;
    p->y = pos->y + vel->y*t;//pt.y;
    collisionPoint = p;
    colPackage->intersectionPoint = collisionPoint;
    colPackage->R3Velocity = vel;
    colPackage->nearestDistance = [x1 floatValue] * [vel length];
    double eSpaceIntersectionPtX = 0;
    double eSpaceIntersectionPtY = 0;
    if (screenWidth == 1242)
    {
        eSpaceIntersectionPtX = colPackage->intersectionPoint->x * (1.0f/(r));
        eSpaceIntersectionPtY = colPackage->intersectionPoint->y * (1.0f/(r));
    }
    else
    {
        eSpaceIntersectionPtX = colPackage->intersectionPoint->x * (1.0f/(r*sx));
        eSpaceIntersectionPtY = colPackage->intersectionPoint->y * (1.0f/(r*sy));
    }
    [eSpaceIntersectionPt initializeVectorX:eSpaceIntersectionPtX andY:eSpaceIntersectionPtY];
    //eSpaceIntersectionPt = [colPackage->intersectionPoint multiply:1/(r*sx)];
    eSpaceNearestDist = t * [velocityInESpace length];//colPackage->nearestDistance * 1/(r*sx);
    
    return eSpaceNearestDist;
    
}

@end
