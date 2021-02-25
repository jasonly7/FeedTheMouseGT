//
//  FeedTheMouseView.m
//  FeedTheMouse
//
//  Created by Jason Ly on 2012-10-28.
//  Copyright (c) 2012 Jason Ly. All rights reserved.
//

#import "FeedTheMouseView.h"


#define kDirForward 0
#define kFPS 40.0
#define TICKS_PER_SECOND 13
#define SKIP_TICKS 1.0 / TICKS_PER_SECOND
#define MAX_FRAMESKIP 5

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
        titleView = [[TitleView alloc] initWithCoder:coder];
        
        [self startAt:0 andTime:0 withCoins:0];
    }
    return self;
}


- (void) startAt:(int)level andTime:(double)startingTime withCoins:(int)numOfCoins
{
    primarySurface = [[Picture alloc] init];
    mouse = [[Mouse alloc] init];
    cheese = [[Cheese alloc] init];
    chatBubble = [[ChatBubble alloc] init];
    pauseButton = [[PauseButton alloc] init];
    musicButton = [[MusicButton alloc] init];
    gear = [[Gear alloc] init];
    drum = [[Drum alloc] init];
    bomb = [[[Bomb alloc] init] autorelease];
    boom = [[Boom alloc] init];
    teeterTotter = [[TeeterTotter alloc] init];
    flipper = [[Flipper alloc] init];
    coin = [[Coin alloc] init];
    cheeseArrayOfLives = [[NSMutableArray alloc] initWithCapacity:5];
    pauseMenu = [[PauseMenu alloc] init];
    for (int i=0; i < 5; i++)
    {
        Cheese *cheeseLife = [[Cheese alloc] init];
        [cheeseArrayOfLives addObject:cheeseLife];
    }
    TitleViewController *titleViewController = (TitleViewController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    titleViewController.playerNameTextField.hidden = true;
    total_time = startingTime;
    parser = [[XMLParser alloc] initXMLParser];
    game_state = GAME_RUNNING;
    NSData *data = [[NSData alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"FeedTheMouse.xml" ofType:nil]];
    [self doParse:data];
    [data release];
    NSString *playerName = titleViewController.playerNameTextField.text;
    if (DEBUG)
        NSLog(@"name: %@", playerName);
    if ([Utility isNumeric:playerName])
    {
        
        currentLevelNumber = [playerName intValue]-1;
        curLevel = [levels objectAtIndex:currentLevelNumber];
        
    }
    else
    {
        currentLevelNumber = level;
        curLevel = [levels objectAtIndex:currentLevelNumber];
        [cheese->world setLevel: &curLevel];
        
    }
    mouse = curLevel->mouse;
    [cheese->world setLevel: &curLevel];
    coins = [curLevel getCoins];
    gears = [curLevel getGears];
    coinIcon = [[Coin alloc] init];
    [coinIcon initializeCoinAtX:0 andY:0 andImage:@"mediumlargecoins.png"];
    drums = [curLevel getDrums];
    bombs = [curLevel getBombs];
    teeterTotters = [curLevel getTeeterTotters];
    
    if ([gears count] > 0)
    {
        NSString *pathForGearSoundFile = [[NSBundle mainBundle] pathForResource:@"sounds/Gear_Turning" ofType:@"mp3"];
        [cheese->world->sndMan playLoopedSound:pathForGearSoundFile];
    }
    
    cheese->world->numOfCoins = numOfCoins;
    next_game_tick = -[lastDate timeIntervalSinceNow];
    direction = kDirForward;
    screenScale = [[UIScreen mainScreen] scale];
    
    timer = [NSTimer scheduledTimerWithTimeInterval: 1.0/(kFPS*screenScale)
                                             target:self
                                           selector:@selector(gameLoop)
                                           userInfo:nil
                                            repeats:NO];
    game_is_running = true;
    animationNumber = 0;
    
    // get array of objects here
    gears = [curLevel getGears];
   // printf("gears retain count:%lu", (unsigned long)[gears retainCount]);
    cheese->gears = gears;
    coins = [curLevel getCoins];
    
    drums = [curLevel getDrums];
    cheese->drums = drums;
    bombs = [curLevel getBombs];
    cheese->bombs = bombs;
    
        
    teeterTotters = [curLevel getTeeterTotters];
    cheese->teeterTotters = teeterTotters;
    if ([teeterTotters count] > 0)
    {
        //[cheese->prevVelocities initWithCapacity:[teeterTotters count]];
        for (int i=0; i < [teeterTotters count]; i++)
        {
            [cheese->prevVelocities addObject:[[Vector alloc] init]];
        }
        for (int i=0; i < [cheese->prevVelocities count]; i++)
        {
            [cheese->prevVelocities[i] initializeVectorX:0 andY:0];
        }
    }
    flippers = [curLevel getFlippers];
    cheese->flippers = flippers;
    
    [cheese->world setLevel:&curLevel];
    mouse = curLevel->mouse;
    [cheese->world setMouse:&(mouse)];
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    screenScale = [[UIScreen mainScreen] scale];
    CGSize screenSize = CGSizeMake(screenBounds.size.width * screenScale, screenBounds.size.height * screenScale);
    screenWidth = screenSize.width;
    screenHeight = screenSize.height;
    sx = screenWidth/640.0f;
    sy = screenHeight/1136.0f;
    cheese->x = -cheese->cheeseSprite.width*sx*screenScale;
    cheese->pos->x = cheese->x;//-43;
    cheese->y = -cheese->cheeseSprite.height*sy*screenScale;
    cheese->pos->y = cheese->y;
    chatBubble->x = mouse->x - chatBubble->bubbleSprite.width;
    chatBubble->y = mouse->y + chatBubble->bubbleSprite.height/4;
    [cheese->world setCheese:&(cheese)];
    lastDate = [[NSDate date] retain];
    //next_game_tick = -[lastDate timeIntervalSinceNow ];
    //titleView = [[TitleView alloc] initWithCoder:coder];
    sleep_time = 0;
    next_tick = next_game_tick;
  
    
    pauseMenu->x = screenBounds.size.width/2 - pauseMenu->pauseSprite.width*sx/2/screenScale;
    if ( screenWidth == 1242 )
        pauseMenu->y = screenBounds.size.height/2 + pauseMenu->pauseSprite.height*sy/2;
    else if (screenWidth == 1668 || screenWidth == 2048 || screenWidth == 1536 || screenWidth == 1620 || screenWidth == 1640)
        pauseMenu->y = screenBounds.size.height/2 ;
    else
        pauseMenu->y = screenBounds.size.height/2 + pauseMenu->pauseSprite.height*sy/2/screenScale;
    
    NSString *backgroundFilename;
    if (screenWidth == 1242)
    {
        backgroundFilename = [[NSString alloc] initWithString:@"big_"];
        backgroundFilename = [backgroundFilename stringByAppendingString:curLevel->backgroundFilename];
        backgroundFilename = [backgroundFilename stringByDeletingPathExtension];
        backgroundFilename = [backgroundFilename stringByAppendingString:@".jpg"];
    }
   /* else if (screenWidth == 750)
    {
        backgroundFilename = @"background_1_641x1140.jpg";
    }*/
    else
    {
        backgroundFilename = [[NSString alloc] initWithString:curLevel->backgroundFilename];
    }
    backgroundSprite = [Picture fromFile:backgroundFilename];
    primarySurface = [Picture fromFile:backgroundFilename];
    struct vImage_Buffer inputBuffer;
    struct vImage_Buffer outputBuffer;
    
    CGImageRef bgImageRef = backgroundSprite->image;

    vImage_CGImageFormat format = {
        .bitsPerComponent = 8,
        .bitsPerPixel = 32,
        .colorSpace = NULL,
        // requests a BGRA buffer.
        .bitmapInfo = kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little,
        .version = 0,
        .decode = NULL,
        .renderingIntent = kCGRenderingIntentDefault
    };
    
    long error = vImageBuffer_InitWithCGImage(&inputBuffer, &format, NULL, bgImageRef, kvImageNoFlags);
    if (error != kvImageNoError)
        NSLog(@"Failed to put background image into input buffer");
    backgroundSprite->image = vImageCreateCGImageFromBuffer(&inputBuffer, &format, NULL, NULL, kvImageNoFlags, &error);
    outputBuffer.data = malloc(sizeof(inputBuffer.data));
    error = vImageBuffer_Init(&outputBuffer, inputBuffer.height, inputBuffer.width, format.bitsPerPixel, kvImageNoFlags);
    if (error != kvImageNoError)
        NSLog(@"Failed to init output buffer");
    error = vImageCopyBuffer(&inputBuffer, &outputBuffer, 4, kvImageNoFlags);
    if (error != kvImageNoError)
        NSLog(@"Failed to put background image into output buffer");
    primarySurface->image = vImageCreateCGImageFromBuffer(&outputBuffer, &format, NULL, NULL, kvImageNoFlags, &error);
    
    pathForMusicFile = [[NSBundle mainBundle] pathForResource:@"sounds/Cute_By_Benjamin_Tissot" ofType:@"mp3"];
    musicFile = [[NSURL alloc] initFileURLWithPath:pathForMusicFile];
    musicPlayer = [AVAudioPlayer alloc];
    [musicPlayer initWithContentsOfURL:musicFile error:NULL];
    musicPlayer.numberOfLoops = -1;
    [musicPlayer prepareToPlay];
    [musicPlayer play];
    message = @"Tap Here to Start";
   
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
    CGFloat black[4] = {0.0f, 0.0f, 0.0f, 1.0f};
    CGFloat blue[4] = {0.0f,0.0f,1.0f, 1.0f};
    CGFloat purple[4] = {1.0f,0.0f,1.0f, 1.0f};
    CGFloat yellow[4] = {1.0f,1.0f,0.0f, 1.0f};
    // Drawing code
    // Get a graphics context, saving its state
    context = UIGraphicsGetCurrentContext();

    
	CGContextSaveGState(context);
    float xCheese = cheese->x;
    float yCheese = cheese->y;
    NSNumber *myDoubleX = [NSNumber numberWithDouble:xCheese];
    NSNumber *myDoubleY = [NSNumber numberWithDouble:yCheese];
    NSString *str = @"(x,y): ";
    str = [str stringByAppendingString: myDoubleX.stringValue];
    str = [str stringByAppendingString: @","];
    str = [str stringByAppendingString: myDoubleY.stringValue] ;
    
  
    CGRect drawRect = CGRectMake(0.0, 50.0, 500.0, 100.0);
  
	// Reset the transformation
	CGAffineTransform t0 = CGContextGetCTM(context);
	t0 = CGAffineTransformInvert(t0);
	
    
    sx = screenWidth/640.0f;
    sy = screenHeight/1136.0f;
    if (screenWidth != 1242 )
        t0 = CGAffineTransformScale(t0, sx, sy);
        
    CGContextConcatCTM(context,t0);
    
    if (screenWidth == 1242 )
    {
        [primarySurface draw:context at:CGPointMake(0, 0)];
        t0 = CGAffineTransformScale(t0, sx, sy);
    }
    /*else if (screenWidth == 750)
    {
        
        [primarySurface draw:context at:CGPointMake(0, 0)];
        //t0 = CGAffineTransformScale(t0, 1/sx, 1/sy);
    }*/
    else
    {
        [backgroundSprite draw:context at:CGPointMake(0,0)];
    }

    [mouse draw:context];
    
    t0 = CGContextGetCTM(context);
    t0 = CGAffineTransformTranslate(t0, cheese->cheeseSprite.x+cheese->cheeseSprite.width/2,cheese->cheeseSprite.y+cheese->cheeseSprite.height/2);
    t0 = CGAffineTransformTranslate(t0, -cheese->cheeseSprite.x-cheese->cheeseSprite.width/2,
                                   -cheese->cheeseSprite.y-cheese->cheeseSprite.height/2);
    if (screenWidth != 1242 )
    {
        t0 = CGAffineTransformScale(t0, 1/sx, 1/sy);
    }
    
    if (screenWidth == 1668 || screenWidth == 2048 || screenWidth == 1536 || screenWidth == 1620 || screenWidth == 1640)
        t0 = CGAffineTransformScale(t0, 1/sx, 1/sy);
        
    if (screenHeight == 960)
        t0 = CGAffineTransformScale(t0, 1, 1/sy);
    
    
    if (screenWidth == 750 )
        t0 = CGAffineTransformScale(t0, 1/sx, 1/sy);
    
    if (screenWidth == 828)
    {
        t0 = CGAffineTransformScale(t0, 1/sx, 1/sy);
        
        t0 = CGAffineTransformTranslate(t0, cheese->cheeseSprite.x+cheese->cheeseSprite.width/2,cheese->cheeseSprite.y+cheese->cheeseSprite.height/2);
        
        t0 = CGAffineTransformScale(t0, sy, sy);
        t0 = CGAffineTransformTranslate(t0, -cheese->cheeseSprite.x-cheese->cheeseSprite.width/2,
                                        -cheese->cheeseSprite.y-cheese->cheeseSprite.height/2);
        
    }
    
    if (screenWidth == 1125)
    {
        t0 = CGAffineTransformScale(t0, 1/sx, 1/sy);
        
        t0 = CGAffineTransformTranslate(t0, cheese->cheeseSprite.x+cheese->cheeseSprite.width/2,cheese->cheeseSprite.y+cheese->cheeseSprite.height/2);
        
        t0 = CGAffineTransformScale(t0, 2, 2);
        t0 = CGAffineTransformTranslate(t0, -cheese->cheeseSprite.x-cheese->cheeseSprite.width/2,
                                        -cheese->cheeseSprite.y-cheese->cheeseSprite.height/2);
    }
    
    if (screenWidth == 1284)
    {
        t0 = CGAffineTransformScale(t0, 1/sx, 1/sy);
        
        t0 = CGAffineTransformTranslate(t0, cheese->cheeseSprite.x+cheese->cheeseSprite.width/2,cheese->cheeseSprite.y+cheese->cheeseSprite.height/2);
        
        t0 = CGAffineTransformScale(t0, sx, sy);
        t0 = CGAffineTransformTranslate(t0, -cheese->cheeseSprite.x-cheese->cheeseSprite.width/2,
                                        -cheese->cheeseSprite.y-cheese->cheeseSprite.height/2);
    }
    CGContextConcatCTM(context,t0);
    if (cheese)
    {
        if (game_state != GAME_CONTINUE && game_state!=GAME_OVER)
        {
            /*if (screenWidth == 1242)
            {
                struct vImage_Buffer inputBuffer;
                struct vImage_Buffer outputBuffer;
                
                CGImageRef bgImageRef = backgroundSprite->image;
                CGImageRef cheeseImageRef = cheese->cheeseSprite->image;
                vImage_CGImageFormat format = {
                    .bitsPerComponent = 8,
                    .bitsPerPixel = 32,
                    .colorSpace = NULL,
                    // requests a BGRA buffer.
                    .bitmapInfo = kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little,
                    .version = 0,
                    .decode = NULL,
                    .renderingIntent = kCGRenderingIntentDefault
                };
                
                long error = vImageBuffer_InitWithCGImage(&outputBuffer, &format, NULL, bgImageRef, kvImageNoFlags);
                if (error != kvImageNoError)
                    NSLog(@"Failed to put background image into output buffer");
                
                
                error = vImageBuffer_InitWithCGImage(&inputBuffer, &format, NULL, cheeseImageRef, kvImageNoFlags);
                if (error != kvImageNoError)
                    NSLog(@"Failed to put background image into input buffer");
                //outputBuffer.data = malloc(sizeof(inputBuffer.data));
                
                Byte *data = (Byte*)inputBuffer.data;
                
                int j = 0, k = 0;
                
                for(vImagePixelCount i = 0; i < inputBuffer.rowBytes * inputBuffer.height ; i+=4) {
                     
                    unsigned long x,y;
                    //unsigned long j = (unsigned long)(cheese->x*sx) + i;
                    y = i / inputBuffer.rowBytes;
                  
                    x = ( i % inputBuffer.rowBytes ) >> 2;
                      
                    if (x >= inputBuffer.width)
                        continue;
                    
                    if ((cheese->x - cheese->cheeseSprite.width) < backgroundSprite.width && (cheese->x + cheese->cheeseSprite.width) > 0 &&
                        (cheese->y + cheese->cheeseSprite.height) < backgroundSprite.height && (cheese->y - cheese->cheeseSprite.height) > 0)
                    {
                        unsigned long outputI = (y + (unsigned long)(backgroundSprite.height - cheese->y-cheese->cheeseSprite.height/2)) * outputBuffer.rowBytes + ((x << 2) + (unsigned long)((int)(cheese->x-cheese->cheeseSprite.width/2) << 2));
                       // int outputI = i;
                        Byte R = (Byte)data[i];
                        Byte G = (Byte)data[i + 1];
                        Byte B = (Byte)data[i + 2];
                        Byte A = (Byte)data[i + 3];
                        //NSLog(@"1: (%d) %d, %d, %d, %d", i, R,G,B,A);
                        
                        if (A>127)
                        {
                            ((Byte*)outputBuffer.data)[outputI] = R;
                
                            ((Byte*)outputBuffer.data)[outputI + 1] = G;
                    
                            ((Byte*)outputBuffer.data)[outputI + 2] = B;
                           
                            ((Byte*)outputBuffer.data)[outputI + 3] = A;
                        }
                    }
                }
               
                primarySurface->image = vImageCreateCGImageFromBuffer(&outputBuffer, &format, NULL, NULL, kvImageNoFlags, &error);
                [primarySurface draw:context at:CGPointMake(0, 0)];
            }
            else
            {*/
                [cheese draw: context];
            //}
        }
        
    }
   // [mouse draw:context];
    if (DEBUG)
    {
        CGContextBeginPath(context);
        CGContextSetStrokeColor(context, blue);
        CGContextAddArc(context, tapPoint.x, tapPoint.y, 5, 0, 2*M_PI,YES);
        CGContextStrokePath(context);
    }
   
    //for (int i=0; i < 1; i++)
    for (int i=0; i < cheese->numOfLives; i++)
    {
       
        Cheese *cheeseLife = [cheeseArrayOfLives objectAtIndex:i];
        if (DEBUG)
            NSLog(@"width: %f" ,self.bounds.size.width);
    
        int chy = 960+cheeseLife->r*2;
        int chx = 640 - (i+1)*(cheeseLife->cheeseSprite.width/2);
        
        if (screenWidth == 1242)
        {
            chx = 630 - (i)*(cheeseLife->cheeseSprite.width/4);
            [cheeseLife placeAt:CGPointMake(chx*sx, chy*sy-cheeseLife->r*2)];
        }
        else if (screenWidth == 1668 || screenWidth == 2048 || screenWidth == 1536 || screenWidth == 1620 || screenWidth == 1640)
        {
            if (screenWidth == 1640 || screenWidth == 1620 )
                chx = 680 - (i)*(cheeseLife->cheeseSprite.width/8);
            else if (screenWidth == 1536 )
                chx = 670 - (i)*(cheeseLife->cheeseSprite.width/6);
            else if (screenWidth == 2048)
                chx = 660 - (i)*(cheeseLife->cheeseSprite.width/6);
            else
                chx = 640 - (i)*(cheeseLife->cheeseSprite.width/4);
            chy = 960+cheeseLife->r*1.5;
            [cheeseLife placeAt:CGPointMake(chx, chy)];
        }
        else
            [cheeseLife placeAt:CGPointMake(chx, chy)];
        t0= CGAffineTransformInvert(t0);
        CGContextConcatCTM(context,t0);
        t0 = CGAffineTransformIdentity;

        if (DEBUG)
            NSLog(@"cheeseSprite.y: %f", cheeseLife->cheeseSprite.y);
        
        CGContextConcatCTM(context, t0);
       
        if (screenWidth == 1640 || screenWidth == 1620)
            [cheeseLife draw:context resizeTo:CGSizeMake(1/(2*sx), 1/(2*sy))];
        else if (screenWidth == 1536)
            [cheeseLife draw:context resizeTo:CGSizeMake(1/(2*sx), 1/(2*sy))];
        else
            [cheeseLife draw:context resizeTo:CGSizeMake(1/sx, 1/sy)];
    }
    
    if (screenWidth == 1242 || screenWidth == 1668)
    {
        t0 = CGAffineTransformInvert(t0);
        CGContextConcatCTM(context,t0);
        t0 = CGAffineTransformIdentity;
        t0 = CGAffineTransformTranslate(t0, pauseMenu->x,pauseMenu->y);
        t0 = CGAffineTransformScale(t0, sx, sy);
        t0 = CGAffineTransformTranslate(t0, -pauseMenu->x,
                                        -pauseMenu->y);
        CGContextConcatCTM(context,t0);
    }
    
    for (int i=0; i < coins.count; i++)
    {
        coin = (Coin*)[coins objectAtIndex:i];
       
        t0 = CGAffineTransformInvert(t0);
        CGContextConcatCTM(context,t0);
        t0 = CGAffineTransformIdentity;
        
        t0 = CGAffineTransformTranslate(t0, coin->coinSprite.x,coin->coinSprite.y);
        t0 = CGAffineTransformRotate(t0, M_PI_2);
        t0 = CGAffineTransformTranslate(t0, -coin->coinSprite.x,
                                        -coin->coinSprite.y);
        
        CGContextConcatCTM(context,t0);
       
        [coin draw:context];
        
    }
    
    
    NSString *strScore = [NSString stringWithFormat:@"X%2d", cheese->world->numOfCoins]; //[strLevel stringByAppendingString:curLevel];
   
    
    
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    
    TextSprite *fakeScoreText = [TextSprite withString: strScore];
    fakeScoreText.r = 0;
    fakeScoreText.g = 1.0;
    fakeScoreText.b = 1.0;
    fakeScoreText.y = 0;
    float screenWidth = self.bounds.size.width*screenScale;
    fakeScoreText.x = screenWidth;
    fakeScoreText.fontSize = 24;
    fakeScoreText.visible = false;
    [(TextSprite *) fakeScoreText setFontSize:24];
    [fakeScoreText drawBody:context on:self.bounds];
    int fakeX,fakeY;
    
    fakeX = (screenWidth/sx - fakeScoreText.width*screenScale/sx-coinIcon->coinSprite.width/2/sx);
    fakeY = self.bounds.size.height*screenScale/sy-(fakeScoreText.height*screenScale/sy+5*screenScale);
    //coin = [[[Coin alloc] init] autorelease];
    if (screenWidth == 1668 || screenWidth == 2048 || screenWidth == 1536 || screenWidth == 1620 || screenWidth == 1640)
        fakeX = screenWidth/sx - fakeScoreText.width*screenScale/sx-coinIcon->coinSprite.width/sx;
    int cx = fakeX;
    int cy = fakeY;
    //[coinIcon setX:cx];
    //[coinIcon setY:cy];
    [coinIcon setIconX:cx andY:cy];
    //[coinIcon initializeCoinAtX:cx andY:cy andImage:@"mediumlargecoins.png"];
   
    t0= CGAffineTransformInvert(t0);
    CGContextConcatCTM(context,t0);
    t0 = CGAffineTransformIdentity;

    //if (DEBUG)
      //  NSLog(@"coinSprite.y: %f", coin->coinSprite.y);
    t0= CGAffineTransformTranslate(t0,cx,cy );
    if (screenWidth == 1242)
        t0 = CGAffineTransformScale(t0,1,1);
    else
        t0 = CGAffineTransformScale(t0, 1/screenScale, 1/screenScale);
    
    t0 = CGAffineTransformTranslate(t0, -cx,-cy);
    CGContextConcatCTM(context, t0);
    [coinIcon draw:context];
    
    t0 = CGAffineTransformInvert(t0);
    CGContextConcatCTM(context,t0);
    t0 = CGAffineTransformIdentity;
    t0 = CGAffineTransformTranslate(t0,cx,cy );
    t0 = CGAffineTransformScale(t0, screenScale, screenScale);
    t0 = CGAffineTransformTranslate(t0,-cx,-cy );
    CGContextConcatCTM(context,t0);

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
    
    t0 = CGAffineTransformInvert(t0);
    CGContextConcatCTM(context,t0);
    t0 = CGAffineTransformIdentity;
    CGContextConcatCTM(context,t0);
    [chatBubble draw:context];
    
    float drumTopLeftX = 0;
    float drumTopLeftY = 0;
   // CGContextSaveGState(context);
    for (int i=0; i < drums.count; i++)
    {
         drum = (Drum*)[drums objectAtIndex:i];
         t0 = CGAffineTransformInvert(t0);
         CGContextConcatCTM(context,t0);
         t0 = CGAffineTransformIdentity;
         float drx = drum->x;
         float dry = drum->y;
         t0 = CGAffineTransformTranslate(t0, drx ,dry);
         float newAngle = [drum getAngle]*M_PI/180;
         t0 = CGAffineTransformRotate(t0,newAngle );
         t0 = CGAffineTransformTranslate(t0, -drx ,-dry);
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
   // CGContextRestoreGState(context);
    
    float bombTopLeftX = 0;
    float bombTopLeftY = 0;

    CGFloat green[4] = {0.0f, 1.0f, 0.0f, 1.0f};
    //CGContextSaveGState(context);
    for (int i=0; i < bombs.count; i++)
    {
         bomb = (Bomb*)[bombs objectAtIndex:i];
         t0 = CGAffineTransformInvert(t0);
         CGContextConcatCTM(context,t0);
         t0 = CGAffineTransformIdentity;
         float bx = bomb->x;
         float by = bomb->y;
        
         t0 = CGAffineTransformTranslate(t0, bx ,by);
         float newAngle = [bomb getAngle]*M_PI/180;
         t0 = CGAffineTransformRotate(t0,newAngle );
         t0 = CGAffineTransformTranslate(t0, -bx ,-by);
         CGContextConcatCTM(context,t0);
       
        [bomb draw:context];
        if ((bomb->state == BOMB_EXPLODE || bomb->state == BOMB_GONE) && bomb->lifespan > 0)
        {
            boom->x = boom->boomSprite->x = bx - boom->boomSprite.width/2;
            boom->y = boom->boomSprite->y = by - boom->boomSprite.height/2;
            [boom draw:context];
            
        }
        
        if (DEBUG)
        {
            CGContextBeginPath(context);
            CGContextSetStrokeColor(context, green);
           
            float bombCenterX = bomb->x;
            float bombCenterY = bomb->y;
            CGContextAddArc(context, bombCenterX, bombCenterY, bomb->r, 0, 2*M_PI,YES);
            CGContextStrokePath(context);
        }
    }
   // CGContextRestoreGState(context);
  
    for (int i=0; i < teeterTotters.count; i++)
    {
        teeterTotter = (TeeterTotter*)[teeterTotters objectAtIndex:i];

        t0 = CGAffineTransformInvert(t0);
        CGContextConcatCTM(context,t0);
        t0 = CGAffineTransformIdentity;
      
        float ttx = teeterTotter->x;
        float tty = teeterTotter->y;
        t0 = CGAffineTransformTranslate(t0, ttx,tty );
        t0 = CGAffineTransformRotate(t0,[teeterTotter getAngle]*M_PI/180 );
        t0 = CGAffineTransformTranslate(t0, -ttx,-tty);
                                
        CGContextConcatCTM(context,t0);
        
        [teeterTotter draw:context];
    }
    
    t0 = CGAffineTransformInvert(t0);
    CGContextConcatCTM(context,t0);
    t0 = CGAffineTransformIdentity;
    CGContextConcatCTM(context,t0);
    if (screenWidth == 1242 || screenWidth == 1668 || screenWidth == 2048 || screenWidth == 1536 || screenWidth == 1620 || screenWidth == 1640)
    {
        pauseButton->x = 10;
        pauseButton->y = timerText.y - timerText.height*screenScale;
        [pauseButton draw:context];
        musicButton->x = pauseButton->x + pauseButton->pauseSprite.width*screenScale ;
        if (screenWidth == 1668 || screenWidth == 2048 || screenWidth == 1536)
            musicButton->x = pauseButton->x + pauseButton->pauseSprite.width + 10 ;
        musicButton->y = pauseButton->y;
        [musicButton draw:context];
    }
    else
    {
        pauseButton->x = 10;
        pauseButton->y = timerText.y - timerText.height*screenScale/sy;//960+pauseButton->pauseSprite.height*screenScale;
        [pauseButton draw:context];
        musicButton->x = pauseButton->x + pauseButton->pauseSprite.width*screenScale/sx ;
        musicButton->y = pauseButton->y;
        [musicButton draw:context];
    }
    
    if (DEBUG)
    {
        CGContextSetStrokeColor(context,blue);
        CGContextMoveToPoint(context, pauseButton->x, pauseButton->y);
        CGContextAddLineToPoint(context, pauseButton->x + pauseButton->pauseSprite.width, pauseButton->y);
        CGContextStrokePath(context);
        CGContextMoveToPoint(context, pauseButton->x, pauseButton->y + pauseButton->pauseSprite.height);
        CGContextAddLineToPoint(context, pauseButton->x + pauseButton->pauseSprite.width, pauseButton->y + pauseButton->pauseSprite.height);
        CGContextStrokePath(context);
    }
    // CGContextSaveGState(context);
     CGFloat red[4] = {1.0f, 0.0f, 0.0f, 1.0f};
    
     float flipperTopRightX;
     float flipperTopRightY;
     for (int i=0; i < flippers.count; i++)
     {
         flipper = (Flipper*)[flippers objectAtIndex:i];
        
         t0 = CGAffineTransformInvert(t0);
         CGContextConcatCTM(context,t0);
         t0 = CGAffineTransformIdentity;
         
         float fx = flipper->x;
         float fy = flipper->y;
         t0 = CGAffineTransformTranslate(t0,fx,fy );
         t0 = CGAffineTransformRotate(t0,[flipper getAngle]*M_PI/180 );
         if (flipper->isImgFlipped)
         {
             t0 = CGAffineTransformScale(t0, -1, 1);
         }
         t0 = CGAffineTransformTranslate(t0, -fx, -fy);
         
         CGContextConcatCTM(context,t0);
         [flipper draw:context];
         
         //CGContextSetStrokeColor(context, red);
         //CGContextBeginPath(context);
         double radianAngle = flipper->angle*M_PI/180.0f;
         flipperTopRightX = flipper->x + cos(radianAngle)*flipper->sprite.width/2 + cos(radianAngle+M_PI_2)*flipper->sprite.height/2;
         flipperTopRightY = flipper->y + sin(radianAngle)*flipper->sprite.width/2 + sin(radianAngle+M_PI_2)*flipper->sprite.height/2;
         flipperTopRightX = flipperTopRightX/2.0f;
         flipperTopRightY = self.bounds.size.height - flipperTopRightY/2.0f;
       
     }
   
    //CGContextRestoreGState(context);
    
    if (game_state==GAME_PAUSED)
    {
        t0 = CGAffineTransformInvert(t0);
        CGContextConcatCTM(context,t0);
        t0 = CGAffineTransformIdentity;
        if (screenWidth == 1242 )
        {
            
            t0 = CGAffineTransformTranslate(t0,pauseMenu->x,pauseMenu->y );
            t0 = CGAffineTransformScale(t0, sx, sy);
            t0 = CGAffineTransformTranslate(t0,-pauseMenu->x,-pauseMenu->y );
        
        }
        
        CGContextConcatCTM(context,t0);
        [pauseMenu draw:context];
        if (DEBUG)
        {
            CGRect playRect = CGRectMake(pauseMenu->x, pauseMenu->y + 3/4*pauseMenu->height, pauseMenu->width, pauseMenu->height/4);
            CGContextSetRGBFillColor(context, 1.0, 0.0, 0.0, 1.0);
            CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0);
            CGContextFillRect(context, playRect);
        }
        
    }
    
    CGContextRestoreGState(context);
    
    if (DEBUG)
    {
        CGContextSetStrokeColor(context, black);
        CGContextBeginPath(context);
        NSLog(@"cheese width: %f", cheese->cheeseSprite.width);
        float cheesePtX = cheese->x/screenScale;
        float cheesePtY = self.bounds.size.height - cheese->y/screenScale;
        float cheeseWidth = (cheese->cheeseSprite.width)/2*sx/screenScale;
        float cheeseHeight = (cheese->cheeseSprite.height)/2*sy/screenScale;
        if (screenWidth == 1242 || screenWidth == 1668)
        {
            cheeseWidth = (cheese->cheeseSprite.width)/2/screenScale;
            cheeseHeight = (cheese->cheeseSprite.height)/2/screenScale;
        }
        float cheeseRadius = cheese->r*sy/screenScale;//sqrtf(cheeseWidth*cheeseWidth+cheeseHeight*cheeseHeight);
        if (screenWidth == 1668 || screenWidth == 2048 || screenWidth == 1536 || screenWidth == 1620 || screenWidth == 1640)
            cheeseRadius = cheese->r/screenScale;
        CGContextAddArc( context, cheesePtX,cheesePtY, cheeseRadius, 0, 2*M_PI, YES);
        CGContextStrokePath(context);
    }
    
    float x3, y3;
    float destPtX, destPtY;
    if (DEBUG)
    {
        CGContextSetStrokeColor(context, red);
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, cheese->x/screenScale, self.bounds.size.height - cheese->y/screenScale);
        //printf("cheese: (%f,%f)", cheese->x/2.0f, self.bounds.size.height-cheese->y/2.0f - 17);
        Vector *cheeseVelNormalized = [[Vector alloc] init];
        [cheeseVelNormalized initializeVectorX:cheese->vel->x andY:cheese->vel->y];
        [cheeseVelNormalized normalize];
        
        float x = (cheese->x + cheese->vel->x*cheese->time)/screenScale;
        //float x = (cheese->x + (cheese->vel->x+cheese->acceleration->x)*cheese->time)/2.0f;
        float y = self.bounds.size.height - (cheese->y + cheese->vel->y*cheese->time)/screenScale;
        //float y = self.bounds.size.height - (cheese->y + (cheese->vel->y+cheese->acceleration->y)*cheese->time)/2.0f;
        //float x3 = (cheese->x + 34 * cheeseVelNormalized->x + cheese->vel->x*cheese->time)/screenScale;
        x3 = (cheese->x + cheese->vel->x*interpolation)/screenScale;
        //float x3 = (cheese->x + 34 * cheeseVelNormalized->x + (cheese->vel->x+cheese->acceleration->x)*cheese->time)/2.0f;
        //float y3 = self.bounds.size.height - (cheese->y + 34 *cheeseVelNormalized->y + cheese->vel->y*cheese->time)/screenScale;
        float velYt = cheese->vel->y*interpolation;
        float movedY = cheese->y + velYt;
        y3 = self.bounds.size.height - movedY/screenScale;
        //float y3 = self.bounds.size.height - (cheese->y + 34 *cheeseVelNormalized->y + (cheese->vel->y+cheese->acceleration->y)*cheese->time)/2.0f;
      //  float x3 = cheese->x + 34 * cheeseVelNormalized->x + (cheese->vel->x * time)/2.0f;
       // float y3 = self.bounds.size.height - (cheese->y + time *cheeseVelNormalized->y)/2.0f;
        //float cheeseX = cheese->x;
        //float cheeseY = self.bounds.size.height - cheese->y;

            printf(" move to: (%f,%f)\n", x, y);
        if (!isnan(x3) && !isnan(y3) )
            CGContextAddLineToPoint(context, x3, y3);
        CGContextStrokePath(context);
    }
    
    
    if (DEBUG)
    {
        CGContextSetStrokeColor(context, red);
        CGContextBeginPath(context);
        if (screenWidth == 1242 || screenWidth == 1668 || screenWidth == 2048 || screenWidth == 1536 || screenWidth == 1620 || screenWidth == 1640)
            CGContextAddArc(context, x3, y3, cheese->r/screenScale, 0, 2*M_PI, YES);
        else
            CGContextAddArc(context, x3, y3, cheese->r*sy/screenScale, 0, 2*M_PI, YES);
        
        CGContextStrokePath(context);
    
        CGContextSetStrokeColor(context, blue);
        CGContextBeginPath(context);
        CGContextAddArc(context, mousePt.x, mousePt.y, 5, 0, 2*M_PI, YES);
        CGContextStrokePath(context);
        
        CGContextSetStrokeColor(context, green);
        CGContextBeginPath(context);
        CGContextAddArc(context, drumTopLeftX, drumTopLeftY, 5, 0, 2*M_PI,YES);
        CGContextStrokePath(context);

        CGContextSetStrokeColor(context, red);
        CGContextBeginPath(context);
        float collisionPtX = sx*cheese->colPackage->intersectionPoint->x/screenScale;
        float collisionPtY = self.bounds.size.height - sy*cheese->colPackage->intersectionPoint->y/screenScale;
        CGContextAddArc(context, collisionPtX, collisionPtY, 15, 0, 2*M_PI,YES);
        CGContextStrokePath(context);
        
        destPtX = sx*cheese->destinationPoint->x*cheese->r /screenScale;
        destPtY = self.bounds.size.height - sy*cheese->destinationPoint->y*cheese->r/screenScale;
        CGContextSetStrokeColor(context, blue);
        CGContextBeginPath(context);
        
        CGContextAddArc(context, destPtX, destPtY, 5, 0, 2*M_PI,YES);
        CGContextStrokePath(context);
        
        if (!isnan(cheese->newDestinationPoint->x) || !isnan(cheese->newDestinationPoint->y))
        {
            CGContextSetStrokeColor(context, purple);
            CGContextBeginPath(context);
            float newDestPtX = cheese->newDestinationPoint->x*(cheese->r*sx)/screenScale;
            float newDestPtY = self.bounds.size.height - cheese->newDestinationPoint->y*(cheese->r*sy)/screenScale;
            CGContextAddArc(context, newDestPtX, newDestPtY, 8, 0, 2*M_PI,YES);
            CGContextStrokePath(context);
        }
        
        CGContextSetStrokeColor(context, red);
        CGContextBeginPath(context);
        float closestPtX = (cheese->colPackage->closestPoint->x * (cheese->r*sx))/screenScale;
        float closestPtY = self.bounds.size.height - (cheese->colPackage->closestPoint->y * (cheese->r*sy))/screenScale;
        CGContextAddArc(context, closestPtX, closestPtY, 10, 0, 2*M_PI,YES);
        CGContextStrokePath(context);
       
        CGContextSetStrokeColor(context, green);
        CGContextBeginPath(context);
        float intersectionPtX = cheese->colPackage->intersectionPoint->x /screenScale;
        float intersectionPtY = self.bounds.size.height - cheese->colPackage->intersectionPoint->y /screenScale;
       
        CGContextAddArc(context, intersectionPtX, intersectionPtY, 5, 0, 2*M_PI,YES);
        CGContextStrokePath(context);
    }
    
    if (DEBUG)
    {
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
            x1 = ox*cheese->colPackage->eRadius*sx;
            y1 =oy*cheese->colPackage->eRadius*sy;
            x2 = sy*(cheese->slidingLine->origin->x*cheese->colPackage->eRadius + cheese->slidingLine->normal->x*10*cheese->colPackage->eRadius);
            y2 = sy*(cheese->slidingLine->origin->y*cheese->colPackage->eRadius + cheese->slidingLine->normal->y*10*cheese->colPackage->eRadius);
            if (!isnan(x1) || !isnan(y1))
            {
                CGContextMoveToPoint(context, x1/screenScale,self.bounds.size.height - y1/screenScale);
                CGContextAddLineToPoint(context, x2/screenScale, self.bounds.size.height - y2/screenScale);
                CGContextStrokePath(context);
            }
        }
    }
   
    CGFloat white[4] = {1.0f, 1.0f, 1.0f, 1.0f};
    if (DEBUG)
    {
        // draw black box
        CGContextSetFillColor(context, black);
       // CGContextFillRect(context, CGRectMake( 0,self.bounds.size.height - 960 /34 * 15/2.0f, 640 / 34 * 15 / 2, 960 /34 * 15 /2.0f));
        CGContextFillRect(context, CGRectMake( 0,self.bounds.size.height - sy*(960.0f/34.0f * 10.0f/screenScale),
                                             (640.0f / 34.0f * 10.0f / screenScale)*sx, sy*(960.0f/34.0f * 10.0f /screenScale))) ;
        
       // CGContextFillRect(context, CGRectMake( 0,self.bounds.size.height - sy*(960.0f/cheese->r * 10.0f/screenScale),
         //                                    (640.0f /cheese->r * 10.0f / screenScale)*sx, sy*(960.0f/cheese->r * 10.0f /screenScale))) ;
        
        for (int i = 0; i < [gears count]; i++)
        {
            CGContextSetStrokeColor(context, black);
            CGContextBeginPath(context);
            gear = [gears objectAtIndex:i];
          //  CGContextAddArc(context, gear->pos->x/screenScale*sx, self.bounds.size.height-gear->pos->y/screenScale*sy, gear->r/screenScale*sy , 0, 2*M_PI,YES);
           
            //CGContextStrokePath(context);
            gear = [gears objectAtIndex:i];
            float gearX = 0;
            float gearY = 0;
            float width = 0;
            float height = 0;
            if (screenWidth == 1242)
            {
                gearX = gear->pos->x/screenScale-gear->gearSprite.width/screenScale/2;
                gearY = self.bounds.size.height-gear->pos->y/screenScale - gear->gearSprite.height/screenScale/2;
                width = gear->gearSprite.width/screenScale;
                height = gear->gearSprite.height/screenScale;
            }
            else
            {
                gearX = gear->pos->x/screenScale*sx-gear->gearSprite.width/screenScale*sx/2;
                gearY = self.bounds.size.height-gear->pos->y/screenScale*sy - gear->gearSprite.height/screenScale*sy/2;
                width = gear->gearSprite.width/screenScale*sx;
                height = gear->gearSprite.height/screenScale*sy;
            }
            UIBezierPath *arc = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(gearX, gearY, width, height)];
            [[UIColor blackColor] setStroke];
            [arc stroke];
        }

        for (int i = 0; i < [coins count]; i++)
        {
         
            coin = [coins objectAtIndex:i];
            float coinX = coin->pos->x/screenScale*sx-coin->coinSprite.width/screenScale*sx;
            float coinY = self.bounds.size.height-coin->pos->y/screenScale*sy;// - coin->coinSprite.height/screenScale*sy;
            float width = coin->coinSprite.width/screenScale*sx;
            float height = coin->coinSprite.height/screenScale*sy;
            UIBezierPath *arc = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(coinX, coinY, width, height)];
            [[UIColor blackColor] setStroke];
            [arc stroke];
            
        }
    }
    
    float topLeftX, topLeftY, topRightX, topRightY;
    float bottomLeftX, bottomLeftY, bottomRightX, bottomRightY;
    CGPoint topLeftPt,topRightPt;
    double radAngle;
    
    if (DEBUG)
    {
        for (int i=0; i < [drums count]; i++)
        {
           // CGContextSetStrokeColor(context, blue);
            drum = [drums objectAtIndex:i];
            radAngle = drum->angle*M_PI/180.0f;
            
            topLeftX = drum->x*sx - cos(radAngle)*drum->drumSprite.width/2*sx + cos(radAngle+M_PI_2)*drum->drumSprite.height/2*sx;
            topLeftY = sy*(drum->y - sin(radAngle)*drum->drumSprite.width/2 + sin(radAngle+M_PI_2)*drum->drumSprite.height/2);
            topLeftPt = CGPointMake(topLeftX, topLeftY);
            // get top right of rectangle
            topRightX = sx*(drum->x + cos(radAngle)*drum->drumSprite.width/2 + cos(radAngle+M_PI_2)*drum->drumSprite.height/2);
            topRightY = sy*(drum->y + sin(radAngle)*drum->drumSprite.width/2 + sin(radAngle+M_PI_2)*drum->drumSprite.height/2);
            topRightPt = CGPointMake(topRightX,topRightY);
            
            bottomLeftX = sx * (drum->x - cos(radAngle)*drum->drumSprite.width/2 + cos(radAngle-M_PI_2)*drum->drumSprite.height/2);
            bottomLeftY = sy * (drum->y - sin(radAngle)*drum->drumSprite.width/2 + sin(radAngle-M_PI_2)*drum->drumSprite.height/2);

            bottomRightX = sx * (drum->x + cos(radAngle)*drum->drumSprite.width/2 + cos(radAngle-M_PI_2)*drum->drumSprite.height/2);
            bottomRightY = sy * (drum->y + sin(radAngle)*drum->drumSprite.width/2 + sin(radAngle-M_PI_2)*drum->drumSprite.height/2);
            
            CGContextSetStrokeColor(context, [[UIColor blueColor] CGColor]);
            CGContextSetLineWidth(context, 3.0);
            float tlx = topLeftX/screenScale;
            float tly = self.bounds.size.height - topLeftY/screenScale;
            float trx = topRightX/screenScale;
            float try = self.bounds.size.height - topRightY/screenScale;
            CGContextMoveToPoint(context, topLeftX/screenScale, self.bounds.size.height - topLeftY/screenScale);
            CGContextAddLineToPoint(context,topRightX/screenScale, self.bounds.size.height - topRightY/screenScale);
            CGContextStrokePath(context);
            UIBezierPath *path = [UIBezierPath bezierPath];
            [[UIColor blueColor] setStroke];
            path.lineWidth = 1;
            [path moveToPoint:CGPointMake(tlx, tly)];
            [path addLineToPoint:CGPointMake(trx, try)];
            [path stroke];
            
            
            if (screenWidth == 1242)
            {
                topLeftX = topLeftX/(sx*cheese->r) *(10/screenScale*sx);
                topLeftY = topLeftY/(sy*cheese->r)*(10/screenScale*sy);
                topRightX = topRightX/(sx*cheese->r)*(10/screenScale*sx);
                topRightY = topRightY/(sy*cheese->r)*(10/screenScale*sy);
                
                bottomLeftX = bottomLeftX/(sx*cheese->r)*(10/screenScale*sx);
                bottomLeftY = bottomLeftY/(sy*cheese->r)*(10/screenScale*sy);
                bottomRightX = bottomRightX/(sx*cheese->r)*(10/screenScale*sx);
                bottomRightY = bottomRightY/(sy*cheese->r)*(10/screenScale*sy);
            }
            else
            {
                topLeftX = topLeftX/(sx*34)*(10/screenScale*sx);
                topLeftY = topLeftY/(sy*34)*(10/screenScale*sy);
                topRightX = topRightX/(sx*34)*(10/screenScale*sx);
                topRightY = topRightY/(sy*34)*(10/screenScale*sy);
                
                bottomLeftX = bottomLeftX/(sx*34)*(10/screenScale*sx);
                bottomLeftY = bottomLeftY/(sy*34)*(10/screenScale*sy);
                bottomRightX = bottomRightX/(sx*34)*(10/screenScale*sx);
                bottomRightY = bottomRightY/(sy*34)*(10/screenScale*sy);
            }
            CGContextSetStrokeColor(context, yellow);
            tly = self.bounds.size.height - topLeftY;
            try = self.bounds.size.height - topRightY;
            CGContextMoveToPoint(context, topLeftX, tly);
            CGContextAddLineToPoint(context,topRightX, try );
            CGContextStrokePath(context);
            CGContextMoveToPoint(context, bottomLeftX, self.bounds.size.height - bottomLeftY);
            CGContextAddLineToPoint(context,bottomRightX, self.bounds.size.height - bottomRightY);
            CGContextStrokePath(context);
        }
    }
    
    if (DEBUG)
    {
        for (int i=0; i < [flippers count]; i++)
        {
           // CGContextSetStrokeColor(context, blue);
            flipper = [flippers objectAtIndex:i];
            radAngle = flipper->angle*M_PI/180.0f;
            
            topLeftX = sx * (flipper->x - cos(radAngle)*flipper->sprite.width/2 + cos(radAngle+M_PI_2)*flipper->sprite.height/2);
            topLeftY = sy * (flipper->y - sin(radAngle)*flipper->sprite.width/2 + sin(radAngle+M_PI_2)*flipper->sprite.height/2);
            topLeftPt = CGPointMake(topLeftX, topLeftY);
            // get top right of rectangle
            topRightX = sx*(flipper->x + cos(radAngle)*flipper->sprite.width/2 + cos(radAngle+M_PI_2)*flipper->sprite.height/2);
            topRightY = sy*(flipper->y + sin(radAngle)*flipper->sprite.width/2 + sin(radAngle+M_PI_2)*flipper->sprite.height/2);
            topRightPt = CGPointMake(topRightX,topRightY);
            
            bottomLeftX = sx * (flipper->x - cos(radAngle)*flipper->sprite.width/2 + cos(radAngle-M_PI_2)*flipper->sprite.height/2);
            bottomLeftY = sy * (flipper->y - sin(radAngle)*flipper->sprite.width/2 + sin(radAngle-M_PI_2)*flipper->sprite.height/2);
            
            bottomRightX = sx * (flipper->x + cos(radAngle)*flipper->sprite.width/2 + cos(radAngle-M_PI_2)*flipper->sprite.height/2);
            bottomRightY = sy * (flipper->y + sin(radAngle)*flipper->sprite.width/2 + sin(radAngle-M_PI_2)*flipper->sprite.height/2);
            
            CGContextSetStrokeColor(context, [[UIColor redColor] CGColor]);
            CGContextSetLineWidth(context, 3.0);
            float tlx = topLeftX/screenScale;
            float tly = self.bounds.size.height - topLeftY/screenScale;
            float trx = topRightX/screenScale;
            float try = self.bounds.size.height - topRightY/screenScale;
            UIBezierPath *path = [UIBezierPath bezierPath];
            [[UIColor redColor] setStroke];
            path.lineWidth = 1;
            [path moveToPoint:CGPointMake(tlx, tly)];
            [path addLineToPoint:CGPointMake(trx, try)];
            [path stroke];
            CGContextMoveToPoint(context,tlx ,tly );
            CGContextAddLineToPoint(context, trx, try);
            CGContextDrawPath(context, 2);
            CGContextStrokePath(context);
            CGContextMoveToPoint(context, bottomLeftX/screenScale, self.bounds.size.height - bottomLeftY/screenScale);
            CGContextAddLineToPoint(context,bottomRightX/screenScale, self.bounds.size.height - bottomRightY/screenScale);
            CGContextStrokePath(context);
            
            topLeftX = topLeftX/(sx*34)*(10/screenScale*sx);
            topLeftY = topLeftY/(sy*34)*(10/screenScale*sy);
            topRightX = topRightX/(sx*34)*(10/screenScale*sx);
            topRightY = topRightY/(sy*34)*(10/screenScale*sy);
            
            bottomLeftX = bottomLeftX/(sx*34)*(10/screenScale*sx);
            bottomLeftY = bottomLeftY/(sy*34)*(10/screenScale*sy);
            bottomRightX = bottomRightX/(sx*34)*(10/screenScale*sx);
            bottomRightY = bottomRightY/(sy*34)*(10/screenScale*sy);
            
            CGContextSetStrokeColor(context, yellow);
            CGContextMoveToPoint(context, topLeftX, self.bounds.size.height - topLeftY);
            CGContextAddLineToPoint(context,topRightX, self.bounds.size.height - topRightY);
            CGContextStrokePath(context);
            CGContextMoveToPoint(context, bottomLeftX, self.bounds.size.height - bottomLeftY);
            CGContextAddLineToPoint(context,bottomRightX, self.bounds.size.height - bottomRightY);
            CGContextStrokePath(context);
        }
    }
    
    if (DEBUG)
    {
        for (int i=0; i < [teeterTotters count]; i++)
        {
            teeterTotter = [teeterTotters objectAtIndex:i];
            radAngle = teeterTotter->angle*M_PI/180.0f;
            
            if (screenWidth == 1242)
            {
                topLeftX = teeterTotter->x - cos(radAngle)*teeterTotter->totterSprite.width/2 + cos(radAngle+M_PI_2)*teeterTotter->totterSprite.height/2;
                topLeftY = teeterTotter->y - sin(radAngle)*teeterTotter->totterSprite.width/2 + sin(radAngle+M_PI_2)*teeterTotter->totterSprite.height/2;
                topLeftPt = CGPointMake(topLeftX, topLeftY);
                // get top right of rectangle
                topRightX =  (teeterTotter->x + cos(radAngle)*teeterTotter->totterSprite.width/2 + cos(radAngle+M_PI_2)*teeterTotter->totterSprite.height/2);
                topRightY =  (teeterTotter->y + sin(radAngle)*teeterTotter->totterSprite.width/2 + sin(radAngle+M_PI_2)*teeterTotter->totterSprite.height/2);
                topRightPt = CGPointMake(topRightX,topRightY);
            }
            else
            {
                topLeftX = teeterTotter->x*sx - cos(radAngle)*teeterTotter->totterSprite.width/2*sx + cos(radAngle+M_PI_2)*teeterTotter->totterSprite.height/2*sx;
                topLeftY = teeterTotter->y*sy - sin(radAngle)*teeterTotter->totterSprite.width/2*sy + sin(radAngle+M_PI_2)*teeterTotter->totterSprite.height/2*sy;
                topLeftPt = CGPointMake(topLeftX, topLeftY);
                // get top right of rectangle
                topRightX = sx * (teeterTotter->x + cos(radAngle)*teeterTotter->totterSprite.width/2 + cos(radAngle+M_PI_2)*teeterTotter->totterSprite.height/2);
                topRightY = sy * (teeterTotter->y + sin(radAngle)*teeterTotter->totterSprite.width/2 + sin(radAngle+M_PI_2)*teeterTotter->totterSprite.height/2);
                topRightPt = CGPointMake(topRightX,topRightY);
            }
            
            float tlx = topLeftX/screenScale;
            float tly = self.bounds.size.height - topLeftY/screenScale;
            float trx = topRightX/screenScale;
            float try = self.bounds.size.height - topRightY/screenScale;
            UIBezierPath *path = [UIBezierPath bezierPath];
            [[UIColor yellowColor] setStroke];
            path.lineWidth = 1;
            CGContextSetStrokeColor(context, yellow);
            [path moveToPoint:CGPointMake(tlx, tly)];
            [path addLineToPoint:CGPointMake(trx, try)];
            [path stroke];
            CGContextMoveToPoint(context, bottomLeftX/screenScale, self.bounds.size.height - bottomLeftY/screenScale);
            CGContextAddLineToPoint(context,bottomRightX/screenScale, self.bounds.size.height - bottomRightY/screenScale);
                   CGContextStrokePath(context);
            CGContextMoveToPoint(context, topLeftX/screenScale, self.bounds.size.height - topLeftY/screenScale);
            CGContextAddLineToPoint(context,topRightX/screenScale, self.bounds.size.height - topRightY/screenScale);
            CGContextStrokePath(context);

            topLeftX = topLeftX/(sx*34)*(10/screenScale*sx);
            topLeftY = topLeftY/(sy*34)*(10/screenScale*sy);
            topRightX = topRightX/(sx*34)*(10/screenScale*sx);
            topRightY = topRightY/(sy*34)*(10/screenScale*sy);

            CGContextSetStrokeColor(context, yellow);
            CGContextMoveToPoint(context, topLeftX, self.bounds.size.height - topLeftY);
            CGContextAddLineToPoint(context,topRightX, self.bounds.size.height - topRightY);
            CGContextStrokePath(context);
        }
    }
    
    if (DEBUG)
    {
         CGContextSetStrokeColor(context, yellow);
       // CGContextBeginPath(context);
        float cheeseX, cheeseY, cheeseX2, cheeseY2;
        float x1 = cheese->x / (34.0f*sx);
        cheeseX = x1 * (10.0f/screenScale * sx);
        float y1 =  cheese->y / (34.0f*sy);
        cheeseY = y1 * (10.0f/screenScale * sy);
     
        float vtx = cheese->vel->x*cheese->time;//(cheese->vel->x+cheese->acceleration->x)*cheese->time;
        if (cheese->colPackage->foundCollision)
        {
            if (cheese->colPackage->state == COLLISION_BOUNCE && cheese->y > 0)
                vtx = cheese->prevVelocity->x*cheese->time;
        }
        float x2t = cheese->x + vtx;
        cheeseX2 = ( x2t / (34.0f*sx)) * (10.0f/screenScale*sx);
        float vty = cheese->vel->y*cheese->time;//(cheese->vel->y+cheese->acceleration->y)*cheese->time;
        if (cheese->colPackage->foundCollision)
        {
            if (cheese->colPackage->state == COLLISION_BOUNCE && cheese->y > 0)
                vty= cheese->prevVelocity->y*cheese->time;
        }
        float y2t = cheese->y + vty;
       // float dist = y2t - cheese->y;
       // NSLog(@"cheese->y: %d", cheese->y);
      //  NSLog(@"cheese->y +vt: %f", y2t);
       // NSLog(@"dist: %f", dist);
        cheeseY2 = (y2t / (34.0f * sy))* (10.0f/screenScale*sy);
        //float distance = cheeseY2 - cheeseY;
     //   NSLog(@"cheeseY: %f", cheeseY);
      //  NSLog(@"cheeseY2: %f", cheeseY2);
      //  NSLog(@"distance: %f",distance);
       // CGContextSetFillColor(context, white);
        float finalY = [self bounds].size.height - cheeseY;
        float finalX = cheeseX ;
            
        if (DEBUG)
        {
            NSLog(@"finalX: %f", finalX);
            NSLog(@"finalY: %f", finalY);
        }
        CGContextMoveToPoint(context, finalX, finalY);
        float x2 = cheeseX2;// /screenScale;
       // NSLog(@"height: %f", [self bounds].size.height);

        float finalY2 = [self bounds].size.height - cheeseY2;// / screenScale;
      //  NSLog(@"finalX2: %f", x2);
       // NSLog(@"finalY2: %f", finalY2);
        
       // CGContextAddLineToPoint(context, x2 , finalY2); // add 1 cuz too tiny
        //CGContextFillRect(context,CGRectMake(cheeseX / 2.0f,self.bounds.size.height - cheeseY/2.0f,1,1));
       // CGContextStrokePath(context);
        CGContextBeginPath(context);
        float basePtX = 0;
        float basePtY = 0;
        if (screenWidth == 1242 || screenWidth == 1668)
        {
            basePtX = cheese->colPackage->basePoint->x * (cheese->r/screenScale);
            basePtY = [self bounds].size.height - cheese->colPackage->basePoint->y * (cheese->r/screenScale);
            CGContextAddArc(context,x2 , finalY2, 10/screenScale*sy, 0, 2*M_PI, YES);
        }
        else
        {
            basePtX = cheese->colPackage->basePoint->x * (cheese->r/screenScale*sx);
            basePtY = [self bounds].size.height - cheese->colPackage->basePoint->y * (cheese->r/screenScale*sy);
            CGContextAddArc(context,x2 , finalY2, cheese->r/(34 * sy), 0, 2*M_PI, YES);
            //CGContextAddArc(context,x2 , finalY2, cheese->r/(screenScale * sy), 0, 2*M_PI, YES);
        }
        
        CGContextStrokePath(context);
        
        CGContextSetStrokeColor(context, white);
        float destX, destY;
        x1 = cheese->destinationPoint->x;
        destX = x1 * 10.0f/screenScale*sx;
        y1 = cheese->destinationPoint->y;
        destY = y1 * 10.0f/screenScale*sy;
     
        finalY = [self bounds].size.height - destY / screenScale;
        finalX = destX / screenScale;
       
        CGContextMoveToPoint(context, finalX, finalY);
        
        float finalX2 = finalX - 3;
        finalY2 = finalY;

        CGContextAddLineToPoint(context, finalX2 , finalY2); // add 1 cuz too tiny
        CGContextFillRect(context,CGRectMake(cheeseX / 2.0f,self.bounds.size.height - cheeseY/2.0f,1,1));
        CGContextStrokePath(context);
        
        CGContextSetStrokeColor(context, white);
        float newDestX, newDestY;
        if (!isnan(cheese->newDestinationPoint->x) || !isnan(cheese->newDestinationPoint->y))
        {
            x1 = cheese->newDestinationPoint->x;
            newDestX = x1 * 10.0f/screenScale * sx;
            y1 = cheese->newDestinationPoint->y;
            newDestY = y1 * 10.0/screenScale * sy;
            
            finalY = [self bounds].size.height - newDestY / screenScale;
            finalX = newDestX / screenScale;
            
            CGContextMoveToPoint(context, finalX, finalY);
            
            finalX2 = finalX - 3;
            finalY2 = finalY;
            
            CGContextAddLineToPoint(context, finalX2 , finalY2); // add 1 cuz too tiny
            CGContextFillRect(context,CGRectMake(cheeseX / 2.0f,self.bounds.size.height - cheeseY/2.0f,1,1));
            CGContextStrokePath(context);
        }
        
        
        CGContextSetStrokeColor(context, purple);
        float sourceX = cheese->x / screenScale;
        float sourceY = [self bounds].size.height - cheese->y/screenScale;
        
        CGContextMoveToPoint(context,sourceX , sourceY);

        float destinationPtX = cheese->destinationPoint->x * 34.0f*sx;
        float destinationPtY = cheese->destinationPoint->y * 34.0f*sy;
        
        float finalY3 = [self bounds].size.height - destinationPtY / screenScale;
        float finalX3 = destinationPtX / screenScale;

        CGContextAddLineToPoint(context, finalX3 , finalY3);
        
        CGContextStrokePath(context);
        
           
        CGContextSetStrokeColor(context, black);
       // float sourceX2 = cheese->x / screenScale;
        //float sourceY2 = [self bounds].size.height - cheese->y/screenScale;
        CGContextMoveToPoint(context,destPtX , destPtY);

        float newDestinationX = 0.0f;
        float newDestinationY = 0.0f;

        if (!isnan(cheese->newDestinationPoint->x) || !isnan(cheese->newDestinationPoint->y))
        {
            newDestinationX = cheese->newDestinationPoint->x * 34.0f*sx;
            newDestinationY = cheese->newDestinationPoint->y * 34.0f*sy;
            
            float finalY4 = [self bounds].size.height - newDestinationY / screenScale;
            float finalX4 = newDestinationX / screenScale;

           // CGContextAddLineToPoint(context, finalX4 , finalY4);
            //CGContextFillRect(context,CGRectMake(cheeseX / 2.0f,self.bounds.size.height - cheeseY/2.0f,1,1));
            //CGContextStrokePath(context);
             //CGContextMoveToPoint(context, mouse->mouseSprite->x, mouse->mouseSprite->y);
           // CGContextFillRect(context, CGRectMake( 0,self.bounds.size.height - 960*sy /(34*sy) * 15/2.0f*sy, 640*sx / (34*sx) * 15 / 2*sx, 960*sy /(34*sy) * 15 /2.0f*sy));
        }
        
        float mouseX = sx* (mouse->mouseSprite->x-mouse->mouseSprite->width/2)/screenScale;
        float mouseY = self.bounds.size.height - sy*(mouse->mouseSprite->y+mouse->mouseSprite->height/2)/screenScale;
        CGRect mouseRect = CGRectMake(mouseX, mouseY,
                                      mouse->mouseSprite->width*sx/screenScale, self.bounds.size.height - mouse->mouseSprite->height*sy/screenScale);
        CGContextAddRect(context, mouseRect);
        CGContextStrokePath(context);
    }
   
    CGContextSaveGState(context);
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGFloat screenScale = [[UIScreen mainScreen] scale];
    NSString *strLevel = [NSString stringWithFormat:@"Level %d", curLevel->num];
    TextSprite *fakeLevelText = [TextSprite withString: strLevel];
    fakeLevelText.r = 0;
    fakeLevelText.g = 1.0;
    fakeLevelText.b = 1.0;
    fakeLevelText.x = screenWidth;
    fakeLevelText.y = self.bounds.size.height*screenScale/sy-fakeLevelText.height*screenScale/sy-15*screenScale;
    if (screenWidth == 1242)
        fakeLevelText.y = self.bounds.size.height*screenScale - 136;
    [(TextSprite *) fakeLevelText setFontSize:24];
    [fakeLevelText drawBody:context on:self.bounds];
    CGContextRestoreGState(context);
    
    CGContextSaveGState(context);
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    screenScale = [[UIScreen mainScreen] scale];
    strLevel = [NSString stringWithFormat:@"Level %d", curLevel->num]; //[strLevel stringByAppendingString:curLevel];
    TextSprite *levelText = [TextSprite withString: strLevel];
    levelText.r = 0;
    levelText.g = 1.0;
    levelText.b = 1.0;
    levelText.x = 10;
    levelText.y = self.bounds.size.height*screenScale/sy-fakeLevelText.height*screenScale/sy-10*screenScale;
    if (screenWidth == 1242)
        levelText.y = self.bounds.size.height*screenScale - fakeLevelText.height*screenScale - 20*screenScale ;//136;
    levelText.fontSize = 24;
    [(TextSprite *) levelText setFontSize:24];
    [levelText drawBody:context on:self.bounds];
    CGContextRestoreGState(context);
    
    CGContextSaveGState(context);
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    screenScale = [[UIScreen mainScreen] scale];
    int secs = (int)total_time%60;
    NSString *strTimer = [NSString stringWithFormat:@"%d:%02d",(int)total_time/60,secs]; //[strLevel stringByAppendingString:curLevel];
    timerText = [TextSprite withString: strTimer];
    timerText.r = 0;
    timerText.g = 1.0;
    timerText.b = 1.0;
    timerText.x = 10;
    timerText.y = levelText.y - levelText.height*screenScale/sy;//self.bounds.size.height*screenScale/sy-2*(fakeLevelText.height*screenScale/sy-10*screenScale);
    if (screenWidth == 1242)
        timerText.y = levelText.y - levelText.height*screenScale;//self.bounds.size.height*screenScale - 136;
    timerText.fontSize = 24;
    [(TextSprite *) timerText setFontSize:24];
    [timerText drawBody:context on:self.bounds];
    CGContextRestoreGState(context);
    
    if (message != @"")
    {
        CGContextSaveGState(context);
        CGContextSetTextMatrix(context, CGAffineTransformIdentity);
        TextSprite *fakeTouchText = [TextSprite withString:message];
        fakeTouchText.x = screenWidth;
        fakeTouchText.y = 1000;
        if (screenWidth == 1242)
            fakeTouchText.y = self.bounds.size.height*screenScale - 136;
        [(TextSprite *) fakeTouchText setFontSize:24];
        [fakeTouchText drawBody:context on:self.bounds];
        CGContextRestoreGState(context);
        
        CGContextSaveGState(context);
        CGContextSetTextMatrix(context, CGAffineTransformIdentity);
        TextSprite *touchText = [TextSprite withString:message];
        touchText.x = 320 - fakeTouchText.width/2*screenScale/sx;
        touchText.y = self.bounds.size.height*screenScale/sy-fakeTouchText.height*screenScale/sy-30*screenScale;
        if (screenWidth == 1242)
        {
            touchText.x = self.bounds.size.width*screenScale/2 - fakeTouchText.width/2*screenScale;
            touchText.y = self.bounds.size.height*screenScale-fakeTouchText.height*screenScale-30*screenScale;
        }
        //if (currentLevelNumber == 1 || currentLevelNumber == 6)
           // touchText.y = self.bounds.size.height*screenScale/2-fakeTouchText.height*screenScale;
            
        [(TextSprite *) touchText setFontSize:24];
        
        [touchText drawBody:context on:self.bounds];

        CGContextRestoreGState(context);
    }
    
    if (game_state == GAME_OVER)
    {
        CGContextSaveGState(context);
        CGContextSetTextMatrix(context, CGAffineTransformIdentity);
        TextSprite *fakeGameOverText = [TextSprite withString:@"GAME OVER"];
        fakeGameOverText.x = screenWidth;
        fakeGameOverText.y = 1000;
        if (screenWidth == 1242)
            fakeGameOverText.y = self.bounds.size.height*screenScale - 136;
        [(TextSprite *) fakeGameOverText setFontSize:48];
        [fakeGameOverText drawBody:context on:self.bounds];
        CGContextRestoreGState(context);
        
        CGContextSaveGState(context);
        CGContextSetTextMatrix(context, CGAffineTransformIdentity);
        TextSprite *txtGameOver = [TextSprite withString:@"GAME OVER"];
        txtGameOver.x = 320 - fakeGameOverText.width/2*screenScale/sx;
        txtGameOver.y = self.bounds.size.height/2*screenScale/sy+fakeGameOverText.height*screenScale/sy;
        if (screenWidth == 1242)
        {
            txtGameOver.x = self.bounds.size.width*screenScale/2 - fakeGameOverText.width/2*screenScale;
            txtGameOver.y = self.bounds.size.height*screenScale/2+fakeGameOverText.height/2*screenScale;
        }
        [(TextSprite *) txtGameOver setFontSize:48];
        [txtGameOver drawBody:context on:self.bounds];
        CGContextRestoreGState(context);
    }
    else if (game_state == GAME_CONTINUE)
    {
        CGContextSaveGState(context);
        CGContextSetTextMatrix(context, CGAffineTransformIdentity);
        TextSprite *fakeContinueText = [TextSprite withString:@"CONTINUE"];
        fakeContinueText.x = screenWidth;
        fakeContinueText.y = 1000;
        if (screenWidth == 1242)
            fakeContinueText.y = self.bounds.size.height*screenScale - 136;
        [(TextSprite *) fakeContinueText setFontSize:48];
        [fakeContinueText drawBody:context on:self.bounds];
        CGContextRestoreGState(context);
        
        CGContextSaveGState(context);
        CGContextSetTextMatrix(context, CGAffineTransformIdentity);
        TextSprite *continueText = [TextSprite withString:@"CONTINUE"];
        continueText.x = 320 - fakeContinueText.width/2*screenScale/sx;
        continueText.y = self.bounds.size.height/2*screenScale/sy+fakeContinueText.height*screenScale/sy;
        if (screenWidth == 1242)
        {
            continueText.x = self.bounds.size.width*screenScale/2 - fakeContinueText.width/2*screenScale;
            continueText.y = self.bounds.size.height*screenScale/2+fakeContinueText.height/2*screenScale;
        }
        [(TextSprite *) continueText setFontSize:48];
        [continueText drawBody:context on:self.bounds];
        CGContextRestoreGState(context);
        
        CGContextSaveGState(context);
        CGContextSetTextMatrix(context, CGAffineTransformIdentity);
        TextSprite *fakeYesText = [TextSprite withString:@"YES"];
        fakeYesText.x = screenWidth;
        fakeYesText.y = 1000;
        if (screenWidth == 1242)
            fakeYesText.y = self.bounds.size.height*screenScale - 136;
        [(TextSprite *) fakeYesText setFontSize:32];
        [fakeYesText drawBody:context on:self.bounds];
        CGContextRestoreGState(context);
        
        CGContextSaveGState(context);
        CGContextSetTextMatrix(context, CGAffineTransformIdentity);
        TextSprite *fakeNoText = [TextSprite withString:@"NO"];
        fakeNoText.x = screenWidth;
        fakeNoText.y = 1000;
        if (screenWidth == 1242)
            fakeNoText.y = self.bounds.size.height*screenScale - 136;
        [(TextSprite *) fakeYesText setFontSize:32];
        [fakeNoText drawBody:context on:self.bounds];
        CGContextRestoreGState(context);
        
        CGContextSaveGState(context);
        CGContextSetTextMatrix(context, CGAffineTransformIdentity);
        yesText = [TextSprite withString:@"YES"];
        yesText.x = 320/2 + 64 - fakeYesText.width/2*screenScale/sx;
        yesText.y = self.bounds.size.height/2*screenScale/sy-fakeYesText.height*screenScale/sy;
        //float xVal = yesText.x*sx/(self.bounds.size.width*screenScale);
        //xVal = xVal/(self.bounds.size.width*screenScale);
        float xYesVal = self.bounds.size.width/4 + self.bounds.size.width/10 - fakeYesText.width/2 - fakeYesText.width/4;
        float yYesVal = self.bounds.size.height/2 + fakeYesText.height/2 - fakeYesText.height/4;
        float xNoVal = self.bounds.size.width/4 + self.bounds.size.width/2 - self.bounds.size.width/10 - fakeNoText.width/2 - fakeNoText.width/4;
        if (screenWidth == 2048 )
            xNoVal =self.bounds.size.width/4 + self.bounds.size.width/2 - self.bounds.size.width/10;
        float yNoVal = yYesVal;
        CGContextSetFillColor(context,black);
        
        if (screenWidth == 1242)
        {
            yesText.x = (self.bounds.size.width*screenScale/4) - fakeYesText.width/2*screenScale;
            yesText.y = self.bounds.size.height*screenScale/2 - fakeYesText.height/2*screenScale;
            yYesVal -= fakeYesText.height/2;
            yNoVal = yYesVal;
        }
        CGRect yesRect = CGRectMake(xYesVal, yYesVal, fakeYesText.width, fakeYesText.height);
        CGContextFillRect(context, yesRect);
        CGRect noRect = CGRectMake(xNoVal, yNoVal, fakeYesText.width, fakeYesText.height);
        CGContextFillRect(context, noRect);
        [(TextSprite *) continueText setFontSize:32];
        yesText->color = [UIColor whiteColor];
        [yesText drawBody:context on:self.bounds];
        CGContextRestoreGState(context);
        
        CGContextSaveGState(context);
        CGContextSetTextMatrix(context, CGAffineTransformIdentity);
        noText = [TextSprite withString:@"NO"];
        noText.x = 480 - 40 - fakeNoText.width/2*screenScale/sx;
        noText.y = yesText.y;
        if (screenWidth == 1242 )
        {
            noText.x = 3*(self.bounds.size.width*screenScale/4) - fakeNoText.width/2;
        }
        else if (screenWidth == 1640 || screenWidth == 1620 || screenWidth == 1668)
        {
            noText.x = 480 - 55 - fakeNoText.width/2*screenScale/sx;
        }
       
        [(TextSprite *) continueText setFontSize:24];
        noText->color = [UIColor whiteColor];
        [noText drawBody:context on:self.bounds];
        CGContextRestoreGState(context);
    }
    
    
    CGContextSaveGState(context);
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
   
    TextSprite *scoreText = [TextSprite withString: strScore];
    scoreText.r = 0;
    scoreText.g = 1.0;
    scoreText.b = 1.0;
    
    scoreText.y = levelText.y;
    
    scoreText.fontSize = 24;
    [(TextSprite *) scoreText setFontSize:24];
    
    if (screenWidth == 1242 || screenWidth == 640)
        scoreText.x = (screenWidth - fakeScoreText.width*screenScale-10);
    else
    {
        //scoreText.x = (screenWidth - fakeScoreText.width)/screenScale;
        scoreText.x = (self.bounds.size.width - fakeScoreText.width)*screenScale/sx-10;
    }

    [scoreText drawBody:context on:self.bounds];
    CGContextRestoreGState(context);
    
    
    for (int i = 0; i < [cheese->world->removedCoins count]; i++)
    {
        CGContextSaveGState(context);
        coin = [cheese->world->removedCoins objectAtIndex:i];
        CGFloat screenScale = [[UIScreen mainScreen] scale];

        NSString *strCoin = [NSString stringWithFormat:@"+%d", 1]; //[strLevel stringByAppendingString:curLevel];
        TextSprite *coinText = [TextSprite withString: strCoin];
        coinText.r = 0;
        coinText.g = 1.0;
        coinText.b = 1.0;
        coinText.x = coin->x;//*sx+coin->coinSprite.width/2*sx;
        coinText.y = coin->y+coin->coinSprite.height;//*sy+coin->coinSprite.height*sy;
        coinText->color =  [UIColor orangeColor].CGColor;
        [(TextSprite *) coinText setFontSize:36];
        [coinText drawBody:context on:self.bounds];
        CGContextRestoreGState(context);
        
    }
   
   
}

