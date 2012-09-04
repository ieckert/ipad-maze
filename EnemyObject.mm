//
//  EnemyObject.m
//  Maze
//
//  Created by ian on 8/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EnemyObject.h"
#import "ObjectInfoConstants.h"
@interface EnemyObject()

-(NSInteger) checkUnvisitedPathsFromLocation:(NSInteger)location;
-(BOOL)isObjectVisible:(GameObject*)object 
         WithinThisBox:(CGRect)box
     OutOfTheseObjects:(CCArray*)listOfGameObjects;

@end
@implementation EnemyObject

- (id)initWithSpriteFrame:(CCSpriteFrame *)frame 
               AtLocation:(CGPoint)location
      WithKnowledgeOfMaze:(MazeMaker*)maze
{
    if ((self = [super init])) {
        body = NULL;
        animationQueue = [[Queue alloc] init];
        
        objectFactory = [ObjectFactory createSingleton];
        
        gameObjectType = tEnemy;
        DFSWasFound = false;
        canSee = true;
        canHear = true;
        timerInterval = 0.6;
        actionInterval = 0.45;
                
        [self setDisplayFrame:frame];
        [self setPosition:location];
        
        objectInfo = [[NSMutableDictionary alloc] init];
        [objectInfo setObject:[NSNumber numberWithFloat:[self position].x ] forKey:notificationUserInfoKeyPositionX];
        [objectInfo setObject:[NSNumber numberWithFloat:[self position].y ] forKey:notificationUserInfoKeyPositionY];
        [objectInfo setObject:[NSNumber numberWithInt:tEnemy] forKey:notificationUserInfoObjectType];
        
        handleOnMaze = maze;
        
        /*find the offset used for displaying things to the screen*/
        /*based off the scene type*/
        if ([handleOnMaze mazeForScene] == kMainMenuScene) {
            screenOffset = kMenuMazeScreenOffset;
        }
        else if ([handleOnMaze mazeForScene] == kNormalLevel) {
            screenOffset = kMazeScreenOffset;
        }
        else {
            screenOffset = 0;
        }
        
        int arrSize = [[handleOnMaze wallList] count];
        visitedLocationList = [[NSMutableArray alloc] initWithCapacity:arrSize];
        for (int i = 0; i < arrSize; i++) {
            [visitedLocationList insertObject:[NSNumber numberWithInt:0] atIndex:i];
        }
//        [self schedule: @selector(timerDuties:) interval:timerInterval];
//        [self changeState:sEnemyPathFinding];         
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
//    NSLog(@"enemy dealloc called");
    
    [animationQueue release];    
    [objectInfo release];
    [visitedLocationList release];
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
    CGRect mySoundBoundingBox = [self returnSenseBoundingBoxFor:kEnemyHearing];
    CGRect myVisionBoundingBox = [self returnSenseBoundingBoxFor:kEnemySight];

    for (GameObject *object in listOfGameObjects) {
        
        CGRect objectBoundingBox = [object adjustedBoundingBox];
        if (CGRectIntersectsRect(mySoundBoundingBox, objectBoundingBox)) {
            if ([object gameObjectType] == tBall && [object isObjectAudible]){
//                NSLog(@"Minion Heard something!!");

                
            }

        }
        if (CGRectIntersectsRect(myVisionBoundingBox, objectBoundingBox)) {
            if ([object gameObjectType] == tBall && [self isObjectVisible:object 
                                                            WithinThisBox:myVisionBoundingBox 
                                                        OutOfTheseObjects:listOfGameObjects] ) {
                NSLog(@"Minion Saw something!!");

            }
        }
        
    }
    
}

-(void)initAnimations {
    NSLog(@"enemyObject - must override initAnimations!");
}

-(void) timerDuties: (ccTime) dt
{  
    NSLog(@"enemyObject - must override timerDuties!");

}

-(NSInteger) locationInMaze:(CGPoint)currentLocation 
{
    NSInteger location;
        
    int tmpX = ((currentLocation.x-screenOffset)/[[objectFactory returnObjectDimensions:tWall]num1]);
    int tmpY = ((currentLocation.y-screenOffset)/[[objectFactory returnObjectDimensions:tWall]num2]);
    
    location = [handleOnMaze translateLargeXYToArrayIndex:tmpX :tmpY];
    return location;
}

-(void) prepDFSForUse
{    
    NSLog(@"make sure you ALWAYS run this BEFORE 'depthFirstSearch'");
    DFSWasFound = FALSE;
    int arrSize = [[handleOnMaze wallList] count];
    for (int i = 0; i < arrSize; i++) {
        [visitedLocationList replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:0]];
    }    
}

