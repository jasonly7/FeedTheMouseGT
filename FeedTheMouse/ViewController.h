//
//  ViewController.h
//  FeedTheMouse
//
//  Created by Jason Ly on 2021-02-28.
//  Copyright © 2021 Jason Ly. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "Pods/FBAudienceNetwork.framework/Headers/FBInterstitialAd.h"
//#import "FBAudienceNetwork/FBInterstitialAd.h>
//@import FBAudienceNetwork;
//@import FBSDKCoreKit;

//#import <AmazonAd/AmazonAdInterstitial.h>
//#import <AmazonAd/AmazonAdOptions.h>
//#import <AmazonAd/AmazonAdError.h>
//@import GoogleMobileAds;
@interface ViewController : UIViewController<AmazonAdInterstitialDelegate>//<FBInterstitialAdDelegate>
{
    
}
//@property (nonatomic, retain) IBOutlet UIButton *playButton;
//@property (nonatomic, strong) FBInterstitialAd *interstitialAd;
@property (nonatomic, retain) AmazonAdInterstitial *interstitial;
//@property (retain, nonatomic) IBOutlet UIButton *loadAdButton;
//@property (strong, nonatomic) IBOutlet UILabel *loadStatusLabel;
//@property(nonatomic, strong) GADInterstitialAd *interstitial;
- (IBAction)loadAmazonInterstitial:(id )sender;

@end
