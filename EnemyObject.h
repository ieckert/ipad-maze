//
//  EnemyObject.h
//  Maze
//
//  Created by ian on 8/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameObject.h"
#import "MazeMaker.h"
#import "Queue.h"
#import "ObjectFactory.h"
#import "Constants.h"
#import "ObjectInfoConstants.h"


@interface EnemyObject : GameObject
{    
    ObjectFactory *objectFactory;
    
    /*used when making the enemy logic threaded*/
    NSOperationQueue *logicQueue;
    NSMutableDictionary *objectInfo;
    NSString *tmpSelector;
    
    MazeMaker *handleOnMaze;
    
    Queue *animationQueue;
    
    BOOL canSee;
    BOOL canHear;
    
    float timerInterval;
    float actionInterval;
    
    NSInteger currentLocationInMazeArray;
    NSInteger screenOffset;

}
@property (readwrite) BOOL canSee;
@property (readwrite) BOOL canHear;
-(void) runDFSWith:(NSMutableDictionary*)directions;

- (id)initWithSpriteFrame:(CCSpriteFrame *)frame 
               AtLocation:(CGPoint)location
      WithKnowledgeOfMaze:(MazeMaker*)maze;

-(NSInvocationOperation*)enemyLogic:(EnemyLogic)enemyLogic From:(NSInteger)startLocation To:(NSInteger)endLocation;

-(NSInteger) locationInMaze:(CGPoint)currentLocation; 
-(CGRect)returnSenseBoundingBoxFor:(EnemySense)sense;
-(void)scheduleAnimationTimer;
-(void)changeState:(CharacterStates)newState; 
-(NSInteger) calculateDifferenceFromCurrentLocation:(CGPoint)currentLocation ToTargetsLocation:(CGPoint)targetLocation;
-(BOOL)isObjectVisible:(GameObject*)object 
         WithinThisBox:(CGRect)box
     OutOfTheseObjects:(CCArray*)listOfGameObjects;

@end
