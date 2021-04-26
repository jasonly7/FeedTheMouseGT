//
//  ViewController.m
//  FeedTheMouse
//
//  Created by Jason Ly on 2021-02-28.
//  Copyright © 2021 Jason Ly. All rights reserved.
//


#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.interstitial = [AmazonAdInterstitial amazonAdInterstitial];
    self.interstitial.delegate = self;
    // Instantiate an InterstitialAd object.
      // NOTE: the placement ID will eventually identify this as your App, you can ignore it for
      // now, while you are testing and replace it later when you have signed up.
      // While you are using this temporary code you will only get test ads and if you release
      // your code like this to the App Store your users will not receive ads (you will get a no fill error).
    /*self.interstitialAd = [[FBInterstitialAd alloc] initWithPlacementID:@"1115581395553027"];
      self.interstitialAd.delegate = self;
      // For auto play video ads, it's recommended to load the ad
      // at least 30 seconds before it is shown
      [self.interstitialAd loadAd];
    
   
    // Create an interstitial
    self.interstitial = [AmazonAdInterstitial amazonAdInterstitial];
       //self->_interstitial =

       // Register the ViewController with the delegate to receive callbacks.
       self.interstitial.delegate = self;
    
    self->_loadStatusLabel.text = @"Loading interstitial...";

    // Set the adOptions.
    AmazonAdOptions *options = [AmazonAdOptions options];
     
   // Turn on isTestRequest to load a test interstitial
   // options->isTestRequest = YES;

    // Load an interstitial
    [self.interstitial load:options];
    [self.interstitial presentFromViewController:self];*/
    /*GADRequest *request = [GADRequest request];
      [GADInterstitialAd loadWithAdUnitID:@"ca-app-pub-3940256099942544/4411468910"
                                  request:request
                        completionHandler:^(GADInterstitialAd *ad, NSError *error) {
        if (error) {
          NSLog(@"Failed to load interstitial ad with error: %@", [error localizedDescription]);
          return;
        }
        self.interstitial = ad;
        self.interstitial.fullScreenContentDelegate = self;
          GADMobileAds.sharedInstance.requestConfiguration.testDeviceIdentifiers = @[kGADSimulatorID];
      }];*/
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
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

- (IBAction)doSomething:(id)sender {
  
  if (self.interstitial) {
    [self.interstitial presentFromRootViewController:self];
  } else {
    NSLog(@"Ad wasn't ready");
  }
}*/
/*- (IBAction)loadAmazonInterstitial:(id *)sender
{
    self->_loadStatusLabel.text = @"Loading interstitial...";

    // Set the adOptions.
    AmazonAdOptions *options = [AmazonAdOptions options];

   // Turn on isTestRequest to load a test interstitial
   // options->isTestRequest = YES;


    // Load an interstitial
    [self.interstitial load:options];
}

- (IBAction)showAmazonInterstitial:(UIButton *)sender
{
    // Present the interstitial on screen
    [self.interstitial presentFromViewController:self];
}

#pragma mark - AmazonAdInterstitialDelegate
- (void)interstitialDidLoad:(AmazonAdInterstitial *)interstitial
{
    NSLog(@"Interstial loaded.");
    self.loadStatusLabel.text = @"Interstitial loaded.";
}

- (void)interstitialDidFailToLoad:(AmazonAdInterstitial *)interstitial withError:(AmazonAdError *)error
{
    NSLog(@"Interstitial failed to load.");
    self.loadStatusLabel.text = @"Interstitial failed to load.";
}

- (void)interstitialWillPresent:(AmazonAdInterstitial *)interstitial
{
    NSLog(@"Interstitial will be presented.");
}

- (void)interstitialDidPresent:(AmazonAdInterstitial *)interstitial
{
    NSLog(@"Interstitial has been presented.");
}

- (void)interstitialWillDismiss:(AmazonAdInterstitial *)interstitial
{
    NSLog(@"Interstitial will be dismissed.");
}

- (void)interstitialDidDismiss:(AmazonAdInterstitial *)interstitial
{
    NSLog(@"Interstitial has been dismissed.");
    self.loadStatusLabel.text = @"No interstitial loaded.";
}*/

/*- (void)interstitialAdDidLoad:(FBInterstitialAd *)interstitialAd
{
  NSLog(@"Ad is loaded and ready to be displayed");

  if (interstitialAd && interstitialAd.isAdValid) {
    // You can now display the full screen ad using this code:
    [interstitialAd showAdFromRootViewController:self];
  }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  // Override point for customization after application launch.
    [[AmazonAdRegistration sharedRegistration] setAppKey:@"a031f5248b7e4e6992f1957b35a87d57"];
    return true;
}*/
#pragma mark - IBAction

/*- (IBAction)loadAmazonInterstitial:(id )sender
{
    self.loadStatusLabel.text = @"Loading interstitial...";
    AmazonAdOptions *options = [AmazonAdOptions options];
    options.isTestRequest = YES;
    [self.interstitial load:options];
}

- (IBAction)showAmazonInterstitial:(UIButton *)sender
{
    [self.interstitial presentFromViewController:self];
}

#pragma mark - AmazonAdInterstitialDelegate

- (void)interstitialDidLoad:(AmazonAdInterstitial *)interstitial
{
    NSLog(@"Interstial loaded.");
    self.loadStatusLabel.text = @"Interstitial loaded.";
}

- (void)interstitialDidFailToLoad:(AmazonAdInterstitial *)interstitial withError:(AmazonAdError *)error
{
    NSLog(@"Interstitial failed to load.");
    self.loadStatusLabel.text = @"Interstitial failed to load.";
}

- (void)interstitialWillPresent:(AmazonAdInterstitial *)interstitial
{
    NSLog(@"Interstitial will be presented.");
}

- (void)interstitialDidPresent:(AmazonAdInterstitial *)interstitial
{
    NSLog(@"Interstitial has been presented.");
}

- (void)interstitialWillDismiss:(AmazonAdInterstitial *)interstitial
{
    NSLog(@"Interstitial will be dismissed.");
}

- (void)interstitialDidDismiss:(AmazonAdInterstitial *)interstitial
{
    NSLog(@"Interstitial has been dismissed.");
    self.loadStatusLabel.text = @"No interstitial loaded.";
}*/
@end
