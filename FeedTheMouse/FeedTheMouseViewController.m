//
//  ViewController.m
//  FeedTheMouse
//
//  Created by Jason Ly on 2017-02-02.
//  Copyright © 2017 Jason Ly. All rights reserved.
//

#import "FeedTheMouseViewController.h"

@interface FeedTheMouseViewController ()

@end

@implementation FeedTheMouseViewController

/*- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}*/

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    TitleViewController *titleViewController = (TitleViewController*)self.view.superview;
}

-(void) setPlayerName: (NSString*) name
{
    playerName = name;
}

-(NSString*) getPlayerName
{
    return playerName;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc {
    //[feedTheMouseView release];
    //[ftMouseView release];
   
  
    //[_feedTheMouseView release];
    [super dealloc];
}
@end
