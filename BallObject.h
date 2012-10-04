//
//  BallObject.h
//  Maze
//
//  Created by ian on 6/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "GameObject.h"

@interface BallObject : GameObject
{
    NSMutableDictionary *objectInfo;

    CCAnimation *collisionAnim;
    CCAnimation *rollingAnim;
    CCAnimation *idleAnim;
    
    b2World *world;
    
    NSInteger health;

}

@property (nonatomic, retain) CCAnimation *collisionAnim;
@property (nonatomic, retain) CCAnimation *idleAnim;
@property (nonatomic, retain) CCAnimation *rollingAnim;
@property (readwrite) NSInteger health;

- (id)initWithWorld:(b2World *)theWorld 
         atLocation:(CGPoint)location 
    withSpriteFrame:(CCSpriteFrame *)frame;
@end
