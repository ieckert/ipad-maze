//
//  EnemyObject.m
//  Maze
//
//  Created by ian on 8/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EnemyObject.h"
#import "ObjectInfoConstants.h"

@implementation EnemyObject

- (id)initWithSpriteFrame:(CCSpriteFrame *)frame 
               AtLocation:(CGPoint)location
      WithKnowledgeOfMaze:(MazeMaker*)maze
{
    if ((self = [super init])) {
        gameObjectType = tEnemy;
        canSee = true;
        canHear = true;
        [self changeState:sEnemyPatrol]; 
        
        [self setDisplayFrame:frame];
        [self setPosition:location];
        
        objectInfo = [[NSMutableDictionary alloc] init];
        [objectInfo setObject:[NSNumber numberWithFloat:[self position].x ] forKey:notificationUserInfoKeyPositionX];
        [objectInfo setObject:[NSNumber numberWithFloat:[self position].y ] forKey:notificationUserInfoKeyPositionY];
        [objectInfo setObject:[NSNumber numberWithInt:tEnemy] forKey:notificationUserInfoObjectType];
        
        handleOnMaze = maze;
        int arrSize = [[handleOnMaze wallList] count];
        visitedLocationList = [[NSMutableArray alloc] initWithCapacity:arrSize];
        for (int i = 0; i < arrSize; i++) {
            [visitedLocationList insertObject:[NSNumber numberWithInt:0] atIndex:i];
        }
    }
    return self;
}

-(id) init {
    if( (self=[super init]) ) {
        //        CCLOG(@"### Enemy initialized");
        
    }
    return self;
}

- (void) dealloc{

    [objectInfo release];
    
    [super dealloc];
}

-(void)changeState:(CharacterStates)newState {
    [self stopAllActions];
    id action = nil;
    [self setCharacterState:sNewState];

    switch (newState) {
        case sEnemyPatrol:
            NSLog(@"Enemy->Starting sEnemyPatrol");
            
            break;
        case sEnemyPathFinding:
            NSLog(@"Enemy->Starting sEnemyPathFinding");
            int X, Y;
            int currentPosition, finalDestination;
            
            X = [[objectInfo objectForKey:notificationUserInfoKeyPositionX]intValue];
            Y = [[objectInfo objectForKey:notificationUserInfoKeyPositionY]intValue];
            currentPosition = [handleOnMaze translateLargeXYToArrayIndex:X :Y];
            
            /* mark current location as "visited" - 1 */
            [visitedLocationList replaceObjectAtIndex:currentPosition withObject:[NSNumber numberWithInt:1]];

            finalDestination = arc4random()%[visitedLocationList count];
            
            
            break;
        case sEnemyAggressive:
            NSLog(@"Enemy->Starting sEnemyAggressive");

            break; 
        case sEnemySleeping:
            NSLog(@"Enemy->Starting sEnemySleeping");
            
            break;
        case sEnemyReloading:
            NSLog(@"Enemy->Starting sEnemyReloading");
            
            break;
        case sEnemyShooting:
            NSLog(@"Enemy->Starting sEnemyShooting");
            
            break;
        default:
            NSLog(@"Unhandled state %d in EnemyObject", newState);
            break;
    }
    if (action != nil) {
        [self runAction:action];
    }
}

-(void)updateStateWithDeltaTime:(ccTime)deltaTime
           andListOfGameObjects:(CCArray*)listOfGameObjects {        
//most likely need to override this for each implementation of an enemy    
    if (isActive == FALSE)
        return;
    
    [objectInfo setObject:[NSNumber numberWithFloat:[self position].x ] forKey:notificationUserInfoKeyPositionX];
    [objectInfo setObject:[NSNumber numberWithFloat:[self position].y ] forKey:notificationUserInfoKeyPositionY];
    
    CGRect myBoundingBox = [self adjustedBoundingBox];
    for (GameObject *object in listOfGameObjects) {
        
        
    }
    
}

-(void)initAnimations {
    NSLog(@"enemyObject - must override initAnimations!");
}

@end
