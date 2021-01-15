//
//  Boom.m
//  FeedTheMouse
//
//  Created by Jason Ly on 2021-01-15.
//  Copyright © 2021 Jason Ly. All rights reserved.
//

#import "Boom.h"

@implementation Boom
- (id) init
{
    self = [super init];
    if (self)
    {
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        float screenScale = [[UIScreen mainScreen] scale];
        CGSize screenSize = CGSizeMake(screenBounds.size.width * screenScale, screenBounds.size.height * screenScale);
        float screenWidth = screenSize.width;
        float screenHeight = screenSize.height;
        float sx = screenWidth/640.0f;
        float sy = screenHeight/1136.0f;
        if (screenWidth == 1242)
        {
            boomSprite = [Picture fromFile:@"BigBoom.png"];
        }
        else
        {
            boomSprite = [Picture fromFile:@"Boom.png"];
        }
    }
    return self;
}

- (void) draw: (CGContextRef) context
{
    [boomSprite draw:context at:CGPointMake(self.x , self.y)];
}
@end
