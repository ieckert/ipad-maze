//
//  WallObject.h
//  Maze
//
//  Created by ian on 6/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "Box2DSprite.h"

@interface WallObject : Box2DSprite
{
    CCAnimation *collisionAnim;
    CCAnimation *idleAnim;

    b2World *world;

}
@property (nonatomic, retain) CCAnimation *collisionAnim;
@property (nonatomic, retain) CCAnimation *idleAnim;

- (id)initWithWorld:(b2World *)theWorld 
         atLocation:(CGPoint)location 
    withSpriteFrame:(CCSpriteFrame *)frame;
@end
