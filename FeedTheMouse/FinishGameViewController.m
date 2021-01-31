//
//  FinishGameViewController.m
//  FeedTheMouse
//
//  Created by Jason Ly on 2018-08-21.
//  Copyright © 2018 Jason Ly. All rights reserved.
//

#import "FinishGameViewController.h"

@interface FinishGameViewController ()

@end

@implementation FinishGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    [scoreboardImageView setFrame:(CGRectMake(scoreboardImageView.frame.origin.x, scoreboardImageView.frame.origin.y, screenBounds.size.width,screenBounds.size.height))];
    
    
    [self initializeTimes];
    [self updateScoresWithNewTime:total_time andNewName:playerName];

    TitleViewController *titleViewController = (TitleViewController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    titleViewController.playerNameTextField.hidden = true;
    
}

- (IBAction)backButtonClicked:(id)sender
{
    //FeedTheMouseViewController *feedTheMouseViewController = (FeedTheMouseViewController*)self.parentViewController;
    //[feedTheMouseViewController removeFromParentViewController];
    [self removeFromParentViewController];
}

- (void)viewWillAppear:(BOOL)animated
{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.width == 414)
    {
        //  [_titleLabel setBounds:CGRectMake(0, 212, scoreboardImageView.frame.size.width, _titleLabel.bounds.size.height)];
        [_titleLabel setFrame:CGRectMake(0, 67 - _titleLabel.frame.size.height, scoreboardImageView.frame.size.width, 46)];
        [_titleLabel setTextAlignment:UIListContentTextAlignmentCenter];
        [_titleLabel setFont:[UIFont boldSystemFontOfSize:24]];
       // [_titleLabel setBackgroundColor:[UIColor blueColor]];
        
        [_player15Label setFont:[UIFont systemFontOfSize:24]];
        [_player15Label setFrame:CGRectMake(51, 803, _player15Label.frame.size.width, _titleLabel.frame.size.height)];
        [_score15Label setFont:[UIFont systemFontOfSize:24]];
        [_score15Label setFrame:CGRectMake(_score15Label.frame.origin.x+40, _player15Label.frame.origin.y, _score15Label.frame.size.width, _player15Label.frame.size.height)];
        
        [_player14Label setFont:[UIFont systemFontOfSize:24]];
        [_player14Label setFrame:CGRectMake(51, _player15Label.frame.origin.y - _player15Label.frame.size.height-3, _player15Label.frame.size.width, _player15Label.frame.size.height)];
        [_score14Label setFont:[UIFont systemFontOfSize:24]];
        [_score14Label setFrame:CGRectMake(_score14Label.frame.origin.x+40, _player14Label.frame.origin.y, _score14Label.frame.size.width, _player14Label.frame.size.height)];
        
        [_player13Label setFont:[UIFont systemFontOfSize:24]];
        [_player13Label setFrame:CGRectMake(51, _player14Label.frame.origin.y - _player15Label.frame.size.height-3, _player15Label.frame.size.width, _player15Label.frame.size.height)];
        [_score13Label setFont:[UIFont systemFontOfSize:24]];
        [_score13Label setFrame:CGRectMake(_score13Label.frame.origin.x+40, _player13Label.frame.origin.y, _score13Label.frame.size.width, _player13Label.frame.size.height)];
        
        [_player12Label setFont:[UIFont systemFontOfSize:24]];
        [_player12Label setFrame:CGRectMake(51, _player13Label.frame.origin.y - _player15Label.frame.size.height-3, _player15Label.frame.size.width, _player15Label.frame.size.height)];
        [_score12Label setFont:[UIFont systemFontOfSize:24]];
        [_score12Label setFrame:CGRectMake(_score12Label.frame.origin.x+40, _player12Label.frame.origin.y, _score12Label.frame.size.width, _player12Label.frame.size.height)];
        
        [_player11Label setFont:[UIFont systemFontOfSize:24]];
        [_player11Label setFrame:CGRectMake(51, _player12Label.frame.origin.y - _player15Label.frame.size.height-3, _player15Label.frame.size.width, _player15Label.frame.size.height)];
        [_score11Label setFont:[UIFont systemFontOfSize:24]];
        [_score11Label setFrame:CGRectMake(_score11Label.frame.origin.x+40, _player11Label.frame.origin.y, _score11Label.frame.size.width, _player11Label.frame.size.height)];
        
        [_player10Label setFont:[UIFont systemFontOfSize:24]];
        [_player10Label setFrame:CGRectMake(51, _player11Label.frame.origin.y - _player15Label.frame.size.height-3, _player15Label.frame.size.width, _player15Label.frame.size.height)];
        [_score10Label setFont:[UIFont systemFontOfSize:24]];
        [_score10Label setFrame:CGRectMake(_score10Label.frame.origin.x+40, _player10Label.frame.origin.y, _score10Label.frame.size.width, _player10Label.frame.size.height)];
        
        [_player9Label setFont:[UIFont systemFontOfSize:24]];
        [_player9Label setFrame:CGRectMake(51, _player10Label.frame.origin.y - _player15Label.frame.size.height-2, _player15Label.frame.size.width, _player15Label.frame.size.height)];
        [_score9Label setFont:[UIFont systemFontOfSize:24]];
        [_score9Label setFrame:CGRectMake(_score9Label.frame.origin.x+40, _player9Label.frame.origin.y, _score9Label.frame.size.width, _player9Label.frame.size.height)];
        
        [_player8Label setFont:[UIFont systemFontOfSize:24]];
        [_player8Label setFrame:CGRectMake(51, _player9Label.frame.origin.y - _player15Label.frame.size.height-2, _player15Label.frame.size.width, _player15Label.frame.size.height)];
        [_score8Label setFont:[UIFont systemFontOfSize:24]];
        [_score8Label setFrame:CGRectMake(_score8Label.frame.origin.x+40, _player8Label.frame.origin.y, _score8Label.frame.size.width, _player8Label.frame.size.height)];
        
        [_player7Label setFont:[UIFont systemFontOfSize:24]];
        [_player7Label setFrame:CGRectMake(51, _player8Label.frame.origin.y - _player15Label.frame.size.height-1, _player15Label.frame.size.width, _player15Label.frame.size.height)];
        [_score7Label setFont:[UIFont systemFontOfSize:24]];
        [_score7Label setFrame:CGRectMake(_score7Label.frame.origin.x+40, _player7Label.frame.origin.y, _score7Label.frame.size.width, _player7Label.frame.size.height)];
        
        [_player6Label setFont:[UIFont systemFontOfSize:24]];
        [_player6Label setFrame:CGRectMake(51, _player7Label.frame.origin.y - _player15Label.frame.size.height, _player15Label.frame.size.width, _player15Label.frame.size.height)];
        [_score6Label setFont:[UIFont systemFontOfSize:24]];
        [_score6Label setFrame:CGRectMake(_score6Label.frame.origin.x+40, _player6Label.frame.origin.y, _score6Label.frame.size.width, _player6Label.frame.size.height)];
        
        [_player5Label setFont:[UIFont systemFontOfSize:24]];
        [_player5Label setFrame:CGRectMake(51, _player6Label.frame.origin.y - _player15Label.frame.size.height, _player15Label.frame.size.width, _player15Label.frame.size.height)];
        [_score5Label setFont:[UIFont systemFontOfSize:24]];
        [_score5Label setFrame:CGRectMake(_score5Label.frame.origin.x+40, _player5Label.frame.origin.y, _score5Label.frame.size.width, _player5Label.frame.size.height)];
        
        [_player4Label setFont:[UIFont systemFontOfSize:24]];
        [_player4Label setFrame:CGRectMake(51, _player5Label.frame.origin.y - _player15Label.frame.size.height, _player15Label.frame.size.width, _player15Label.frame.size.height)];
        [_score4Label setFont:[UIFont systemFontOfSize:24]];
        [_score4Label setFrame:CGRectMake(_score4Label.frame.origin.x+40, _player4Label.frame.origin.y, _score4Label.frame.size.width, _player4Label.frame.size.height)];
        
        [_player3Label setFont:[UIFont systemFontOfSize:24]];
        [_player3Label setFrame:CGRectMake(51, _player4Label.frame.origin.y - _player15Label.frame.size.height, _player15Label.frame.size.width, _player15Label.frame.size.height)];
        [_score3Label setFont:[UIFont systemFontOfSize:24]];
        [_score3Label setFrame:CGRectMake(_score3Label.frame.origin.x+40, _player3Label.frame.origin.y, _score3Label.frame.size.width, _player3Label.frame.size.height)];
        
        [_player2Label setFont:[UIFont systemFontOfSize:24]];
        [_player2Label setFrame:CGRectMake(51, _player3Label.frame.origin.y - _player15Label.frame.size.height, _player15Label.frame.size.width, _player15Label.frame.size.height)];
        [_score2Label setFont:[UIFont systemFontOfSize:24]];
        [_score2Label setFrame:CGRectMake(_score2Label.frame.origin.x+40, _player2Label.frame.origin.y, _score2Label.frame.size.width, _player2Label.frame.size.height)];
        
        [_player1Label setFrame:CGRectMake(51, _player2Label.frame.origin.y - _player15Label.frame.size.height, _player15Label.frame.size.width, _player15Label.frame.size.height)];
        [_score1Label setFont:[UIFont systemFontOfSize:24]];
        [_score1Label setFrame:CGRectMake(_score1Label.frame.origin.x+40, _player1Label.frame.origin.y, _score1Label.frame.size.width, _player1Label.frame.size.height)];
        [_player1Label setFont:[UIFont systemFontOfSize:24]];
    }
    else if (screenBounds.size.width == 428)
    {
      
        [_titleLabel setFrame:CGRectMake(0, 80 - _titleLabel.frame.size.height, scoreboardImageView.frame.size.width, _titleLabel.bounds.size.height+5)];
        [_titleLabel setTextAlignment:UIListContentTextAlignmentCenter];
        [_titleLabel setFont:[UIFont boldSystemFontOfSize:24]];
        
       
        [_player15Label setFont:[UIFont systemFontOfSize:24]];
        [_player15Label setFrame:CGRectMake(51, 830, _player15Label.frame.size.width+50, 47)];
        [_score15Label setFont:[UIFont systemFontOfSize:24]];
        [_score15Label setFrame:CGRectMake(_score15Label.frame.origin.x+40, _player15Label.frame.origin.y, _score15Label.frame.size.width, _player15Label.frame.size.height)];
        
        //[_player14Label setBackgroundColor:[UIColor blueColor]];
        [_player14Label setFont:[UIFont systemFontOfSize:24]];
        [_player14Label setFrame:CGRectMake(51, _player15Label.frame.origin.y - _player15Label.frame.size.height-3, _player15Label.frame.size.width, _player15Label.frame.size.height)];
        [_score14Label setFont:[UIFont systemFontOfSize:24]];
        [_score14Label setFrame:CGRectMake(_score14Label.frame.origin.x+40, _player14Label.frame.origin.y, _score14Label.frame.size.width, _player14Label.frame.size.height)];
        
        [_player13Label setFont:[UIFont systemFontOfSize:24]];
        [_player13Label setFrame:CGRectMake(51, _player14Label.frame.origin.y - _player15Label.frame.size.height-3, _player15Label.frame.size.width, _player15Label.frame.size.height)];
        [_score13Label setFont:[UIFont systemFontOfSize:24]];
        [_score13Label setFrame:CGRectMake(_score13Label.frame.origin.x+40, _player13Label.frame.origin.y, _score13Label.frame.size.width, _player13Label.frame.size.height)];
        
        [_player12Label setFont:[UIFont systemFontOfSize:24]];
        [_player12Label setFrame:CGRectMake(51, _player13Label.frame.origin.y - _player15Label.frame.size.height-3, _player15Label.frame.size.width, _player15Label.frame.size.height)];
        [_score12Label setFont:[UIFont systemFontOfSize:24]];
        [_score12Label setFrame:CGRectMake(_score12Label.frame.origin.x+40, _player12Label.frame.origin.y, _score12Label.frame.size.width, _player12Label.frame.size.height)];
        
        [_player11Label setFont:[UIFont systemFontOfSize:24]];
        [_player11Label setFrame:CGRectMake(51, _player12Label.frame.origin.y - _player15Label.frame.size.height-3, _player15Label.frame.size.width, _player15Label.frame.size.height)];
        [_score11Label setFont:[UIFont systemFontOfSize:24]];
        [_score11Label setFrame:CGRectMake(_score11Label.frame.origin.x+40, _player11Label.frame.origin.y, _score11Label.frame.size.width, _player11Label.frame.size.height)];
        
        [_player10Label setFont:[UIFont systemFontOfSize:24]];
        [_player10Label setFrame:CGRectMake(51, _player11Label.frame.origin.y - _player15Label.frame.size.height-3, _player15Label.frame.size.width, _player15Label.frame.size.height)];
        [_score10Label setFont:[UIFont systemFontOfSize:24]];
        [_score10Label setFrame:CGRectMake(_score10Label.frame.origin.x+40, _player10Label.frame.origin.y, _score10Label.frame.size.width, _player10Label.frame.size.height)];
        
        [_player9Label setFont:[UIFont systemFontOfSize:24]];
        [_player9Label setFrame:CGRectMake(51, _player10Label.frame.origin.y - _player15Label.frame.size.height-2, _player15Label.frame.size.width, _player15Label.frame.size.height)];
        [_score9Label setFont:[UIFont systemFontOfSize:24]];
        [_score9Label setFrame:CGRectMake(_score9Label.frame.origin.x+40, _player9Label.frame.origin.y, _score9Label.frame.size.width, _player9Label.frame.size.height)];
        
        [_player8Label setFont:[UIFont systemFontOfSize:24]];
        [_player8Label setFrame:CGRectMake(51, _player9Label.frame.origin.y - _player15Label.frame.size.height-2, _player15Label.frame.size.width, _player15Label.frame.size.height)];
        [_score8Label setFont:[UIFont systemFontOfSize:24]];
        [_score8Label setFrame:CGRectMake(_score8Label.frame.origin.x+40, _player8Label.frame.origin.y, _score8Label.frame.size.width, _player8Label.frame.size.height)];
        
        [_player7Label setFont:[UIFont systemFontOfSize:24]];
        [_player7Label setFrame:CGRectMake(51, _player8Label.frame.origin.y - _player15Label.frame.size.height-1, _player15Label.frame.size.width, _player15Label.frame.size.height)];
        [_score7Label setFont:[UIFont systemFontOfSize:24]];
        [_score7Label setFrame:CGRectMake(_score7Label.frame.origin.x+40, _player7Label.frame.origin.y, _score7Label.frame.size.width, _player7Label.frame.size.height)];
        
        [_player6Label setFont:[UIFont systemFontOfSize:24]];
        [_player6Label setFrame:CGRectMake(51, _player7Label.frame.origin.y - _player15Label.frame.size.height, _player15Label.frame.size.width, _player15Label.frame.size.height)];
        [_score6Label setFont:[UIFont systemFontOfSize:24]];
        [_score6Label setFrame:CGRectMake(_score6Label.frame.origin.x+40, _player6Label.frame.origin.y, _score6Label.frame.size.width, _player6Label.frame.size.height)];
        
        [_player5Label setFont:[UIFont systemFontOfSize:24]];
        [_player5Label setFrame:CGRectMake(51, _player6Label.frame.origin.y - _player15Label.frame.size.height, _player15Label.frame.size.width, _player15Label.frame.size.height)];
        [_score5Label setFont:[UIFont systemFontOfSize:24]];
        [_score5Label setFrame:CGRectMake(_score5Label.frame.origin.x+40, _player5Label.frame.origin.y, _score5Label.frame.size.width, _player5Label.frame.size.height)];
        
        [_player4Label setFont:[UIFont systemFontOfSize:24]];
        [_player4Label setFrame:CGRectMake(51, _player5Label.frame.origin.y - _player15Label.frame.size.height, _player15Label.frame.size.width, _player15Label.frame.size.height)];
        [_score4Label setFont:[UIFont systemFontOfSize:24]];
        [_score4Label setFrame:CGRectMake(_score4Label.frame.origin.x+40, _player4Label.frame.origin.y, _score4Label.frame.size.width, _player4Label.frame.size.height)];
        
        [_player3Label setFont:[UIFont systemFontOfSize:24]];
        [_player3Label setFrame:CGRectMake(51, _player4Label.frame.origin.y - _player15Label.frame.size.height, _player15Label.frame.size.width, _player15Label.frame.size.height)];
        [_score3Label setFont:[UIFont systemFontOfSize:24]];
        [_score3Label setFrame:CGRectMake(_score3Label.frame.origin.x+40, _player3Label.frame.origin.y, _score3Label.frame.size.width, _player3Label.frame.size.height)];
        
        [_player2Label setFont:[UIFont systemFontOfSize:24]];
        [_player2Label setFrame:CGRectMake(51, _player3Label.frame.origin.y - _player15Label.frame.size.height, _player15Label.frame.size.width, _player15Label.frame.size.height)];
        [_score2Label setFont:[UIFont systemFontOfSize:24]];
        [_score2Label setFrame:CGRectMake(_score2Label.frame.origin.x+40, _player2Label.frame.origin.y, _score2Label.frame.size.width, _player2Label.frame.size.height)];
        
        [_player1Label setFont:[UIFont systemFontOfSize:24]];
        CGRect frame = _player1Label.frame;
        frame.origin.x = 285;
        frame.origin.y = 152;
        
        [_player1Label setFrame:CGRectMake(51, _player2Label.frame.origin.y - _player15Label.frame.size.height, _player15Label.frame.size.width, _player15Label.frame.size.height)];
        [_score1Label setFont:[UIFont systemFontOfSize:24]];
        [_score1Label setFrame:CGRectMake(_score1Label.frame.origin.x+40, _player1Label.frame.origin.y, _score1Label.frame.size.width, _player1Label.frame.size.height)];
        _score1Label.frame = frame;
    }
    if (DEBUG)
    {
        NSLog(@"%@ score 1 label: %@ (x,y): (%f,%f)",_score1Label.text, _score1Label.text, _score1Label.frame.origin.x,_score1Label.frame.origin.y);
        NSLog(@"%@ score 2 label: %@ (x,y): (%f,%f)",_score2Label.text, _score2Label.text, _score2Label.frame.origin.x,_score2Label.frame.origin.y);
        NSLog(@"%@ score 3 label: %@",_player3Label.text, _score3Label.text);
        NSLog(@"%@ score 4 label: %@",_player4Label.text, _score4Label.text);
        NSLog(@"%@ score 5 label: %@",_player5Label.text, _score5Label.text);
        NSLog(@"%@ score 6 label: %@",_player6Label.text, _score6Label.text);
        NSLog(@"%@ score 7 label: %@",_player7Label.text, _score7Label.text);
        NSLog(@"%@ score 8 label: %@",_player8Label.text, _score8Label.text);
        NSLog(@"%@ score 9 label: %@",_player9Label.text, _score9Label.text);
        NSLog(@"%@ score 10 label: %@",_player10Label.text, _score10Label.text);
        NSLog(@"%@ score 11 label: %@",_player11Label.text, _score11Label.text);
        NSLog(@"%@ score 12 label: %@",_player12Label.text, _score12Label.text);
        NSLog(@"%@ score 13 label: %@",_player13Label.text, _score13Label.text);
        NSLog(@"%@ score 14 label: %@",_player14Label.text, _score14Label.text);
        NSLog(@"%@ score 15 label: %@",_player15Label.text, _score15Label.text);
    }
}

