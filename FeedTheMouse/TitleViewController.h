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

@interface TitleViewController : UIViewController
{

    //IBOutlet UIView *ftmView;
    IBOutlet UIImageView *titleImageView;
     IBOutlet UIImageView *splashImageView;
     NSTimer *timer, *splashTimer;
     int count;

}
@property (nonatomic, retain) IBOutlet UIButton *playButton;
@property (nonatomic, retain) UITextField *playerNameTextField;
- (IBAction)doneEnteringPlayerName:(id)sender;

- (void) splashLoop;
- (void) transitionLoop;
@end