- (void) update_game
{
    
    coins = [curLevel getCoins];
    if ([mouse isDoneChewing] && [coins count] <= 0)
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
        bombs = [curLevel getBombs];
        //printf("drums count: %d\n", drums.count);
        teeterTotters = [curLevel getTeeterTotters];
        
        if ([gears count] > 0)
        {
            NSString *pathForGearSoundFile = [[NSBundle mainBundle] pathForResource:@"sounds/Gear_Turning" ofType:@"mp3"];
            [cheese->world->sndMan playLoopedSound:pathForGearSoundFile];
        }
        
        if ([cheese->prevVelocities count] > 0)
            [cheese->prevVelocities removeAllObjects];
         for (int i=0; i < [teeterTotters count]; i++)
         {
             [cheese->prevVelocities addObject:[[Vector alloc] init]];
         }
        for (int i=0; i < [cheese->prevVelocities count]; i++)
        {
            [cheese->prevVelocities[i] initializeVectorX:0 andY:0];
        }
        
        flippers = [curLevel getFlippers];

        NSString *backgroundFilename;
        if (screenWidth == 1242)
        {
            backgroundFilename = [[NSString alloc] initWithString:@"big_"];
            backgroundFilename = [backgroundFilename stringByAppendingString:curLevel->backgroundFilename];
            backgroundFilename = [backgroundFilename stringByDeletingPathExtension];
            backgroundFilename = [backgroundFilename stringByAppendingString:@".jpg"];
        }
        else
        {
            backgroundFilename = [[NSString alloc] initWithString:curLevel->backgroundFilename];
        }
        backgroundSprite = [Picture fromFile:backgroundFilename];
        struct vImage_Buffer buf;
       
        CGImageRef bgImageRef = backgroundSprite->image;

        vImage_CGImageFormat format = {
            .bitsPerComponent = 8,
            .bitsPerPixel = 32,
            .colorSpace = NULL,
            // requests a BGRA buffer.
            .bitmapInfo = kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little,
            .version = 0,
            .decode = NULL,
            .renderingIntent = kCGRenderingIntentDefault
        };
        
        long error = vImageBuffer_InitWithCGImage(&buf, &format, NULL, bgImageRef, kvImageNoFlags);
        if (error != kvImageNoError)
            NSLog(@"Failed to put background image into buffer");
        backgroundSprite->image = vImageCreateCGImageFromBuffer(&buf, &format, NULL, NULL, kvImageNoFlags, &error);
        
        [cheese->world->removedCoins removeAllObjects];
        //message = @"Tap Here To Start";
       /* if (currentLevelNumber == 1)
            message = @"Tap Gears to Rotate Other Way";
        else if (currentLevelNumber == 6)
            message = @"Tap Flippers to Rotate";*/
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
        if ([gear pointIsInside:mouseTouchedPoint] && isTouched)
        {
            mouseTouchedPoint = CGPointMake(0, 0);
            if ([gear isRotatingClockwise])
                [gear rotateCounterClockWise];
            else
                [gear rotateClockWise];
        }
        if ([gear isRotatingClockwise])
            [gear rotateClockWise];
        else
            [gear rotateCounterClockWise];
    }
    for (int i=0; i < [drums count]; i++)
    {
        drum = (Drum*)[drums objectAtIndex:i];
        [drum update];
    }
    for (int i=0; i < [bombs count]; i++)
    {
        bomb = (Bomb*)[bombs objectAtIndex:i];
        [bomb update];
        if (bomb->frame >= BOMB_FRAMES-1)
        {
            if (cheese->numOfLives <= 0)
            {
                //[InneractiveAd DisplayAd:@"test" withType:IaAdType_Banner withRoot:self.view withReload:60];
                if (cheese->world->numOfCoins < 5)
                {
                    game_state = GAME_OVER;
                   
                }
                else
                    game_state = GAME_CONTINUE;
            }
        }
        
    }
    for (int i=0; i < [teeterTotters count]; i++)
    {
        teeterTotter = (TeeterTotter*)[teeterTotters objectAtIndex:i];
        [teeterTotter update];
    }
    
    for (int i=0; i < [flippers count]; i++)
    {
        flipper = (Flipper*)[flippers objectAtIndex:i];
        flipper->sx = sx;
        flipper->sy = sy;

        if ([flipper pointIsInside:mouseTouchedPoint] && isTouched)
            [flipper rotate];
        else
            [flipper unrotate];
        
    }
    for (int i=0; i < [coins count]; i++)
    {
        coin = (Coin*)[coins objectAtIndex:i];
        [coin update];
    }
    for (int i=0; i < [cheese->world->removedCoins count]; i++)
    {
        coin = (Coin*)[cheese->world->removedCoins objectAtIndex:i];
        coin->lifespan -= interpolation;
        coin->y+=1;
        if (coin->lifespan <0)
            [cheese->world->removedCoins removeObjectAtIndex:i];
    }
    [mouse update];
}


    
- (void) gameLoop
{
    if (game_is_running) {
        
        loops = 0;
        if (DEBUG)
        {
            printf("delta_tick: %f\n",delta_tick);
            NSLog(@"next_tick: %f", next_tick);
            NSLog(@"cur_game_tick: %f", cur_game_tick);
            NSLog(@"SKIP_TICKS: %f", SKIP_TICKS);
            NSLog(@"interpolation: %f", interpolation);
        }
        loops = 0;
        delta_tick = -[lastDate timeIntervalSinceNow] - cur_game_tick;
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
        interpolation = (cur_game_tick + SKIP_TICKS - next_game_tick) / SKIP_TICKS;
        
        if (interpolation > MAX_FRAMESKIP*SKIP_TICKS)
        {
           interpolation = MAX_FRAMESKIP*SKIP_TICKS;
        }
        else if (interpolation < SKIP_TICKS)
        {
            interpolation = SKIP_TICKS;
        }
       
        next_game_tick = cur_game_tick;
        if ( game_state == GAME_RUNNING)
        {
            if (delta_tick > 0)
                total_time+= delta_tick;
            if (DEBUG)
                printf("interp: %f\n", interpolation);
            if (cheese->colPackage->state!=COLLISION_EXPLODE)
            {
                [cheese collideAndSlide:interpolation];
            }
            if (cheese->colPackage->state==COLLISION_EXPLODE)
            {
                cheese->x = -cheese->cheeseSprite.width*sx*screenScale;
                cheese->pos->x = cheese->x;
                cheese->y = -cheese->cheeseSprite.height*sy*screenScale;
                cheese->pos->y = cheese->y;                
            }
            else
            {
                [cheese fall:interpolation];
            }
        }
        [self display_game];
       
        if (currentLevelNumber >= [levels count])
        {
            TitleViewController *titleViewController = (TitleViewController*)[UIApplication sharedApplication].keyWindow.rootViewController;
            NSString *playerName = titleViewController.playerNameTextField.text;
            //UIViewController *titleViewController = [[TitleViewController alloc] initWithNibName:@"TitleViewController" bundle:[NSBundle mainBundle]];
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            [musicPlayer stop];
            UIViewController *viewController = [sb instantiateViewControllerWithIdentifier:@"FinishGameViewController"];
            FinishGameViewController *finishController = (FinishGameViewController*) viewController;
            finishController->playerName = playerName;
            finishController->score = cheese->world->numOfCoins;
            finishController->total_time = total_time;
            NSString *strScore = [[NSString alloc] initWithFormat:@"Score: %d",finishController->scores[0]];
           
            [titleViewController.view addSubview:finishController.view];
            titleViewController.playerNameTextField.hidden = false;
           
            [timer invalidate];
            timer = nil;

           [self removeFromSuperview];
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

/*- (void)touchesMoved:(NSSet *)touches withEvent:( UIEvent *)event
{
    
}*/
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    double leftLimit = 0;
    double rightLimit = 0;
    if (screenWidth == 1242 || screenWidth == 1668 || screenWidth == 2048 || screenWidth == 1536 || screenWidth == 1620 || screenWidth == 1640)
    {
        leftLimit = cheese->cheeseSprite->width/2;
        rightLimit = screenWidth - cheese->cheeseSprite->width/2;
    }
    else
    {
        leftLimit = sx * (cheese->cheeseSprite->width/2);
        rightLimit = screenWidth*sx - cheese->cheeseSprite->width/2;
    }
    animationNumber = (animationNumber+1)%4;
    isTouched = true;
    UITouch *touch = [[event allTouches] anyObject];
    float touchX = [touch locationInView:touch.view].x;
    float touchY = [touch locationInView:touch.view].y;
    mousePt = CGPointMake(touchX, touchY);
    CGPoint touchPt = CGPointMake(touchX*screenScale,touchY*screenScale);
    //CGRect screenBounds = [[UIScreen mainScreen] bounds];
    //float sx = screenBounds.size.width/640.0f;
    sx = screenWidth/640.0f;
    sy = screenHeight/1136.0f;
    float x = touchX * screenScale ;
    float y = 1136*sy-touchY*screenScale;
    if (screenWidth == 1242)
    {
        y = 2688 - touchY*screenScale;
    }
    tapPoint = CGPointMake(x, y);
    if (x > rightLimit)
        x = rightLimit;
    else if (x < leftLimit)
        x = leftLimit+1;
    CGPoint pt = CGPointMake(x,y);
    mouseTouchedPoint = pt;
    //printf("drop (x,y): (%f, %f)\n",pt.x,pt.y);
    bool found = false;
    if (game_state != GAME_PAUSED && game_state != GAME_CONTINUE)
    {
        for (int i=0; i < [flippers count]; i++)
        {
            flipper = (Flipper*)[flippers objectAtIndex:i];
            flipper->sx = sx;
            flipper->sy = sy;

            if ([flipper pointIsInside:mouseTouchedPoint])
                found = true;
        }
        for (int i=0; i < [gears count]; i++)
        {
            gear = (Gear*)[gears objectAtIndex:i];
            gear->sx = sx;
            gear->sy = sy;

            if ([gear pointIsInside:mouseTouchedPoint])
            {
                found = true;
                //NSString *pathForGearSoundFile = [[NSBundle mainBundle] pathForResource:@"sounds/Gear_Turning" ofType:@"mp3"];
               // [sndMan playSound:pathForGearSoundFile];
            }
        }
    }
    for (int i=0; i < [teeterTotters count]; i++)
    {
        teeterTotter = (TeeterTotter*)[teeterTotters objectAtIndex:i];
        teeterTotter->reset = true;
    }
    
    if (!found)
    {
        
        TitleViewController *titleViewController = (TitleViewController*)[UIApplication sharedApplication].keyWindow.rootViewController;
        NSString *playerName = titleViewController.playerNameTextField.text;
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        screenScale = [[UIScreen mainScreen] scale];
        CGSize screenSize = CGSizeMake(screenBounds.size.width * screenScale, screenBounds.size.height * screenScale);
        screenWidth = screenSize.width;
        screenHeight = screenSize.height;
        sx = screenWidth/640.0f;
        sy = screenHeight/1136.0f;
        if (![pauseButton pointIsInside:tapPoint withScreenScale:sy])
        {
            
            if (game_state == GAME_RUNNING)
            {
                if ([playerName isEqualToString:@"cheat"])
                {
                    cheese->colPackage->foundCollision = false;
                    [cheese dropAt:pt];
                    cheese->colPackage->state = COLLISION_NONE;
                }
                else
                {
                    if (y > (960 * sy))
                    {
                        cheese->colPackage->foundCollision = false;
                        [cheese dropAt:pt];
                        cheese->colPackage->state = COLLISION_NONE;
                    }
                }
            }
            if (game_state == GAME_PAUSED)
            {
                if ( [pauseMenu pointIsInsidePlayButton:tapPoint withScreenScale:sy])
                    game_state = GAME_RUNNING;
                else if ( [pauseMenu pointIsInsideRestartButton:tapPoint withScreenScale:sy])
                {
                    [musicPlayer stop];
                    [timer invalidate];
                    [self startAt:0 andTime:0 withCoins:0];
                    //[self startAt:currentLevelNumber andTime:total_time];
                }
                else if ( [pauseMenu pointIsInsideMainMenuButton:tapPoint withScreenScale:sy])
                {
                    [musicPlayer stop];
                    [cheese->world->sndMan stopAllSounds];
                    TitleViewController *titleViewController = (TitleViewController*)[UIApplication sharedApplication].keyWindow.rootViewController;
                    titleViewController.playerNameTextField.hidden = false;
                    [titleViewController->musicTitlePlayer play];
                    [self removeFromSuperview];
                }
            }
        }
        if (game_state == GAME_RUNNING)
        {
            if ([pauseButton pointIsInside:tapPoint withScreenScale:sy])
                game_state = GAME_PAUSED;
            else if ( [musicButton pointIsInside:tapPoint withScreenScale:sy])
            {
                if ([musicPlayer isPlaying])
                {
                    [musicButton turnOffMusic];
                    [musicPlayer stop];
                }
                else
                {
                    [musicButton turnOnMusic];
                    [musicPlayer play];
                }
            }
        }
        else if (game_state == GAME_OVER)
        {
            [musicPlayer stop];
            [cheese->world->sndMan stopAllSounds];
            TitleViewController *titleViewController = (TitleViewController*)[UIApplication sharedApplication].keyWindow.rootViewController;
            titleViewController.playerNameTextField.hidden = false;
            [titleViewController->musicTitlePlayer play];
            [self removeFromSuperview];
        }
        else if (game_state == GAME_CONTINUE)
        {
            //if (touchX > self.bounds.size.width/2)
            if ([noText pointIsInside:mousePt])
            {
                [musicPlayer stop];
                TitleViewController *titleViewController = (TitleViewController*)[UIApplication sharedApplication].keyWindow.rootViewController;
                titleViewController.playerNameTextField.hidden = false;
                [titleViewController->musicTitlePlayer play];
                
                [self removeFromSuperview];
            }
            else if ( [yesText pointIsInside:mousePt])
            {
                game_state = GAME_RUNNING;
                [musicPlayer stop];
                [cheese->world->sndMan stopAllSounds];
                [timer invalidate];
                int numOfCoins = cheese->world->numOfCoins-5;
                [self startAt:currentLevelNumber andTime:total_time withCoins:numOfCoins];
               
            }
        }
    }
    message = @"";
  
    chatBubble->visible = false;
    message = @"";
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    isTouched = false;
    mousePt = CGPointMake(0, 0);
}

- (void) dealloc
{
    
    [fpsLabel release];
    [super dealloc];

}

@end
