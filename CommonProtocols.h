//
//  CommonProtocols.h
//  Maze
//
//  Created by ian on 6/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef Maze_CommonProtocols_h
#define Maze_CommonProtocols_h

typedef enum {
    statCoin,
    statTime
} TrackedStats;

typedef enum {
    cWall,
    cCoin,
    cNone
} MazeContents;

typedef enum {
    dLeft,
    dRight,
    dUp,
    dDown
} BallDirection;

typedef enum {
    sNewState,
    sBallRolling,
    sBallIdle,
    sBallColliding,
    sWallColliding,
    sWallIdle,
    sCoinSpinning,
    sCoinCaptured,
    sCoinIdle,
    sCoinRemoving
} CharacterStates; // 1

typedef enum {
    tNone,
    tWall,
    tBall,
    tCoin
} GameObjectType;

@protocol GameplayLayerDelegate
-(void)createObjectOfType:(GameObjectType)objectType
               atLocation:(CGPoint)spawnLocation
               withZValue:(int)ZValue;

-(void)createBallWithDirection:(BallDirection)ballDirection
                     andPosition:(CGPoint)spawnPosition;
@end



#endif
