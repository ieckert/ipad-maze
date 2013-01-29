//
//  Constants.h
//  Maze
//
//  Created by ian on 1/22/13.
//
//

#import <Foundation/Foundation.h>
#import "StringConstants.h"

#define PTM_RATIO ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 100.0 : 50.0)

#define C_BATCH_NODE_CAPACITY 100
#define C_POOL_SIZE 10
#define C_POOL_MAZE_SIZE 5
#define C_POOL_OBJET_SIZE 11

typedef enum {
    G_OBJET,
    G_MAZE,
    G_PLAYER,
    G_ENEMY,
    G_ENEMY_SHOOTING,
    G_WALL,
    G_COIN,
    G_DOOR
} ObjectType;