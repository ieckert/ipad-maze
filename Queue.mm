//
//  Queue.m
//  Maze
//
//  Created by ian on 8/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Queue.h"

@implementation Queue
@synthesize tail, head, counter;

-(id) init {
    if( (self=[super init]) ) {
        head = nil;
        tail = nil;
        counter = 0;
    }
    return self;
}

- (void) dealloc{
    tail = nil;
    head = nil;
    [super dealloc];
}

-(void) enqueueObjects:(NSArray *)objects
{
    for (id tmp in objects) {
        [self enqueue:tmp];
    }
    
}

-(void) enqueue:(id) animation
//-(void) enqueue:(int) animation
{
    QueueObject *tmp = [[QueueObject alloc] init];
    [tmp setM_next:nil];
    [tmp setObject:animation];
    
    if (head == nil) {
        head = tmp;
        tail = tmp;
    }
    else {
        [tail setM_next:tmp];
        tail = tmp;
    }
    counter++;
    
}

-(id) dequeue
{
    id tmpObject = nil;
    QueueObject *tmpContainer = nil;
    if (head == nil) {
//        NSLog(@"the queue is empty");
    }
    else if ([head m_next] == nil)
    {
        tmpObject = [head object];
        tmpContainer = head;
        head = nil;
        [tmpContainer release];
        counter--;
    }
    else if ([head m_next] != nil) {
        tmpObject = [head object];
        tmpContainer = head;
        head = [head m_next];
        [tmpContainer release];
        counter--;
    }
    else {
        NSLog(@"something else happend with dequeuein' the queue");
    }
    return tmpObject;
}

-(void) lifoPushObjects:(NSArray *)objects
{
    for (id tmp in objects) {
        [self lifoPush:tmp];
    }
    
}

-(void) lifoPush:(id) object
{
    QueueObject *tmp = [[QueueObject alloc] init];
    [tmp setObject:object];

    if (head == nil) {
        head = tmp;
        tail = tmp;
    }
    else {
        [tmp setM_next:head];
        head = tmp;
    }
    counter++;
    
}

-(BOOL) isQueueEmpty
{
    BOOL tmpBool;
    if (counter == 0)
        tmpBool = TRUE;
    else 
        tmpBool = FALSE;
    
    return tmpBool;
}

-(void) removeAllObjects
{
/*
    while (counter != 0) {
        [self dequeue];
    }
 */
    while (head)
        [self dequeue];
    return;
}


@end
