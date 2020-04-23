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
    CGPoint wallTopLeft = CGPointMake(0, 960);
    CGPoint wallBottomLeft = CGPointMake(0,0);
    CGPoint wallTopRight = CGPointMake(640 ,960);
    CGPoint wallBottomRight = CGPointMake(640 , 0);
    
    /*CGPoint wallTopLeft = CGPointMake(0, 0);
    CGPoint wallBottomLeft = CGPointMake(0,960);
    CGPoint wallTopRight = CGPointMake(640 ,0);
    CGPoint wallBottomRight = CGPointMake(640 , 960);*/
    Line *leftWall = [[Line alloc] init];
    Line *rightWall = [[Line alloc] init];
    Line *topWall = [[Line alloc] init];
    [topWall initializeLineWithPoint1:wallTopLeft andPoint2:wallTopRight];
    [leftWall initializeLineWithPoint1:wallTopLeft andPoint2:wallBottomLeft];
    [rightWall initializeLineWithPoint1:wallTopRight andPoint2:wallBottomRight];
    cheese->teeterTotters = lvl->teeterTotters;
    if (cheese->y > 960 - cheese->cheeseSprite.height/2)//([cheese collideWithLine:topWall])
    {
        [cheese bounceOffTopWall];
    }
    if ([cheese collideWithLine:leftWall])
    {
        [cheese bounceOffLeftWall];
    }
    else if ([cheese collideWithLine:rightWall])
    {
        [cheese bounceOffRightWall];
    }
    TeeterTotter *topTeeterTotter = [[TeeterTotter alloc] init];
    if ([lvl->teeterTotters count] > 0)
        topTeeterTotter = [lvl->teeterTotters objectAtIndex:0];
    
    cheese->isPastTopLine = false;
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
               // cheese->colPackage->collidedObj = coin;
               // NSLog(@"# of coins: %d", (int)lvl->coins.count);
               // NSLog(@"removing coin at index %d", i);
                [lvl->coins removeObjectAtIndex:i];
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
               // }
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
            if (cheese->colPackage->foundCollision)
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
    
    cheese->isPastRightLine = false;
    if (cheese->colPackage->foundCollision==false)
    {
        //printf("# of teeter totters: %d", [lvl->teeterTotters count] );
        for (int i = 0; i < [lvl->teeterTotters count]; i++ )
        {
            TeeterTotter *teeterTotter = [lvl->teeterTotters objectAtIndex:i];
            cheese->colPackage->foundCollision = [cheese checkTeeterTotter:teeterTotter];
            bool isNearTopLine = [cheese nearLine:teeterTotter->topLine];
             
            if (cheese->colPackage->foundCollision || isNearTopLine || [cheese nearVertex:teeterTotter->topLine->p1] || [cheese nearVertex:teeterTotter->topLine->p2])
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
                }
                else //if (cheese->colPackage->state != COLLISION_BOUNCE)
                {
                    printf("near the teeter totter\n");
                    cheese->colPackage->state = cheese->colPackage->state == COLLISION_SLIDE;
                    //cheese->colPackage->foundCollision = true;
                }
                
                
                if ([cheese nearLine:teeterTotter->topLine])// && cheese->colPackage->state != COLLISION_BOUNCE)
                    cheese->colPackage->state = COLLISION_SLIDE;

                if (cheese->colPackage->state == COLLISION_SLIDE )
                    [cheese slideOffTeeterTotter:teeterTotter];
                else if (cheese->colPackage->state == COLLISION_BOUNCE)
                    [cheese bounceOffTeeterTotter];
               // teeterTotter->time += 2;
                if (cheese->pos->y > teeterTotter->topLine->p1.y && cheese->pos->y > teeterTotter->topLine->p2.y)
                {
                    if (cheese->pos->x > teeterTotter->x)
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
                        else
                            teeterTotter->angle = 315;
                    }
                    else if (cheese->pos->x < teeterTotter->x)
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
                        else
                            teeterTotter->angle = 45;
                    }
                    radAngle = teeterTotter->angle*M_PI/180.0f;
                    // get top left of rectangle
                    topLeftX = teeterTotter->x - cos(radAngle)*teeterTotter->totterSprite.width/2 + cos(radAngle+M_PI_2)*teeterTotter->totterSprite.height/2;
                    topLeftY = teeterTotter->y - sin(radAngle)*teeterTotter->totterSprite.width/2 + sin(radAngle+M_PI_2)*teeterTotter->totterSprite.height/2;
                    topLeftPt = CGPointMake(topLeftX, topLeftY);
                    // get top right of rectangle
                    topRightX = teeterTotter->x + cos(radAngle)*teeterTotter->totterSprite.width/2 + cos(radAngle+M_PI_2)*teeterTotter->totterSprite.height/2;
                    topRightY = teeterTotter->y + sin(radAngle)*teeterTotter->totterSprite.width/2 + sin(radAngle+M_PI_2)*teeterTotter->totterSprite.height/2;
                    topRightPt = CGPointMake(topRightX,topRightY);
                    teeterTotter->topLineRotated = [topLine initializeLineWithPoint1:topLeftPt andPoint2:topRightPt];
                    cheese->slidingLine->normal = [teeterTotter->topLineRotated normal];
                    break;
                }
            }
            else if ( cheese->colPackage->collisionRecursionDepth > 0 )
            {
                printf("sliding on teeter totter\n");
                if (cheese->colPackage->state == COLLISION_SLIDE)
                {            
                    [cheese slideOffTeeterTotter:teeterTotter];
                }
            }
            else
            {
                printf("miss the teeter totter\n");
               // if (teeterTotter->time <=0)
               // {
                    //teeterTotter->time=0;
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
                            teeterTotter->angle+=teeterTotter->angularVelocity/2;
                        else if (teeterTotter->angle <=45 && teeterTotter->angle >=0)//(cheese->pos->x < teeterTotter->x)
                            teeterTotter->angle-=teeterTotter->angularVelocity/2;
                    }
                    else
                        NSLog(@"teeterTotter angle: %f",teeterTotter->angle);
               /* }
                else
                {
                    teeterTotter->time-=1;
                }*/
                
            }
           
        }
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
