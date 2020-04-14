//
//  FeedTheMouseView.m
//  FeedTheMouse
//
//  Created by Jason Ly on 2012-10-28.
//  Copyright (c) 2012 Jason Ly. All rights reserved.
//

#import "FeedTheMouseView.h"


#define kDirForward 0
#define kFPS 30.0
#define TICKS_PER_SECOND 30
#define SKIP_TICKS 1 / kFPS
#define MAX_FRAMESKIP 30

@implementation FeedTheMouseView

- (void) doParse:(NSData *)data
{
    // create and init NSXMLParser object
    NSXMLParser *nsXmlParser = [[NSXMLParser alloc] initWithData:data];
    
    // create and init our delegate
    parser = [[XMLParser alloc] initXMLParser];
    
    // set delegate
    [nsXmlParser setDelegate:(id<NSXMLParserDelegate>) parser];
    
    // parsing...
    BOOL success = [nsXmlParser parse];
    
    // test the result
    if (success) {
        levels = parser->levels;
        Level *lvl = (Level*)[levels objectAtIndex:0];
        curLevel = lvl;
        
    } else {
        NSLog(@"Error parsing document!");
    }
    
    [parser release];
    [nsXmlParser release];

}

- (id) initWithCoder: (NSCoder *) coder {
    if (self = [super initWithCoder: coder]) {
        mouse = [[Mouse alloc] init];
        cheese = [[Cheese alloc] init];
        backgroundSprite = [Picture fromFile:@"background_1.png"];
        gear = [[Gear alloc] init];
		drum = [[Drum alloc] init];
        teeterTotter = [[TeeterTotter alloc] init];
        flipper = [[Flipper alloc] init];
        coin = [[Coin alloc] init];
       // cheese->mouse = mouse;
        /*cheese->gear = gear;
        cheese->drum = drum;
        cheese->teeterTotter = teeterTotter;*/
        next_game_tick = -[lastDate timeIntervalSinceNow];
		direction = kDirForward;
		timer = [NSTimer scheduledTimerWithTimeInterval: 1.0/kFPS
												 target:self
											   selector:@selector(gameLoop)
											   userInfo:nil
												repeats:NO];
        game_is_running = true;
        animationNumber = 0;
        parser = [[XMLParser alloc] initXMLParser];
       
        NSData *data = [[NSData alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"FeedTheMouse.xml" ofType:nil]];
        [self doParse:data];
        [data release];
        // get array of objects here
        gears = [curLevel getGears];
       // printf("gears retain count:%lu", (unsigned long)[gears retainCount]);
        cheese->gears = gears;
        coins = [curLevel getCoins];
        drums = [curLevel getDrums];
        cheese->drums = drums;
        teeterTotters = [curLevel getTeeterTotters];
        cheese->teeterTotters = teeterTotters;
        flippers = [curLevel getFlippers];
        cheese->flippers = flippers;
        currentLevelNumber = 0;
        [cheese->world setLevel:&curLevel];
        mouse = curLevel->mouse;
        [cheese->world setMouse:&(mouse)];
        cheese->x = -43;
        cheese->pos->x = -43;
        [cheese->world setCheese:&(cheese)];
        lastDate = [[NSDate date] retain];
        //next_game_tick = -[lastDate timeIntervalSinceNow ];
        titleView = [[TitleView alloc] initWithCoder:coder];
        sleep_time = 0;
        next_tick = next_game_tick;
    }
    return self;
}

/*- (id)initWithFrame:(CGRect)frame
 {
 self = [super initWithFrame:frame];
 if (self) {
 // Initialization code
 }
 return self;
 }*/


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
   // t++;
    // Drawing code
    // Get a graphics context, saving its state
    context = UIGraphicsGetCurrentContext();

    
	CGContextSaveGState(context);
    NSNumber *myDoubleX = [NSNumber numberWithDouble:cheese->x];
    NSNumber *myDoubleY = [NSNumber numberWithDouble:cheese->y];
    NSString *str = @"(x,y): ";
    str = [str stringByAppendingString: myDoubleX.stringValue];
    str = [str stringByAppendingString: @","];
    str = [str stringByAppendingString: myDoubleY.stringValue] ;
    
   // CGPoint textPt = CGPointMake(50, 100);
    
    NSFont *font = [NSFont fontWithName:@"Arial" size:24.0];
    
    NSDictionary *attrsDictionary =
        [NSDictionary dictionaryWithObjectsAndKeys:
         font, NSFontAttributeName,
         [NSNumber numberWithFloat:1.0], NSBaselineOffsetAttributeName, nil];
    //[str drawAtPoint:textPt withAttributes:attrsDictionary];
    //CGContextShowTextAtPoint(context, 10, 100, str, strlen(str));
    CGRect drawRect = CGRectMake(0.0, 10.0, 500.0, 100.0);
    [str drawInRect:drawRect withAttributes:attrsDictionary];
	// Reset the transformation
	CGAffineTransform t0 = CGContextGetCTM(context);
	t0 = CGAffineTransformInvert(t0);
	CGContextConcatCTM(context,t0);
    
    [backgroundSprite draw:context at:CGPointMake(0,0)];
    
    
