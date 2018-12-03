//
//  TitleScreenViewController.m
//  Feed The Mouse
//
//  Created by Jason Ly on 2013-03-23.
//  Copyright (c) 2013 Jason Ly. All rights reserved.
//

#import "TitleScreenViewController.h"
#import "ViewController.h"

@interface TitleScreenViewController ()

@end

@implementation TitleScreenViewController

@synthesize button;

-(IBAction)buttonpressed:(id)sender
{
    ViewController *viewController = [[ViewController alloc] init];
    [self presentViewController:viewController animated:YES completion:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
      
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
