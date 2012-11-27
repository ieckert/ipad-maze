//
//  StatsKeeper.h
//  Maze
//
//  Created by ian on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonProtocols.h"
#import "DataAdapter.h"

@interface StatsKeeper : NSObject {
    
    DataAdapter *dataAdapter;
    
    NSInteger coins;
    NSInteger time;
    NSInteger health;
    
    int currentLevel;
    BOOL active;
}

@property (readwrite, assign) int currentLevel;
@property (readwrite) BOOL active;

+(StatsKeeper *) createSingleton;

-(NSInteger) nextLevel;

-(NSInteger) returnStatFromLevel: (TrackedStats)stat: (NSInteger) level;

-(NSInteger) returnCurrentCoinCount;
-(NSInteger) returnCurrentTime;
-(NSInteger) returnCurrentLevel;
-(NSInteger) returnCurrentHealth;

-(void) dropStatsFromCurrentLevel;
-(void) dropStatsFromAllLevels;
@end