//
//  SplashViewController.h
//  FeedTheMouse
//
//  Created by Jason Ly on 2020-09-08.
//  Copyright © 2020 Jason Ly. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SplashViewController : UIViewController
{
    IBOutlet UIImageView *splashImageView;
    NSTimer *timer;
    NSTimer *timer2;
    CGFloat screenScale;
    CGFloat sx,sy;
    float screenWidth, screenHeight;
    int count;
    int alpha;
}

@end

NS_ASSUME_NONNULL_END
