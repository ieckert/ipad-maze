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
#import "DoorObject.h"
#import "ObjectInfoConstants.h"

@implementation ObjectFactory
static ObjectFactory *singleton = nil;

-(id) init {
    if( (self=[super init]) ) {
        objectInfo = [[Pair alloc] init];                           
    }
    return self;
}

- (void) dealloc{
    [objectInfo release];
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

-(Pair *) returnObjectDimensions:(GameObjectType)object
{
    switch (object) {
        case tWall:
            [objectInfo setNum1:[[CCSpriteFrameCache sharedSpriteFrameCache]
                         spriteFrameByName:@"wall_4.png"].rect.size.height];
            [objectInfo setNum2:[[CCSpriteFrameCache sharedSpriteFrameCache]
                          spriteFrameByName:@"wall_4.png"].rect.size.width];
            break;
            
        default:
            break;
    }
    return objectInfo;
}

-(void)createObjectOfType:(NSInteger)objectType
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
        CoinObject *coin = [[CoinObject alloc] initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]
                                                                     spriteFrameByName:@"coin_1.png"] AtLocation:spawnLocation];
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
    else if (objectType == tStart) {
        DoorObject *start = [[DoorObject alloc] initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]
                                                                     spriteFrameByName:@"door_ruby.png"]
                                                         AtLocation:spawnLocation 
                                                           WithType:tStart];
        [sceneSpriteBatchNode addChild:start
                                     z:ZValue
                                   tag:kDoorTagValue];
        [start release];
    }
    else if (objectType == tFinish) {
        DoorObject *finish = [[DoorObject alloc] initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]
                                                                     spriteFrameByName:@"door_purple.png"]
                                                         AtLocation:spawnLocation 
                                                           WithType:tFinish];
        [sceneSpriteBatchNode addChild:finish
                                     z:ZValue
                                   tag:kDoorTagValue];
        [finish release];
    }
    else {
        NSLog(@"trying to create something that doesn't exist");
    }
    
}

@end
