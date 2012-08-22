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
    
    Pair *wallDimensions;
    
    NSInteger smallMazeRows;
    NSInteger smallMazeCols;
    NSInteger smallMazeSize;

    NSInteger largeMazeRows;
    NSInteger largeMazeCols;
    NSInteger largeMazeSize;
    
    NSInteger startingLocation;
    NSInteger endingLocation;
    
    Pair *translationReturnPair;
    Pair *returnMazeDimensions;
}

@property (readwrite) NSInteger smallMazeRows;
@property (readwrite) NSInteger smallMazeCols;
@property (readwrite) NSInteger largeMazeRows;
@property (readwrite) NSInteger largeMazeCols;
@property (readwrite, retain) NSMutableDictionary *wallList;

-(id) initWithHeight: (NSInteger) windowHeight
               Width: (NSInteger) windowWidth
      WallDimensions: (Pair *) wallSpriteDimensions
        Requirements: (MazeRequirements*) reqs
                Maze: (NSMutableArray*) maze;

-(Pair *) createMaze;

-(NSInteger) translateSmallArrayIndexToLarge:(NSInteger) smallArrIndex;
-(NSInteger) translateLargeArrayIndexToSmall:(NSInteger) largeArrIndex;

-(Pair *) translateLargeArrayIndexToXY:(NSInteger) num1;
-(Pair *) translateSmallArrayIndexToXY:(NSInteger) num1;

-(NSInteger) translateLargeXYToArrayIndex:(NSInteger) X:(NSInteger) Y;
-(NSInteger) translateSmallXYToArrayIndex:(NSInteger) X:(NSInteger) Y;

-(NSInteger) returnLargeMazeStartingLocation;

-(NSInteger) returnLargeMazeEndingLocation;

@end
