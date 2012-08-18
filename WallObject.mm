//
//  WallObject.m
//  Maze
//
//  Created by ian on 6/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WallObject.h"
#import "ObjectInfoConstants.h"

@implementation WallObject
@synthesize collisionAnim, idleAnim;

- (void) dealloc{
    NSLog(@"wall dealloc called");
    [collisionAnim release];
    [idleAnim release];
    [super dealloc];
}

-(void)changeState:(CharacterStates)newState {
    [self stopAllActions];
    id action = nil;
    [self setCharacterState:sNewState];
    
    switch (newState) {
        case sWallIdle:
//            CCLOG(@"Wall->Starting the Spawning Animation");
            action = [CCAnimate actionWithAnimation:idleAnim
                               restoreOriginalFrame:NO];
            break;
            
        case sWallColliding:
//            CCLOG(@"Wall->Changing State to Idle");
            action = [CCAnimate actionWithAnimation:collisionAnim
                               restoreOriginalFrame:NO];
            break;
        
        default:
            CCLOG(@"Unhandled state %d in WallObject", newState);
            break;
    }
    if (action != nil) {
        [self runAction:action];
    }
}

-(void)updateStateWithDeltaTime:(ccTime)deltaTime
           andListOfGameObjects:(CCArray*)listOfGameObjects {                                                  
    
}

-(void)initAnimations {
    [self setCollisionAnim:
     [self loadPlistForAnimationWithName:@"collisionAnim"
                            andClassName:NSStringFromClass([self class])]];
    
    [self setIdleAnim:
     [self loadPlistForAnimationWithName:@"idleAnim"
                            andClassName:NSStringFromClass([self class])]];
}

- (void)createBodyAtLocation:(CGPoint)location {
    b2BodyDef bodyDef;
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

- (id)initWithWorld:(b2World *)theWorld atLocation:(CGPoint)location withSpriteFrame:(CCSpriteFrame *)frame {
    if ((self = [super init])) {
        world = theWorld;
        [self setDisplayFrame:frame];
        gameObjectType = tWall;
        [self createBodyAtLocation:location];
    }
    return self;
}

-(id) init {
    if( (self=[super init]) ) {
        [self initAnimations];                                   // 1// 2
        gameObjectType = tWall;                    // 3
        [self changeState:sWallIdle];                       // 4
    }
    return self;
}

@end

