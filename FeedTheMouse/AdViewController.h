//
//  AdViewController.h
//  FeedTheMouse
//
//  Created by Jason Ly on 2021-03-04.
//  Copyright © 2021 Jason Ly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TitleViewController.h"
#import "FeedTheMouseViewController.h"
#import "FeedTheMouseView.h"
@import GoogleMobileAds;
@import UIKit;



@interface AdViewController : UIViewController
{
    
}

@property(nonatomic, strong) GADInterstitialAd *interstitial;
@property(nonatomic, retain) IBOutlet UIButton *showAdButton;
@property(nonatomic, retain) IBOutlet UILabel *add5CoinsLabel;
@property(nonatomic, retain) IBOutlet UIImageView *coinImageView;

- (IBAction)displayAd:(id)sender;
- (IBAction)returnToTitleScreen;
@end

