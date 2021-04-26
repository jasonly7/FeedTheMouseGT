//
//  AdViewController.m
//  FeedTheMouse
//
//  Created by Jason Ly on 2021-03-04.
//  Copyright © 2021 Jason Ly. All rights reserved.
//

#import "AdViewController.h"


@interface AdViewController ()

@end

@implementation AdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GADRequest *request = [GADRequest request];
    GADMobileAds.sharedInstance.requestConfiguration.testDeviceIdentifiers = @[ kGADSimulatorID ];
    //ca-app-pub-3940256099942544/4411468910 test
    //ca-app-pub-1204392323834204/8130796338
    [GADInterstitialAd loadWithAdUnitID:@"ca-app-pub-1204392323834204/8130796338" request:request completionHandler:^(GADInterstitialAd *ad, NSError *error) {
        if (error) {
            NSLog(@"Failed to load interstitial ad with error: %@", [error localizedDescription]);
            return;
        }
        self.interstitial = ad;
        self.interstitial.fullScreenContentDelegate = self;
        _showAdButton.enabled = true;
        _add5CoinsLabel.hidden = false;
        
        //[_coinImageView drawRect:_add5CoinsLabel.bounds];
        _coinImageView.hidden = false;
        UIImage * image = [UIImage imageNamed:@"coin.png"];
        CGSize sacleSize = _add5CoinsLabel.bounds.size;//CGSizeMake(10, 10);
           UIGraphicsBeginImageContextWithOptions(sacleSize, NO, 0.0);
           [image drawInRect:CGRectMake(0, 0, sacleSize.width, sacleSize.height)];
           UIImage * resizedImage = UIGraphicsGetImageFromCurrentImageContext();
           UIGraphicsEndImageContext();
        _coinImageView.image = resizedImage;
        CGFloat x =_add5CoinsLabel.frame.origin.x-_add5CoinsLabel.frame.size.width;
        CGFloat y =_add5CoinsLabel.frame.origin.y;
       
        
        [_add5CoinsLabel setBounds:CGRectMake(x, y, _add5CoinsLabel.frame.size.width, _add5CoinsLabel.frame.size.height)];
       
    }];
   
}

/// Tells the delegate that the ad failed to present full screen content.
- (void)ad:(nonnull id<GADFullScreenPresentingAd>)ad
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
    TitleViewController *titleViewController = (TitleViewController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    titleViewController.nameTextField.hidden = false;
    
    FeedTheMouseViewController *ftmViewController = (FeedTheMouseViewController*) self.presentingViewController;
    FeedTheMouseView *ftmView = (FeedTheMouseView*) ftmViewController.view;
    
    ftmView->game_state = GAME_CONTINUE;
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self.view removeFromSuperview];
   // [self removeFromParentViewController];
   // [self.parentViewController removeFromParentViewController];
    
   
}

- (IBAction)displayAd:(id)sender {
    if (self.interstitial) {
        FeedTheMouseViewController *ftmViewController = (FeedTheMouseViewController*) self.presentingViewController;
        FeedTheMouseView *ftmView = (FeedTheMouseView*) ftmViewController.view;
        [ftmView->musicPlayer stop];
        [ftmView stopSounds];
        [self.interstitial presentFromRootViewController:self];
    } else {
        NSLog(@"Ad wasn't ready");
    }
}

- (IBAction)returnToTitleScreen
{
    FeedTheMouseViewController *ftmViewController = (FeedTheMouseViewController*) self.presentingViewController;
    FeedTheMouseView *ftmView = (FeedTheMouseView*) ftmViewController.view;
    [ftmView->musicPlayer stop];
    [self dismissViewControllerAnimated:YES completion:^{
        [ftmViewController close];
    }];
}
@end
