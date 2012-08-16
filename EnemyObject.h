//
//  EnemyObject.h
//  Maze
//
//  Created by ian on 8/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameObject.h"
#import "MazeMaker.h"

@interface EnemyObject : GameObject
{
    
    NSMutableDictionary *objectInfo;
    
    NSMutableArray *visitedLocationList;
    MazeMaker *handleOnMaze;
    
    BOOL canSee;
    BOOL canHear;
}

- (id)initWithSpriteFrame:(CCSpriteFrame *)frame 
               AtLocation:(CGPoint)location
      WithKnowledgeOfMaze:(MazeMaker*)maze;

@end
