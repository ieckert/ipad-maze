//
//  SpecialArea.h
//  Maze
//
//  Created by  on 10/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameObject.h"
#import "MazeMaker.h"
#import "MazeInterface.h"
#import "ObjectFactory.h"
#import "Constants.h"

@interface ShootingEnemy : GameObject
{
    NSInteger activeAnimDuration;
    NSInteger activeAnimDurationMax;
    NSInteger activeAnimDurationMin;
    
    NSInteger chargingAnimDuration;
    NSInteger chargingAnimDurationMax;
    NSInteger chargingAnimDurationMin;
    
    b2World *world;
    
    
    NSMutableArray *moveableLocations;
    NSInteger shootDirection;
    ShootingEnemyLocation enemyPathLocation;
    bool follow;
    
    MazeMaker *handleOnMaze;
    ObjectFactory *objectFactory;
    NSInteger screenOffset;
}

@property (readwrite) NSInteger chargingAnimDurationMax;
@property (readwrite) NSInteger chargingAnimDurationMin;
@property (readwrite) NSInteger activeAnimDurationMax;
@property (readwrite) NSInteger activeAnimDurationMin;



- (id)initWithWorld:(b2World *)theWorld 
         withDirection:(ShootingEnemyLocation)location 
    withSpriteFrame:(CCSpriteFrame *)frame
WithKnowledgeOfMaze:(MazeMaker*)maze
WillFollowPlayer:(bool)followPlayer;

- (CGPoint)changeLocation;

@end

