//
//  Quadratic.h
//  Feed The Mouse
//
//  Created by Jason Ly on 2013-10-22.
//  Copyright (c) 2013 Jason Ly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Quadratic : NSObject
{
    
}

+ (bool) getLowestRootA: (double) a andB: (double) b andC: (double) c andThreshold: (double) maxR andRoot: (NSNumber **) root;
@end
