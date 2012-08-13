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
    sCoinRemoving,
    sDoorIdle,
    sDoorInteracting
} CharacterStates; // 1

@protocol GameplayLayerDelegate
-(void)createObjectOfType:(NSInteger const)objectType
               atLocation:(CGPoint)spawnLocation
               withZValue:(int)ZValue;
@end



#endif
