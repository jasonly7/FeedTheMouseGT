//
//  TitleViewController.h
//  FeedTheMouse
//
//  Created by Jason Ly on 2018-08-20.
//  Copyright © 2018 Jason Ly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayImageView.h"

@interface TitleViewController : UIViewController
{
     IBOutlet UIImageView *titleImageView;
     IBOutlet UIImageView *splashImageView;
     NSTimer *timer, *splashTimer;
     int count;
}
@property (nonatomic, retain) IBOutlet UIButton *playButton;

- (void) splashLoop;
- (void) transitionLoop;
@end
