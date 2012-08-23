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
            /*will add animations to queue*/
            [self depthFirstSearch:[self locationInMaze] :[handleOnMaze returnEmptySlotInMaze]];
            //action = [CCCallFuncND actionWithTarget:self selector:@selector(changeState:)];
            //[animationQueue enqueue:action];
            break;
        case sEnemyAggressive:
            NSLog(@"Enemy->Starting sEnemyAggressive");
            
            break; 
        case sEnemySleeping:
            NSLog(@"Enemy->Starting sEnemySleeping");
            for (int i =0; i < 4; i++) {
                id action = [CCRotateBy actionWithDuration:0.5 angle:45];
                [animationQueue enqueue:action];
            }
            
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
        NSLog(@"minion timer running - animationQueue size: %i", [animationQueue counter]);
        [self stopAllActions];
        id action = nil;  
        action = [animationQueue dequeue];
        if (action != nil) {
            NSLog(@"minion - ran action");
            [self runAction:action];
        }
//            [self unschedule:@selector(timerDuties:)];
//            NSInteger currentLocation = [objectFactory returnObjectDimensions:tWall].num2 / [handleOnMaze translateLargeXYToArrayIndex:[self position].y-150 :[objectFactory returnObjectDimensions:tWall].num2/[self position].x-150];
//            NSLog(@"before dfs currentLocation: %f, %f", [self position].x, [self position].y);
//            currentLocation = [handleOnMaze translateLargeArrayIndexToSmall:currentLocation];
//            NSLog(@"for dfs currentLocation: %i", currentLocation);
//            [self depthFirstSearch: currentLocation :11];
//            [self schedule:@selector(timerDuties:)];
    
}

@end
