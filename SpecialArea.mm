//
//  SpecialArea.m
//  Maze
//
//  Created by  on 10/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SpecialArea.h"
#import "ObjectInfoConstants.h"
#import "Pair.h"

@implementation SpecialArea
@synthesize chargingAnimDurationMax, chargingAnimDurationMin, activeAnimDurationMax, activeAnimDurationMin;

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
    if ([self characterState] == sAreaActive) {
        CGRect myBoundingBox = [self adjustedBoundingBox];
        for (GameObject *object in listOfGameObjects) {
            CGRect characterBox = [object adjustedBoundingBox];
            if (CGRectIntersectsRect(myBoundingBox, characterBox)) {
                if ([object gameObjectType] == tBall) {
                    NSLog(@"In Special Area - Ball touched it!");
                
                
                }
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
    //    NSLog(@"exiting locationOnScreen");
    
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
    [self changeLocation];
    [self recalculateRunLoopTime];
    id action = [CCSequence actions:
                 [CCCallFunc actionWithTarget:self selector:@selector(forceCharging)],
                 [CCFadeIn actionWithDuration:chargingAnimDuration],
                 [CCCallFunc actionWithTarget:self selector:@selector(forceActive)],
                 [CCBlink actionWithDuration:activeAnimDuration blinks:1000],
                 [CCCallFunc actionWithTarget:self selector:@selector(forceInActive)],
                 [CCCallFunc actionWithTarget:self selector:@selector(runLoop)],
                 nil];
    [self runAction:action];
}

- (void)createBodyAtLocation:(CGPoint)location {
    b2BodyDef bodyDef;
//prevent physics of collisions
    bodyDef.active = false;
//prevents the body from moving with accelerometer
    bodyDef.type = b2_staticBody;
    bodyDef.position =
    b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO);
    body = world->CreateBody(&bodyDef);
    body->SetUserData(self);
    
    b2FixtureDef fixtureDef;
    
    b2PolygonShape shape;
    shape.SetAsBox(self.contentSize.width/2/PTM_RATIO, self.contentSize.height/2/PTM_RATIO);
    
    fixtureDef.shape = &shape;
    
    fixtureDef.density = 0.0;
    
    body->CreateFixture(&fixtureDef);
}

- (id)initWithWorld:(b2World *)theWorld atLocation:(CGPoint)location withSpriteFrame:(CCSpriteFrame *)frame WithKnowledgeOfMaze:(MazeMaker*)maze {
    if ((self = [super init])) {
        gameObjectType = tArea;
        handleOnMaze = maze;
        objectFactory = [ObjectFactory createSingleton];
        world = theWorld;
        
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
        [self setDisplayFrame:frame];
        [self createBodyAtLocation:location];
        [self setActiveAnimDurationMin:2];
        [self setActiveAnimDurationMax:5];
        [self setChargingAnimDurationMin:1];
        [self setChargingAnimDurationMax:3];
        [self runLoop];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(respondToPauseCall) 
                                                     name:@"pauseGameObjects" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(respondToUnPauseCall) 
                                                     name:@"unPauseGameObjects" object:nil];
        
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
}


-(void)respondToPauseCall
{
    [self pauseSchedulerAndActions]; 
}

-(void)respondToUnPauseCall
{
    [self resumeSchedulerAndActions];
}

- (void)changeLocation
{
    CGPoint location = [self locationOnScreen:[handleOnMaze returnEmptySlotInMaze]];
    world->DestroyBody(body);
    b2BodyDef bodyDef;
    //prevent physics of collisions
    bodyDef.active = false;
    //prevents the body from moving with accelerometer
    bodyDef.type = b2_staticBody;
    bodyDef.position =
    b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO);
    body = world->CreateBody(&bodyDef);
    body->SetUserData(self);
}

@end
