//
//  BallObject.m
//  Maze
//
//  Created by ian on 6/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BallObject.h"
#import "ObjectInfoConstants.h"

@implementation BallObject
@synthesize rollingAnim, idleAnim, collisionAnim, health;

- (void) dealloc{
//    NSLog(@"ball dealloc called");
    [collisionAnim release];
    [idleAnim release];
    [super dealloc];
}

-(void)forceRollingState
{
    [self changeState:sBallRolling];
}

-(void)changeState:(CharacterStates)newState {
    [self stopAllActions];
    id action = nil;
    [self setCharacterState:newState];

    switch (newState) {
        case sBallIdle:
//            CCLOG(@"Ball->Starting the Spawning Animation");
//            action = [CCAnimate actionWithAnimation:idleAnim
//                               restoreOriginalFrame:NO];
            break;
            
        case sBallColliding:
//            CCLOG(@"Ball->Changing State to Idle");
//            action = [CCAnimate actionWithAnimation:collisionAnim
//                               restoreOriginalFrame:NO];
            break;
        
        case sBallRolling:
            CCLOG(@"Ball->Changing State to Rolling");

            break;
        case sBallInvulnerable:
            CCLOG(@"Ball->Changing State to Invulnerable");
            [self performSelector:@selector(forceRollingState) withObject:nil afterDelay:3.0f];

            break;
        case sBallHurt:
            CCLOG(@"Ball->Changing State to Hurt");

            [self performSelector:@selector(forceRollingState) withObject:nil afterDelay:3.0f];
            action = [CCBlink actionWithDuration:3.0 blinks:50];
            break;    
        default:
            CCLOG(@"Unhandled state %d in BallObject", newState);
            break;
    }
    if (action != nil) {
        [self runAction:action];
    }
}

-(void)updateStateWithDeltaTime:(ccTime)deltaTime
           andListOfGameObjects:(CCArray*)listOfGameObjects {
    // Check for collisions
    // Change this to keep the object count from querying it each time
    CGRect myBoundingBox = [self adjustedBoundingBox];
    for (GameObject *object in listOfGameObjects) {
        if ([object tag] == tBall)
            continue;
        else {
            CGRect characterBox = [object adjustedBoundingBox];
            if (CGRectIntersectsRect(myBoundingBox, characterBox)) {
                if ([object gameObjectType] == tCoin) {
                    NSLog(@"Hit a Coin!");
                    
                    
                }
                if ( [object gameObjectType] == tEnemy && [self characterState] != sBallInvulnerable && [self characterState] != sBallHurt ) {
                    NSLog(@"Hit an Enemy!");
                    
                    [objectInfo setObject:[NSNumber numberWithFloat:[self position].x ] forKey:notificationUserInfoKeyPositionX];
                    [objectInfo setObject:[NSNumber numberWithFloat:[self position].y ] forKey:notificationUserInfoKeyPositionY];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"playerTouchedEnemy" 
                                                                        object:self
                                                                      userInfo:objectInfo];
                    [self changeState:sBallHurt];
                }
            }
        }
    }
    
}

-(void)initAnimations {
    [self setCollisionAnim:
     [self loadPlistForAnimationWithName:@"collisionAnim"
                            andClassName:NSStringFromClass([self class])]];
    
    [self setIdleAnim:
     [self loadPlistForAnimationWithName:@"idleAnim"
                            andClassName:NSStringFromClass([self class])]];
    
    [self setRollingAnim:
     [self loadPlistForAnimationWithName:@"rollingAnim"
                            andClassName:NSStringFromClass([self class])]];
}

- (void)createBodyAtLocation:(CGPoint)location {
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;
    bodyDef.position =
    b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO);
    
    body = world->CreateBody(&bodyDef);
    body->SetUserData(self);
    body->SetAngularDamping(kAngularDamp);
    
    b2FixtureDef fixtureDef;
    b2CircleShape circleShape;
    circleShape.m_radius = self.contentSize.width/2/PTM_RATIO;

    fixtureDef.shape = &circleShape;
    
    fixtureDef.density = 1.0;
    fixtureDef.friction = 0.7;
    fixtureDef.restitution = 0.2;
    
    body->CreateFixture(&fixtureDef);
}

- (id)initWithWorld:(b2World *)theWorld atLocation:(CGPoint)location withSpriteFrame:(CCSpriteFrame *)frame {
    if ((self = [super init])) {
        world = theWorld;
        [self setDisplayFrame:frame];
        gameObjectType = tBall;
        [self createBodyAtLocation:location];
        objectInfo = [[NSMutableDictionary alloc] init];
        [objectInfo setObject:[NSNumber numberWithFloat:[self position].x ] forKey:notificationUserInfoKeyPositionX];
        [objectInfo setObject:[NSNumber numberWithFloat:[self position].y ] forKey:notificationUserInfoKeyPositionY];
        [objectInfo setObject:[NSNumber numberWithInt:tBall] forKey:notificationUserInfoObjectType];
    }
    return self;
}

-(id) init {
    if( (self=[super init]) ) {
        CCLOG(@"### BallObject initialized");
        [self initAnimations];                                   // 1// 2
        gameObjectType = tBall;                    // 3
        [self changeState:sBallIdle];                       // 4
        health = 100;
    }
    return self;
}


@end