//    [mouseSprite draw:context at:CGPointMake(mouse->x,mouse->y)];
  //  mouse = curLevel->mouse;
    [mouse draw:context];
    t0 = CGContextGetCTM(context);
    t0 = CGAffineTransformTranslate(t0, cheese->cheeseSprite.x+cheese->cheeseSprite.width/2,cheese->cheeseSprite.y+cheese->cheeseSprite.height/2);
    t0 = CGAffineTransformRotate(t0,cheese->angularDisplacement );
    t0 = CGAffineTransformTranslate(t0, -cheese->cheeseSprite.x-cheese->cheeseSprite.width/2,
                                    -cheese->cheeseSprite.y-cheese->cheeseSprite.height/2);
    CGContextConcatCTM(context,t0);
    [cheese draw: context];
    
    for (int i=0; i < coins.count; i++)
    {
        coin = (Coin*)[coins objectAtIndex:i];
        t0 = CGAffineTransformInvert(t0);
        CGContextConcatCTM(context,t0);
        t0 = CGAffineTransformIdentity;
        t0 = CGAffineTransformTranslate(t0, coin->coinSprite.x+coin->coinSprite.width/2,coin->coinSprite.y+coin->coinSprite.height/2);
       
        t0 = CGAffineTransformTranslate(t0, -coin->coinSprite.x-coin->coinSprite.width/2,
                                        -coin->coinSprite.y-coin->coinSprite.height/2);
        
        CGContextConcatCTM(context,t0);
        
        [coin draw:context];
    }

    
    for (int i=0; i < gears.count; i++)
    {
        gear = (Gear*)[gears objectAtIndex:i];
        t0 = CGAffineTransformInvert(t0);
        CGContextConcatCTM(context,t0);
        t0 = CGAffineTransformIdentity;
        t0 = CGAffineTransformTranslate(t0, gear->gearSprite.x+gear->gearSprite.width/2,gear->gearSprite.y+gear->gearSprite.height/2);
        t0 = CGAffineTransformRotate(t0,gear->rotateAngle );
        t0 = CGAffineTransformTranslate(t0, -gear->gearSprite.x-gear->gearSprite.width/2,
                                            -gear->gearSprite.y-gear->gearSprite.height/2);

        CGContextConcatCTM(context,t0);

        [gear draw:context];
    }
    
    
    
    float drumTopLeftX = 0;
    float drumTopLeftY = 0;

    
    for (int i=0; i < drums.count; i++)
    {
         drum = (Drum*)[drums objectAtIndex:i];
         t0 = CGAffineTransformInvert(t0);
         CGContextConcatCTM(context,t0);
         t0 = CGAffineTransformIdentity;
         t0 = CGAffineTransformTranslate(t0, drum->x ,drum->y);
         float newAngle = [drum getAngle]*M_PI/180;
         t0 = CGAffineTransformRotate(t0,newAngle );
         t0 = CGAffineTransformTranslate(t0, -drum->x ,-drum->y);
         CGContextConcatCTM(context,t0);
        
        [drum draw:context];
        
       // CGContextBeginPath(context);
      //  CGContextSetStrokeColor(context, green);
        double radianAngle = drum->angle*M_PI/180.0f;
        drumTopLeftX = drum->x - cos(radianAngle)*drum->drumSprite.width/2 + cos(radianAngle+M_PI_2)*drum->drumSprite.height/2;
        drumTopLeftY = drum->y - sin(radianAngle)*drum->drumSprite.width/2 + sin(radianAngle+M_PI_2)*drum->drumSprite.height/2;
        drumTopLeftX = drumTopLeftX/2.0f;
        drumTopLeftY = self.bounds.size.height - drumTopLeftY/2.0f;
       // CGContextAddArc(context, drumTopLeftX, drumTopLeftY, 5, 0, 2*M_PI,YES);
       // CGContextStrokePath(context);
    }

   
    
    
    for (int i=0; i < teeterTotters.count; i++)
    {
        teeterTotter = (TeeterTotter*)[teeterTotters objectAtIndex:i];
        t0 = CGAffineTransformInvert(t0);
        CGContextConcatCTM(context,t0);
        t0 = CGAffineTransformIdentity;
        t0 = CGAffineTransformTranslate(t0, teeterTotter->totterSprite.x+teeterTotter->totterSprite.width/2,teeterTotter->totterSprite.y+teeterTotter->totterSprite.height/2);
        t0 = CGAffineTransformRotate(t0,[teeterTotter getAngle]*M_PI/180 );
        t0 = CGAffineTransformTranslate(t0, -teeterTotter->totterSprite.x-teeterTotter->totterSprite.width/2,
                                        -teeterTotter->totterSprite.y-teeterTotter->totterSprite.height/2);
        CGContextConcatCTM(context,t0);
        
        [teeterTotter draw:context];
    }
    CGFloat red[4] = {1.0f, 0.0f, 0.0f, 1.0f};
    //double radianAngle;
    float flipperTopRightX;
    float flipperTopRightY;
    for (int i=0; i < flippers.count; i++)
    {
        flipper = (Flipper*)[flippers objectAtIndex:i];
       
        
        t0 = CGAffineTransformInvert(t0);
        CGContextConcatCTM(context,t0);
        t0 = CGAffineTransformIdentity;
        t0 = CGAffineTransformTranslate(t0, flipper->sprite.x+flipper->sprite.width/2,flipper->sprite.y+flipper->sprite.height/2);
        t0 = CGAffineTransformRotate(t0,[flipper getAngle]*M_PI/180 );
        if (flipper->isImgFlipped)
        {
            t0 = CGAffineTransformScale(t0, -1, 1);
        }
        t0 = CGAffineTransformTranslate(t0, -flipper->sprite.x-flipper->sprite.width/2,
                                        -flipper->sprite.y-flipper->sprite.height/2);
        
        CGContextConcatCTM(context,t0);
        [flipper draw:context];
        CGContextSetStrokeColor(context, red);
        CGContextBeginPath(context);
        double radianAngle = flipper->angle*M_PI/180.0f;
        flipperTopRightX = flipper->x + cos(radianAngle)*flipper->sprite.width/2 + cos(radianAngle+M_PI_2)*flipper->sprite.height/2;
        flipperTopRightY = flipper->y + sin(radianAngle)*flipper->sprite.width/2 + sin(radianAngle+M_PI_2)*flipper->sprite.height/2;
        flipperTopRightX = flipperTopRightX/2.0f;
        flipperTopRightY = self.bounds.size.height - flipperTopRightY/2.0f;
        CGContextAddArc(context, flipperTopRightX, flipperTopRightY, 5, 0, 2*M_PI,YES);
        CGContextStrokePath(context);
    }
    
    CGContextRestoreGState(context);

    
    CGContextSetStrokeColor(context, red);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, cheese->x/2.0f, self.bounds.size.height - cheese->y/2.0f);
    //printf("cheese: (%f,%f)", cheese->x/2.0f, self.bounds.size.height-cheese->y/2.0f - 17);
    Vector *cheeseVelNormalized = [[Vector alloc] init];
    [cheeseVelNormalized initializeVectorX:cheese->vel->x andY:cheese->vel->y];
    [cheeseVelNormalized normalize];
    
    float x = (cheese->x + cheese->vel->x*cheese->time)/2.0f;
    //float x = (cheese->x + (cheese->vel->x+cheese->acceleration->x)*cheese->time)/2.0f;
    float y = self.bounds.size.height - (cheese->y + cheese->vel->y*cheese->time)/2.0f;
    //float y = self.bounds.size.height - (cheese->y + (cheese->vel->y+cheese->acceleration->y)*cheese->time)/2.0f;
    float x3 = (cheese->x + 34 * cheeseVelNormalized->x + cheese->vel->x*cheese->time)/2.0f;
    //float x3 = (cheese->x + 34 * cheeseVelNormalized->x + (cheese->vel->x+cheese->acceleration->x)*cheese->time)/2.0f;
    float y3 = self.bounds.size.height - (cheese->y + 34 *cheeseVelNormalized->y + cheese->vel->y*cheese->time)/2.0f;
    //float y3 = self.bounds.size.height - (cheese->y + 34 *cheeseVelNormalized->y + (cheese->vel->y+cheese->acceleration->y)*cheese->time)/2.0f;
  //  float x3 = cheese->x + 34 * cheeseVelNormalized->x + (cheese->vel->x * time)/2.0f;
   // float y3 = self.bounds.size.height - (cheese->y + time *cheeseVelNormalized->y)/2.0f;
    
  
    //printf(" move to: (%f,%f)\n", x, y);
    CGContextAddLineToPoint(context, x3, y3);
    CGContextStrokePath(context);
    CGContextSetStrokeColor(context, red);
    CGContextBeginPath(context);
    CGContextAddArc(context, x, y, cheese->r/2, 0, 2*M_PI, YES);
    CGContextStrokePath(context);
    
    CGFloat green[4] = {0.0f, 1.0f, 0.0f, 1.0f};
    CGContextSetStrokeColor(context, green);
    CGContextBeginPath(context);
    CGContextAddArc(context, drumTopLeftX, drumTopLeftY, 5, 0, 2*M_PI,YES);
    CGContextStrokePath(context);
    
    CGFloat blue[4] = {0.0f,0.0f,1.0f, 1.0f};
    CGFloat purple[4] = {1.0f,0.0f,1.0f, 1.0f};
    CGFloat yellow[4] = {0.0f,1.0f,1.0f, 1.0f};
    CGContextSetStrokeColor(context, red);
    CGContextBeginPath(context);
   // CGContextMoveToPoint(context, cheese->collisionPoint->x, cheese->collisionPoint->y);
    
    
    
    float collisionPtX = cheese->colPackage->intersectionPoint->x/2.0f;
    float collisionPtY = self.bounds.size.height - cheese->colPackage->intersectionPoint->y/2.0f;
    CGContextAddArc(context, collisionPtX, collisionPtY, 5, 0, 2*M_PI,YES);
    CGContextStrokePath(context);
    
    CGContextSetStrokeColor(context, blue);
    CGContextBeginPath(context);
    float destPtX = (cheese->destinationPoint->x * cheese->r)/2;
    float destPtY = self.bounds.size.height - cheese->destinationPoint->y * cheese->r/2.0f;
    CGContextAddArc(context, destPtX, destPtY, 5, 0, 2*M_PI,YES);
    CGContextStrokePath(context);
    
    CGContextSetStrokeColor(context, purple);
    CGContextBeginPath(context);
    float newDestPtX = (cheese->newDestinationPoint->x * cheese->r)/2;
    float newDestPtY = self.bounds.size.height - cheese->newDestinationPoint->y * cheese->r/2.0f;
    CGContextAddArc(context, newDestPtX, newDestPtY, 5, 0, 2*M_PI,YES);
    CGContextStrokePath(context);
    
    CGContextSetStrokeColor(context, yellow);
    CGContextBeginPath(context);
    float closestPtX = (cheese->colPackage->closestPt->x * cheese->r)/2;
    float closestPtY = self.bounds.size.height - cheese->colPackage->closestPt->y * cheese->r/2.0f;
    CGContextAddArc(context, closestPtX, closestPtY, 5, 0, 2*M_PI,YES);
    CGContextStrokePath(context);
    
    if (cheese->slidingLine->normal!=nil)
    {
        
        CGContextSetStrokeColor(context, blue);
        CGContextBeginPath(context);
        float x1 = 0.0, y1 = 0.0, x2 = 0.0, y2 = 0.0;
        
        //Line *a = [[Line alloc] init];
       // [a initializeLineWithVectorOrigin:cheese->slidingLine->origin andVectorNormal:cheese->slidingLine->normal];
       // Vector *origin = [[Vector alloc] init];
       // origin = a->origin;
        //cheese->slidingLine->origin;
        //float originX = origin->x;
        float ox = [cheese->slidingLine getOriginX];
        float oy = [cheese->slidingLine getOriginY];
        //float nx = [cheese->slidingLine getNormalX];
        //float ny = [cheese->slidingLine getNormalY];
        x1 = ox*cheese->colPackage->eRadius;
        y1 =self.bounds.size.height -oy*cheese->colPackage->eRadius/2.0f;
        x2 = cheese->slidingLine->origin->x*cheese->colPackage->eRadius + cheese->slidingLine->normal->x*10*cheese->colPackage->eRadius;
        y2 = cheese->slidingLine->origin->y*cheese->colPackage->eRadius + cheese->slidingLine->normal->y*10*cheese->colPackage->eRadius;
        if (!isnan(x1))
        {
            CGContextMoveToPoint(context, x1/2.0f,  y1);
            CGContextAddLineToPoint(context, x2/2.0f, self.bounds.size.height - y2/2.0f);
            CGContextStrokePath(context);
        }
    }
    
    CGFloat black[4] = {0.0f, 0.0f, 0.0f, 1.0f};
   // CGFloat yellow[4] = {1.0f, 1.0f, 0.0f, 1.0f};
    CGFloat white[4] = {1.0f, 1.0f, 1.0f, 1.0f};
    CGContextSetFillColor(context, black);
    CGContextFillRect(context, CGRectMake( 0,self.bounds.size.height - 960 /34 * 15/2.0f, 640 / 34 * 15 / 2, 960 /34 * 15 /2.0f));
   
    float topLeftX, topLeftY, topRightX, topRightY;
    CGPoint topLeftPt,topRightPt;
    double radAngle;
    for (int i=0; i < [drums count]; i++)
    {
       // CGContextSetStrokeColor(context, blue);
        drum = [drums objectAtIndex:i];
        radAngle = drum->angle*M_PI/180.0f;
        
        topLeftX = drum->x - cos(radAngle)*drum->drumSprite.width/2 + cos(radAngle+M_PI_2)*drum->drumSprite.height/2;
        topLeftY = drum->y - sin(radAngle)*drum->drumSprite.width/2 + sin(radAngle+M_PI_2)*drum->drumSprite.height/2;
        topLeftPt = CGPointMake(topLeftX, topLeftY);
        // get top right of rectangle
        topRightX = drum->x + cos(radAngle)*drum->drumSprite.width/2 + cos(radAngle+M_PI_2)*drum->drumSprite.height/2;
        topRightY = drum->y + sin(radAngle)*drum->drumSprite.width/2 + sin(radAngle+M_PI_2)*drum->drumSprite.height/2;
        topRightPt = CGPointMake(topRightX,topRightY);
        
        CGContextSetStrokeColor(context, blue);
        CGContextMoveToPoint(context, topLeftX/2.0f, self.bounds.size.height - topLeftY/2.0f);
        CGContextAddLineToPoint(context,topRightX/2.0f, self.bounds.size.height - topRightY/2.0f);
        CGContextStrokePath(context);
        
        topLeftX = topLeftX/34*15;
        topLeftY = topLeftY/34*15;
        topRightX = topRightX/34*15;
        topRightY = topRightY/34*15;
        
        CGContextSetStrokeColor(context, yellow);
        CGContextMoveToPoint(context, topLeftX/2.0f, self.bounds.size.height - topLeftY/2.0f);
        CGContextAddLineToPoint(context,topRightX/2.0f, self.bounds.size.height - topRightY/2.0f);
        CGContextStrokePath(context);
    }
    
    for (int i=0; i < [teeterTotters count]; i++)
    {
        teeterTotter = [teeterTotters objectAtIndex:i];
        radAngle = teeterTotter->angle*M_PI/180.0f;
        
        topLeftX = teeterTotter->x - cos(radAngle)*teeterTotter->totterSprite.width/2 + cos(radAngle+M_PI_2)*teeterTotter->totterSprite.height/2;
        topLeftY = teeterTotter->y - sin(radAngle)*teeterTotter->totterSprite.width/2 + sin(radAngle+M_PI_2)*teeterTotter->totterSprite.height/2;
        topLeftPt = CGPointMake(topLeftX, topLeftY);
        // get top right of rectangle
        topRightX = teeterTotter->x + cos(radAngle)*teeterTotter->totterSprite.width/2 + cos(radAngle+M_PI_2)*teeterTotter->totterSprite.height/2;
        topRightY = teeterTotter->y + sin(radAngle)*teeterTotter->totterSprite.width/2 + sin(radAngle+M_PI_2)*teeterTotter->totterSprite.height/2;
        topRightPt = CGPointMake(topRightX,topRightY);
        
        CGContextSetStrokeColor(context, blue);
        CGContextMoveToPoint(context, topLeftX/2.0f, self.bounds.size.height - topLeftY/2.0f);
        CGContextAddLineToPoint(context,topRightX/2.0f, self.bounds.size.height - topRightY/2.0f);
        CGContextStrokePath(context);
        
        topLeftX = topLeftX/34*15;
        topLeftY = topLeftY/34*15;
        topRightX = topRightX/34*15;
        topRightY = topRightY/34*15;
        
        CGContextSetStrokeColor(context, yellow);
        CGContextMoveToPoint(context, topLeftX/2.0f, self.bounds.size.height - topLeftY/2.0f);
        CGContextAddLineToPoint(context,topRightX/2.0f, self.bounds.size.height - topRightY/2.0f);
        CGContextStrokePath(context);
    }
    
     CGContextSetStrokeColor(context, yellow);
   // CGContextBeginPath(context);
    float cheeseX, cheeseY, cheeseX2, cheeseY2;
    float x1 = cheese->x / 34.0f;
    cheeseX = x1 * 15.0f;
    float y1 = cheese->y/ 34.0f;
    cheeseY = y1 * 15.0f;
 
    float vtx = (cheese->vel->x+cheese->acceleration->x)*cheese->time;
    float x2t = cheese->x + vtx;
    cheeseX2 = ( x2t ) / 34.0f * 15.0f;
    float vty = (cheese->vel->y+cheese->acceleration->y)*cheese->time;
    float y2t = cheese->y + vty;
   // float dist = y2t - cheese->y;
   // NSLog(@"cheese->y: %d", cheese->y);
  //  NSLog(@"cheese->y +vt: %f", y2t);
   // NSLog(@"dist: %f", dist);
    cheeseY2 = y2t / 34.0f * 15.0f;
    //float distance = cheeseY2 - cheeseY;
 //   NSLog(@"cheeseY: %f", cheeseY);
  //  NSLog(@"cheeseY2: %f", cheeseY2);
  //  NSLog(@"distance: %f",distance);
   // CGContextSetFillColor(context, white);
    float finalY = [self bounds].size.height - cheeseY / 2.0f;
    float finalX = cheeseX / 2.0f;
   // NSLog(@"finalX: %f", finalX);
   // NSLog(@"finalY: %f", finalY);
    CGContextMoveToPoint(context, finalX, finalY);
    float x2 = cheeseX2 /2.0f;
   // NSLog(@"height: %f", [self bounds].size.height);

    float finalY2 = [self bounds].size.height - cheeseY2 / 2.0f;
  //  NSLog(@"finalX2: %f", x2);
   // NSLog(@"finalY2: %f", finalY2);
    
    CGContextAddLineToPoint(context, x2 , finalY2); // add 1 cuz too tiny
    //CGContextFillRect(context,CGRectMake(cheeseX / 2.0f,self.bounds.size.height - cheeseY/2.0f,1,1));
    CGContextStrokePath(context);
    
    
    CGContextSetStrokeColor(context, white);
    float destX, destY;
    x1 = cheese->destinationPoint->x;
    destX = x1 * 15.0f;
    y1 = cheese->destinationPoint->y;
    destY = y1 * 15.0f;
 
    finalY = [self bounds].size.height - destY / 2.0f;
    finalX = destX / 2.0f;
   
    CGContextMoveToPoint(context, finalX, finalY);
    
    float finalX2 = finalX - 3;
    finalY2 = finalY;

    CGContextAddLineToPoint(context, finalX2 , finalY2); // add 1 cuz too tiny
    //CGContextFillRect(context,CGRectMake(cheeseX / 2.0f,self.bounds.size.height - cheeseY/2.0f,1,1));
    CGContextStrokePath(context);
    
    CGContextSetStrokeColor(context, white);
    float newDestX, newDestY;
    x1 = cheese->newDestinationPoint->x;
    newDestX = x1 * 15.0f;
    y1 = cheese->newDestinationPoint->y;
    newDestY = y1 * 15.0f;
    
    finalY = [self bounds].size.height - newDestY / 2.0f;
    finalX = newDestX / 2.0f;
    
    CGContextMoveToPoint(context, finalX, finalY);
    
    finalX2 = finalX - 3;
    finalY2 = finalY;
    
    CGContextAddLineToPoint(context, finalX2 , finalY2); // add 1 cuz too tiny
    //CGContextFillRect(context,CGRectMake(cheeseX / 2.0f,self.bounds.size.height - cheeseY/2.0f,1,1));
    CGContextStrokePath(context);}

