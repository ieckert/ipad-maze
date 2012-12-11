//
//  ObjectFactory.h
//  Maze
//
//  Created by ian on 7/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GameObject.h"
#import "Constants.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "WallObject.h"
#import "BallObject.h"
#import "CoinObject.h"
#import "Pair.h"
#import "MazeMaker.h"

@interface ObjectFactory : NSObject
{
    Pair *objectInfo;
    ShootingEnemyLocation shootLocation;
    StatsKeeper *statsKeeper;
    
}

+(ObjectFactory *) createSingleton;

-(void)createObjectOfType:(NSInteger const)objectType
               atLocation:(CGPoint)spawnLocation
               withZValue:(int)ZValue
                  inWorld:(b2World*)world
addToSceneSpriteBatchNode:(CCSpriteBatchNode*)sceneSpriteBatchNode;


-(void)createEnemyOfType:(NSInteger const)objectType
              atLocation:(CGPoint)spawnLocation
              withZValue:(int)ZValue
                 inWorld:(b2World*)world
addToSceneSpriteBatchNode:(CCSpriteBatchNode*)sceneSpriteBatchNode
     withKnowledgeOfMaze:(MazeMaker*)maze;

-(Pair *) returnObjectDimensions:(GameObjectType)object;

@end
