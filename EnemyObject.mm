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

-(NSInteger) checkUnvisitedPathsFromLocation:(NSInteger)location UsingWallList:(NSMutableArray*)visitedLocationList;

-(void) runBFSWith:(NSMutableDictionary*)directions;
-(void) addAnimationsToQueue:(NSArray *)animations;
-(void) addAnimationToQueue:(id)animation;

-(BOOL)isObjectVisible:(GameObject*)object 
         WithinThisBox:(CGRect)box
     OutOfTheseObjects:(CCArray*)listOfGameObjects;

-(NSInteger) calculateDifferenceFromCurrentLocation:(CGPoint)currentLocation ToTargetsLocation:(CGPoint)targetLocation;

-(void) depthFirstSearchFrom:(NSInteger)startLocation 
                          To:(NSInteger)endLocation 
             WithVisitedList:(NSMutableArray*)visitedLocationList 
              WithWhiteNodes:(NSInteger&)whiteNodes
               WithContainer:(NSMutableArray*)animationContainer;

-(CGPoint) locationOnScreen:(NSInteger)currentIndex;

@end

@implementation EnemyObject
@synthesize canSee, canHear;

- (void) dealloc{
    //might have to do the timer earlier
    //    NSLog(@"enemy dealloc called");

    [tmpSelector release];
    [logicQueue release];
    [animationQueue release];    
    [objectInfo release];
    [super dealloc];
}

- (id)initWithSpriteFrame:(CCSpriteFrame *)frame 
               AtLocation:(CGPoint)location
      WithKnowledgeOfMaze:(MazeMaker*)maze
{
    if ((self = [super init])) {
        CCLOG(@"### Enemy initialized with parameters");

        body = NULL;
        animationQueue = [[Queue alloc] init];
        
        objectFactory = [ObjectFactory createSingleton];
        
        gameObjectType = tEnemy;
        canSee = TRUE;
        canHear = TRUE;
        timerInterval = 0.4;
        actionInterval = 0.4;
                
        [self setDisplayFrame:frame];
        [self setPosition:location];
        
        handleOnMaze = maze;
        mazeInterface = [MazeInterface createSingleton];
        
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
        NSLog(@"enemy - screenOffset:%i", screenOffset);

        logicQueue = [[NSOperationQueue alloc] init];
        [logicQueue setName:@"enemyLogicQueue"];
        [logicQueue setSuspended:FALSE];
        objectInfo = [[NSMutableDictionary alloc] init];
        tmpSelector = [[NSString alloc] init];
        [self scheduleAnimationTimer];
        
    }
    return self;
}

-(void)scheduleAnimationTimer
{
    [self schedule: @selector(timerDuties:) interval:timerInterval];
}

-(id) init {
    if( (self=[super init]) ) {
        CCLOG(@"### Enemy initialized");
        
    }
    return self;
}

-(void)changeState:(CharacterStates)newState {
    NSLog(@"enemyObject - must override changeState!");

}

-(void)updateStateWithDeltaTime:(ccTime)deltaTime
           andListOfGameObjects:(CCArray*)listOfGameObjects {        
    NSLog(@"enemyObject - must override update!");
}

