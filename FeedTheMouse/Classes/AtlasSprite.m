//
//  AtlasSprite.m
//
//

#import "AtlasSprite.h"

@implementation AtlasSprite
@synthesize rows, columns;
@synthesize image, atlas, atlasWidth, atlasHeight, clipRect, w2, h2;

+(NSMutableDictionary *) sharedSpriteAtlas
{
    static NSMutableDictionary *sharedSpriteDictionary;
    @synchronized(self)
    {
        if (!sharedSpriteDictionary) {
            sharedSpriteDictionary = [[NSMutableDictionary alloc] init];
            return sharedSpriteDictionary;
        }
    }
    return sharedSpriteDictionary;
}

+ (UIImage *) getSpriteAtlas:(NSString *)name
{
    NSMutableDictionary *d = [AtlasSprite sharedSpriteAtlas]; // Singleton
    UIImage *img = [d objectForKey:name];
    if (!img) {
        img = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:nil]];
        [d setObject: img forKey:name];
    }

//    printf("img retainCount is %d\n",[img retainCount]);

    return img;
}

+ (AtlasSprite *) fromFile:(NSString *)fname withRows:(int)rows withColumns:(int)columns
{
    AtlasSprite *s = [[AtlasSprite alloc] init];
    
    s.atlas = [[AtlasSprite getSpriteAtlas: fname] retain];
    //printf("retain count is %d\n", [s.atlas retainCount]);

    CGImageRef img = [s.atlas CGImage];
    s.image = img;
    s->filename = fname;
    int width = CGImageGetWidth(s.image);
    int height = CGImageGetHeight(s.image);
    if (rows < 1) s.rows = 1;
    if (columns < 1) s.columns = 1;
    s.atlasWidth = width;
    s.atlasHeight = height;
    s.rows = rows;
    s.columns = columns;
    s.width = round(width/s.columns);
    s.height = round(height/s.rows);
    s.w2 = s.width * 0.5;
    s.h2 = s.height * 0.5;
    s.clipRect = CGRectMake(-s.width*0.5,-s.height*0.5,s.width,s.height);
    
    return [s autorelease];
}

- (void) fromFile:(NSString *)fname withRows:(int)rws withColumns:(int)cols
{
    atlas = [AtlasSprite getSpriteAtlas: fname];
    //printf("atlas retain count is %d\n", [atlas retainCount]);
    
    CGImageRef img = [atlas CGImage];
    image = img;
    filename = fname; 
    if (rws < 1) rows = 1;
    if (cols < 1) columns = 1;
    atlasWidth =   CGImageGetWidth(image);;
    atlasHeight =  CGImageGetHeight(image);
    rows = rws;
    columns = cols;
    width = round(atlasWidth/columns);
    height = round(atlasHeight/rows);
    w2 = width * 0.5;
    h2 = height * 0.5;
    clipRect = CGRectMake(-width*0.5,-height*0.5,width,height);
}

- (void) drawBody: (CGContextRef) context
{
    int r0 = floor(frame/columns);
    int c0 = frame - columns * r0;
    CGFloat u = c0 * width + w2;
    CGFloat v = atlasHeight - (r0*height + h2);     // within the atlas
    
    // clip our image from the atlas
    CGContextBeginPath(context);
    CGContextAddRect(context, clipRect);
    CGContextClip(context);
    CGContextDrawImage(context, CGRectMake(-u,-v, atlasWidth, atlasHeight), image);
}

- (id) init
{
    self = [super init];
    if (self) {
        rows = 0.0;
        columns = 0.0;
    }
    return self;
}

- (void) dealloc
{
    
    [atlas release];
    CGImageRelease(image);
    [super dealloc];
}

@end
