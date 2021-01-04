//
//  ChatBubble.h
//  FeedTheMouse
//
//  Created by Jason Ly on 2020-12-30.
//  Copyright © 2020 Jason Ly. All rights reserved.
//

//#import "Sprite.h"
#import "Picture.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChatBubble : Sprite
{
    
    CGFloat sx,sy;
    @public
        Sprite *bubbleSprite;
        bool visible;
}

- (void) draw: (CGContextRef) context;
@end

NS_ASSUME_NONNULL_END
