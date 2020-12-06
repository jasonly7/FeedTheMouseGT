//
//  ViewController.h
//  FeedTheMouse
//
//  Created by Jason Ly on 2017-02-02.
//  Copyright © 2017 Jason Ly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedTheMouseView.h"
#import "TitleViewController.h"

@interface FeedTheMouseViewController : UIViewController
{
   
    NSString *playerName;
    
}
//@property (retain, nonatomic) IBOutlet FeedTheMouseView *feedTheMouseView;
-(void) setPlayerName: (NSString*) name;
-(NSString*) getPlayerName;
@end

