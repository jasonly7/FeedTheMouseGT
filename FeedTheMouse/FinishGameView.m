//
//  FinishGameView.m
//  FeedTheMouse
//
//  Created by Jason Ly on 2018-08-21.
//  Copyright © 2018 Jason Ly. All rights reserved.
//

#import "FinishGameView.h"

@implementation FinishGameView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    UIViewController *viewController = [sb instantiateViewControllerWithIdentifier:@"TitleViewController"];
    
    [super addSubview:viewController.view];
    
}

@end
