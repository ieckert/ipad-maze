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
    /* set of rules for building the maze */
    MazeRequirements *requirements;
        
    /*these structures use the largeMaze cols/rows/size*/
    /*all other classes outside this one will use these*/
    /*if you have a smallMaze array index - transform it to large then access these*/
    NSMutableDictionary *wallList;
    NSMutableArray *realMaze;
   
    /*these structures use the smallMaze cols/rows/size*/
    Disjsets *disjsets;
    NSMutableDictionary *fullBreakdownOptionsList;
    NSMutableArray *fullKeysList;
        
    NSInteger smallMazeRows;
    NSInteger smallMazeCols;
    NSInteger smallMazeSize;

    NSInteger largeMazeRows;
    NSInteger largeMazeCols;
    NSInteger largeMazeSize;
    
    NSInteger startingLocation;
    NSInteger endingLocation;
    
    NSInteger wallHeight;
    NSInteger wallWidth;
    
    Pair *translationReturnPair;
    Pair *returnMazeDimensions;
    
    SceneTypes mazeForScene;
}

@property (readwrite) NSInteger smallMazeRows;
@property (readwrite) NSInteger smallMazeCols;
@property (readwrite) NSInteger largeMazeRows;
@property (readwrite) NSInteger largeMazeCols;
@property (readwrite) SceneTypes mazeForScene;
@property (readwrite, retain) NSMutableDictionary *wallList;

-(id) initWithHeight: (NSInteger) windowHeight
               Width: (NSInteger) windowWidth
      WallDimensions: (Pair *) wallSpriteDimensions
        Requirements: (MazeRequirements*) reqs
                Maze: (NSMutableArray*) maze
            ForScene:(SceneTypes)scene;

-(Pair *) createMaze;

-(NSInteger) translateSmallArrayIndexToLarge:(NSInteger) smallArrIndex;
-(NSInteger) translateLargeArrayIndexToSmall:(NSInteger) largeArrIndex;

-(Pair *) translateLargeArrayIndexToXY:(NSInteger) num1;
-(Pair *) translateSmallArrayIndexToXY:(NSInteger) num1;

-(NSInteger) translateLargeXYToArrayIndex:(NSInteger) X:(NSInteger) Y;
-(NSInteger) translateSmallXYToArrayIndex:(NSInteger) X:(NSInteger) Y;

-(NSInteger) returnLargeMazeStartingLocation;

-(NSInteger) returnLargeMazeEndingLocation;

-(NSInteger) returnEmptySlotInMaze;
-(BOOL) wallBetweenPoint1:(NSInteger)pt1 AndPoint2:(NSInteger)pt2 pointsInSmallMazeFormat:(BOOL)isItASmallMaze;


@end