- (void) update_game
{
    
    if ([mouse isDoneChewing])
    {
        currentLevelNumber++;
        if (currentLevelNumber < [levels count])
        {
            curLevel = [levels objectAtIndex:currentLevelNumber];
            mouse = curLevel->mouse;
        }
        [cheese->world setMouse:&(mouse)];
        
        //curLevel->teeterTotters =
        [cheese->world setLevel: &curLevel];
    
       /* if ([cheese->teeterTotters count] > 0)
        {
            cheese->teeterTotters = cheese->world->lvl->teeterTotters;
        }*/
        Vector *v = [[Vector alloc] init];
        [v initializeVectorX:-100 andY:-100];
        [cheese moveTo:v];
       
        while (gears.count > 0)
        {
            [gears removeObjectAtIndex:0];
        }
        coins = [curLevel getCoins];
        gears = [curLevel getGears];
        
       // printf("gears count: %d\n", gears.count);
        drums = [curLevel getDrums];
        //printf("drums count: %d\n", drums.count);
        teeterTotters = [curLevel getTeeterTotters];
        flippers = [curLevel getFlippers];
       // printf("teeter count: %d\n", teeterTotters.count);
       /* cheese->gears = gears;
        cheese->drums = drums;
        cheese->teeterTotters = teeterTotters;*/
    }
    /* else if ([mouseSprite getFileName]==@"newopenmouthsheet.png")
     {
     mouseSprite.frame = kOpenMouth[frame];
     }
     else if ([mouseSprite getFileName]==@"newclosemouthsheet.png")
     {
     mouseSprite.frame = kCloseMouth[frame];
     }
     else if ([mouseSprite getFileName]==@"MouseSad.png")
     {
     mouseSprite.frame = kSad[frame];
     }*/
    [cheese update];
    for (int i=0; i < [gears count]; i++)
    {
        gear = (Gear*)[gears objectAtIndex:i];
        [gear rotate];
    }
    for (int i=0; i < [drums count]; i++)
    {
        drum = (Drum*)[drums objectAtIndex:i];
        [drum update];
    }
    for (int i=0; i < [teeterTotters count]; i++)
    {
        teeterTotter = (TeeterTotter*)[teeterTotters objectAtIndex:i];
        [teeterTotter update];
    }
    for (int i=0; i < [flippers count]; i++)
    {
        flipper = (Flipper*)[flippers objectAtIndex:i];
        
    }
    [mouse update];
}

