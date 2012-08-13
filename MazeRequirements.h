//
//  MazeRequirements.h
//  Maze
//
//  Created by ian on 7/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface MazeRequirements : NSObject
{
    NSInteger startingPosition;
    NSInteger endingPosition;
    NSInteger numCoins;
    NSInteger numEnemies;
    NSInteger circles;
    BOOL straightShot;
    
}
@property (readwrite) NSInteger startingPosition;
@property (readwrite) NSInteger endingPosition;
@property (readwrite) NSInteger numCoins;
@property (readwrite) NSInteger numEnemies;
@property (readwrite) NSInteger circles;
@property (readwrite) BOOL straightShot;

-(id) initWithRequirements: (NSInteger) coins
                          : (NSInteger) enemies
                          : (BOOL) allowStraights
                          : (NSInteger) numCircles
                          : (NSInteger) startingPoint
                          : (NSInteger) endingPoint;

@end
