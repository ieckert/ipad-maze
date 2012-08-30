//
//  EnemyObject.h
//  Maze
//
//  Created by ian on 8/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameObject.h"
#import "MazeMaker.h"
#import "Queue.h"
#import "ObjectFactory.h"

@interface EnemyObject : GameObject
{
    ObjectFactory *objectFactory;
    NSMutableDictionary *objectInfo;
    
    NSMutableArray *visitedLocationList;
    
    MazeMaker *handleOnMaze;
    
    Queue *animationQueue;
    
    BOOL DFSWasFound;

    BOOL canSee;
    BOOL canHear;
    
    float timerInterval;
    float actionInterval;
    
    NSInteger currentLocationInMazeArray;
}

- (id)initWithSpriteFrame:(CCSpriteFrame *)frame 
               AtLocation:(CGPoint)location
      WithKnowledgeOfMaze:(MazeMaker*)maze;

-(void) depthFirstSearch:(NSInteger)startLocation :(NSInteger)endLocation;
-(NSInteger) locationInMaze;
-(void) prepDFSForUse;

@end
