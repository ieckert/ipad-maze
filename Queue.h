//
//  Queue.h
//  Maze
//
//  Created by ian on 8/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameObject.h"
#import "QueueObject.h"
#import "cocos2d.h"

@interface Queue : NSObject
{
    QueueObject *tail;
    QueueObject *head;
    int counter;    
}
@property (readonly, retain) QueueObject *tail;
@property (readonly, retain) QueueObject *head;
@property (readonly) int counter;

/*Normal push to have animations come out in FIFO order*/
-(void) enqueue:(id) object;

/*Have access to animations in normal FIFO order*/
-(id) dequeue;

/*To interrupt current animation with a new one - push onto the front! no waiting in lines!*/
-(void) lifoPush:(id) object;

-(BOOL) isQueueEmpty;

-(void) removeAllObjects;

@end
