//
//  FinishGameView.m
//  FeedTheMouse
//
//  Created by Jason Ly on 2018-08-21.
//  Copyright © 2018 Jason Ly. All rights reserved.
//
#import "TitleViewController.h"
#import "FinishGameView.h"

@implementation FinishGameView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id) initWithCoder:(NSCoder *)coder
{
    if (self = [super initWithCoder: coder]) {
        pathForMusicFile = [[NSBundle mainBundle] pathForResource:@"sounds/Ukulele_By_Benjamin_Tissot" ofType:@"mp3"];
        musicFile = [[NSURL alloc] initFileURLWithPath:pathForMusicFile];
        musicPlayer = [AVAudioPlayer alloc];
        [musicPlayer initWithContentsOfURL:musicFile error:NULL];
        musicPlayer.numberOfLoops = -1;
        [musicPlayer prepareToPlay];
        [musicPlayer play];
    }
    return self;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    //UIViewController *viewController = [sb instantiateViewControllerWithIdentifier:@"TitleViewController"];
    [musicPlayer stop];
    TitleViewController *titleViewController = (TitleViewController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    titleViewController.playerNameTextField.hidden = false;
    [titleViewController->musicTitlePlayer play];
    //[super addSubview:viewController.view];
    [super removeFromSuperview];
    //super v
    
    /*NSArray *viewsToRemove = [titleViewController.view subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
        break;
    }*/
    
}

@end
