//
//  DoorObject.m
//  Maze
//
//  Created by ian on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DoorObject.h"
#import "ObjectInfoConstants.h"

@implementation DoorObject
@synthesize idleAnim, interactAnim;

- (void) dealloc{
//    NSLog(@"door dealloc called");

    [idleAnim release];
    [interactAnim release];
    [objectInfo release];
    
    [super dealloc];
}

-(void)changeState:(CharacterStates)newState {
    [self stopAllActions];
    id action = nil;
    [self setCharacterState:newState];
    
    switch (newState) {
        case sDoorIdle:
            
            break;
        case sDoorInteracting:
//            action = [CCSpawn actions:
//                      [CCRepeat actionWithAction:[CCAnimate actionWithAnimation:interactAnim restoreOriginalFrame:NO] times:5],
//                      [CCFadeOut actionWithDuration:2.0f],
//                      nil];
            break;
        default:
            NSLog(@"Unhandled state %d in DoorObject", newState);
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
                    if (characterState != sDoorInteracting) {
//                        NSLog(@"enterin' a door!");    
//                        [self changeState:sDoorInteracting];

                        [[NSNotificationCenter defaultCenter] postNotificationName:@"doorEntered" 
                                                                            object:self
                                                                          userInfo:objectInfo];                        
//                        [self setIsActive:FALSE];
                    } 
                    
                }         
            }
        }
        
    }
    
}

-(void)initAnimations {
    [self setIdleAnim:
     [self loadPlistForAnimationWithName:@"idleAnim"
                            andClassName:NSStringFromClass([self class])]];
    
    [self setInteractAnim:
     [self loadPlistForAnimationWithName:@"interactAnim"
                            andClassName:NSStringFromClass([self class])]];
}

- (id)initWithSpriteFrame:(CCSpriteFrame *)frame AtLocation:(CGPoint)location WithType:(GameObjectType)doorType
{
    if ((self = [super init])) {
        //either start or finish slot
        gameObjectType = doorType;                    // 3
        
//        [self initAnimations];                                   // 1// 2
        [self changeState:sDoorIdle]; 
        
        [self setDisplayFrame:frame];
        [self setPosition:location];
        
        objectInfo = [[NSMutableDictionary alloc] init];
        [objectInfo setObject:[NSNumber numberWithFloat:[self position].x ] forKey:notificationUserInfoKeyPositionX];
        [objectInfo setObject:[NSNumber numberWithFloat:[self position].y ] forKey:notificationUserInfoKeyPositionY];
        [objectInfo setObject:[NSNumber numberWithInt:doorType] forKey:notificationUserInfoObjectType];
    }
    return self;
}

-(id) init {
    if( (self=[super init]) ) {
        //        CCLOG(@"### Door initialized");                      // 4
        
    }
    return self;
}
@end

