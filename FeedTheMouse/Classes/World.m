//
//  World.m
//  Feed The Mouse
//
//  Created by Jason Ly on 2014-03-26.
//  Copyright (c) 2014 Jason Ly. All rights reserved.
//

#import "World.h"

@implementation World

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
        removedCoins = [[NSMutableArray alloc] initWithCapacity:10];
        score = 0;
    }
    return self;
}
- (void)checkCollision :( CollisionPacket **) colPackage
{
    cheese->colPackage->foundCollision = false;
    cheese->colPackage->collidedObj = nil;
    cheese->colPackage->state = COLLISION_NONE;
    /*CGPoint wallTopLeft = CGPointMake(cheese->cheeseSprite->width/4, 0);
    CGPoint wallBottomLeft = CGPointMake(cheese->cheeseSprite->width/4,960);
    CGPoint wallTopRight = CGPointMake(640 - cheese->cheeseSprite->width/4,0);
    CGPoint wallBottomRight = CGPointMake(640 - cheese->cheeseSprite->width/4, 960);*/
    CGPoint wallTopLeft = CGPointMake(0, 960 * sy);
    CGPoint wallBottomLeft = CGPointMake(0,0);
    CGPoint wallTopRight = CGPointMake(640 * sx ,1334 * sy);
    CGPoint wallBottomRight = CGPointMake(640 * sx, 0);
    
    /*CGPoint wallTopLeft = CGPointMake(0, 0);
    CGPoint wallBottomLeft = CGPointMake(0,960);
    CGPoint wallTopRight = CGPointMake(640 ,0);
    CGPoint wallBottomRight = CGPointMake(640 , 960);*/
    Wall *leftWall = [[Wall alloc] init];
    Wall *rightWall = [[Wall alloc] init];
    Line *topWall = [[Line alloc] init];
    [topWall initializeLineWithPoint1:wallTopLeft andPoint2:wallTopRight];
    [leftWall initializeLineWithPoint1:wallTopLeft andPoint2:wallBottomLeft];
    [rightWall initializeLineWithPoint1:wallBottomRight andPoint2:wallTopRight];
    cheese->teeterTotters = lvl->teeterTotters;
    cheese->colPackage->collisionCount = 0;
    if (cheese->y > 960*sy - cheese->cheeseSprite.height/2)//([cheese collideWithLine:topWall])
    {
        [cheese bounceOffTopWall];
    }
    if ([cheese collideWithLine:leftWall])
    {
        [cheese bounceOffLeftWall];
        cheese->colPackage->collidedObj = leftWall;
    }
    else if ([cheese checkWall:rightWall])
    {
        [cheese bounceOffRightWall];
        cheese->colPackage->collidedObj = rightWall;
     
       // slidingLine = line;
        //cheese->pos->x = cheese->cheeseSprite.width/2*sx;
        //cheese->x = cheese->pos->x;
    }
    TeeterTotter *topTeeterTotter = [[TeeterTotter alloc] init];
    if ([lvl->teeterTotters count] > 0)
        topTeeterTotter = [lvl->teeterTotters objectAtIndex:0];
    
    
    if (cheese->colPackage->foundCollision==false)
    {
        for (int i = 0; i< [lvl->coins count]; i++)
        {
            Coin *coin;// = [[Coin alloc] init];
            coin = [lvl->coins objectAtIndex:i];
           // NSLog(@"Checking coin %d", i);
            cheese->colPackage->foundCollision = [cheese checkCoin:coin];
            
            if (cheese->colPackage->foundCollision)
            {
              //  NSLog(@"Found coin collision");
                cheese->colPackage->collidedObj = coin;
               // NSLog(@"# of coins: %d", (int)lvl->coins.count);
               // NSLog(@"removing coin at index %d", i);
                score+=1;
                [removedCoins addObject:coin];
                [lvl->coins removeObjectAtIndex:i];
                cheese->colPackage->foundCollision = false;
                
                break;
            }
            else
            {
               // NSLog(@"No coin collision found for #%d", i);
            }
        }
    }
    if (cheese->colPackage->foundCollision==false)
    {
        for (int i = 0; i < [lvl->gears count]; i++ )
        {
            Gear *gear = [lvl->gears objectAtIndex:i];
            cheese->colPackage->foundCollision = [cheese checkGear:gear];
            //if ([cheese collideWithCircle:gear])
            if (cheese->colPackage->foundCollision)
            {
                cheese->colPackage->collidedObj = gear;
                [mouse openMouth];
                [cheese bounceOffGear:gear];
                break;
            }
        }
    }
    
    cheese->isPastTopLeft = false;
    cheese->isPastTopRight = false;
    cheese->isPastBottomRight = false;
    cheese->isPastBottomLeft = false;
    cheese->isPastBottomLine = false;
    cheese->isPastTopLine = false;
    cheese->isPastLeftLine = false;
    
    if (cheese->colPackage->foundCollision==false)
    {
        
        for (int i = 0; i < [lvl->drums count]; i++)
        {
            Drum *drum = [lvl->drums objectAtIndex:i];
            NSLog(@"Checking drum %d", i);
            cheese->colPackage->foundCollision = [cheese checkDrum:drum];
            if (cheese->colPackage->foundCollision || cheese->colPackage->state == COLLISION_BOUNCE)
            {
                cheese->colPackage->collidedObj = drum;
             //   NSLog(@"bounceVel length: %f", [cheese->bounceVel length]);
               // if ([cheese->bounceVel length] < 1)
               // {
                    //cheese->colPackage->state = COLLISION_SLIDE;
               // }
                //else
               // {
                    cheese->colPackage->state = COLLISION_BOUNCE;
                   // cheese->initVel = cheese->bounceVel; will be set in bounceOffDrum
                    [cheese bounceOffDrum];
                    [drum vibrate];
               // }
                [mouse openMouth];
                
                break;
            }
        }
    }
    
    if (cheese->colPackage->foundCollision==false)
    {
        
        for (int i = 0; i < [lvl->bombs count]; i++)
        {
            Bomb *bomb = [lvl->bombs objectAtIndex:i];
            NSLog(@"Checking bomb %d", i);
            if (bomb->state != BOMB_GONE)
                cheese->colPackage->foundCollision = [cheese checkBomb:bomb];
            if (cheese->colPackage->foundCollision || cheese->colPackage->state == COLLISION_BOUNCE)
            {
                cheese->colPackage->collidedObj = bomb;
           
                cheese->colPackage->state = COLLISION_BOUNCE;
               
                [cheese bounceOffBomb];
                [bomb explode];
               
                [mouse openMouth];
                
                break;
            }
        }
    }
    
    if (cheese->colPackage->foundCollision==false)
    {
        for (int i = 0; i < [lvl->flippers count]; i++ )
        {
            Flipper *flipper = [lvl->flippers objectAtIndex:i];
            cheese->colPackage->foundCollision = [cheese checkFlipper:flipper];
            if (cheese->colPackage->foundCollision || cheese->colPackage->state == COLLISION_BOUNCE)
            {
                cheese->colPackage->collidedObj = flipper;
                /*if ( [cheese->bounceVel length] < 1)
                {
                    cheese->colPackage->state = COLLISION_SLIDE;
                }
                else
                {*/
                    cheese->colPackage->state = COLLISION_BOUNCE;
                    [cheese bounceOffFlipper];
                
                //}
                [mouse openMouth];
                break;
            }
        }
    }
    
    
    if (cheese->colPackage->foundCollision==false)
    {
        //printf("# of teeter totters: %d", [lvl->teeterTotters count] );
        cheese->colPackage->collisionCount = 0;
        for (int i = 0; i < [lvl->teeterTotters count]; i++ )
        {
            TeeterTotter *teeterTotter = [lvl->teeterTotters objectAtIndex:i];
            if ( cheese->colPackage->collisionCount == 0)
            {
            cheese->colPackage->foundCollision = [cheese checkTeeterTotter:teeterTotter];
            //bool isNearTopLine = [cheese nearLine:teeterTotter->topLine];
            
                if (cheese->colPackage->foundCollision || (cheese->isNearTopLine || cheese->isNearTopRight || cheese->isNearTopLeft) || [cheese nearVertex:teeterTotter->topLine->p1] || [cheese nearVertex:teeterTotter->topLine->p2] || cheese->isPastTopLine ||
                    cheese->colPackage->state == COLLISION_SLIDE)
                {
                    float topLeftX, topLeftY, topRightX, topRightY;
                    CGPoint topLeftPt,topRightPt;
                    double radAngle = teeterTotter->angle*M_PI/180.0f;
                    Line *topLine = [[[Line alloc] init] autorelease];
                    cheese->colPackage->collidedObj = teeterTotter;
                    cheese->colPackage->collidedTotter = teeterTotter;
                    
                    if (cheese->colPackage->foundCollision)
                    {
                        printf("collided with teeter totter\n");
                        [cheese->vel initializeVectorX:0 andY:0];
                    }
                    else if (cheese->colPackage->state != COLLISION_BOUNCE)// && !cheese->isPastTopRight)
                    {
                        printf("near the teeter totter\n");
                        cheese->colPackage->state = cheese->colPackage->state == COLLISION_SLIDE;
                        //cheese->colPackage->foundCollision = true;
                        [cheese->vel initializeVectorX:0 andY:0];
                    }
                    
                    if ((cheese->isNearTopLine && !cheese->isNearTopLeft && !cheese->isNearTopRight) || cheese->isPastTopLine)// && (cheese->colPackage->state != COLLISION_BOUNCE && //!cheese->isPastTopRight))
                        cheese->colPackage->state = COLLISION_SLIDE;

                    if (cheese->colPackage->state == COLLISION_SLIDE )
                    {
                        [cheese slideOffTeeterTotter:teeterTotter];
                        [cheese->vel initializeVectorX:0 andY:0];
                    }
                    else if (cheese->colPackage->state == COLLISION_BOUNCE)
                        [cheese bounceOffTeeterTotter];
                   // teeterTotter->time += 2;
                    if (cheese->pos->y > teeterTotter->topLine->p1.y && cheese->pos->y > teeterTotter->topLine->p2.y)
                    {
                        double teeterTotterX = teeterTotter->x*sx;
                        if (screenWidth == 1242)
                            teeterTotterX = teeterTotter->x;
                        if (cheese->pos->x > teeterTotterX)
                        {
                            //teeterTotter->angularVelocity+=teeterTotter->angularAcceleration;
                            //if (teeterTotter->angularVelocity > 1000)
                                //teeterTotter->angularVelocity = 1000;
                            if ((teeterTotter->angle >=315 && teeterTotter->angle <360) || teeterTotter->angle==0)
                            {
                                if (teeterTotter->angle == 0)
                                    teeterTotter->angle = 360;
                                if (teeterTotter->angle-teeterTotter->angularVelocity >= 315)
                                    teeterTotter->angle-=teeterTotter->angularVelocity;
                                else
                                    teeterTotter->angle = 315;
                            }
                            else if (teeterTotter->angle <=45 && teeterTotter->angle >=0)
                            {
                                if (teeterTotter->angle+teeterTotter->angularVelocity <= 45)
                                    teeterTotter->angle+=teeterTotter->angularVelocity;
                                else
                                    teeterTotter->angle=45;
                            }
                            else if (teeterTotter->angle > 315 && teeterTotter->angle < 360)
                                teeterTotter->angle = 315;
                            else
                                teeterTotter->angle-=teeterTotter->angularVelocity;
                        }
                        else if (cheese->pos->x  < teeterTotterX)
                        {
                            //teeterTotter->angularVelocity+=teeterTotter->angularAcceleration;
                            //if (teeterTotter->angularVelocity > 1000)
                                //teeterTotter->angularVelocity = 1000;
                            if (teeterTotter->angle <=45 && teeterTotter->angle >=0)
                            {
                                if (teeterTotter->angle+teeterTotter->angularVelocity <= 45)
                                    teeterTotter->angle+=teeterTotter->angularVelocity;
                                else
                                    teeterTotter->angle=45;
                            }
                            else if ((teeterTotter->angle >=315 && teeterTotter->angle <360) || teeterTotter->angle==0)
                            {
                                if (teeterTotter->angle == 0)
                                    teeterTotter->angle = 360;
                                if (teeterTotter->angle-teeterTotter->angularVelocity >= 315)
                                    teeterTotter->angle-=teeterTotter->angularVelocity;
                                else
                                    teeterTotter->angle = 315;
                            }
                            else if (teeterTotter->angle > 45 && teeterTotter->angle < 90)
                                teeterTotter->angle = 45;
                            else
                                teeterTotter->angle+=teeterTotter->angularVelocity;
                        }
                        radAngle = teeterTotter->angle*M_PI/180.0f;
                        // get top left of rectangle
                        if (screenWidth == 1242)
                        {
                            topLeftX = (teeterTotter->x - cos(radAngle)*teeterTotter->totterSprite.width/2 + cos(radAngle+M_PI_2)*teeterTotter->totterSprite.height/2);
                            topLeftY = (teeterTotter->y - sin(radAngle)*teeterTotter->totterSprite.width/2 + sin(radAngle+M_PI_2)*teeterTotter->totterSprite.height/2);
                            topLeftPt = CGPointMake(topLeftX, topLeftY);
                            // get top right of rectangle
                            topRightX = (teeterTotter->x + cos(radAngle)*teeterTotter->totterSprite.width/2 + cos(radAngle+M_PI_2)*teeterTotter->totterSprite.height/2);
                            topRightY = (teeterTotter->y + sin(radAngle)*teeterTotter->totterSprite.width/2 + sin(radAngle+M_PI_2)*teeterTotter->totterSprite.height/2);
                            topRightPt = CGPointMake(topRightX,topRightY);
                            teeterTotter->topLineRotated = [topLine initializeLineWithPoint1:topLeftPt andPoint2:topRightPt];
                            cheese->slidingLine->normal = [teeterTotter->topLineRotated normal];
                        }
                        else
                        {
                            topLeftX = sx*(teeterTotter->x - cos(radAngle)*teeterTotter->totterSprite.width/2 + cos(radAngle+M_PI_2)*teeterTotter->totterSprite.height/2);
                            topLeftY = sy*(teeterTotter->y - sin(radAngle)*teeterTotter->totterSprite.width/2 + sin(radAngle+M_PI_2)*teeterTotter->totterSprite.height/2);
                            topLeftPt = CGPointMake(topLeftX, topLeftY);
                            // get top right of rectangle
                            topRightX = sx*(teeterTotter->x + cos(radAngle)*teeterTotter->totterSprite.width/2 + cos(radAngle+M_PI_2)*teeterTotter->totterSprite.height/2);
                            topRightY = sy*(teeterTotter->y + sin(radAngle)*teeterTotter->totterSprite.width/2 + sin(radAngle+M_PI_2)*teeterTotter->totterSprite.height/2);
                            topRightPt = CGPointMake(topRightX,topRightY);
                            teeterTotter->topLineRotated = [topLine initializeLineWithPoint1:topLeftPt andPoint2:topRightPt];
                            cheese->slidingLine->normal = [teeterTotter->topLineRotated normal];
                        }
                       // break;
                    }
                    [cheese->vel initializeVectorX:1 andY:1];
                    if (cheese->colPackage->prevStates[i] == COLLISION_NONE)
                        [cheese->prevVelocities[i] initializeVectorX:0 andY:0];
                    cheese->colPackage->prevStates[i] = cheese->colPackage->state;
                    break;
                }
                else if ( cheese->colPackage->collisionRecursionDepth > 0 )
                {
                    printf("sliding on teeter totter\n");
                    if (cheese->colPackage->state == COLLISION_SLIDE)
                    {
                        [cheese slideOffTeeterTotter:teeterTotter];
                        [cheese->vel initializeVectorX:1 andY:1];
                        //break;
                    }
                    //break;
                }
                else
                {
                    printf("miss the teeter totter\n");
                    if (cheese->colPackage->prevStates[i] == COLLISION_NONE)
                        [cheese->prevVelocities[i] initializeVectorX:0 andY:0];
                    cheese->colPackage->prevStates[i] = cheese->colPackage->state;
                        if (teeterTotter->angle == 360)
                            teeterTotter->angle = 0;
                        //if (teeterTotter->angle <= 1)
                          //  teeterTotter->angle = 0;
                        if (teeterTotter->angle!=0)
                        {
                            //teeterTotter->angularVelocity-=teeterTotter->angularAcceleration;
                            if (teeterTotter->angularVelocity<0)
                                teeterTotter->angularVelocity = 0;
                            //if (cheese->pos->x > teeterTotter->x)
                            if (teeterTotter->angle >= 315 && teeterTotter->angle < 360)
                                teeterTotter->angle+=teeterTotter->angularVelocity;
                            else if (teeterTotter->angle <=45 && teeterTotter->angle >=0)//(cheese->pos->x < teeterTotter->x)
                                teeterTotter->angle-=teeterTotter->angularVelocity;
                        }
                        else
                        {
                          //  NSLog(@"teeterTotter angle: %f",teeterTotter->angle);
                        }
                   /* }
                    else
                    {
                        teeterTotter->time-=1;
                    }*/
                    
                }// end if
            }
            if (cheese->colPackage->foundCollision || cheese->colPackage->collisionRecursionDepth > 0)
            {
                if (cheese->colPackage->prevStates[i] == COLLISION_NONE)
                    [cheese->prevVelocities[i] initializeVectorX:0 andY:0];
                cheese->colPackage->prevStates[i] = cheese->colPackage->state;
                cheese->colPackage->collisionCount++;
                [cheese->vel initializeVectorX:1 andY:1];
                
                break;
            }
        } // end for
        
    }
    
    
    if ([cheese collideWith:mouse])
    {
        //CGPoint pt = CGPointMake(cheese->x,-960);
      //  cheese->x = 180;
        CGPoint pt = CGPointMake(0,-960);
        [cheese dropAt:pt];
        [mouse chew];
    }
}

- (void)setMouse :(Mouse **)m
{
    mouse = *m;
}

- (void)setCheese:(Cheese **)c
{
    cheese = *c;
}

- (void)setLevel :(Level **)level
{
    lvl = *level;
}
@end