- (void) gameLoop
{
    if (game_is_running) {
        
        loops = 0;

        
        //[self update_game:SKIP_TICKS];
       
       
       
        
        //delta_tick = cur_game_tick - next_game_tick;
        
        //time+=delta_tick;
        printf("delta_tick: %f\n",delta_tick);
        NSLog(@"next_tick: %f", next_tick);
        NSLog(@"cur_game_tick: %f", cur_game_tick);
        //next_tick += SKIP_TICKS;
        //sleep_time = cur_game_tick - next_tick;
        NSLog(@"SKIP_TICKS: %f", SKIP_TICKS);
        NSLog(@"interpolation: %f", interpolation);
        //[self update_game:SKIP_TICKS];//delta_tick < 1 && cheese->y <=815
        loops = 0;
        cur_game_tick = -[lastDate timeIntervalSinceNow];
        while (cur_game_tick > next_game_tick && loops < MAX_FRAMESKIP)
        {
            [self update_game];
            next_game_tick += SKIP_TICKS;
            loops++;
            cur_game_tick = -[lastDate timeIntervalSinceNow];
        }
        
        //NSLog(@"sleep_time: %f", sleep_time);
       /* if (sleep_time >= 0 ) {
            NSLog(@"Sleeping for %f", sleep_time);
           // sleep(sleep_time);
            
        }
        else
        {
            NSLog(@"Running behind..");
        }*/
        if (time > 1)
        {
          //  NSLog(@"fps: %d", frame);
            frame = 0;
            time = 0;
        }
        else
        {
            frame++;
        }
        
        timer = [NSTimer scheduledTimerWithTimeInterval: 0
                                                 target:self
                                               selector:@selector(gameLoop)
                                               userInfo:nil
                                                repeats:NO];
        cur_game_tick = -[lastDate timeIntervalSinceNow];
        interpolation = (cur_game_tick + SKIP_TICKS - next_game_tick);// / SKIP_TICKS;
        if (interpolation > (1/kFPS))
        {
            interpolation = 1/kFPS;
        }
        [cheese collideAndSlide:interpolation];
        [cheese fall:interpolation];
        [self display_game];
       
        //interpolation = (cur_game_tick + SKIP_TICKS - next_game_tick) / SKIP_TICKS;
        //printf("interp: %f", interpolation);
        
       /* if (currentLevelNumber==2)
        {
            cleanRemoveFromSuperview(self.superview);
            [self addSubview:titleView];
        }*/
        if (currentLevelNumber >= [levels count])
        {
            
            //UIViewController *titleViewController = [[TitleViewController alloc] initWithNibName:@"TitleViewController" bundle:[NSBundle mainBundle]];
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            
            UIViewController *viewController = [sb instantiateViewControllerWithIdentifier:@"FinishGameViewController"];
            
           [super addSubview:viewController.view];
            [timer invalidate];
            timer = nil;
           //[self willMoveToSuperview:titleViewController.view];
         //  [self removeFromSuperview];
        }
    }
}

