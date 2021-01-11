//
//  PauseMenu.h
//  FeedTheMouse
//
//  Created by Jason Ly on 2021-01-09.
//  Copyright © 2021 Jason Ly. All rights reserved.
//

#import "Sprite.h"
#import "Picture.h"

NS_ASSUME_NONNULL_BEGIN

@interface PauseMenu : Sprite
{
    @public
        Sprite *pauseSprite;
}
- (void) draw: (CGContextRef) context;
- (bool) pointIsInside: (CGPoint)pt withScreenScale: (float)scale;
- (bool) pointIsInsidePlayButton: (CGPoint)pt withScreenScale: (float)scale;
- (bool) pointIsInsideRestartButton: (CGPoint)pt withScreenScale: (float)scale;
- (bool) pointIsInsideMainMenuButton: (CGPoint)pt withScreenScale: (float)scale;
@end

NS_ASSUME_NONNULL_END
