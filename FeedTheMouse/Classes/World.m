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
    
    /*CGPoint wallTopLeft = CGPointMake(cheese->cheeseSprite->width/4, 0);
    CGPoint wallBottomLeft = CGPointMake(cheese->cheeseSprite->width/4,960);
    CGPoint wallTopRight = CGPointMake(640 - cheese->cheeseSprite->width/4,0);
    CGPoint wallBottomRight = CGPointMake(640 - cheese->cheeseSprite->width/4, 960);*/
    CGPoint wallTopLeft = CGPointMake(0, 0);
    CGPoint wallBottomLeft = CGPointMake(0,960);
    CGPoint wallTopRight = CGPointMake(640 ,0);
    CGPoint wallBottomRight = CGPointMake(640 , 960);
    Line *leftWall = [[Line alloc] init];
    Line *rightWall = [[Line alloc] init];
    [leftWall initializeLineWithPoint1:wallTopLeft andPoint2:wallBottomLeft];
    [rightWall initializeLineWithPoint1:wallTopRight andPoint2:wallBottomRight];
    
    if ([cheese collideWithLine:leftWall])
    {
        [cheese bounceOffLeftWall];
    }
    else if ([cheese collideWithLine:rightWall])
    {
        [cheese bounceOffRightWall];
    }
    
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
            if (cheese->colPackage->foundCollision)
            {
                cheese->colPackage->collidedObj = drum;
             //   NSLog(@"bounceVel length: %f", [cheese->bounceVel length]);
                if ([cheese->bounceVel length] < 1)
                {
                    cheese->colPackage->state = COLLISION_SLIDE;
                }
                else
                {
                    cheese->colPackage->state = COLLISION_BOUNCE;
                   // cheese->initVel = cheese->bounceVel; will be set in bounceOffDrum
                    [cheese bounceOffDrum];
                }
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
                if ( [cheese->bounceVel length] < 1)
                {
                    cheese->colPackage->state = COLLISION_SLIDE;
                }
                else
                {
                    cheese->colPackage->state = COLLISION_BOUNCE;
                    [cheese bounceOffFlipper];
                }
                [mouse openMouth];
                break;
            }
        }
    }
    
    if (cheese->colPackage->foundCollision==false)
    {
        for (int i = 0; i < [lvl->teeterTotters count]; i++ )
        {
            TeeterTotter *teeterTotter = [lvl->teeterTotters objectAtIndex:i];
            cheese->colPackage->foundCollision = [cheese checkTeeterTotter:teeterTotter];
            if (cheese->colPackage->foundCollision)
            {
                cheese->colPackage->collidedObj = teeterTotter;
                if (cheese->colPackage->state == COLLISION_SLIDE)
                    [cheese slideOffTeeterTotter:teeterTotter];
                else if (cheese->colPackage->state == COLLISION_BOUNCE)
                    [cheese bounceOffTeeterTotter];
                    
               /* if (cheese->pos->x > teeterTotter->x)
                    teeterTotter->angle-=1;
                else if (cheese->pos->x < teeterTotter->x)
                    teeterTotter->angle+=1;*/
                break;
            }
           
            
        }
    }
    
    
    if ([cheese collideWith:mouse])
    {
        CGPoint pt = CGPointMake(cheese->x,-960);
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

- (void)setLevel :(Level *)level
{
    lvl = level;
}
@end
