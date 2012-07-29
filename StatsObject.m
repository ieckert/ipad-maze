//
//  StatsObject.m
//  Maze
//
//  Created by ian on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StatsObject.h"

@implementation StatsObject
@synthesize time, coins;

- (id)init
{
    self = [super init];
    if (self) {
        NSLog(@"StatsObject Init");
        self.time = 0;
        self.coins = 0;

    }
    
    return self;
}

@end
