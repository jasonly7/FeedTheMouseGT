//
//  Boom.h
//  FeedTheMouse
//
//  Created by Jason Ly on 2021-01-15.
//  Copyright © 2021 Jason Ly. All rights reserved.
//

#import "Sprite.h"
#import "Picture.h"

NS_ASSUME_NONNULL_BEGIN

@interface Boom : Sprite
{
    @public
        Sprite *boomSprite;
        float lifespan;
}

- (void) draw: (CGContextRef) context;
@end

NS_ASSUME_NONNULL_END