void cleanRemoveFromSuperview( UIView * view ) {
    if(!view || !view.superview) return;
    
    //First remove any constraints on the superview
    NSMutableArray * constraints_to_remove = [NSMutableArray new];
    UIView * superview = view.superview;
    
    for( NSLayoutConstraint * constraint in superview.constraints) {
        if( constraint.firstItem == view ||constraint.secondItem == view ) {
            [constraints_to_remove addObject:constraint];
        }
    }
    [superview removeConstraints:constraints_to_remove];
    
    //Then remove the view itself.
    [view removeFromSuperview];
}

- (void) display_game
{
    [self setNeedsDisplay];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    animationNumber = (animationNumber+1)%4;
    float touchX = [touch locationInView:touch.view].x;
    float x = touchX * 2;
    float y = 960 - cheese->cheeseSprite.height/2;// - [touch locationInView:touch.view].y * 2;
    if (x > 640 - cheese->cheeseSprite->width/2)
        x = 640 - cheese->cheeseSprite->width/2;
    else if (x < cheese->cheeseSprite->width/2)
        x = cheese->cheeseSprite->width/2;
    CGPoint pt = CGPointMake(x,y);
    printf("drop (x,y): (%f, %f)\n",pt.x,pt.y);
    [cheese dropAt:pt];
    lastDate = [[NSDate date] retain];
    next_game_tick = -[lastDate timeIntervalSinceNow];//+SKIP_TICKS;
   /* switch (animationNumber)
    {
        case 0:
            steps = 7;
           // if (mouseSprite!=nil)
              //  [mouseSprite release];
            mouseSprite = [AtlasSprite fromFile: @"MouseBlink.png" withRows: 1 withColumns: steps];
            break;
        case 1:
            steps = 12;
            //if (mouseSprite!=nil)
              //  [mouseSprite release];
            mouseSprite = [AtlasSprite fromFile: @"newopenmouthsheet.png" withRows: 1 withColumns: steps];
            break;
        case 2:
            steps = 12;
           // if (mouseSprite!=nil)
               // [mouseSprite release];
            mouseSprite = [AtlasSprite fromFile: @"newclosemouthsheet.png" withRows: 1 withColumns: steps];
            break;
        case 3:
            steps = 6;
           // if (mouseSprite!=nil)
              //  [mouseSprite release];
            mouseSprite = [AtlasSprite fromFile: @"MouseSad.png" withRows: 1 withColumns: steps];
            break;
    }*/
}

- (void) dealloc
{
    
    [fpsLabel release];
    [super dealloc];

}

@end
