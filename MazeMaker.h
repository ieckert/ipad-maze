//
//  MazeMaker.h
//  Maze
//
//  Created by ian on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Disjsets.h"
#import "CommonProtocols.h"
#import "MazeRequirements.h"
#import "Pair.h"

@interface MazeMaker : NSObject
{
    /* local copy of maze - might not need? */
    NSMutableArray *realMaze;
    
    /* set of rules for building the maze */
    MazeRequirements *requirements;

    Disjsets *disjsets;

    NSMutableDictionary *wallList;
    
    NSMutableDictionary *fullBreakdownOptionsList;
    NSMutableArray *fullKeysList;
    
    NSInteger rows;
    NSInteger cols;
    
    Pair *translationReturnPair;
}

@property (readwrite) NSInteger rows;
@property (readwrite) NSInteger cols;
@property (readwrite, assign) NSMutableDictionary *wallList;

-(id) initWithSizeAndRequirements: 
                (NSInteger) numRows: 
                (NSInteger) numCols: 
            (MazeRequirements*) reqs:   
                (NSMutableArray*) maze;

-(Boolean) createMaze;

-(NSInteger) translateSmallArrayIndexToLarge:(NSInteger) smallArrIndex;

-(Pair *) translateLargeArrayIndexToXY:(NSInteger) num1;
-(Pair *) translateSmallArrayIndexToXY:(NSInteger) num1;

-(NSInteger) translateLargeXYToArrayIndex:(NSInteger) X:(NSInteger) Y;
-(NSInteger) translateSmallXYToArrayIndex:(NSInteger) X:(NSInteger) Y;

@end
