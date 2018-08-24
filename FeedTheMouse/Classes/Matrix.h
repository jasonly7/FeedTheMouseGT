//
//  Matrix.h
//  Feed The Mouse
//
//  Created by Jason Ly on 2013-10-19.
//  Copyright (c) 2013 Jason Ly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Matrix : NSObject
{
@public
    NSMutableArray *M;
    Matrix *result;
}
+ (Matrix *)arrayOfWidth:(NSInteger)width andHeight:(NSInteger)height;
- (id)initWithWidth:(NSInteger)width andHeight:(NSInteger)height;
+ (Matrix *)matrixA:(Matrix *)matrixA multiplyMatrixB:(Matrix *)matrixB;
+ (Matrix *)scale:(double) s multiplyMatrix:(Matrix *)matrix;
- (void)dealloc;
@end
