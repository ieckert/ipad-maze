//
//  Pair.m
//  Maze
//
//  Created by ian on 7/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Pair.h"

@implementation Pair
@synthesize chosenBlock, breakdownBlock;

-(id)init
{
    self = [super init];
    if (self) {
        NSLog(@"Never use this function - need to use initWithRequirements");
    }
    return self;
}

-(id) initWithRequirements: (NSInteger) b1
                          : (NSInteger) b2
{
    if (self = [super init])
    {
        chosenBlock = b1;
        breakdownBlock = b2;
    }
    return self;
}
@end