-(void) depthFirstSearch:(NSInteger)startLocation :(NSInteger)endLocation
{
    //use handleOnMaze - wallList for the path
    //use visitedLocationList for the DFS 'coloring'
    [visitedLocationList replaceObjectAtIndex:startLocation withObject:[NSNumber numberWithInt:1]];
    CGPoint animPoint;

    if (startLocation == endLocation) {
        DFSWasFound = true;
        animPoint.x = ([objectFactory returnObjectDimensions:tWall].num2*[handleOnMaze translateLargeArrayIndexToXY:endLocation].num1)+screenOffset;
        animPoint.y = ([objectFactory returnObjectDimensions:tWall].num2*[handleOnMaze translateLargeArrayIndexToXY:endLocation].num2)+screenOffset;
        
        id action = [CCMoveTo actionWithDuration:actionInterval position:animPoint];
        [animationQueue enqueue:action];
        
//        NSLog(@"end location found: %i", endLocation); 
        /*after this - it is the dfs path to the goal*/
    }
    else {
        int newLocation = [self checkUnvisitedPathsFromLocation:startLocation];
        while (newLocation != -1) {

            if (!DFSWasFound) {
//                NSLog(@"in while DFS at: %i", newLocation);
                animPoint.x = ([objectFactory returnObjectDimensions:tWall].num2*[handleOnMaze translateLargeArrayIndexToXY:newLocation].num1)+screenOffset;
                animPoint.y = ([objectFactory returnObjectDimensions:tWall].num2*[handleOnMaze translateLargeArrayIndexToXY:newLocation].num2)+screenOffset;
                
                id action = [CCMoveTo actionWithDuration:actionInterval position:animPoint];
                [animationQueue enqueue:action];
            }
            else {
                
            }
            
            [self depthFirstSearch:newLocation :endLocation];
            newLocation = [self checkUnvisitedPathsFromLocation:startLocation];
            
            if (!DFSWasFound) {
//                NSLog(@"in while DFS at: %i", startLocation);
                animPoint.x = ([objectFactory returnObjectDimensions:tWall].num2*[handleOnMaze translateLargeArrayIndexToXY:startLocation].num1)+screenOffset;
                animPoint.y = ([objectFactory returnObjectDimensions:tWall].num2*[handleOnMaze translateLargeArrayIndexToXY:startLocation].num2)+screenOffset;
                
                id action = [CCMoveTo actionWithDuration:actionInterval position:animPoint];
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

-(CGRect)returnSenseBoundingBoxFor:(EnemySense)sense
{
    CGRect boundingBox;
    CGSize boundingSize;
    NSInteger distanceMultiplier;
    
    switch (sense) {
        case kEnemySense:
             
            break;        
        case kEnemyHearing:
            distanceMultiplier = kEnemyHearingMultiplier;
            /*to make it so the enemy can "hear" from a distance relative to its size*/
            boundingSize.height = [self boundingBox].size.height*distanceMultiplier;
            boundingSize.width = [self boundingBox].size.width*distanceMultiplier;
            
            boundingBox.size = boundingSize;
            
            /*to make the bounding box be centered on the enemy*/
            /*otherwise, it would start at the 0,0 point of the enemy rect*/
            /*we want a rect that is fully around the enemy*/
            boundingBox.origin = [self boundingBox].origin;
            boundingBox.origin.x -= boundingSize.width/2;
            boundingBox.origin.y -= boundingSize.height/2;
            break;
        case kEnemySight:
            distanceMultiplier = kEnemyVisionMultiplier;
            
            boundingSize.height = [self boundingBox].size.height*distanceMultiplier;
            boundingSize.width = [self boundingBox].size.width;
            
            boundingBox.size = boundingSize;
            
            boundingBox.origin = [self boundingBox].origin;            
            break;    
        default:
            break;
    }    
    
    return boundingBox;
}

-(BOOL)isObjectVisible:(GameObject*)object 
         WithinThisBox:(CGRect)box
     OutOfTheseObjects:(CCArray*)listOfGameObjects
{
    BOOL tmpBool = true;
    for (GameObject *obj in listOfGameObjects) {
        if ([obj gameObjectType] != tCoin && obj != object && obj != self && CGRectIntersectsRect(box, [obj boundingBox])) {
            if ( ([obj position].x < [object position].x && [obj position].x > [self position].x) ||
                 ([obj position].y < [object position].y && [obj position].y > [self position].y) ) {
                tmpBool = false;
                break;
            }
        }
    }
    return tmpBool;
}



@end
