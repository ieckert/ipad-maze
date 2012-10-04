//
//  MinionObject.m
//  Maze
//
//  Created by ian on 8/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MinionObject.h"
#import "ObjectInfoConstants.h"

@implementation MinionObject

/*this will be called after the superclass - EnemyObject - init is called*/

-(void)onEnterTransitionDidFinish
{
    NSLog(@"### Minion on enter");

}

/*the logic of if the enemy is in a certain state and it ends - need to go to the next logical one*/
-(void)stateMap
{
    switch ([self characterState]) {
        case sEnemyPatrol:
            
            break;
        case sEnemyPathFinding:
            [self changeState:sEnemySleeping];
            break;
        case sEnemyAggressive:
            [self changeState:sEnemySleeping];
            break; 
        case sEnemySleeping:
            [self changeState:sEnemyPathFinding];
            break;
        case sEnemyReloading:
            
            break;
        case sEnemyShooting:
            
            break;
        default:
            NSLog(@"Unhandled state in EnemyObject - stateMap - %d", [self characterState]);
            break;
    }
}

-(void)changeState:(CharacterStates)newState {
    
    [self stopAllActions];
        
    id action = nil;
    [self setCharacterState:newState];
    
    switch (newState) {
        case sEnemyPatrol:
            NSLog(@"Enemy->Starting sEnemyPatrol");
            
            break;
        case sEnemyPathFinding:
            NSLog(@"Enemy->Starting sEnemyPathFinding");
            [self setCanSee:TRUE];
            [self setCanHear:TRUE];
            [logicQueue addOperation:[self enemyLogic:kEnemyWanderInMaze From:[self locationInMaze:[self backOnTrack:[self position]]] To:[handleOnMaze returnEmptySlotInMaze]]];
            
            break;
        case sEnemyAggressive:
            NSLog(@"Enemy->Starting sEnemyAggressive");

            break;
        case sEnemySleeping:
            NSLog(@"Enemy->Starting sEnemySleeping");
            [self setCanHear:TRUE];
            [self setCanSee:TRUE];
            [animationQueue removeAllObjects];
            for (int i=0; i < 4; i++) {
                id action = [CCFadeIn actionWithDuration:actionInterval];
                [animationQueue enqueue:action];
            }
//            action = [CCMoveTo actionWithDuration:actionInterval position:[self backOnTrack:[self position]]];
//            [animationQueue enqueue:action];
            action = [CCCallFunc actionWithTarget:self selector:@selector(stateMap)];
            [animationQueue enqueue:action];
            
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

}

-(void)updateStateWithDeltaTime:(ccTime)deltaTime
           andListOfGameObjects:(CCArray*)listOfGameObjects {        
    //most likely need to override this for each implementation of an enemy    
    if (isActive == FALSE)
        return;

    CGRect myBoundingBox = [self adjustedBoundingBox];
    CGRect mySoundBoundingBox = [self returnSenseBoundingBoxFor:kEnemyHearing];
    CGRect myVisionBoundingBox = [self returnSenseBoundingBoxFor:kEnemySight];
    
    BOOL detectedPlayer = false;
    
    [objectInfo setObject:[NSNumber numberWithFloat:[self position].x ] forKey:notificationUserInfoKeyPositionX];
    [objectInfo setObject:[NSNumber numberWithFloat:[self position].y ] forKey:notificationUserInfoKeyPositionY];
    [objectInfo setObject:[NSNumber numberWithInt:tEnemy] forKey:notificationUserInfoObjectType];
    
    for (GameObject *object in listOfGameObjects) {
        CGRect objectBoundingBox = [object adjustedBoundingBox];
/*
        if (canHear && CGRectIntersectsRect(mySoundBoundingBox, objectBoundingBox)) {
            if ([object gameObjectType] == tBall && [object isObjectAudible]){
                NSLog(@"Minion Heard something!!");
                detectedPlayer = true;

            }
            
        }
*/      
        //player touched minion
        if ([object gameObjectType] == tBall && CGRectIntersectsRect([object boundingBox], myBoundingBox)) {
//            NSLog(@"Minion Touched something!!");

        }
        
        if (canSee && CGRectIntersectsRect(myVisionBoundingBox, objectBoundingBox)) {
            if ([object gameObjectType] == tBall && [self isObjectVisible:object 
                                                            WithinThisBox:myVisionBoundingBox 
                                                        OutOfTheseObjects:listOfGameObjects] ) {
                NSLog(@"Minion Saw something!!");
                detectedPlayer = true;
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"positionOfItemToPlace" 
                                                                    object:self
                                                                  userInfo:objectInfo];
                
                [animationQueue removeAllObjects];
                [self setCanSee:FALSE];
                [self setCanHear:FALSE];
                [self changeState:sEnemyAggressive];

                [self chargeForwardFrom:[self position] To:[object position]];
                id action = [CCCallFunc actionWithTarget:self selector:@selector(stateMap)];
                [animationQueue enqueue:action];
            }
        }
     /*
        if (detectedPlayer) {
//                NSLog(@"Minion x: %f y: %f", [self position].x, [self position].y);
//                NSLog(@"Player x: %f y: %f", [object position].x, [object position].y);
//                NSLog(@"Wall width: %i height: %i",[objectFactory returnObjectDimensions:tWall].num1, [objectFactory returnObjectDimensions:tWall].num2);
            NSInteger targetLocation = [self calculateDifferenceFromCurrentLocation:[self position] ToTargetsLocation:[object position]];
//                NSLog(@"self position: %f %f" , [self position].x, [self position].y);
            
            if (targetLocation == -1) {
                NSLog(@"Minion Sense - Could not find solid location of player T.T");
            }
            else {
                //load up all of the animations to get to the character's position
                [animationQueue removeAllObjects];
                
                [self setCanSee:FALSE];
                [self setCanHear:FALSE];
//                NSLog(@"self position: %f %f" , [self position].x, [self position].y);
                
                [self changeState:sEnemyAggressive];
                
                [logicQueue addOperation:[self enemyLogic:kEnemyGoToPlayer From:[self locationInMaze:[self position]] To:targetLocation]];
//                NSLog(@"num in logicQueue: %i", [logicQueue operationCount]);
                //load the animation that will call the next state - once the enemy gets to the players's location
            }    
            break;
        }
        */
    }
    
}

@end
