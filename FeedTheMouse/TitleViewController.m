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
        
       /* CGRect buttonFrame = _playButton.frame;
         buttonFrame.size = CGSizeMake(10,10);
         [_playButton setFrame:buttonFrame];*/
        
        
        
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
    float x =  self.view.center.x - _playButton.frame.size.width/2;
    float y = self.view.center.y;
    CGRect playRect = CGRectMake(0, y, _playButton.frame.size.width, _playButton.frame.size.height);
    //_playButton.frame = CGRectMake(0, y, _playButton.frame.size.width, _playButton.frame.size.height);
    //_playButton.center = self.view.center;
    //[_playButton.imageView setFrame:playRect];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    UIViewController *feedTheMouseViewController = [sb instantiateViewControllerWithIdentifier:@"FeedTheMouseViewController"];
    FeedTheMouseViewController *feedController = (FeedTheMouseViewController*) feedTheMouseViewController;
    //FeedTheMouseViewController *feedController = [[FeedTheMouseViewController alloc] initWithNibName:@"FeedTheMouse" bundle:[NSBundle mainBundle]];
    [feedController setPlayerName:_playerNameTextField.text];
    [musicPlayer stop];
    [self.view addSubview:feedTheMouseViewController.view];
    //[self.view addSubview:feedController.view];
}

-(void)animationCompleted{

   // Whatever you want to do after finish animation

    NSLog(@"Animation Completed");

}

- (void) splashLoop
{
    NSLog(@"Count: %d", count);
    count--;
    if (count<=0)
    {

        NSLog(@"Titleview added");
        timer = [NSTimer scheduledTimerWithTimeInterval: 0.1
            target:self
            selector:@selector(transitionLoop)
            userInfo:nil
            repeats:YES];
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
      //  UIViewController *titleViewController = [sb instantiateViewControllerWithIdentifier:@"TitleViewController"];
        //titleViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
       // [self presentViewController:titleViewController animated:YES completion:NULL];
        [splashTimer invalidate];
        splashTimer = nil;
        
    }
}

- (IBAction)doneEnteringPlayerName:(id)sender {
    
    [sender resignFirstResponder];
}

- (void) transitionLoop
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    
    
    if (splashImageView.alpha > 0)
    {
        splashImageView.alpha -=0.1;
    }
    else
    {
        [musicPlayer play];
        [timer invalidate];
        timer = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    [splashImageView setFrame:(CGRectMake(splashImageView.frame.origin.x, splashImageView.frame.origin.y, screenBounds.size.width,screenBounds.size.height))];
    [titleImageView setFrame:(CGRectMake(titleImageView.frame.origin.x, titleImageView.frame.origin.y, screenBounds.size.width,screenBounds.size.height))];
    float x =  self.view.center.x;// - _playButton.frame.size.width/2;
    float y = self.view.center.y + screenBounds.size.height/4;
   
    [_playButton setCenter:CGPointMake(x, y)];
    count = 5;
    splashTimer = [NSTimer scheduledTimerWithTimeInterval: 1
        target:self
        selector:@selector(splashLoop)
        userInfo:nil
        repeats:YES];
    [_playerNameTextField setBackgroundColor:[UIColor whiteColor]];
    pathForMusicFile = [[NSBundle mainBundle] pathForResource:@"sounds/menu_edited" ofType:@"wav"];
    musicFile = [[NSURL alloc] initFileURLWithPath:pathForMusicFile];
    musicPlayer = [AVAudioPlayer alloc];
    [musicPlayer initWithContentsOfURL:musicFile error:NULL];
    musicPlayer.numberOfLoops = -1;
    [musicPlayer prepareToPlay];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"Play Clicked");
   /* float x =  self.view.center.x - _playButton.frame.size.width/2;
    float y = self.view.center.y;
    CGRect playRect = CGRectMake(0, y, _playButton.frame.size.width, _playButton.frame.size.height);
    [_playButton.imageView setFrame:playRect];*/
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)dealloc {
    //[view release];
  //  [ftmView release];
    [_playerNameTextField release];
    [super dealloc];
}
@end
