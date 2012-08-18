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
        animationQueue = [[Queue alloc] init];
        
        gameObjectType = tEnemy;
        DFSWasFound = false;
        activeTimer = false;
        canSee = true;
        canHear = true;
        [self changeState:sEnemySleeping]; 
        
        [self setDisplayFrame:frame];
        [self setPosition:location];
        
        objectInfo = [[NSMutableDictionary alloc] init];
        [objectInfo setObject:[NSNumber numberWithFloat:[self position].x ] forKey:notificationUserInfoKeyPositionX];
        [objectInfo setObject:[NSNumber numberWithFloat:[self position].y ] forKey:notificationUserInfoKeyPositionY];
        [objectInfo setObject:[NSNumber numberWithInt:tEnemy] forKey:notificationUserInfoObjectType];
        
        handleOnMaze = maze;
        int arrSize = [[handleOnMaze wallList] count];
        NSLog(@"slots in maze: %i", arrSize);
        visitedLocationList = [[NSMutableArray alloc] initWithCapacity:arrSize];
        for (int i = 0; i < arrSize; i++) {
            [visitedLocationList insertObject:[NSNumber numberWithInt:0] atIndex:i];
        }
        [self setTimer];
        [self depthFirstSearch:0 :11];
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
//might have to do the timer earlier
    NSLog(@"enemy dealloc called");
    [repeatingTimer invalidate];
    [animationQueue release];
    
    [objectInfo release];
    [visitedLocationList release];
    [animationQueue release];
    [super dealloc];
}

-(void)changeState:(CharacterStates)newState {
    NSLog(@"enemyObject - must override changeState!");

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

-(void) setTimer
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.5
                                                      target:self selector:@selector(timerDuties)
                                                    userInfo:nil repeats:YES];
    repeatingTimer = timer;    
}

-(void) timerDuties
{  
    NSLog(@"enemyObject - must override timerDuties!");

}

-(void) depthFirstSearch:(NSInteger)startLocation :(NSInteger)endLocation
{
//    NSLog(@"inDFS");
    //use handleOnMaze wallList for the path
    //use visitedLocationList for the DFS 'coloring'
    
    [visitedLocationList replaceObjectAtIndex:startLocation withObject:[NSNumber numberWithInt:1]];
    
    if (startLocation == endLocation) {
        DFSWasFound = true;
        CGPoint animPoint;
        animPoint.x = (48*[handleOnMaze translateLargeArrayIndexToXY:[handleOnMaze translateSmallArrayIndexToLarge:endLocation]].num1)+150;
        animPoint.y = (48*[handleOnMaze translateLargeArrayIndexToXY:[handleOnMaze translateSmallArrayIndexToLarge:endLocation]].num2)+150;
        
        id action = [CCMoveTo actionWithDuration:1.0f position:animPoint];
        [animationQueue enqueue:action];
        
        NSLog(@"end location found: %i", endLocation); 
        /*after this - it is the dfs path to the goal*/
    }
    else {
        int newLocation = [self checkUnvisitedPathsFromLocation:startLocation];
        while (newLocation != -1) {
            CGPoint animPoint;

            if (!DFSWasFound) {
                NSLog(@"in while DFS at: %i", newLocation);
                animPoint.x = (48*[handleOnMaze translateLargeArrayIndexToXY:[handleOnMaze translateSmallArrayIndexToLarge:newLocation]].num1)+150;
                animPoint.y = (48*[handleOnMaze translateLargeArrayIndexToXY:[handleOnMaze translateSmallArrayIndexToLarge:newLocation]].num2)+150;
                
                id action = [CCMoveTo actionWithDuration:1.0f position:animPoint];
                [animationQueue enqueue:action];
            }
            else {
                
            }
            
            [self depthFirstSearch:newLocation :endLocation];
            newLocation = [self checkUnvisitedPathsFromLocation:startLocation];
            
            if (!DFSWasFound) {
                NSLog(@"in while DFS at: %i", startLocation);
                animPoint.x = (48*[handleOnMaze translateLargeArrayIndexToXY:[handleOnMaze translateSmallArrayIndexToLarge:startLocation]].num1)+150;
                animPoint.y = (48*[handleOnMaze translateLargeArrayIndexToXY:[handleOnMaze translateSmallArrayIndexToLarge:startLocation]].num2)+150;
                
                id action = [CCMoveTo actionWithDuration:1.0f position:animPoint];
                [animationQueue enqueue:action];
            }
            else {
                
            }
        }
    }
    return;
}

-(NSInteger) checkUnvisitedPathsFromLocation:(NSInteger)location
{
    /*-1 signifies that all paths from this location have been traveled*/
//    NSLog(@"maze size: %i", [[handleOnMaze wallList] count]);
//    NSLog(@"number of possible paths at: %i - %i", location, [[[handleOnMaze wallList] objectForKey:[NSNumber numberWithInt:location]] count]);
//    NSLog(@"checking for paths not traveled: %i", location);
    NSInteger tmpInt = -1;
    
    for (NSNumber *tmpPath in [[handleOnMaze wallList] objectForKey:[NSNumber numberWithInt:location]] ) {
        /*if this location has not been visited yet - value of 0*/
//        NSLog(@"checking: %i", [tmpPath intValue]);
        if ([[visitedLocationList objectAtIndex:[tmpPath intValue]] intValue] == 0) {
            tmpInt = [tmpPath intValue];
            break;
        }
    }
//    NSLog(@"this path has not been traveled: %i", tmpInt);
    return tmpInt;
}

@end
