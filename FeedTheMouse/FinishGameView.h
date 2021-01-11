//
//  FinishGameView.h
//  FeedTheMouse
//
//  Created by Jason Ly on 2018-08-21.
//  Copyright © 2018 Jason Ly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FinishGameView : UIView
{
    NSString *pathForMusicFile;
    NSURL *musicFile;
    AVAudioPlayer *musicPlayer;
    }
@end