- (void)initializeTimes {
    int time = 0;
    
    NSString *strName;

    for (int i=0; i < 15; i++)
    {
        time = [[NSUserDefaults standardUserDefaults] integerForKey:[NSString stringWithFormat:@"time%d",i]];
        strName = [[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"name%d",i]];
       
        /*if (score>0)
        {
            scores[i] = score;
        }
        else
        {
            scores[i] = 15-i;
        }*/
        if (time == 0)
            time = 3600;
        times[i] = time;
        if (strName==NULL)
        {
            switch (i)
            {
                case 0:
                    names[i] = _player1Label.text = @"Player 1";
                    break;
                case 1:
                    names[i] = _player2Label.text = @"Player 2";
                    break;
                case 2:
                    names[i] = _player3Label.text = @"Player 3";
                    break;
                case 3:
                    names[i] = _player4Label.text = @"Player 4";
                    break;
                case 4:
                    names[i] = _player5Label.text = @"Player 5";
                    break;
                case 5:
                    names[i] = _player6Label.text = @"Player 6";
                    break;
                case 6:
                    names[i] = _player7Label.text = @"Player 7";
                    break;
                case 7:
                    names[i] = _player8Label.text = @"Player 8";
                    break;
                case 8:
                    names[i] = _player9Label.text = @"Player 9";
                    break;
                case 9:
                    names[i] = _player10Label.text = @"Player 10";
                    break;
                case 10:
                    names[i] = _player11Label.text = @"Player 11";
                    break;
                case 11:
                    names[i] = _player12Label.text = @"Player 12";
                    break;
                case 12:
                    names[i] = _player13Label.text = @"Player 13";
                    break;
                case 13:
                    names[i] = _player14Label.text = @"Player 14";
                    break;
                case 14:
                    names[i] = _player15Label.text = @"Player 15";
                    break;
            }
        }
        else
        {
            names[i] = strName;
        }
        printf("name is %s and time %d is %d\n",[names[i] UTF8String], i,times[i]);
    }
    _score1Label.text = [NSString stringWithFormat:@"%d", times[0]];
    _score2Label.text = [NSString stringWithFormat:@"%d", times[1]];
    _score3Label.text = [NSString stringWithFormat:@"%d", times[2]];
    _score4Label.text = [NSString stringWithFormat:@"%d", times[3]];
    _score5Label.text = [NSString stringWithFormat:@"%d", times[4]];
    _score6Label.text = [NSString stringWithFormat:@"%d", times[5]];
    _score7Label.text = [NSString stringWithFormat:@"%d", times[6]];
    _score8Label.text = [NSString stringWithFormat:@"%d", times[7]];
    _score9Label.text = [NSString stringWithFormat:@"%d", times[8]];
    _score10Label.text = [NSString stringWithFormat:@"%d", times[9]];
    _score11Label.text = [NSString stringWithFormat:@"%d", times[10]];
    _score12Label.text = [NSString stringWithFormat:@"%d", times[11]];
    _score13Label.text = [NSString stringWithFormat:@"%d", times[12]];
    _score14Label.text = [NSString stringWithFormat:@"%d", times[13]];
    _score15Label.text = [NSString stringWithFormat:@"%d", times[14]];
    _player1Label.text = names[0];
    _player2Label.text = names[1];
    _player3Label.text = names[2];
    _player4Label.text = names[3];
    _player5Label.text = names[4];
    _player6Label.text = names[5];
    _player7Label.text = names[6];
    _player8Label.text = names[7];
    _player9Label.text = names[8];
    _player10Label.text = names[9];
    _player11Label.text = names[10];
    _player12Label.text = names[11];
    _player13Label.text = names[12];
    _player14Label.text = names[13];
    _player15Label.text = names[14];
}

