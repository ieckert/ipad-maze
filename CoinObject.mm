//
//  CoinObject.m
//  Maze
//
//  Created by ian on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CoinObject.h"
#import "ObjectInfoConstants.h"

@implementation CoinObject
@synthesize spinningAnim, capturedAnim, removingAnim, idleAnim;

- (void) dealloc{
//    NSLog(@"coin dealloc called");

    [spinningAnim release];
    [capturedAnim release];
    [removingAnim release];
    [idleAnim release];
    [objectInfo release];

    [super dealloc];
}

-(void)changeState:(CharacterStates)newState {
    [self stopAllActions];
    id action = nil;
    [self setCharacterState:newState];
    
    switch (newState) {
        case sCoinIdle:

            break;
        case sCoinCaptured:
//            NSLog(@"Coin->Starting the Captured Animation");
            action = [CCSpawn actions:
                                      [CCRepeat actionWithAction:[CCAnimate actionWithAnimation:capturedAnim restoreOriginalFrame:NO] times:5],
                                      [CCFadeOut actionWithDuration:2.0f],
                                      nil];
            break;
        case sCoinSpinning:
//            NSLog(@"Coin->Changing State to Spinning");
            action = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:spinningAnim
                                     restoreOriginalFrame:NO]];
            break;
        case sCoinRemoving:
//            NSLog(@"Coin->Changing State to Removing");
            action = [CCAnimate actionWithAnimation:removingAnim
                               restoreOriginalFrame:NO];
            break;    
        default:
            NSLog(@"Unhandled state %d in CoinObject", newState);
            break;
    }
    if (action != nil) {
        [self runAction:action];
    }
}

-(void)updateStateWithDeltaTime:(ccTime)deltaTime
           andListOfGameObjects:(CCArray*)listOfGameObjects {        
    if (isActive == FALSE)
        return;
    
    // Check for collisions
    // Change this to keep the object count from querying it each time
    CGRect myBoundingBox = [self adjustedBoundingBox];
    for (GameObject *object in listOfGameObjects) {
        if ([object tag] == [self gameObjectType])
            continue;
        else {
            CGRect characterBox = [object adjustedBoundingBox];
            if (CGRectIntersectsRect(myBoundingBox, characterBox)) {
                if ([object gameObjectType] == tBall) {
                    if (characterState != sCoinCaptured) {
                        [object addHealth];
                        [self changeState:sCoinCaptured];

                        [[NSNotificationCenter defaultCenter] postNotificationName:@"statsKeeperAddCoin" 
                                                                            object:self];
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"positionOfItemToPlace" 
                                                                            object:self
                                                                          userInfo:objectInfo];
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadCoinLabel" 
                                                                            object:self];
                        
                        [self setIsActive:FALSE];
                    } 
                    
                }         
            }
        }
        
    }
    
}

-(void)initAnimations {
    [self setSpinningAnim:
     [self loadPlistForAnimationWithName:@"spinningAnim"
                            andClassName:NSStringFromClass([self class])]];
    
    [self setCapturedAnim:
     [self loadPlistForAnimationWithName:@"capturedAnim"
                            andClassName:NSStringFromClass([self class])]];
    
    [self setRemovingAnim:
     [self loadPlistForAnimationWithName:@"removingAnim"
                            andClassName:NSStringFromClass([self class])]];
}

- (id)initWithSpriteFrame:(CCSpriteFrame *)frame AtLocation:(CGPoint)location  {
    if ((self = [super init])) {
        body = NULL;
        gameObjectType = tCoin;                    // 3

        [self initAnimations];                                   // 1// 2
        [self changeState:sCoinSpinning]; 
        
        [self setDisplayFrame:frame];
        [self setPosition:location];
        
        objectInfo = [[NSMutableDictionary alloc] init];
        [objectInfo setObject:[NSNumber numberWithFloat:[self position].x ] forKey:notificationUserInfoKeyPositionX];
        [objectInfo setObject:[NSNumber numberWithFloat:[self position].y ] forKey:notificationUserInfoKeyPositionY];
        [objectInfo setObject:[NSNumber numberWithInt:tCoin] forKey:notificationUserInfoObjectType];

    }
    return self;
}

-(id) init {
    if( (self=[super init]) ) {
//        CCLOG(@"### Coin initialized");                      // 4
    
    }
    return self;
}
@end

