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
    NSInteger numCoins;
    NSInteger numEnemies;
    NSInteger circles;
    BOOL straightShot;
    
}
@property (readwrite) NSInteger numCoins;
@property (readwrite) NSInteger numEnemies;
@property (readwrite) NSInteger circles;
@property (readwrite) BOOL straightShot;

-(id) initWithCoins: (NSInteger) coins
            Enemies: (NSInteger) enemies
 AllowableStraights: (BOOL) allowStraights
    NumberOfCircles: (NSInteger) numCircles;

@end
