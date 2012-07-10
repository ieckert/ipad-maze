//
//  Disjsets.m
//  Maze
//
//  Created by ian on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Disjsets.h"

@implementation Disjsets

-(id)init
{
    self = [super init];
    if (self) {
        //arr
        //numElements
    }
    return self;
}

-(id) initWithSize: (NSInteger) numRows: (NSInteger) numCols
{
    if (self = [super init])
    {
        arr = [[NSMutableArray alloc] init];
        numElements = numRows * numCols;
        for (NSInteger i = 0; i < numElements; i++) {
            [arr insertObject:[NSNumber numberWithInteger:-1] atIndex:i];
        }
    }
    return self;
}

-(NSInteger) find: (NSInteger)num
{
    if ([[arr objectAtIndex:num] intValue] < 0)
    {
        return num;
    }
    else {
        find:[[arr objectAtIndex:num] intValue];
    }
}


-(void) unionSets: (NSInteger)root1: (NSInteger)root2
{
    if( [[arr objectAtIndex:root2]intValue] < [[arr objectAtIndex:root1]intValue] )
    {
        [arr replaceObjectAtIndex:root1 withObject:[NSNumber numberWithInt:root2]];
    }
    else				     
    {
        if( [[arr objectAtIndex:root1]intValue] == [[arr objectAtIndex:root2]intValue] )
        {
            int tmp = [[arr objectAtIndex:root1] intValue];
            tmp--;
            [arr replaceObjectAtIndex:root1 withObject:[NSNumber numberWithInt:tmp]];
        }
        [arr replaceObjectAtIndex:root2 withObject:[NSNumber numberWithInt:root1]];
    }
}

-(Boolean) isComplete
{
    NSInteger count = 0;
    for (NSInteger i = 0; i < [arr count]; i++)
    {
        NSLog(@"in isComplete arr[%i]: %i", i, [[arr objectAtIndex:i]intValue]);
        if ([[arr objectAtIndex:i]intValue] < 0)
        {
            count++;
        }
        if (count > 1)
        {
            return false;
        }
    }
    return true;
 
}

-(void) print
{
    for (int i = 0; i < [arr count]; i++)
    {
        NSLog(@"index: %d, value: %@", i, [arr objectAtIndex:i]);
    }
}
@end
