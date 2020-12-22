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
    [musicTitlePlayer stop];
    
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

- (IBAction)infoButtonTouchedUp:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    CreditsViewController *creditVC = (CreditsViewController*) [sb instantiateViewControllerWithIdentifier:@"CreditsStoryBoardID"];
    //[creditVC->background setBounds:CGRectMake(0, 0, self.view.bounds.size.width*sx, self.view.bounds.size.height*sy)];
    [creditVC.view setFrame:CGRectMake(0, 0, screenWidth*sx, screenHeight*sy)];
    //creditVC.view.frame.size = CGSizeMake(screenWidth*sx, screenHeight*sy);
    [self presentViewController:creditVC animated:YES completion:nil];
    //[self.view addSubview:creditVC.view];
}

- (IBAction)scoreButtonTouchedUp:(id)sender {
   /* UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    FinishGameViewController *scoreVC = (FinishGameViewController*) [sb instantiateViewControllerWithIdentifier:@"FinishGameViewController"];

    [scoreVC.view setFrame:CGRectMake(0, 0, screenWidth*sx, screenHeight*sy)];
    
    [self presentViewController:scoreVC animated:YES completion:nil];*/

    TitleViewController *titleViewController = (TitleViewController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    NSString *playerName = titleViewController.playerNameTextField.text;
   
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    [musicTitlePlayer stop];
    UIViewController *viewController = [sb instantiateViewControllerWithIdentifier:@"FinishGameViewController"];
    FinishGameViewController *finishController = (FinishGameViewController*) viewController;
    finishController->playerName = playerName;
    finishController->score = 0;//cheese->world->score;
    NSString *strScore = [[NSString alloc] initWithFormat:@"Score: %d",finishController->scores[0]];
   
    [titleViewController.view addSubview:finishController.view];
    titleViewController.playerNameTextField.hidden = false;
  
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
        if (![musicTitlePlayer isPlaying])
            [musicTitlePlayer play];
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
    pathForMusicFile = [[NSBundle mainBundle] pathForResource:@"sounds/PHOTO_ALBUM_By_Benjamin_Tissot" ofType:@"mp3"];
    musicFile = [[NSURL alloc] initFileURLWithPath:pathForMusicFile];
    musicTitlePlayer = [AVAudioPlayer alloc];
    [musicTitlePlayer initWithContentsOfURL:musicFile error:NULL];
    musicTitlePlayer.numberOfLoops = -1;
    [musicTitlePlayer prepareToPlay];
    //CGRect screenBounds = [[UIScreen mainScreen] bounds];
    screenScale = [[UIScreen mainScreen] scale];
    CGSize screenSize = CGSizeMake(screenBounds.size.width * screenScale, screenBounds.size.height * screenScale);
    screenWidth = screenSize.width;
    screenHeight = screenSize.height;
    sx = screenWidth/640.0f;
    sy = screenHeight/1136.0f;
    //[_infoButton setFrame:CGRectMake(screenWidth-_infoButton.frame.size.width-10, //10,_infoButton.frame.size.width, _infoButton.frame.size.height)];
    //_playerNameTextField.constraints remo
    //[self.view removeConstraint:_PlayerNameCenterConstraint];
    int yPos = _playButton.center.y + ( titleImageView.center.y - _playButton.center.y)/2;
    //[_playerNameTextField removeConstraints:_playerNameTextField.constraints];
    //[self.view removeConstraints:self.view.constraints];
    //[self.view setTranslatesAutoresizingMaskIntoConstraints:false];
    //NSLog(@"constraints: %d",self.view.translatesAutoresizingMaskIntoConstraints);
    //[_playerNameTextField setCenter:CGPointMake(_playerNameTextField.center.x, 300)];
    //_playerNameTextField.frame.origin.y = 300;
    //UILabel *nameLabel = [[UILabel alloc] init];
    //titleImageView.hidden = true;
    //[nameLabel initWithFrame:CGRectMake(30, 30, 100, 20)];
    //[nameLabel setText:@"sadf"];
    //[self.view addSubview:nameLabel];
    //[_playerNameTextField setFrame:CGRectMake(_playerNameTextField.frame.origin.x, yPos, _playerNameTextField.frame.size.width, _playerNameTextField.frame.size.height)];
    [_infoButton setCenter:CGPointMake(self.view.frame.size.width - _infoButton.frame.size.width ,
                                       self.view.frame.size.height - _infoButton.frame.size.height )];
    [_scoreButton setCenter:CGPointMake(self.view.frame.size.width - _infoButton.frame.size.width*2,
                                       self.view.frame.size.height - _infoButton.frame.size.height )];
    
    float ratio = _playerNameTextField.frame.origin.y/667;
    [_playerNameTextField setCenter:CGPointMake(screenBounds.size.width/2+_playerNameTextField.frame.size.width/4,screenBounds.size.height*ratio+_playerNameTextField.frame.size.height/2)];
    ratio = _nameTextField.frame.origin.y/667;
    [_nameTextField setCenter:CGPointMake(screenBounds.size.width/2-_nameTextField.frame.size.width,_playerNameTextField.center.y)];
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

    [_infoButton release];
    [_NameCenterConstraint release];
    [_PlayerNameCenterConstraint release];
    [_infoButton release];
    [_nameTextField release];
    [_scoreButton release];
    [super dealloc];
}
@end
