//
//  PauseButton.h
//  FeedTheMouse
//
//  Created by Jason Ly on 2021-01-06.
//  Copyright © 2021 Jason Ly. All rights reserved.
//

#import "Sprite.h"
#import "Picture.h"
NS_ASSUME_NONNULL_BEGIN

@interface MusicButton : Sprite
{
    @public
        Sprite *musicSprite;
    
}
- (bool) pointIsInside: (CGPoint)pt withScreenScale: (float)scale;
- (void) draw: (CGContextRef) context;
- (void) turnOffMusic;
- (void) turnOnMusic;
@end

NS_ASSUME_NONNULL_END
