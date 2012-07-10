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

@interface MazeMaker : NSObject
{
    Disjsets *disjsets;
    NSMutableDictionary *wallList;
    NSInteger rows;
    NSInteger cols;
    MazeContents *realMaze;
}

@property (readwrite) NSInteger rows;
@property (readwrite) NSInteger cols;
@property (readwrite, retain) NSMutableDictionary *wallList;

//can take out singleton
+ (MazeMaker *) createSingleton;
-(id) initWithSize: (NSInteger) numRows: (NSInteger) numCols: (MazeContents*) maze;
-(Boolean) createMaze;

@end
