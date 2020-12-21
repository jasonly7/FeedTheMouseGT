//
//  TitleViewController.h
//  FeedTheMouse
//
//  Created by Jason Ly on 2018-08-20.
//  Copyright © 2018 Jason Ly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayImageView.h"
#import "FeedTheMouseViewController.h"
#import "CreditsViewController.h"

@interface TitleViewController : UIViewController
{

    //IBOutlet UIView *ftmView;
    IBOutlet UIImageView *titleImageView;
     IBOutlet UIImageView *splashImageView;
     NSTimer *timer, *splashTimer;
     int count;
    @public
    NSString *pathForMusicFile;
    NSURL *musicFile;
    AVAudioPlayer *musicTitlePlayer;
    CGFloat screenScale;
    CGFloat sx,sy;
    float screenWidth, screenHeight;
}
@property (nonatomic, retain) IBOutlet UIButton *playButton;
@property (nonatomic, retain) UITextField *playerNameTextField;
@property (retain, nonatomic) IBOutlet UIButton *infoButton;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *PlayerNameCenterConstraint;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *NameCenterConstraint;

- (IBAction)infoButtonTouchedUp:(id)sender;

- (IBAction)doneEnteringPlayerName:(id)sender;

- (void) splashLoop;
- (void) transitionLoop;
@end