-(void)initAnimations {
    NSLog(@"enemyObject - must override initAnimations!");
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

-(NSInvocationOperation*)enemyLogic:(EnemyLogic)enemyLogic From:(NSInteger)startLocation To:(NSInteger)endLocation
{
    NSLog(@"in enemyLogic");
    switch (enemyLogic) {
        case kEnemyGoToPlayer:
            tmpSelector = @"runBFSWith:";
            break;        
        case kEnemyWanderInMaze:
            tmpSelector = @"runDFSWith:";
            break;
            
        default:
            break;
    }
    
    [objectInfo setObject:[NSNumber numberWithInt:startLocation] forKey:enemyStartLocation];
    [objectInfo setObject:[NSNumber numberWithInt:endLocation] forKey:enemyEndLocation];
        
    NSInvocationOperation* theOp = [[NSInvocationOperation alloc] initWithTarget:self
                                                                        selector:NSSelectorFromString(tmpSelector) object:objectInfo];
    NSLog(@"exiting enemyLogic");

    return theOp;
}

-(CGPoint) backOnTrack:(CGPoint)location
{
    NSLog(@"in and exiting backOnTrack");

    return [mazeInterface findClosestArrayMatchToPoint:location];
}

-(void) chargeForwardFrom:(CGPoint)location To:(CGPoint)target
{
    NSLog(@"in chargeForwardFrom");

    CGPoint currentLocation = location;
    float X1, Y1, X2, Y2, diffX, diffY, dirX, dirY, dist;
    id action;

    X1 = location.x;
    Y1 = location.y;
    X2 = target.x;
    Y2 = target.y;
    
//figure out which way the enemy needs to move
    if (X2 > X1) 
        dirX = 1;
    else
        dirX = -1;
    
    if (Y2 > Y1) 
        dirY = 1;
    else
        dirY = -1;
    
    diffX = abs(X1 - X2);
    diffY = abs(Y1 - Y2);
    
    //distance to point / the wall size - so each unit of time the enemy moves a certain amount
    dist = sqrt( pow(diffX, 2) + pow(diffY, 2) )/[objectFactory returnObjectDimensions:tWall].num2;

    diffX = (diffX / dist)*dirX;
    diffY = (diffY / dist)*dirY;
    
    for (int i=0; i<dist-1; i++) {
        currentLocation.x += diffX;
        currentLocation.y += diffY;
        action = [CCMoveTo actionWithDuration:actionInterval position:currentLocation];
        [animationQueue enqueue:action];
    }
    
    action = [CCMoveTo actionWithDuration:actionInterval position:target];
    [animationQueue enqueue:action];
    action = [CCMoveTo actionWithDuration:actionInterval position:[self backOnTrack:target]];
    [animationQueue enqueue:action];
    NSLog(@"exiting chargeForwardFrom");

}

-(NSInteger) calculateDifferenceFromCurrentLocation:(CGPoint)currentLocation ToTargetsLocation:(CGPoint)targetLocation
{
    /*the enemy always moves on a track - so it is easy to translate the screen position to the position in the mazeArray*/
    /*the player does not have to move on this track - so can't just translate the screen position to the mazeArray one*/
    /*this function will take the "unfiltered" player location and return a location that the enemy can search to*/
    /* -1 means that it could not find a location! */
//    NSLog(@"in calculateDifferenceFromCurrentLocation");

    
    NSInteger returnMazeArrayLocation, returnFloorMazeArrayLocation, returnCeilMazeArrayLocation;
    NSInteger testFloorReturnX, testFloorReturnY, testCeilReturnX,testCeilReturnY;
    float clX, clY, tlX, tlY, floorTmpX, floorTmpY, ceilTmpX, ceilTmpY;
    
    clX = currentLocation.x;
    clY = currentLocation.y;
    tlX = floor(targetLocation.x);
    tlY = floor(targetLocation.y);
    
    /*get the difference (in walls) between the x/y of the two points*/
    floorTmpX = (clX-tlX)/[objectFactory returnObjectDimensions:tWall].num1;
    floorTmpY = (clY-tlY)/[objectFactory returnObjectDimensions:tWall].num2;
    
    /*get the tmp floor / ceil values of the difference*/
    ceilTmpX = ceil(floorTmpX);
    ceilTmpY = ceil(floorTmpY);
    floorTmpX = floor(floorTmpX);
    floorTmpY = floor(floorTmpY);
    
//    NSLog(@"floor Difference x: %f y: %f", floorTmpX, floorTmpY);
//    NSLog(@"ceil Difference x: %f y: %f", ceilTmpX, ceilTmpY);
    
    /*reuse variables to have a container for the x/y from the current location of the enemy*/
    returnMazeArrayLocation = [self locationInMaze:currentLocation];
    clX = [handleOnMaze translateLargeArrayIndexToXY:returnMazeArrayLocation].num1;
    clY = [handleOnMaze translateLargeArrayIndexToXY:returnMazeArrayLocation].num2;
    
    /*adjust the current enemy location to be equal to the x/y of the target location*/
    testFloorReturnX = clX-floorTmpX;
    testFloorReturnY = clY-floorTmpY;
    
    testCeilReturnX = clX-ceilTmpX;
    testCeilReturnY = clY-ceilTmpY;
    
    returnFloorMazeArrayLocation = [handleOnMaze translateLargeXYToArrayIndex:testFloorReturnX :testFloorReturnY];
    returnCeilMazeArrayLocation = [handleOnMaze translateLargeXYToArrayIndex:testCeilReturnX :testCeilReturnY];
    
    if ([handleOnMaze returnContentsOfMazePosition:returnFloorMazeArrayLocation] != tWall) {
        returnMazeArrayLocation = returnFloorMazeArrayLocation;
    }
    else if ([handleOnMaze returnContentsOfMazePosition:returnCeilMazeArrayLocation] != tWall) {
        returnMazeArrayLocation = returnCeilMazeArrayLocation;
    }
    else {
        returnMazeArrayLocation = -1;
    }
    
    return returnMazeArrayLocation;
}

-(CGPoint) locationOnScreen:(NSInteger)currentIndex
{
    NSLog(@"in locationOnScreen");

    /*takes an index in the mazeArray and places it on the screen*/
    CGPoint screenLocation;
    screenLocation.x = ([objectFactory returnObjectDimensions:tWall].num2*[handleOnMaze translateLargeArrayIndexToXY:currentIndex].num1)+screenOffset;
    screenLocation.y = ([objectFactory returnObjectDimensions:tWall].num2*[handleOnMaze translateLargeArrayIndexToXY:currentIndex].num2)+screenOffset;
    NSLog(@"exiting locationOnScreen");

    return screenLocation;
}

-(NSInteger) locationInMaze:(CGPoint)currentLocation 
{
    NSLog(@"in locationInMaze");

/*takes a single location on the screen and translates it to an index in the mazeArray*/
/*only works with enemys because they move along a track*/
    NSInteger location;
    NSInteger wallHeight = [[objectFactory returnObjectDimensions:tWall]num2];
    NSInteger wallWidth = [[objectFactory returnObjectDimensions:tWall]num2];
    NSLog(@"in locationInMaze currentLocation: %f %f screenOffset:%i wallSize:%i", currentLocation.x, currentLocation.y, screenOffset, wallWidth);

    
    int tmpX = ceil(((currentLocation.x-screenOffset)/wallHeight));
    int tmpY = ceil(((currentLocation.y-screenOffset)/wallWidth));
    
    location = [handleOnMaze translateLargeXYToArrayIndex:tmpX :tmpY];
    NSLog(@"exiting locationInMaze");

    return location;
}

-(void) runBFSWith:(NSMutableDictionary*)directions
{
    NSInteger startLocation, endLocation;
    startLocation = [[directions objectForKey:enemyStartLocation] intValue];
    endLocation = [[directions objectForKey:enemyEndLocation] intValue];
    
//    NSLog(@"in runBFSFrom startLocation: %i endLocation: %i", startLocation, endLocation);
    NSInteger tmpSize = [[handleOnMaze wallList] count];
    
    /*use visitedList for the DFS 'coloring'*/
    NSMutableArray* visitedList = [[NSMutableArray alloc] initWithCapacity:tmpSize];
    NSMutableArray* pred = [[NSMutableArray alloc] initWithCapacity:tmpSize];
    NSMutableArray* animations = [[NSMutableArray alloc] initWithCapacity:tmpSize];
    
    for (int i = 0; i < tmpSize; i++) {
        [visitedList insertObject:[NSNumber numberWithInt:0] atIndex:i];
        [pred insertObject:[NSNumber numberWithInt:-1] atIndex:i];
    }
    
    int current, nextLocation;
    
    Queue *queue = [[Queue alloc] init];
    [queue enqueue:[NSNumber numberWithInt:startLocation]];

    while (![queue isQueueEmpty]) {
         
        current = [[queue dequeue] intValue];
        
        nextLocation = [self checkUnvisitedPathsFromLocation:current UsingWallList:visitedList];
        [visitedList replaceObjectAtIndex:startLocation withObject:[NSNumber numberWithInt:1]];
        
        while (nextLocation != -1) {
            [pred replaceObjectAtIndex:nextLocation withObject:[NSNumber numberWithInt:current]];
            [visitedList replaceObjectAtIndex:nextLocation withObject:[NSNumber numberWithInt:1]];
            if (nextLocation != -1)
                [queue enqueue:[NSNumber numberWithInt:nextLocation]];
            
            nextLocation = [self checkUnvisitedPathsFromLocation:current UsingWallList:visitedList];
            
        }
    }

    
    int tmpPosition = endLocation;
    
    CGPoint animPoint;
    
//    for (NSNumber *tmp in pred) {
//        NSLog(@"pred: %i", [tmp intValue]);
//    }
    id action;
    int count = 0;
    while (startLocation != tmpPosition) {
        animPoint = [self locationOnScreen:tmpPosition];
        action = [CCMoveTo actionWithDuration:actionInterval position:animPoint];
        [animations insertObject:action atIndex:count];
//        NSLog(@"moving to: %i", tmpPosition);
//        NSLog(@"animation queue counter: %i", [animationQueue counter]);
        tmpPosition = [[pred objectAtIndex:tmpPosition] intValue];
        count++;
    }
    
    //add the action that will change the minion into a different state at the end of this animation string
    [animations insertObject:[CCCallFunc actionWithTarget:self selector:@selector(stateMap)] atIndex:count];
    [animationQueue lifoPushObjects:animations];
    
    [animations release];
    [queue release];
    [visitedList release];
    [pred release];
    return;
}

-(void) runDFSWith:(NSMutableDictionary*)directions
{
    NSLog(@"in runDFSWith");

    NSInteger startLocation, endLocation;
    startLocation = [[directions objectForKey:enemyStartLocation] intValue];
    endLocation = [[directions objectForKey:enemyEndLocation] intValue];
    
    
    NSInteger tmpSize = [[handleOnMaze wallList] count];
    
    /*use visitedList for the DFS 'coloring'*/
    NSMutableArray* visitedList = [[NSMutableArray alloc] initWithCapacity:tmpSize];
    for (int i = 0; i < tmpSize; i++) {
        [visitedList insertObject:[NSNumber numberWithInt:0] atIndex:i];
    }
    
    NSMutableArray *animationContainer = [[NSMutableArray alloc] init];
    
    //start recurisve function
    [self depthFirstSearchFrom:startLocation 
                            To:endLocation 
               WithVisitedList:visitedList 
                WithWhiteNodes:(NSInteger&)tmpSize
                 WithContainer:animationContainer];
   
    [animationContainer insertObject:[CCCallFunc actionWithTarget:self selector:@selector(stateMap)] atIndex:[animationContainer count]];
    [animationQueue enqueueObjects:animationContainer];
        
    [visitedList release];
    [animationContainer release];
    NSLog(@"exiting runDFSWith");

    return;
}

-(void) depthFirstSearchFrom:(NSInteger)startLocation 
                          To:(NSInteger)endLocation 
             WithVisitedList:(NSMutableArray*)visitedLocationList 
              WithWhiteNodes:(NSInteger&)whiteNodes
               WithContainer:(NSMutableArray*)animationContainer
{
    NSLog(@"in depthFirstSearchFrom");

    [visitedLocationList replaceObjectAtIndex:startLocation withObject:[NSNumber numberWithInt:1]];
    whiteNodes--;
    
    if (whiteNodes < 0)
        return;
    
    CGPoint animPoint;
    
    int newLocation = [self checkUnvisitedPathsFromLocation:startLocation UsingWallList:visitedLocationList];
    while (newLocation != -1) {
        
        animPoint = [self locationOnScreen:newLocation];
        id action;
        action = [CCMoveTo actionWithDuration:actionInterval position:animPoint];
        [animationContainer insertObject:action atIndex:[animationContainer count]];
    
        [self depthFirstSearchFrom:newLocation
                                To:endLocation 
                   WithVisitedList:visitedLocationList 
                    WithWhiteNodes:whiteNodes
                     WithContainer:animationContainer];
        
        newLocation = [self checkUnvisitedPathsFromLocation:startLocation UsingWallList:visitedLocationList];
        
        animPoint = [self locationOnScreen:startLocation];

        action = [CCMoveTo actionWithDuration:actionInterval position:animPoint];
        [animationContainer insertObject:action atIndex:[animationContainer count]];
    }
    NSLog(@"exiting depthFirstSearchFrom");

    return;
}


-(NSInteger) checkUnvisitedPathsFromLocation:(NSInteger)location UsingWallList:(NSMutableArray*)visitedLocationList
{
    NSLog(@"in checkUnvisitedPathsFrom");

    /*-1 signifies that all paths from this location have been traveled*/
//    NSLog(@"maze size: %i", [[handleOnMaze wallList] count]);
//    NSLog(@"contents: %i,", [handleOnMaze returnContentsOfMazePosition:location]);
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
    NSLog(@"exiting checkUnvisitedPathsFrom");

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
