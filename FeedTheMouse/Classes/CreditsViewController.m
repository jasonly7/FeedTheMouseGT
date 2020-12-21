//
//  CreditsViewController.m
//  FeedTheMouse
//
//  Created by Jason Ly on 2020-12-19.
//  Copyright © 2020 Jason Ly. All rights reserved.
//

#import "CreditsViewController.h"
#import "TitleViewController.h"
@interface CreditsViewController ()

@end

@implementation CreditsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    screenScale = [[UIScreen mainScreen] scale];
    CGSize screenSize = CGSizeMake(screenBounds.size.width * screenScale, screenBounds.size.height * screenScale);
    screenWidth = screenSize.width;
    screenHeight = screenSize.height;
    sx = screenWidth/640.0f;
    sy = screenHeight/1136.0f;
    [background setFrame:CGRectMake(0, 0, screenBounds.size.width, screenBounds.size.height)];
    NSLog(@"credits label y: %f", _creditsTitleLabel.frame.origin.y);
    NSLog(@"background height: %f",screenBounds.size.height );
    float ratio = _creditsTitleLabel.frame.origin.y/667;
    [_creditsTitleLabel setCenter:CGPointMake(screenBounds.size.width/2,screenBounds.size.height*ratio+_creditsTitleLabel.frame.size.height/2)];
    ratio = _designerLabel.frame.origin.y/667;
    [_designerLabel setCenter:CGPointMake(screenBounds.size.width/2,screenBounds.size.height*ratio+_designerLabel.frame.size.height/2)];
    ratio = _viTranLabel.frame.origin.y/667;
    [_viTranLabel setCenter:CGPointMake(screenBounds.size.width/2,screenBounds.size.height*ratio+_viTranLabel.frame.size.height/2)];
    ratio = _programmerLabel.frame.origin.y/667;
    [_programmerLabel setCenter:CGPointMake(screenBounds.size.width/2,screenBounds.size.height*ratio+_programmerLabel.frame.size.height/2)];
    ratio = _jasonLabel.frame.origin.y/667;
    [_jasonLabel setCenter:CGPointMake(screenBounds.size.width/2,screenBounds.size.height*ratio+_jasonLabel.frame.size.height/2)];
    ratio = _musicLabel.frame.origin.y/667;
    [_musicLabel setCenter:CGPointMake(screenBounds.size.width/2,screenBounds.size.height*ratio+_musicLabel.frame.size.height/2)];
    ratio = _benLabel.frame.origin.y/667;
    [_benLabel setCenter:CGPointMake(screenBounds.size.width/2,screenBounds.size.height*ratio+_benLabel.frame.size.height/2)];
    ratio = _thanksLabel.frame.origin.y/667;
    [_thanksLabel setCenter:CGPointMake(screenBounds.size.width/2,screenBounds.size.height*ratio+_thanksLabel.frame.size.height/2)];
    ratio = _dukeLabel.frame.origin.y/667;
    [_dukeLabel setCenter:CGPointMake(screenBounds.size.width/2,screenBounds.size.height*ratio+_dukeLabel.frame.size.height/2)];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)backButtonClicked:(id)sender {
    //TitleViewController *titleViewController = (TitleViewController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    //[self presentViewController:titleViewController animated:YES completion:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)dealloc {
    [background release];
    [_creditsTitleLabel release];
    [_designerLabel release];
    [_viTranLabel release];
    [_programmerLabel release];
    [_jasonLabel release];
    [_musicLabel release];
    [_benLabel release];
    [_thanksLabel release];
    [_dukeLabel release];
    [super dealloc];
}
@end
