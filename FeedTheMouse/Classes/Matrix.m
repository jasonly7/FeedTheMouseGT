//
//  Matrix.m
//  Feed The Mouse
//
//  Created by Jason Ly on 2013-10-19.
//  Copyright (c) 2013 Jason Ly. All rights reserved.
//

#import "Matrix.h"

@implementation Matrix


+ (Matrix *)arrayOfWidth:(NSInteger)width andHeight:(NSInteger)height {
    return [[[self alloc] initWithWidth:width andHeight:height] autorelease];
}

- (id) init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (id)initWithWidth:(NSInteger)width andHeight:(NSInteger)height {
    self = [self init];
  //  result = [[Matrix alloc] init];
    M = [[NSMutableArray alloc] initWithCapacity:height];
   
    for(int i = 0; i < height; i++) {
         NSMutableArray *inner = [[NSMutableArray alloc] initWithCapacity:width];
       [M addObject:inner];
        [inner release];
    }
  //  [inner release];
  //  [self release];
    return self;
}

+ (Matrix *)matrixA:(Matrix *)matrixA multiplyMatrixB:(Matrix *)matrixB {
    int aRow = [matrixA->M count];
    int aColumn = [[matrixA->M objectAtIndex:0] count];
    int bRow = [matrixB->M count];
    int bColumn = [[matrixB->M objectAtIndex:0] count];
    Matrix *R = [[[Matrix alloc] init] autorelease];
    if (aColumn == bRow)
    {
        R = [R initWithWidth:(bColumn) andHeight:aRow];
        //[[Matrix alloc] initWithCapacity:aRow];
        for (int i = 0; i < aRow; i++) {
            
            for (int j = 0; j < bColumn; j++) {
                double sum = 0.0;
                for (int k = 0; k < aColumn; k++) {
//                    Matrix *innerA = [matrixA->M objectAtIndex:i];
                    double numA = [[[matrixA->M objectAtIndex:i] objectAtIndex:k ] doubleValue];
//                    Matrix * innerB = [matrixB->M objectAtIndex:k];
                    double numB = [[[matrixB->M objectAtIndex:k] objectAtIndex:j] doubleValue];
                    sum += numA * numB;
                }
                NSNumber *result = [NSNumber numberWithDouble:sum];
                [[R->M objectAtIndex:i] insertObject:result atIndex:j];
            }
        }
    }
    
    return R;
}

+ (Matrix *)scale:(double)s multiplyMatrix:(Matrix *)matrix
{
    int Rows = [matrix->M count];
    int Columns = [[matrix->M objectAtIndex:0] count];
    Matrix *R = [[[Matrix alloc] init] autorelease];
    R = [R initWithWidth:Columns  andHeight:Rows];
    for (int i = 0; i < Rows; i++) {
        
        for (int j = 0; j < Columns; j++) {
            double num =s * [[[matrix->M objectAtIndex:i] objectAtIndex:j] doubleValue];
            NSNumber *result = [NSNumber numberWithDouble:num];
            [[R->M objectAtIndex:i] insertObject:result atIndex:j];
        }
    }

    return R;
}

- (void) dealloc {
    
    for(int i = 0; i < [M count]; i++) {
        [[M objectAtIndex:i] removeAllObjects];
    }
   // [M release];
    [super dealloc];
}

@end
