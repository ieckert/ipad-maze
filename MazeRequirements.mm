//
//  MazeRequirements.m
//  Maze
//
//  Created by ian on 7/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MazeRequirements.h"

@implementation MazeRequirements
@synthesize numCoins, numEnemies, straightShot, circles;

- (void) dealloc
{
    NSLog(@"MazeRequirements Dealloc");

	[super dealloc];
}

-(id)init
{
    self = [super init];
    if (self) {
        NSLog(@"working with default maze requirement values");
        numCoins = 5;
        numEnemies = 0;
        circles = 3;
        straightShot = FALSE;
    }
    return self;
}

-(id) initWithCoins: (NSInteger) coins
            Enemies: (NSInteger) enemies
 AllowableStraights: (BOOL) allowStraights
    NumberOfCircles: (NSInteger) numCircles
{
    if (self = [super init])
    {
        NSLog(@"MazeRequirements Init");
        numCoins = coins;
        numEnemies = enemies;
        straightShot = allowStraights;
        circles = numCircles;
    }
    return self;
}

@end
