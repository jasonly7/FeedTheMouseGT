//
//  SplashViewController.m
//  FeedTheMouse
//
//  Created by Jason Ly on 2020-09-08.
//  Copyright © 2020 Jason Ly. All rights reserved.
//

#import "SplashViewController.h"


@interface SplashViewController ()

@end

@implementation SplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
   
    // Do any additional setup after loading the view.
    count = 5;
    timer = [NSTimer scheduledTimerWithTimeInterval: 1
                target:self
                selector:@selector(splashLoop)
                userInfo:nil
                repeats:YES];

    //[splashImageView setFrame:(CGRectMake(splashImageView.frame.origin.x, splashImageView.frame.origin.y, screenBounds.size.width,screenBounds.size.height))];
}

- (void) dissolve
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    UIViewController *titleViewController = [sb instantiateViewControllerWithIdentifier:@"TitleViewController"];
    
    if (splashImageView.alpha > 0)
    {
        splashImageView.alpha -=0.1;
    }
    else
    {
        titleViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:titleViewController animated:YES completion:NULL];
        
        [timer2 invalidate];
        timer2 = nil;
    }
}

- (void) splashLoop
{
    //NSLog(@"Count: %d", count);
    count--;
    if (count<=0)
    {

        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        UIViewController *titleViewController = [sb instantiateViewControllerWithIdentifier:@"TitleViewController"];
        titleViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:titleViewController animated:YES completion:NULL];
        [timer invalidate];
        timer = nil;
        
    }
    
}

-(void)animationCompleted{

   // Whatever you want to do after finish animation

    //NSLog(@"Animation Completed");

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
