//
//  StatsKeeper.h
//  Maze
//
//  Created by ian on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StatsObject.h"
#import "CommonProtocols.h"

@interface StatsKeeper : NSObject {
    
    NSMutableArray *statsArr;
    StatsObject *currentStats;
    int currentLevel;
    BOOL active;

}

@property (readwrite, assign) int currentLevel;
@property (readwrite) BOOL active;

+(StatsKeeper *) createSingleton;

-(NSInteger) nextLevel;

-(void) addCoin;
-(void) addTime;

-(NSInteger) returnStatFromLevel: (TrackedStats)stat: (NSInteger) level;

-(NSInteger) returnCurrentCoinCount;
-(NSInteger) returnCurrentTime;
-(NSInteger) returnCurrentLevel;

-(void) dropStatsFromCurrentLevel;
@end