//
//  BallObject.h
//  Maze
//
//  Created by ian on 6/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "Box2DSprite.h"

@interface BallObject : Box2DSprite
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
