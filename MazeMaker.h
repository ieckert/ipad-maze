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

@interface MazeMaker : NSObject
{
    Disjsets *disjsets;
    NSMutableDictionary *wallList;
    NSMutableDictionary *fullBreakdownOptionsList;
    NSMutableArray *fullKeysList;
    NSInteger rows;
    NSInteger cols;
    NSMutableArray *realMaze;
    
    MazeRequirements *requirements;
}

@property (readwrite) NSInteger rows;
@property (readwrite) NSInteger cols;
@property (readwrite, retain) NSMutableDictionary *wallList;
//can take out singleton
+ (MazeMaker *) createSingleton;
-(id) initWithSizeAndRequirements: 
                (NSInteger) numRows: 
                (NSInteger) numCols: 
            (MazeRequirements*) reqs:   
                (NSMutableArray*) maze;
-(Boolean) createMaze;

@end
