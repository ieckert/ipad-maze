//
//  Disjsets.h
//  Maze
//
//  Created by ian on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Disjsets : NSObject
{
    NSMutableArray *arr;
    NSInteger numElements;
}


-(id) initWithSize: (NSInteger) numRows: (NSInteger) numCols;
-(NSInteger) find: (NSInteger)num;
-(void) unionSets: (NSInteger)root1: (NSInteger)root2;
-(void) print;

@end
