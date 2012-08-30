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
            /*will add animations to queue*/
            [self prepDFSForUse];
            [self depthFirstSearch:[self locationInMaze] :[handleOnMaze returnEmptySlotInMaze]];
            action = [CCCallFunc actionWithTarget:self selector:@selector(stateMap)];
            [animationQueue enqueue:action];
            break;
        case sEnemyAggressive:
            NSLog(@"Enemy->Starting sEnemyAggressive");
            
            break; 
        case sEnemySleeping:
            NSLog(@"Enemy->Starting sEnemySleeping");
            for (int i=0; i < 4; i++) {
                id action = [CCRotateBy actionWithDuration:actionInterval angle:45];
                [animationQueue enqueue:action];
            }
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

-(void) timerDuties: (ccTime) dt
{  
//        NSLog(@"minion timer running - animationQueue size: %i", [animationQueue counter]);
        [self stopAllActions];
        id action = nil;  
        action = [animationQueue dequeue];
        if (action != nil) {
//            NSLog(@"minion - ran action");
            [self runAction:action];
        }
}

@end
