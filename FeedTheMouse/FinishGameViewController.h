//
//  FinishGameViewController.h
//  FeedTheMouse
//
//  Created by Jason Ly on 2018-08-21.
//  Copyright © 2018 Jason Ly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedTheMouseViewController.h"


@interface FinishGameViewController : UIViewController
{
    IBOutlet UIImageView *scoreboardImageView;
 //   IBOutlet UITextField *nameField;
    
 @public
   
    IBOutlet UILabel *scoreLabel;
    int scores[15];
    NSString *names[15];
    int score;
    NSString *playerName;
}

//@property (nonatomic, assign) int score;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UILabel *score1Label;
@property (nonatomic, retain) IBOutlet UILabel *player1Label;
@property (nonatomic, retain) IBOutlet UILabel *score2Label;
@property (nonatomic, retain) IBOutlet UILabel *player2Label;
@property (nonatomic, retain) IBOutlet UILabel *score3Label;
@property (nonatomic, retain) IBOutlet UILabel *player3Label;
@property (nonatomic, retain) IBOutlet UILabel *score4Label;
@property (nonatomic, retain) IBOutlet UILabel *player4Label;
@property (nonatomic, retain) IBOutlet UILabel *score5Label;
@property (nonatomic, retain) IBOutlet UILabel *player5Label;
@property (nonatomic, retain) IBOutlet UILabel *score6Label;
@property (nonatomic, retain) IBOutlet UILabel *player6Label;
@property (nonatomic, retain) IBOutlet UILabel *score7Label;
@property (nonatomic, retain) IBOutlet UILabel *player7Label;
@property (nonatomic, retain) IBOutlet UILabel *score8Label;
@property (nonatomic, retain) IBOutlet UILabel *player8Label;
@property (nonatomic, retain) IBOutlet UILabel *score9Label;
@property (nonatomic, retain) IBOutlet UILabel *player9Label;
@property (nonatomic, retain) IBOutlet UILabel *score10Label;
@property (nonatomic, retain) IBOutlet UILabel *player10Label;
@property (nonatomic, retain) IBOutlet UILabel *score11Label;
@property (nonatomic, retain) IBOutlet UILabel *player11Label;
@property (nonatomic, retain) IBOutlet UILabel *score12Label;
@property (nonatomic, retain) IBOutlet UILabel *player12Label;
@property (nonatomic, retain) IBOutlet UILabel *score13Label;
@property (nonatomic, retain) IBOutlet UILabel *player13Label;
@property (nonatomic, retain) IBOutlet UILabel *score14Label;
@property (nonatomic, retain) IBOutlet UILabel *player14Label;
@property (nonatomic, retain) IBOutlet UILabel *score15Label;
@property (nonatomic, retain) IBOutlet UILabel *player15Label;

- (void)initializeScores;
- (void)updateScoresWithNew:(int)score andNew:(NSString *)name;
@end
