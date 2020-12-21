//
//  CreditsViewController.h
//  FeedTheMouse
//
//  Created by Jason Ly on 2020-12-19.
//  Copyright © 2020 Jason Ly. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CreditsViewController : UIViewController
{
    CGFloat screenScale;
    CGFloat sx,sy;
    float screenWidth, screenHeight;
    @public
        IBOutlet UIImageView *background;
}

@property (retain, nonatomic) IBOutlet UILabel *creditsTitleLabel;
@property (retain, nonatomic) IBOutlet UILabel *designerLabel;
@property (retain, nonatomic) IBOutlet UILabel *viTranLabel;
@property (retain, nonatomic) IBOutlet UILabel *programmerLabel;
@property (retain, nonatomic) IBOutlet UILabel *jasonLabel;
@property (retain, nonatomic) IBOutlet UILabel *musicLabel;
@property (retain, nonatomic) IBOutlet UILabel *benLabel;
@property (retain, nonatomic) IBOutlet UILabel *thanksLabel;
@property (retain, nonatomic) IBOutlet UILabel *dukeLabel;


- (IBAction)backButtonClicked:(id)sender;


@end


