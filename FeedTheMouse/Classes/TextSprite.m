//
//  TextSprite.m
//  FeedTheMouse
//
//  Created by Jason Ly on 2020-11-15.
//  Copyright © 2020 Jason Ly. All rights reserved.
//

#import "TextSprite.h"
#define kDefaultFont    @"Helvetica"
#define kDefaultFontSize        14

@implementation TextSprite
@synthesize text, font, fontSize;

- (id) init
{
    self = [super init];
    if (self) {
        font = [kDefaultFont retain];
        fontSize = kDefaultFontSize;
        text = nil;
        width = height = 0.0;
        color = [UIColor blackColor].CGColor;
    }
    return self;
}

- (void) moveUpperLeftTo:(CGPoint)p
{
    CGPoint p2 = CGPointMake(0, 0);
    p2.x = p.x;
    p2.y = p.y + height;
    [self moveTo: p2];
}

+ (TextSprite *) withString:(NSString *)label
{
    TextSprite *ts = [[TextSprite alloc] init];
    if (ts) {
        ts.text = [label retain];
    }
    return ts;
}

- (void) newText:(NSString *)val
{
    if (text)
        [text release];
    text = [val retain];
    width = 0;
    height = 0;
}

- (void) computeWidth: (CGContextRef) context on: (CGRect) rect
{
    textLength = [text length];
    
    CGFontRef fref = CGFontCreateWithFontName((CFStringRef) font);
    if (!fref) {
        width = 0.0;
        height = 0.0;
        printf("Warning: missing font %s\n", [font UTF8String]);
        return;
    }
    CGRect bbox = CGFontGetFontBBox(fref);
    int units = CGFontGetUnitsPerEm(fref);
    
    // Convert from glyph units, multiply by fontSize to get our hegiht
    height = ( ((float) bbox.size.height) / ((float) units)) * fontSize;
    
    // Draw the text, invisibly, to figure out its width
    CGPoint left = CGContextGetTextPosition(context);
    CGContextSetTextDrawingMode(context, kCGTextInvisible);
    CGAffineTransform transform = CGAffineTransformIdentity;
   // // ;//
    
    //CGSize scales = CGSizeMake(viewRect.size.width/rect.size.width,
      //                             viewRect.size.height/rect.size.height);
    //left.x = 100;
    // Move origin from upper left to lower left
   // transform = CGAffineTransformScale(transform, 1, -1);//CGAffineTransformTranslate(transform, 0, 100);// rect.size.height);
    // Flip the sign of the Y axis
    //transform = CGAffineTransformScale(transform, 1, -1);
    // Apply value-to-scren scaling
   // transform = CGAffineTransformScale(transform, <#CGFloat sx#>, <#CGFloat sy#>)
    
    CGContextSetTextMatrix(context, transform);
    CGContextSelectFont(context, [font UTF8String], fontSize, kCGEncodingMacRoman);
    CGContextShowText(context,[text UTF8String], textLength);
    CGPoint right = CGContextGetTextPosition(context);
    width = right.x - left.x;
    
    // Figure out our new bounding box and release
    //[self updateBox];
    CGFontRelease(fref);
}

- (void) drawBody: (CGContextRef) context on: (CGRect) rect
{
    if (!text) return;
   // if (!width)
      //  [self computeWidth:context on:rect];
   /*CGAffineTransform t0 = CGContextGetCTM(context);
   // t0 = CGAffineTransformInvert(t0);
   // t0 = CGAffineTransformRotate(t0,180 );//CGAffineTransformScale(t0, 0, -1);
    CGContextSelectFont(context, [font UTF8String], fontSize, kCGEncodingMacRoman);
    CGContextSetTextDrawingMode(context, kCGTextFillStroke);
    CGContextSetRGBFillColor(context, r, g, b, alpha);
    
    //CGFontRef fref = CGFontCreateWithFontName((CFStringRef) font);
   // int units = //CGFontGetUnitsPerEm(fref);
   // float y = ((rect.size.height - (rect.size.height*0.17)) * 2 - height);
    //CGPoint pt = CGPointMake(0, rect.size.height);
    //CGPoint ptText = CGContextConvertPointToDeviceSpace(context, pt);
    CGRect deviceRect = CGContextConvertRectToUserSpace(context, rect);
    float y = rect.size.height- height;
    CGContextShowTextAtPoint(context, 0,  y , [text UTF8String], textLength);
    */
     // create a font, quasi systemFontWithSize:24.0
    CTFontRef sysUIFont = CTFontCreateWithName(CFSTR("Helvetica-Bold"), 24.0, NULL);
    //CTFontCreateUIFontForLanguage(kCTFontSystemFontType,
           //  24.0, NULL);
      
    // create a naked string
    NSString *string = [text UTF8String];//@"Some Text";

    // single underline
    NSNumber *underline = [NSNumber numberWithInt:kCTUnderlineStyleNone];


    // pack it into attributes dictionary
    NSDictionary *attributesDict = [NSDictionary dictionaryWithObjectsAndKeys:
     (id)sysUIFont, (id)kCTFontAttributeName,
     color, (id)kCTForegroundColorAttributeName,
     underline, (id)kCTUnderlineStyleAttributeName, nil];

    // make the attributed string
    NSAttributedString *stringToDraw = [[NSAttributedString alloc] initWithString:text
     attributes:attributesDict];

    // flip the coordinate system
    
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGFloat screenScale = [[UIScreen mainScreen] scale];
    CGSize screenSize = CGSizeMake(screenBounds.size.width * screenScale, screenBounds.size.height * screenScale);
    float screenWidth = screenSize.width;
    float screenHeight = screenSize.height;
    float sx = screenWidth/640.0f;
    float sy = screenHeight/1136.0f;
    
    float yVal = 1-(y*sy/(rect.size.height*screenScale));
    float xVal = x*sx/(rect.size.width*screenScale);
    if (screenWidth == 1242)
    {
        xVal = x/(rect.size.width*screenScale);
        yVal = 1-(y/(rect.size.height*screenScale));
    }
  //  CGPoint pt = CGPointMake(xVal, height);
  //  pt = CGContextConvertPointToDeviceSpace(context, pt);
    //CGContextTranslateCTM(context, xVal*rect.size.width, rect.size.height*val);
    CGContextTranslateCTM(context, xVal*rect.size.width, rect.size.height*yVal);
    CGContextScaleCTM(context, 1.0, -1.0);

    // draw
    CTLineRef line = CTLineCreateWithAttributedString(
     (CFAttributedStringRef)stringToDraw);
    CGContextSetTextPosition(context,0.0, 0.0);
    CTLineDraw(line, context);

    // clean up
    CFRelease(line);
    CFRelease(sysUIFont);
    [stringToDraw release];
    
}

- (void) dealloc
{
    [text release];
    [font release];
    [super dealloc];
}
@end
