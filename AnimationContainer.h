//
//  AnimationContainer.h
//  Maze
//
//  Created by ian on 8/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameObject.h"

@interface AnimationContainer : GameObject
{
    AnimationContainer *next;
    id animation;
//    int animation;
}

@property (readwrite, retain) AnimationContainer *next;
@property (readwrite, retain) id animation;
//@property (readwrite, assign) int animation;
@end
