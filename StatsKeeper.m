//
//  StatsKeeper.m
//  Maze
//
//  Created by ian on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StatsKeeper.h"

@implementation StatsKeeper
@synthesize currentLevel, active;
static StatsKeeper *singleton = nil;


- (id)init
{
    self = [super init];
    if (self) {
        NSLog(@"StatsKeeper Init");
        
        dataAdapter = [DataAdapter createSingleton];
        self.currentLevel = 0;
        active = false;
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(addCoinDueToNotification:) 
                                                     name:@"statsKeeperAddCoin" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(addTimeDueToNotification:) 
                                                     name:@"statsKeeperAddTime" object:nil];
    }
    
    return self;
}

+ (StatsKeeper *) createSingleton
{
    @synchronized(singleton) {
        if ( !singleton || singleton==nil ) {
            singleton = [[StatsKeeper alloc] init];
        }
    }
    return singleton;
}

-(void)dealloc
{
    NSLog(@"StatsKeeper Dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [singleton release];
    
    [super dealloc];
}

-(NSInteger) nextLevel
{
    NSLog(@"StatsKeeper NextLevel");
    BOOL tmpBool = FALSE;
    /*save off time and stats to core data*/
    tmpBool = [dataAdapter addStatisticsToLevel:[NSNumber numberWithInt:currentLevel]
                             WithTime:[NSNumber numberWithInt:time]
                             AndCoins:[NSNumber numberWithInt:coins]];
    if (tmpBool) {
        NSLog(@"level saved correctly");
    }
    else {
        NSLog(@"level not saved");
    }
    /*reset counters since old data is saved*/
    coins = 0;
    time = 0;
    
    self.currentLevel++;
    return self.currentLevel;
}

-(NSInteger) returnStatFromLevel:(TrackedStats)stat :(NSInteger)level
{
    NSInteger returnStat = 0;
    
    /*
        query stat from certain level from core data
        return -1 if stat does not exist
     */
    
    return returnStat;
}

-(NSInteger) returnCurrentCoinCount
{
    return coins;
}

-(NSInteger) returnCurrentTime
{
    return time;
}

-(NSInteger) returnCurrentLevel
{
    return currentLevel;
}

- (void)addCoinDueToNotification:(NSNotification *)notification {
    if (active == true)
        coins++;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"coinAddedToStats" 
                                                        object:self];
}

- (void)addTimeDueToNotification:(NSNotification *)notification {
    if (active == true)
        time++;
}

-(void) dropStatsFromCurrentLevel
{
    coins = 0;
    time = 0;
}


@end
