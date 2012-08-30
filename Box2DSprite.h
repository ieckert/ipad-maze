//
//  Box2DSprite.h
//  Maze
//
//  Created by ian on 7/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "Box2D.h"
#import "GameObject.h"

@interface Box2DSprite : GameObject {
    b2Body *body;
}

@property (assign) b2Body *body;
@end
