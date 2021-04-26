//
//  ViewController.m
//  FeedTheMouse
//
//  Created by Jason Ly on 2017-02-02.
//  Copyright © 2017 Jason Ly. All rights reserved.
//

#import "FeedTheMouseViewController.h"

@interface FeedTheMouseViewController ()

@end

@implementation FeedTheMouseViewController

/*- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}*/

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    TitleViewController *titleViewController = (TitleViewController*)self.view.superview;
    
    GADRequest *request = [GADRequest request];
    GADMobileAds.sharedInstance.requestConfiguration.testDeviceIdentifiers = @[ kGADSimulatorID ];
    //ca-app-pub-1204392323834204/8130796338
    [GADInterstitialAd loadWithAdUnitID:@"ca-app-pub-3940256099942544/4411468910" request:request completionHandler:^(GADInterstitialAd *ad, NSError *error) {
        if (error) {
            NSLog(@"Failed to load interstitial ad with error: %@", [error localizedDescription]);
            return;
        }
        self.interstitial = ad;
        self.interstitial.fullScreenContentDelegate = self;
    }];
}

/// Tells the delegate that the ad failed to present full screen content.
/*- (void)ad:(nonnull id<GADFullScreenPresentingAd>)ad
didFailToPresentFullScreenContentWithError:(nonnull NSError *)error {
    NSLog(@"Ad did fail to present full screen content.");
}

/// Tells the delegate that the ad presented full screen content.
- (void)adDidPresentFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
    NSLog(@"Ad did present full screen content.");
}

/// Tells the delegate that the ad dismissed full screen content.
- (void)adDidDismissFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
   NSLog(@"Ad did dismiss full screen content.");
}

- (void)displayAd
{
    if (_interstitial) {
        [_interstitial presentFromRootViewController:self];
    } else {
        NSLog(@"Ad wasn't ready");
    }
}
*/
-(void) setPlayerName: (NSString*) name
{
    playerName = name;
}

-(NSString*) getPlayerName
{
    return playerName;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)close
{
    TitleViewController *titleViewController = (TitleViewController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    titleViewController.playerNameTextField.hidden = false;
    [titleViewController->musicTitlePlayer play];
    [self.view removeFromSuperview];
    //[self removeFromParentViewController];
}

- (void)dealloc {
    //[feedTheMouseView release];
    //[ftMouseView release];
   
  
    //[_feedTheMouseView release];
    [super dealloc];
}
@end
