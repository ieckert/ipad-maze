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
    CCAnimation *collisionAnim;
    CCAnimation *rollingAnim;
    CCAnimation *idleAnim;
    
    b2World *world;

}

@property (nonatomic, retain) CCAnimation *collisionAnim;
@property (nonatomic, retain) CCAnimation *idleAnim;
@property (nonatomic, retain) CCAnimation *rollingAnim;

- (id)initWithWorld:(b2World *)theWorld 
         atLocation:(CGPoint)location 
    withSpriteFrame:(CCSpriteFrame *)frame;
@end
