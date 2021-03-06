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
        numOfCoins = 0;
        sndMan = [[SoundManager alloc] init ];
        [sndMan initializeSoundManager:(10)];
        pathForCoinSoundFile = [[[NSBundle mainBundle] pathForResource:@"sounds/coin_sound" ofType:@"wav"] retain];
        
        wallTopLeft = CGPointMake(0, 1334 * sy);//960 * sy);
        wallBottomLeft = CGPointMake(0,0);
        wallTopRight = CGPointMake(640 * sx ,1334 * sy);
        wallBottomRight = CGPointMake(640 * sx, 0);
        leftWall = [[Wall alloc] init];
        rightWall = [[Wall alloc] init];

        [leftWall initializeLineWithPoint1:wallTopLeft andPoint2:wallBottomLeft];
        [rightWall initializeLineWithPoint1:wallBottomRight andPoint2:wallTopRight];
             
    }
    return self;
}
- (void)checkCollision :( CollisionPacket **) colPackage
{
    if (cheese==nil)
        return;
    cheese->colPackage->foundCollision = false;
    cheese->colPackage->collidedObj = nil;
    cheese->colPackage->state = COLLISION_NONE;
    
    cheese->teeterTotters = lvl->teeterTotters;
    cheese->colPackage->collisionCount = 0;
   
    if ([cheese checkWall:leftWall])
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
    
    
    if (cheese->colPackage->foundCollision==false )
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
                numOfCoins+=1;
                [removedCoins addObject:coin];
                [lvl->coins removeObjectAtIndex:i];
                cheese->colPackage->foundCollision = false;
                if ([lvl->coins count] == 0)
                    [mouse openMouth];
                [sndMan playSound:pathForCoinSoundFile];
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
               // [mouse openMouth];
                [cheese bounceOffGear:gear];
                NSString *pathForBounceSoundFile = [[NSBundle mainBundle] pathForResource:@"sounds/Ball_Bounce" ofType:@"mp3"];
                [sndMan playSound:pathForBounceSoundFile];
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
            if (DEBUG)
                NSLog(@"Checking drum %d", i);
            cheese->colPackage->foundCollision = [cheese checkDrum:drum];
            if (cheese->colPackage->foundCollision || cheese->colPackage->state == COLLISION_BOUNCE)
            {
                cheese->colPackage->collidedObj = drum;
                cheese->colPackage->state = COLLISION_BOUNCE;
                [cheese bounceOffDrum];
               
                
                break;
            }
        }
    }
    
    if (cheese->colPackage->foundCollision==false)
    {
        
        for (int i = 0; i < [lvl->bombs count]; i++)
        {
            Bomb *bomb = [lvl->bombs objectAtIndex:i];
            if (DEBUG)
                NSLog(@"Checking bomb %d", i);
            if (bomb->state != BOMB_GONE)
                cheese->colPackage->foundCollision = [cheese checkBomb:bomb];
            if (cheese->colPackage->foundCollision)// || cheese->colPackage->state == COLLISION_BOUNCE)
            {
                //cheese->colPackage->collidedObj = bomb;
           
               // cheese->colPackage->state = COLLISION_BOUNCE;
                CGPoint pt = CGPointMake(0,-960);
                [cheese dropAt:pt];
                //[cheese bounceOffBomb];
                [bomb explode];
                NSString *pathForBombSoundFile = [[NSBundle mainBundle] pathForResource:@"sounds/bomb" ofType:@"wav"];
                [sndMan playSound:pathForBombSoundFile];
               // [mouse openMouth];
                
                
                cheese->colPackage->state = COLLISION_EXPLODE;
                //[cheese release];
               // [cheese dealloc];
                //cheese = nil;
                break;
            }
        }
    }
    
    if (cheese !=nil)
    {
        if (cheese->colPackage->foundCollision==false)
        {
            for (int i = 0; i < [lvl->flippers count]; i++ )
            {
                Flipper *flipper = [lvl->flippers objectAtIndex:i];
                cheese->colPackage->foundCollision = [cheese checkFlipper:flipper];
                if (cheese->colPackage->foundCollision || cheese->colPackage->state == COLLISION_BOUNCE)
                {
                    cheese->colPackage->collidedObj = flipper;
                   
                    cheese->colPackage->state = COLLISION_BOUNCE;
                    [cheese bounceOffFlipper];
                    NSString *pathForFlippersSoundFile = [[NSBundle mainBundle] pathForResource:@"sounds/Flippers" ofType:@"mp3"];
                    [sndMan playSound:pathForFlippersSoundFile];
                    
                    break;
                }
            }
        }
    }
    
    float topLeftX, topLeftY, topRightX, topRightY;
    double radAngle = 0;
    
    if (cheese!=nil)
    {
        if (cheese->colPackage->foundCollision==false)
        {
            //printf("# of teeter totters: %d", [lvl->teeterTotters count] );
            cheese->colPackage->collisionCount = 0;
            for (int i = 0; i < [lvl->teeterTotters count]; i++ )
            {
                TeeterTotter *teeterTotter = [lvl->teeterTotters objectAtIndex:i];
                if (screenWidth == 1242 )
                {
                    topRightX = (teeterTotter->x + cos(radAngle)*teeterTotter->totterSprite.width/2 + cos(radAngle+M_PI_2)*teeterTotter->totterSprite.height/2);
                }
                else
                {
                    topRightX = sx * (teeterTotter->x + cos(radAngle)*teeterTotter->totterSprite.width/2 + cos(radAngle+M_PI_2)*teeterTotter->totterSprite.height/2);
                }
                if ( cheese->colPackage->collisionCount == 0)
                {
                    cheese->colPackage->foundCollision = [cheese checkTeeterTotter:teeterTotter];
                    //bool isNearTopLine = [cheese nearLine:teeterTotter->topLine];
                    radAngle = teeterTotter->angle*M_PI/180.0f;
                    float xRightCheese = cheese->pos->x + cheese->cheeseSprite->width/2.0f;
                    if (cheese->colPackage->foundCollision || (cheese->isNearTopLine && xRightCheese < topRightX) || cheese->isNearTopRight || cheese->isNearTopLeft || [cheese nearVertex:teeterTotter->topLine->p1] || [cheese nearVertex:teeterTotter->topLine->p2] || cheese->isPastTopLine ||
                        cheese->colPackage->state == COLLISION_SLIDE)
                    {
                        
                        CGPoint topLeftPt,topRightPt;
                        
                        Line *topLine = [[[Line alloc] init] autorelease];
                        cheese->colPackage->collidedObj = teeterTotter;
                        cheese->colPackage->collidedTotter = teeterTotter;
                        
                        if (cheese->colPackage->foundCollision)
                        {
                            if (DEBUG)
                                printf("collided with teeter totter\n");
                            [cheese->vel initializeVectorX:0 andY:0];
                        }
                        else if (cheese->colPackage->state != COLLISION_BOUNCE)// && !cheese->isPastTopRight)
                        {
                            if (DEBUG)
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
                            if (screenWidth == 1242 )
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
                            if (screenWidth == 1242 )
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
                        
                        NSString *pathForSlidingSoundFile = [[NSBundle mainBundle] pathForResource:@"sounds/Cheese_Sliding" ofType:@"mp3"];
                        if (![sndMan checkSound:pathForSlidingSoundFile])
                            [sndMan playSound:pathForSlidingSoundFile];
                        
                        break;
                    }
                    else if ( cheese->colPackage->collisionRecursionDepth > 0 )
                    {
                        if (DEBUG)
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
                        if (DEBUG)
                            printf("miss the teeter totter\n");
                        
                        if (cheese->colPackage->prevStates[i] == COLLISION_NONE)
                            [cheese->prevVelocities[i] initializeVectorX:0 andY:0];
                        cheese->colPackage->prevStates[i] = cheese->colPackage->state;
                        
                        if (screenWidth == 1242 )
                        {
                            topLeftX = (teeterTotter->x - cos(radAngle)*teeterTotter->totterSprite.width/2 + cos(radAngle+M_PI_2)*teeterTotter->totterSprite.height/2);
                            topLeftY = (teeterTotter->y - sin(radAngle)*teeterTotter->totterSprite.width/2 + sin(radAngle+M_PI_2)*teeterTotter->totterSprite.height/2);
                            
                            topRightX = (teeterTotter->x + cos(radAngle)*teeterTotter->totterSprite.width/2 + cos(radAngle+M_PI_2)*teeterTotter->totterSprite.height/2);
                            topRightY = (teeterTotter->y + sin(radAngle)*teeterTotter->totterSprite.width/2 + sin(radAngle+M_PI_2)*teeterTotter->totterSprite.height/2);
                        }
                        else
                        {
                            topLeftX = sx*(teeterTotter->x - cos(radAngle)*teeterTotter->totterSprite.width/2 + cos(radAngle+M_PI_2)*teeterTotter->totterSprite.height/2);
                            topLeftY = sy*(teeterTotter->y - sin(radAngle)*teeterTotter->totterSprite.width/2 + sin(radAngle+M_PI_2)*teeterTotter->totterSprite.height/2);
                          
                            // get top right of rectangle
                            topRightX = sx*(teeterTotter->x + cos(radAngle)*teeterTotter->totterSprite.width/2 + cos(radAngle+M_PI_2)*teeterTotter->totterSprite.height/2);
                            topRightY = sy*(teeterTotter->y + sin(radAngle)*teeterTotter->totterSprite.width/2 + sin(radAngle+M_PI_2)*teeterTotter->totterSprite.height/2);
                        }
                        
                        
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
                                //if (!cheese->colPackage->isSlidingOff)
                                //{
                                    if (teeterTotter->angle >= 300 && teeterTotter->angle < 360)
                                    {
                                        if (cheese->pos->y + cheese->cheeseSprite->height/2.0f < topRightY || teeterTotter->reset ||
                                            cheese->pos->x - cheese->cheeseSprite->width/2.0f > topRightX)
                                            teeterTotter->angle+=teeterTotter->angularVelocity;
                                    }
                                    else if (teeterTotter->angle <=60 && teeterTotter->angle >=0 )
                                    {
                                        if (cheese->pos->y + cheese->cheeseSprite->height/2.0f < topLeftY || teeterTotter->reset ||
                                            cheese->pos->x + cheese->cheeseSprite->width/2.0f < topLeftX)
                                            teeterTotter->angle-=teeterTotter->angularVelocity;
                                    }
                                //}
                            }
                            else
                            {
                                teeterTotter->reset=false;
                              //  NSLog(@"teeterTotter angle: %f",teeterTotter->angle);
                            }
                       /* }
                        else
                        {
                            
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
                    //teeterTotter->time = 1000;
                    break;
                }
            } // end for
        }
    }
    
    if (cheese!=nil)
    {
        if ([cheese collideWith:mouse])
        {
            //CGPoint pt = CGPointMake(cheese->x,-960);
          //  cheese->x = 180;
            CGPoint pt = CGPointMake(0,-960);
            [cheese dropAt:pt];
            [mouse chew];
            NSString *pathForChewSoundFile = [[NSBundle mainBundle] pathForResource:@"sounds/Chewing_Sound" ofType:@"mp3"];
            [sndMan playSound:pathForChewSoundFile];
        }
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
