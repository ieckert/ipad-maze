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

@interface ObjectFactory : NSObject
{
    
}

+(ObjectFactory *) createSingleton;

-(void)createObjectOfType:(GameObjectType)objectType
               atLocation:(CGPoint)spawnLocation
               withZValue:(int)ZValue
                  inWorld:(b2World*)world
addToSceneSpriteBatchNode:(CCSpriteBatchNode*)sceneSpriteBatchNode;

@end
