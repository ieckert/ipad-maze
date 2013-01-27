//
//  ObjectBuilder.m
//  Maze
//
//  Created by ian on 1/24/13.
//
//

#import "ObjectBuilder.h"

@implementation ObjectBuilder

+(Pool*)buildPool:(ObjectType)poolType
{
    Pool *pool = nil;
    NSInteger poolSize = C_POOL_SIZE;
    switch (poolType)
    {
        case G_OBJET:
            poolSize = C_POOL_OBJET_SIZE;
            break;
            
        case G_MAZE:
            poolSize = C_POOL_MAZE_SIZE;
            break;
            
        case G_PLAYER:
            
            break;
            
        case G_ENEMY:
            
            break;
            
        case G_ENEMY_SHOOTING:
            
            break;
            
        case G_WALL:
            
            break;
            
        case G_COIN:
            
            break;
            
        case G_DOOR:
            
            break;

        default:
            
            break;
    }
    pool = [[Pool alloc] initWithObjectType:poolType Size:poolSize];
    return pool;
}

+(GameObject*)buildObject:(ObjectType)objectType
{
    GameObject *gameObject;
    switch (objectType)
    {
        case G_OBJET:
            gameObject = [[GameObject alloc] init];
            break;
        
        case G_MAZE:
            gameObject = [[MazeObject alloc] init];
            break;
            
        case G_PLAYER:
            
            break;
        
        case G_ENEMY:
            
            break;
            
        case G_ENEMY_SHOOTING:
            
            break;
            
        case G_WALL:
            
            break;
            
        case G_COIN:
            
            break;
            
        case G_DOOR:
            
            break;

        default:
            
            break;
    }
    return gameObject;
}

@end