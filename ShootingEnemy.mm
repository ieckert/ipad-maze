//
//  SpecialArea.m
//  Maze
//
//  Created by  on 10/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ShootingEnemy.h"
#import "ObjectInfoConstants.h"
#import "Pair.h"

@implementation ShootingEnemy
@synthesize chargingAnimDurationMax, chargingAnimDurationMin, activeAnimDurationMax, activeAnimDurationMin;

-(void)noLaser
{
    [[self getChildByTag:0] runAction:[CCHide action]];
}

-(void)prepLaser
{
    laserSprite.scaleY = 0.05;
    [[self getChildByTag:0] runAction:[CCShow action]];
}

-(void)realLaser
{
    laserSprite.scaleY = 0.5;
    [[self getChildByTag:0] runAction:[CCShow action]];
}

-(void)forceActive
{
    [self changeState:sAreaActive];
}

-(void)forceInActive
{
    [self changeState:sAreaInactive];
}

-(void)forceCharging
{
    [self changeState:sAreaCharging];
}

-(id)buildInActiveAnim
{
    id action = [CCSequence actions:[CCFadeOut actionWithDuration:1],
                 [CCCallFunc actionWithTarget:self selector:@selector(changeLocation)], nil];
    return action;
}

-(id)buildChargingAnim
{
    id action = [CCSequence actions:[CCBlink actionWithDuration:chargingAnimDuration blinks:50],
                 [CCCallFunc actionWithTarget:self selector:@selector(forceActive)], nil];
    return action;
}

-(id)buildActiveAnim
{
    id action = [CCSequence actions:[CCTwirl actionWithDuration:activeAnimDuration],
                 [CCCallFunc actionWithTarget:self selector:@selector(forceInActive)], nil];
    return action;
    
}

-(void)changeState:(CharacterStates)newState {
    [self setCharacterState:newState];
    
    switch (newState) {
        case sAreaInactive:
            break;
        case sAreaActive:
            break;
        case sAreaCharging:
            break;
        default:
            CCLOG(@"Unhandled state %d in SpecialArea", newState);
            break;
    }
}

-(void)updateStateWithDeltaTime:(ccTime)deltaTime
           andListOfGameObjects:(CCArray*)listOfGameObjects {
    if (!isActive) {
        return;
    }

    shootBoundingBox.origin = [self boundingBox].origin;
    shootBoundingBox.origin.x -= boundingSize.width/2;
    shootBoundingBox.origin.y -= boundingSize.height/2;
    
    if ([self characterState] == sAreaActive) {

        for (GameObject *object in listOfGameObjects) {
            CGRect characterBox = [object adjustedBoundingBox];
            if ([object gameObjectType] == tBall && CGRectIntersectsRect(shootBoundingBox, characterBox)) {
                [object applyDamage:kAreaBasicDamage];
            }
        }
    }
    
}

-(CGPoint) locationOnScreen:(NSInteger)currentIndex
{
    //    NSLog(@"in locationOnScreen");
    
    /*takes an index in the mazeArray and places it on the screen*/
    CGPoint screenLocation;
    screenLocation.x = ([objectFactory returnObjectDimensions:tWall].num2*[handleOnMaze translateLargeArrayIndexToXY:currentIndex].num1)+screenOffset;
    screenLocation.y = ([objectFactory returnObjectDimensions:tWall].num2*[handleOnMaze translateLargeArrayIndexToXY:currentIndex].num2)+screenOffset;
    
    return screenLocation;
}

