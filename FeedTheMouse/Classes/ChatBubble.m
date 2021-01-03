//
//  ChatBubble.m
//  FeedTheMouse
//
//  Created by Jason Ly on 2020-12-30.
//  Copyright © 2020 Jason Ly. All rights reserved.
//

#import "ChatBubble.h"

@implementation ChatBubble

- (id) init
{
    self = [super init];
    if (self)
    {
        bubbleSprite = [Picture fromFile:@"chat_bubble_compressed.png"];
    }
    return self;
}

- (void) draw: (CGContextRef) context
{
    
    [bubbleSprite draw:context at:CGPointMake(self.x , self.y)];
}
@end
