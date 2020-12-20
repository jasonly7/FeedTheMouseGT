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
- (IBAction)backButtonClicked:(id)sender;


@end


