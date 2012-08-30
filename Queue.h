//
//  Queue.h
//  Maze
//
//  Created by ian on 8/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameObject.h"
#import "AnimationContainer.h"
#import "cocos2d.h"

@interface Queue : GameObject
{
    AnimationContainer *tail;
    AnimationContainer *head;
    int counter;    
}
@property (readwrite, retain) AnimationContainer *tail;
@property (readwrite, retain) AnimationContainer *head;
@property (readonly) int counter;

/*Normal push to have animations come out in FIFO order*/
-(void) enqueue:(id) animation;
//-(void) enqueue:(int) animation;

/*Have access to animations in normal FIFO order*/
-(id) dequeue;
//-(int) dequeue;

/*To interrupt current animation with a new one - push onto the front! no waiting in lines!*/
-(void) lifoPush:(id) animation;
//-(void) lifoPush:(int) animation;


@end
