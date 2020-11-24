//
//  NavigationControllerViewController.m
//  FeedTheMouse
//
//  Created by Jason Ly on 2020-09-09.
//  Copyright © 2020 Jason Ly. All rights reserved.
//

#import "NavigationControllerViewController.h"

@interface NavigationControllerViewController ()

@end

@implementation NavigationControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // self.navigationController.delegate = self;
   
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController*)fromVC
                                                 toViewController:(UIViewController*)toVC
{
    if (operation == UINavigationControllerOperationPush)
        return [[PushAnimator alloc] init];

    if (operation == UINavigationControllerOperationPop)
        return [[PopAnimator alloc] init];
    
    

    return nil;
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
