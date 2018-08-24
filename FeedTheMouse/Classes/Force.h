//
//  Force.h
//  Feed The Mouse
//
//  Created by Jason Ly on 2013-01-03.
//  Copyright (c) 2013 Jason Ly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Vector.h"

@interface Force : NSObject
{
@public
    float m; // mass
    Vector *a; // acceleration
}
@end
