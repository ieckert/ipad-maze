//
//  MazeRequirements.m
//  Maze
//
//  Created by ian on 7/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MazeRequirements.h"

@implementation MazeRequirements
@synthesize numCoins, numEnemies, straightShot, startingPosition;

- (void) dealloc
{
	[super dealloc];
}

-(id)init
{
    self = [super init];
    if (self) {
        NSLog(@"working with default maze requirement values");
        numCoins = 5;
        numEnemies = 0;
        straightShot = FALSE;
        startingPosition = CGPointMake(1.0f, kTrueMazeRows-1);
    }
    return self;
}

-(id) initWithRequirements: (NSInteger) coins
                          : (NSInteger) enemies
                          : (BOOL) allowStraights
                          : (CGPoint) startingPoint

{
    if (self = [super init])
    {
        numCoins = coins;
        numEnemies = enemies;
        straightShot = allowStraights;
        startingPosition = startingPoint;
    }
    return self;
}

@end