-(NSInteger) locationInMaze:(CGPoint)currentLocation
{
    //    NSLog(@"in locationInMaze");
    
    /*takes a single location on the screen and translates it to an index in the mazeArray*/
    /*only works with enemys because they move along a track*/
    NSInteger location;
    NSInteger wallHeight = [[objectFactory returnObjectDimensions:tWall]num2];
    NSInteger wallWidth = [[objectFactory returnObjectDimensions:tWall]num2];
    //    NSLog(@"in locationInMaze currentLocation: %f %f screenOffset:%i wallSize:%i", currentLocation.x, currentLocation.y, screenOffset, wallWidth);
    
    
    int tmpX = ceil(((currentLocation.x-screenOffset)/wallHeight));
    int tmpY = ceil(((currentLocation.y-screenOffset)/wallWidth));
    
    location = [handleOnMaze translateLargeXYToArrayIndex:tmpX :tmpY];
    //    NSLog(@"exiting locationInMaze");
    
    return location;
}


-(void)recalculateRunLoopTime
{
    activeAnimDuration = arc4random()%([self activeAnimDurationMax] - [self activeAnimDurationMin]) + [self activeAnimDurationMin]+1;
    chargingAnimDuration = arc4random()%([self chargingAnimDurationMax] - [self chargingAnimDurationMin]) + [self chargingAnimDurationMin];
}

-(void)runLoop
{
    
    [self recalculateRunLoopTime];

    CGPoint tmp = [self changeLocation];
//    NSLog(@"for shooting enemy: animDuration: %i", chargingAnimDuration);
    id action = [CCSequence actions:
                 [CCCallFunc actionWithTarget:self selector:@selector(forceCharging)],
                 [CCMoveTo actionWithDuration:chargingAnimDuration position:tmp],
                 [CCCallFunc actionWithTarget:self selector:@selector(prepLaser)],
                 [CCDelayTime actionWithDuration:chargingAnimDuration],
                 [CCCallFunc actionWithTarget:self selector:@selector(realLaser)],
                 [CCCallFunc actionWithTarget:self selector:@selector(forceActive)],
                 [CCDelayTime actionWithDuration:activeAnimDuration],
                 [CCCallFunc actionWithTarget:self selector:@selector(forceInActive)],
                 [CCCallFunc actionWithTarget:self selector:@selector(noLaser)],
                 [CCCallFunc actionWithTarget:self selector:@selector(runLoop)],
                 nil];
    [self runAction:action];
}


-(void)respondToPauseCall
{
//    NSLog(@"paused called for shooting enemy");
    isActive = false;
    [self pauseSchedulerAndActions]; 
}

-(void)respondToUnPauseCall
{
    isActive = true;
    [self resumeSchedulerAndActions];
}


- (CGPoint)changeLocation
{
    CGPoint newLocation;
    int xDiff, yDiff;
    NSInteger index;
    int wallSize = ([objectFactory returnObjectDimensions:tWall].num2*6);

    if (follow) {
        
    }
    else {
        index = arc4random()%[moveableLocations count];
        newLocation = [self locationOnScreen:[[moveableLocations objectAtIndex:index] intValue]];
        xDiff = abs(abs([self position].x) - abs(newLocation.x));
        yDiff = abs(abs([self position].y) - abs(newLocation.y));
        while (yDiff > wallSize || xDiff > wallSize) {
            index = arc4random()%[moveableLocations count];
            newLocation = [self locationOnScreen:[[moveableLocations objectAtIndex:index] intValue]];
            xDiff = abs(abs([self position].x) - abs(newLocation.x));
            yDiff = abs(abs([self position].y) - abs(newLocation.y));
        }
    }
    return newLocation;
}

