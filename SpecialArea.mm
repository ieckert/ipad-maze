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
@synthesize activeAnim, chargingAnim, chargingAnimDurationMax, chargingAnimDurationMin, activeAnimDurationMax, activeAnimDurationMin;

-(void)changeState:(CharacterStates)newState {
    [self stopAllActions];
    id action = nil;
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
    
    if (action != nil) {
        [self runAction:action];
    }
}

- (void)changeLocation
{
    CGPoint location = [mazeInterface returnRandomOpenPoint];
    
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

-(void)initAnimations {    
/*
    [self setRollingAnim:
     [self loadPlistForAnimationWithName:@"rollingAnim"
                            andClassName:NSStringFromClass([self class])]];
*/
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

-(void)scheduleMovementTimer
{    
    activeAnimDuration = arc4random()%([self activeAnimDurationMax] - [self activeAnimDurationMin]) + [self activeAnimDurationMin];
    chargingAnimDuration = arc4random()%([self chargingAnimDurationMax] - [self chargingAnimDurationMin]) + [self chargingAnimDurationMin];

    [self schedule: @selector(changeLocation) interval:(activeAnimDuration + chargingAnimDuration)];    
}

-(void) unScheduleMovementTimer
{
    [self unschedule: @selector(changeLocation)];
}

- (id)initWithWorld:(b2World *)theWorld atLocation:(CGPoint)location withSpriteFrame:(CCSpriteFrame *)frame WithKnowledgeOfMaze:(MazeMaker*)maze {
    if ((self = [super init])) {
        [self initAnimations];                                   
        gameObjectType = tArea;
        handleOnMaze = maze;
        world = theWorld;
        mazeInterface = [MazeInterface createSingleton];
        [self setDisplayFrame:frame];
        [self createBodyAtLocation:location];
        [self changeState:sAreaActive];
        [self setActiveAnimDurationMin:3];
        [self setActiveAnimDurationMax:7];
        [self setChargingAnimDurationMin:1];
        [self setChargingAnimDurationMax:5];
        [self scheduleMovementTimer];
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
    [activeAnim release];
    [super dealloc];
}

@end
