//
//  TitleViewController.m
//  FeedTheMouse
//
//  Created by Jason Ly on 2018-08-20.
//  Copyright © 2018 Jason Ly. All rights reserved.
//

#import "TitleViewController.h"

@interface TitleViewController ()

@end

@implementation TitleViewController
- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        NSLog(@"Title view controller created");
    }
    return self;
}

/*-(void) buttonClicked:(UIButton*)sender
{
    NSLog(@"You clicked on button %@", sender.tag);
}*/

- (IBAction)btnClicked:(id)sender
{
    NSLog(@"Button Clicked");
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    UIViewController *feedTheMouseViewController = [sb instantiateViewControllerWithIdentifier:@"FeedTheMouseViewController"];
    
    [self.view addSubview:feedTheMouseViewController.view];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