-(void)buildMoveableLocations
{
//also makes the bounding box!!
    NSInteger rows = [handleOnMaze largeMazeRows];
    NSInteger cols = [handleOnMaze largeMazeCols];
    
    int distanceMultiplier = (rows+cols)*[objectFactory returnObjectDimensions:tWall].num2;
    
    switch (enemyPathLocation) {
        case lTop:
            for (int i = (rows*cols)-1; i>(rows*cols)-cols-1; i--) {
                [moveableLocations addObject:[NSNumber numberWithInt:i]];
            }
            boundingSize.height = -[self boundingBox].size.height*distanceMultiplier;
            boundingSize.width = [self boundingBox].size.width;
            
            break;
        case lBottom:
            for (int i = cols-1; i>1; i--) {
                [moveableLocations addObject:[NSNumber numberWithInt:i]];
            }
            boundingSize.height = [self boundingBox].size.height*distanceMultiplier;
            boundingSize.width = [self boundingBox].size.width;
            
            break;
        case lLeft:
            for (int i = (rows*cols)-1; i>cols+rows; i-=cols) {
                [moveableLocations addObject:[NSNumber numberWithInt:i]];
            }
            boundingSize.height = [self boundingBox].size.height;
            boundingSize.width = -[self boundingBox].size.width*distanceMultiplier;
            
            break;
        case lRight:
            for (int i = (rows*cols)-cols; i>2*cols; i-=cols) {
                [moveableLocations addObject:[NSNumber numberWithInt:i]];
            }
            boundingSize.height = [self boundingBox].size.height;
            boundingSize.width = [self boundingBox].size.width*distanceMultiplier;
            
            break;
        default:
            break;
    }
    
    shootBoundingBox.size = boundingSize;
}

- (id)initWithWorld:(b2World *)theWorld 
      withDirection:(ShootingEnemyLocation)location 
    withSpriteFrame:(CCSpriteFrame *)frame
WithKnowledgeOfMaze:(MazeMaker*)maze
   WillFollowPlayer:(bool)followPlayer {
    if ((self = [super init])) {
        isActive = true;
        gameObjectType = tShoot;
        handleOnMaze = maze;
        objectFactory = [ObjectFactory createSingleton];
        moveableLocations = [[NSMutableArray alloc] init];
        world = theWorld;
        follow = followPlayer;
        
        /*find the offset used for displaying things to the screen*/
        /*based off the scene type*/
        if ([handleOnMaze mazeForScene] == kMainMenuScene) {
            screenOffset = kMenuMazeScreenOffset;
        }
        else {
            screenOffset = kMazeScreenOffset;
        }
        
        [self setDisplayFrame:frame];
        
        laserSprite = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]
                                        spriteFrameByName:@"LaserLarge.png"]];
        
        laserSprite.tag = 0;
        CGPoint tmp = self.position;
        switch (location) {
            case lTop:
                laserSprite.rotation = 90.0;
                tmp.x += 7;
                tmp.y -= 750;
                break;
            case lBottom:
                laserSprite.rotation = 90.0;
                tmp.x += 7;
                tmp.y += 770;
                break;
            case lLeft:
                tmp.x -= 750;
                tmp.y += 7;
                break;
            case lRight:
                tmp.x += 775;
                tmp.y += 7;
                break;
                
            default:
                break;
        }
        laserSprite.position = tmp;

        laserSprite.scaleX = 1.5;
        laserSprite.scaleY = 1.5;
        [self addChild:laserSprite];
        [[self getChildByTag:0] runAction:[CCHide action]];

        enemyPathLocation = location;
        [self buildMoveableLocations];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(respondToPauseCall) 
                                                     name:@"pauseGameObjects" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(respondToUnPauseCall) 
                                                     name:@"unPauseGameObjects" object:nil];
        [self setPosition:[self locationOnScreen:[[moveableLocations objectAtIndex:0] intValue]]];
        [self setActiveAnimDurationMin:2];
        [self setActiveAnimDurationMax:5];
        [self setChargingAnimDurationMin:1];
        [self setChargingAnimDurationMax:3];
        [self runAction:[CCSequence actions:
         [CCRotateBy actionWithDuration:5.0 angle:0],
         [CCCallFunc actionWithTarget:self selector:@selector(runLoop)],
         nil]];
    }
    return self;
}

-(id) init {
    if( (self=[super init]) ) {
        CCLOG(@"### SpecialArea initialized");
    }
    return self;
}

- (void) dealloc{
    [super dealloc];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [moveableLocations release];
}

@end
