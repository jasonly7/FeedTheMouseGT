//
//  Quadratic.h
//  Feed The Mouse
//
//  Created by Jason Ly on 2013-10-22.
//  Copyright (c) 2013 Jason Ly. All rights reserved.
//

#import <Foundation/Foundation.h>

#define veryCloseDistance 0.1
@interface Quadratic : NSObject
{
    
}

+ (bool) getLowestRootA: (double) a andB: (double) b andC: (double) c andMinThreshold: (double) minR andMaxThreshold: (double) maxR  andRoot: (NSNumber **) root;
@end
