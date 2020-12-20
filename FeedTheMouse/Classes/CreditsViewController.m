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
    [super dealloc];
}
@end
