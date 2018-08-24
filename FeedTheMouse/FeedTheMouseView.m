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
#define TICKS_PER_SECOND 50
#define SKIP_TICKS 1000 / TICKS_PER_SECOND
#define MAX_FRAMESKIP 10

@implementation FeedTheMouseView

- (void) doParse:(NSData *)data
{
    // create and init NSXMLParser object
    NSXMLParser *nsXmlParser = [[NSXMLParser alloc] initWithData:data];
    
    // create and init our delegate
    parser = [[XMLParser alloc] initXMLParser];
    
    // set delegate
    [nsXmlParser setDelegate:parser];
    
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
        printf("gears retain count:%lu", (unsigned long)[gears retainCount]);
        cheese->gears = gears;
        coins = [curLevel getCoins];
        drums = [curLevel getDrums];
        cheese->drums = drums;
        teeterTotters = [curLevel getTeeterTotters];
        cheese->teeterTotters = teeterTotters;
        flippers = [curLevel getFlippers];
        cheese->flippers = flippers;
        currentLevelNumber = 0;
        [cheese->world setLevel:curLevel];
        mouse = curLevel->mouse;
        [cheese->world setMouse:&(mouse)];
        [cheese->world setCheese:&(cheese)];
        lastDate = [[NSDate date] retain];
        next_game_tick = -[lastDate timeIntervalSinceNow ];
        titleView = [[TitleView alloc] initWithCoder:coder];
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
    }
    
    CGContextRestoreGState(context);
    
    CGFloat red[4] = {1.0f, 0.0f, 0.0f, 1.0f};
    CGContextSetStrokeColor(context, red);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, cheese->x/2.0f, self.bounds.size.height - cheese->y/2.0f);
    //printf("cheese: (%f,%f)", cheese->x/2.0f, self.bounds.size.height-cheese->y/2.0f - 17);
    float x = (cheese->x + cheese->vel->x )/2.0f;
    float y = (self.bounds.size.height - cheese->y/2.0f) - cheese->vel->y/2.0f;

    //printf(" move to: (%f,%f)\n", x, y);
    CGContextAddLineToPoint(context, x, y);
    CGContextStrokePath(context);
    CGContextSetStrokeColor(context, red);
    CGContextBeginPath(context);
    CGContextAddArc(context, x, y, cheese->r/2, 0, 2*M_PI, YES);
    CGContextStrokePath(context);

    if (cheese->slidingLine->normal!=nil)
    {
        CGFloat blue[4] = {0.0f, 0.0f, 1.0f, 1.0f};
        CGContextSetStrokeColor(context, blue);
        CGContextBeginPath(context);
        float x1 = 0.0, y1 = 0.0, x2 = 0.0, y2 = 0.0;
        
        Line *a = [[Line alloc] init];
       // [a initializeLineWithVectorOrigin:cheese->slidingLine->origin andVectorNormal:cheese->slidingLine->normal];
       // Vector *origin = [[Vector alloc] init];
       // origin = a->origin;
        //cheese->slidingLine->origin;
        //float originX = origin->x;
        float ox = [cheese->slidingLine getOriginX];
        float oy = [cheese->slidingLine getOriginY];
        float nx = [cheese->slidingLine getNormalX];
        float ny = [cheese->slidingLine getNormalY];
        x1 = ox*cheese->colPackage->eRadius;
        y1 = oy*cheese->colPackage->eRadius;
        x2 = cheese->slidingLine->origin->x*cheese->colPackage->eRadius + cheese->slidingLine->normal->x*10*cheese->colPackage->eRadius;
        y2 = cheese->slidingLine->origin->y*cheese->colPackage->eRadius + cheese->slidingLine->normal->y*10*cheese->colPackage->eRadius;
        if (!isnan(x1))
        {
            CGContextMoveToPoint(context, x1/2.0f, self.bounds.size.height - y1/2.0f);
            CGContextAddLineToPoint(context, x2/2.0f, self.bounds.size.height - y2/2.0f);
            CGContextStrokePath(context);
        }
    }
   
}

- (void) update_game
{
    if ([mouse isDoneChewing])
    {
        currentLevelNumber++;
        curLevel = [levels objectAtIndex:currentLevelNumber];
        mouse = curLevel->mouse;
        [cheese->world setMouse:&(mouse)];
        [cheese->world setLevel: curLevel];
        Vector *v = [[Vector alloc] init];
        [v initializeVectorX:-100 andY:-100];
        [cheese moveTo:v];
        [v release];
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
    
}

- (void) gameLoop
{
    if (game_is_running) {
        
        
       
        /*
        loops = 0;

        while (cur_game_tick > next_game_tick && loops < MAX_FRAMESKIP)
        {
         
            next_game_tick += SKIP_TICKS;
            loops++;
        }*/
        [self update_game];
        timer = [NSTimer scheduledTimerWithTimeInterval: 0
                                                 target:self
                                               selector:@selector(gameLoop)
                                               userInfo:nil
                                                repeats:NO];
        
        cur_game_tick = -[lastDate timeIntervalSinceNow];
        delta_tick = cur_game_tick - next_game_tick;
        next_game_tick = -[lastDate timeIntervalSinceNow];
        [self display_game:.02];
        printf("delta_tick: %f\n",delta_tick);
        //interpolation = (cur_game_tick + SKIP_TICKS - next_game_tick) / SKIP_TICKS;
        //printf("interp: %f", interpolation);
        
       /* if (currentLevelNumber==2)
        {
            cleanRemoveFromSuperview(self.superview);
            [self addSubview:titleView];
        }*/
        if (currentLevelNumber >= [levels count]-1)
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

- (void) display_game:(double) lerp
{

    [cheese display:lerp];
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
    [self setNeedsDisplay];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    animationNumber = (animationNumber+1)%4;
    float x = [touch locationInView:touch.view].x * 2;
    float y = 960;// - [touch locationInView:touch.view].y * 2;
    CGPoint pt = CGPointMake(x,y);
    printf("(x,y): (%f, %f)\n",pt.x,pt.y);
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
    
    [super dealloc];

}

@end
