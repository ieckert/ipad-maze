//
//  ObjectFactory.m
//  Maze
//
//  Created by ian on 7/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ObjectFactory.h"

#import "BallObject.h"
#import "CoinObject.h"
#import "WallObject.h"

@implementation ObjectFactory
static ObjectFactory *singleton = nil;

-(id) init {
    if( (self=[super init]) ) {
                               
    }
    return self;
}

- (void) dealloc{
    
    [super dealloc];
}

+ (ObjectFactory *) createSingleton
{
    @synchronized(singleton) {
        if ( !singleton || singleton==nil ) {
            singleton = [[ObjectFactory alloc] init];
        }
    }
    return singleton;
}

-(void)createObjectOfType:(GameObjectType)objectType
               atLocation:(CGPoint)spawnLocation
               withZValue:(int)ZValue
                  inWorld:(b2World*)world
addToSceneSpriteBatchNode:(CCSpriteBatchNode*)sceneSpriteBatchNode
{
    
    if (objectType == tBall) {
        BallObject *ball = [[BallObject alloc] initWithWorld:world
                                                  atLocation:spawnLocation
                                             withSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]
                                                              spriteFrameByName:@"ball_2.png"]];
        [sceneSpriteBatchNode addChild:ball
                                     z:ZValue
                                   tag:kBallTagValue];  
        [ball release];
    }
    else if (objectType == tCoin) {
        NSLog(@"Creating a coin");
        CoinObject *coin = [[CoinObject alloc] initWithSpriteFrameName:
                            @"coin_1.png"];
        [coin setPosition:spawnLocation];
        [sceneSpriteBatchNode addChild:coin
                                     z:ZValue
                                   tag:kCoinTagValue];
        [coin release];
    }
    else if (objectType == tWall) {
        WallObject *wall = [[WallObject alloc] initWithWorld:world
                                                  atLocation:spawnLocation
                                             withSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]
                                                              spriteFrameByName:@"wall_4.png"]];
        [sceneSpriteBatchNode addChild:wall
                                     z:ZValue
                                   tag:kWallTagValue];  
        [wall release];
        
    }
    else {
        NSLog(@"trying to create something that doesn't exist");
    }
    
}

@end