- (void)initializeScores {
    int score = 0;
    
    NSString *strName;

    for (int i=0; i < 15; i++)
    {
        score = [[NSUserDefaults standardUserDefaults] integerForKey:[NSString stringWithFormat:@"score%d",i]];
        strName = [[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"name%d",i]];
       
        if (score>0)
        {
            scores[i] = score;
        }
        else
        {
            scores[i] = 15-i;
        }
        if (strName==NULL)
        {
            switch (i)
            {
                case 0:
                    names[i] = _player1Label.text = @"Player 1";
                    break;
                case 1:
                    names[i] = _player2Label.text = @"Player 2";
                    break;
                case 2:
                    names[i] = _player3Label.text = @"Player 3";
                    break;
                case 3:
                    names[i] = _player4Label.text = @"Player 4";
                    break;
                case 4:
                    names[i] = _player5Label.text = @"Player 5";
                    break;
                case 5:
                    names[i] = _player6Label.text = @"Player 6";
                    break;
                case 6:
                    names[i] = _player7Label.text = @"Player 7";
                    break;
                case 7:
                    names[i] = _player8Label.text = @"Player 8";
                    break;
                case 8:
                    names[i] = _player9Label.text = @"Player 9";
                    break;
                case 9:
                    names[i] = _player10Label.text = @"Player 10";
                    break;
                case 10:
                    names[i] = _player11Label.text = @"Player 11";
                    break;
                case 11:
                    names[i] = _player12Label.text = @"Player 12";
                    break;
                case 12:
                    names[i] = _player13Label.text = @"Player 13";
                    break;
                case 13:
                    names[i] = _player14Label.text = @"Player 14";
                    break;
                case 14:
                    names[i] = _player15Label.text = @"Player 15";
                    break;
            }
        }
        else
        {
            names[i] = strName;
        }
        printf("name is %s and score %d is %d\n",[names[i] UTF8String], i,scores[i]);
    }
    _score1Label.text = [NSString stringWithFormat:@"%06d", scores[0]];
    _score2Label.text = [NSString stringWithFormat:@"%06d", scores[1]];
    _score3Label.text = [NSString stringWithFormat:@"%06d", scores[2]];
    _score4Label.text = [NSString stringWithFormat:@"%06d", scores[3]];
    _score5Label.text = [NSString stringWithFormat:@"%06d", scores[4]];
    _score6Label.text = [NSString stringWithFormat:@"%06d", scores[5]];
    _score7Label.text = [NSString stringWithFormat:@"%06d", scores[6]];
    _score8Label.text = [NSString stringWithFormat:@"%06d", scores[7]];
    _score9Label.text = [NSString stringWithFormat:@"%06d", scores[8]];
    _score10Label.text = [NSString stringWithFormat:@"%06d", scores[9]];
    _score11Label.text = [NSString stringWithFormat:@"%06d", scores[10]];
    _score12Label.text = [NSString stringWithFormat:@"%06d", scores[11]];
    _score13Label.text = [NSString stringWithFormat:@"%06d", scores[12]];
    _score14Label.text = [NSString stringWithFormat:@"%06d", scores[13]];
    _score15Label.text = [NSString stringWithFormat:@"%06d", scores[14]];
    _player1Label.text = names[0];
    _player2Label.text = names[1];
    _player3Label.text = names[2];
    _player4Label.text = names[3];
    _player5Label.text = names[4];
    _player6Label.text = names[5];
    _player7Label.text = names[6];
    _player8Label.text = names[7];
    _player9Label.text = names[8];
    _player10Label.text = names[9];
    _player11Label.text = names[10];
    _player12Label.text = names[11];
    _player13Label.text = names[12];
    _player14Label.text = names[13];
    _player15Label.text = names[14];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateScoresWithNewTime:(int)time andNewName:(NSString *)name
{
    int tmpTime = 0;
    NSString *tmpName = @"";

    if (total_time < times[14])
    {
        times[14] = total_time;
        names[14] = name;
        for(int i=0; i<15; i++)
        {
            printf("name %d: %s time: %d\n",i, [names[i] UTF8String],times[i]);
        }
        for(int i=14; i>0; i--)
        {
            for(int j=i-1; j>=0; j--)
            {
                if (times[i]<times[j])
                {
                    tmpTime = times[i];
                   
                    tmpName = [NSString stringWithString:names[i]];
                    
                    times[i] = times[j];
                    names[i] = [NSString stringWithString:names[j]];
                    
                    times[j] = tmpTime;
                    names[j] = [NSString stringWithString:tmpName];
                }
            }
            printf("name %d: %s time: %d, ",i, [names[i] UTF8String],times[i]);
            printf("\n");
        }
    }
    
    _score1Label.text = [NSString stringWithFormat:@"%d:%02d", (int)times[0]/60, (int)times[0]%60];
    _score2Label.text = [NSString stringWithFormat:@"%d:%02d", (int)times[1]/60, (int)times[1]%60];
    _score3Label.text = [NSString stringWithFormat:@"%d:%02d", (int)times[2]/60, (int)times[2]%60];
    _score4Label.text = [NSString stringWithFormat:@"%d:%02d", (int)times[3]/60, (int)times[3]%60];
    _score5Label.text = [NSString stringWithFormat:@"%d:%02d", (int)times[4]/60, (int)times[4]%60];
    _score6Label.text = [NSString stringWithFormat:@"%d:%02d", (int)times[5]/60, (int)times[5]%60];
    _score7Label.text = [NSString stringWithFormat:@"%d:%02d", (int)times[6]/60, (int)times[6]%60];
    _score8Label.text = [NSString stringWithFormat:@"%d:%02d", (int)times[7]/60, (int)times[7]%60];
    _score9Label.text = [NSString stringWithFormat:@"%d:%02d", (int)times[8]/60, (int)times[8]%60];
    _score10Label.text = [NSString stringWithFormat:@"%d:%02d", (int)times[9]/60, (int)times[9]%60];
    _score11Label.text = [NSString stringWithFormat:@"%d:%02d", (int)times[10]/60, (int)times[10]%60];
    _score12Label.text = [NSString stringWithFormat:@"%d:%02d", (int)times[11]/60, (int)times[11]%60];
    _score13Label.text = [NSString stringWithFormat:@"%d:%02d", (int)times[12]/60, (int)times[12]%60];
    _score14Label.text = [NSString stringWithFormat:@"%d:%02d", (int)times[13]/60, (int)times[13]%60];
    _score15Label.text = [NSString stringWithFormat:@"%d:%02d", (int)times[14]/60, (int)times[14]%60];
    _player1Label.text = names[0];
    _player2Label.text = names[1];
    _player3Label.text = names[2];
    _player4Label.text = names[3];
    _player5Label.text = names[4];
    _player6Label.text = names[5];
    _player7Label.text = names[6];
    _player8Label.text = names[7];
    _player9Label.text = names[8];
    _player10Label.text = names[9];
    _player11Label.text = names[10];
    _player12Label.text = names[11];
    _player13Label.text = names[12];
    _player14Label.text = names[13];
    _player15Label.text = names[14];
    
    for(int i=0; i<15; i++)
    {
        [[NSUserDefaults standardUserDefaults] setObject:names[i] forKey:[NSString stringWithFormat:@"name%d",i]];
        [[NSUserDefaults standardUserDefaults] setInteger:times[i] forKey:[NSString stringWithFormat:@"time%d",i]];
    }
}

- (void)updateScoresWithNew:(int)score andNew:(NSString *)name
{
    int tmpScore = 0;
    NSString *tmpName = @"";

    if (score > scores[14])
    {
        scores[14] = score;
        names[14] = name;
        for(int i=0; i<15; i++)
        {
            printf("name %d: %s score: %d\n",i, [names[i] UTF8String],scores[i]);
        }
        for(int i=0; i<15; i++)
        {
            for(int j=i+1; j<15; j++)
            {
                if (scores[i]<scores[j])
                {
                    tmpScore = scores[i];
                   
                    tmpName = [NSString stringWithString:names[i]];
                    
                    scores[i] = scores[j];
                    names[i] = [NSString stringWithString:names[j]];
                    
                    scores[j] = tmpScore;
                    names[j] = [NSString stringWithString:tmpName];
                }
            }
            printf("name %d: %s score: %d, ",i, [names[i] UTF8String],scores[i]);
            printf("\n");
        }
    }
    
    _score1Label.text = [NSString stringWithFormat:@"%06d", scores[0]];
    _score2Label.text = [NSString stringWithFormat:@"%06d", scores[1]];
    _score3Label.text = [NSString stringWithFormat:@"%06d", scores[2]];
    _score4Label.text = [NSString stringWithFormat:@"%06d", scores[3]];
    _score5Label.text = [NSString stringWithFormat:@"%06d", scores[4]];
    _score6Label.text = [NSString stringWithFormat:@"%06d", scores[5]];
    _score7Label.text = [NSString stringWithFormat:@"%06d", scores[6]];
    _score8Label.text = [NSString stringWithFormat:@"%06d", scores[7]];
    _score9Label.text = [NSString stringWithFormat:@"%06d", scores[8]];
    _score10Label.text = [NSString stringWithFormat:@"%06d", scores[9]];
    _score11Label.text = [NSString stringWithFormat:@"%06d", scores[10]];
    _score12Label.text = [NSString stringWithFormat:@"%06d", scores[11]];
    _score13Label.text = [NSString stringWithFormat:@"%06d", scores[12]];
    _score14Label.text = [NSString stringWithFormat:@"%06d", scores[13]];
    _score15Label.text = [NSString stringWithFormat:@"%06d", scores[14]];
    _player1Label.text = names[0];
    _player2Label.text = names[1];
    _player3Label.text = names[2];
    _player4Label.text = names[3];
    _player5Label.text = names[4];
    _player6Label.text = names[5];
    _player7Label.text = names[6];
    _player8Label.text = names[7];
    _player9Label.text = names[8];
    _player10Label.text = names[9];
    _player11Label.text = names[10];
    _player12Label.text = names[11];
    _player13Label.text = names[12];
    _player14Label.text = names[13];
    _player15Label.text = names[14];
    
    for(int i=0; i<15; i++)
    {
        [[NSUserDefaults standardUserDefaults] setObject:names[i] forKey:[NSString stringWithFormat:@"name%d",i]];
        [[NSUserDefaults standardUserDefaults] setInteger:scores[i] forKey:[NSString stringWithFormat:@"score%d",i]];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
    [scoreLabel release];
    [_titleLabel release];
  
    [super dealloc];
}
@end
