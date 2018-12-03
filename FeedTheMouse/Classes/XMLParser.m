//
//  XMLParser.m
//  Feed The Mouse
//
//  Created by Jason Ly on 2013-02-02.
//  Copyright (c) 2013 Jason Ly. All rights reserved.
//

#import "XMLParser.h"
#import "Flipper.h"
#import "Gear.h"
#import "Level.h"
#import "Drum.h"

@implementation XMLParser

@synthesize gear;
@synthesize level;
- (XMLParser *) initXMLParser {
    self = [super init];
    coins = [[NSMutableArray alloc] initWithCapacity:3];
    levels = [[NSMutableArray alloc] initWithCapacity:3];
    gears = [[NSMutableArray alloc] initWithCapacity:3];
    drums = [[NSMutableArray alloc] initWithCapacity:3];
    teeterTotters = [[NSMutableArray alloc] initWithCapacity:3];
    flippers = [[NSMutableArray alloc] initWithCapacity:3];
    lvlNum = 0;
    return self;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict
{
    currentElementName = elementName;

    if ([elementName isEqualToString:@"Coin"]) {
        coin = [[Coin alloc] init];
        currentObject = @"Coin";
    }
    else if ([elementName isEqualToString:@"Gear"]) {
      //  NSLog(@"gear element found – create a new instance of Gear class...");
        gear = [[Gear alloc] init];
        currentObject = @"Gear";
        //We do not have any attributes in the gear elements, but if
        // you do, you can extract them here:
        // gear = [[attributeDict objectForKey:@"<att name>"] ...];
    }
    else if ([elementName isEqualToString:@"Drum"]) {
        drum = [[Drum alloc] init];
        currentObject = @"Drum";
    }
    else if ([elementName isEqualToString:@"TeeterTotter"])
    {
        teeterTotter = [[TeeterTotter alloc] init];
        currentObject = @"TeeterTotter";
    }
    else if ([elementName isEqualToString:@"Flipper"])
    {
        flipper = [[Flipper alloc] init];
        currentObject = @"Flipper";
    }
    else if ([elementName isEqualToString:@"Mouse"])
    {
        mouse = [[Mouse alloc] init];
        currentObject = @"Mouse";
    }
    else if ([elementName isEqualToString:@"Level"]) {
        lvlNum++;
        level = [[Level alloc] init];
        [level initializeLevel:lvlNum];
        currentObject = @"";
    }
    
}

- (void) parser: (NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (!currentElementValue) {
        // init the ad hoc string with the value
        currentElementValue = [[NSMutableString alloc] initWithString:string];
    } else {
        // append value to the ad hoc string
        [currentElementValue appendString:string];
    }
   // printf("string: %s", [string UTF8String]);

    if ([currentElementName isEqualToString:@"X"])
    {
        if ([currentObject isEqualToString:@"Gear"])
            x = [string intValue]-174;
        else if ([currentObject isEqualToString:@"Drum"])
            x = [string intValue];
        else if ([currentObject isEqualToString:@"TeeterTotter"])
            x = [string intValue]-180;
        else if ([currentObject isEqualToString:@"Flipper"])
            x = [string intValue]-168;
        else if ([currentObject isEqualToString:@"Mouse"])
            x = [string intValue];//-MOUSE_WIDTH;
        else if ([currentObject isEqualToString:@"Coin"])
            x = [string intValue]-29;
        currentElementName = @"";
    } else if ([currentElementName isEqualToString:@"Y"]) {
        if ([currentObject isEqualToString:@"Gear"])
            y = [string intValue]-174;
        else if ([currentObject isEqualToString:@"Drum"])
            y = [string intValue];
        else if ([currentObject isEqualToString:@"TeeterTotter"])
            y = [string intValue]-72;
        else if ([currentObject isEqualToString:@"Flipper"])
            y = [string intValue]-56;
        else if ([currentObject isEqualToString:@"Mouse"])
            y = [string intValue];//-MOUSE_HEIGHT;
        else if ([currentObject isEqualToString:@"Coin"])
            y = [string intValue]-29;

        currentElementName = @"";
    } else if ([currentElementName isEqualToString:@"ANGLE"]) {
        angle = [string floatValue];
        currentElementName = @"";
    } else if ([currentElementName isEqualToString:@"ISFLIPPED"]) {
        if ([string isEqualToString:@"true"])
            isFlipped = true;
        else
            isFlipped = false;
        currentElementName = @"";
    } else if ([currentElementName isEqualToString:@"Color"]) {
        if ([string isEqualToString:@"blue"])
            color = [UIColor blueColor];
        else if ([string isEqualToString:@"green"])
            color = [UIColor greenColor];
        else if ([string isEqualToString:@"magenta"])
            color = [UIColor magentaColor];
        else if ([string isEqualToString:@"yellow"])
            color = [UIColor yellowColor];
        else if ([string isEqualToString:@"orange"])
            color = [UIColor orangeColor];
        else if ([string isEqualToString:@"purple"])
            color = [UIColor purpleColor];
        currentElementName = @"";
    }

    //NSLog(@"Processing value for : %s", [string UTF8String]);
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"FeedTheMouse"]) {
        // We reached the end of the XML document
        return;
    }
    
    if ([elementName isEqualToString:@"Level"])
    {
        [level setMouse:mouse];
        for (int i=0; i < coins.count; i++)
        {
            Coin *newCoin = [[[Coin alloc] init] autorelease];
            Coin *c = (Coin*)[coins objectAtIndex:i];
            int cx = [c getX];
            int cy = [c getY];
            
            [newCoin initializeCoinAtX:cx andY:cy];
            [level addCoin:newCoin];
        }

        for (int i=0; i < gears.count; i++)
        {
            Gear *newGear = [[[Gear alloc] init] autorelease];
            Gear *g = (Gear*)[gears objectAtIndex:i];
            int gx = [g getX];
            int gy = [g getY];
            UIColor *c = [g getColor];
            NSString *strColor = [g getStringColor];
           // NSLog(@"gear color:%@", strColor);
            [newGear initializeGearWithX:gx andY:gy andColor:c];
            [level addGear:newGear];
        }
        for (int i=0; i < drums.count; i++)
        {
            Drum *newDrum = [[[Drum alloc] init] autorelease];
            Drum *d = (Drum*)[drums objectAtIndex:i];
            int dx = [d getX];
            int dy = [d getY];
            float newAngle = [d getAngle];
            [newDrum initializeDrumAtX:dx andY:dy andAngle:newAngle];
            [level addDrum:newDrum];
        }
        for (int i=0; i < flippers.count; i++)
        {
            Flipper *newFlipper = [[[Flipper alloc] init] autorelease];
            Flipper *f = (Flipper*)[flippers objectAtIndex:i];
            int fx = [f getX];
            int fy = [f getY];
            UIColor *c = [f getColor];
            float newAngle = [f getAngle];
            bool fIsFlipped = f->isImgFlipped;
            [newFlipper initializeFlipperAtX:fx andY:fy andAngle:newAngle andColor:c];
            newFlipper->isImgFlipped = fIsFlipped;
            [level addFlipper:newFlipper];
        }
        for (int i=0; i < teeterTotters.count; i++)
        {
            TeeterTotter *newTeeterTotter = [[[TeeterTotter alloc] init] autorelease];
            TeeterTotter *t = (TeeterTotter*)[teeterTotters objectAtIndex:i];
            int tx = [t getX];
            int ty = [t getY];
            UIColor *c = [t getColor];
            [newTeeterTotter initializeTeeterTotterAtX:tx andY:ty andColor:c];
            [level addTeeterTotter:newTeeterTotter];
        }
        [levels addObject:level];
        [coins removeAllObjects];
        [gears removeAllObjects];
        [drums removeAllObjects];
        [teeterTotters removeAllObjects];
        [flippers removeAllObjects];
    }
    
    if ([elementName isEqualToString:@"Mouse"]) {
        [mouse setX:x];
        [mouse setY:y];
    }
    else if ([elementName isEqualToString:@"Coin"]) {
        [coin setX:x];
        [coin setY:y];
        [coins addObject:coin];
    }
    else if ([elementName isEqualToString:@"Gear"]) {
        // We are done with user entry – add the parsed user
        // object to our user array
        [gear setX:x];
        [gear setY:y];
        [gear setColor:color];
        [gears addObject:gear];
        //printf("Gear(x,y): %d %d\n", [gear getX], [gear getY]);
        // release user object
       // [gear release];
        //gear = nil;
    }
    if ([elementName isEqualToString:@"Drum"]) {
        [drum setX:x];
        [drum setY:y];
        [drum setAngle:angle];
        [drums addObject:drum];
    }
    if ([elementName isEqualToString:@"TeeterTotter"]) {
        [teeterTotter setX:x];
        [teeterTotter setY:y];
        [teeterTotter setColor:color];
        [teeterTotters addObject:teeterTotter];
    }
    if ([elementName isEqualToString:@"Flipper"]) {
        [flipper setX:x];
        [flipper setY:y];
        [flipper setColor:color];
        [flipper setAngle:angle];
        flipper->isImgFlipped = isFlipped;
        [flippers addObject:flipper];
    }
    [currentElementValue release];
    currentElementValue = nil;
}
@end
