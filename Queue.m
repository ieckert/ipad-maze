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


-(void) enqueue:(id) animation
//-(void) enqueue:(int) animation
{
    AnimationContainer *tmp = [[AnimationContainer alloc] init];
    [tmp setNext:nil];
    [tmp setAnimation:animation];
    
    if (head == nil) {
        head = tmp;
        tail = tmp;
    }
    else {
        [tail setNext:tmp];
        tail = tmp;
    }
    counter++;
    
}

-(id) dequeue
//-(int) dequeue
{
    id animTmp = nil;
//    int animTmp;
    AnimationContainer *tmpContainer = nil;
    if (head == nil) {
        NSLog(@"the queue is empty");
    }
    else if ([head next] == nil)
    {
        animTmp = [head animation];
        tmpContainer = head;
        head = nil;
        [tmpContainer release];
        counter--;
    }
    else if ([head next] != nil) {
        animTmp = [head animation];
        tmpContainer = head;
        head = [head next];
        [tmpContainer release];
        counter--;
    }
    else {
        NSLog(@"something else happend with dequeuein' the queue");
    }
    return animTmp;
}

-(void) lifoPush:(id) animation
//-(void) lifoPush:(int)animation
{
    AnimationContainer *tmp = [[AnimationContainer alloc] init];
    [tmp setAnimation:animation];

    if (head == nil) {
        head = tmp;
        tail = tmp;
    }
    else {
        [tmp setNext:head];
        head = tmp;
    }
    counter++;
    
}


@end
