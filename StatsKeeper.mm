//
//  StatsKeeper.m
//  Maze
//
//  Created by ian on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StatsKeeper.h"
#import "ObjectInfoConstants.h"
#import "Constants.h"

@implementation StatsKeeper
@synthesize currentLevel, active;
static StatsKeeper *singleton = nil;


- (id)init
{
    self = [super init];
    if (self) {
        NSLog(@"StatsKeeper Init");
        
        dataAdapter = [DataAdapter createSingleton];
        self.currentLevel = [dataAdapter returnLatestLevel];
        health = [dataAdapter returnLatestHealth];
        active = false;
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(addCoinDueToNotification:) 
                                                     name:@"statsKeeperAddCoin" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(addTimeDueToNotification:) 
                                                     name:@"statsKeeperAddTime" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(changeHealthDueToNotification:)
                                                     name:@"playerTouchedEnemy" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(changeHealthDueToNotification:)
                                                     name:@"resetPlayerHealth" object:nil];
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
//    NSLog(@"StatsKeeper NextLevel");
    BOOL tmpBool = FALSE;
    /*save off time and stats to core data*/
    tmpBool = [dataAdapter addStatisticsToLevel:[NSNumber numberWithInt:currentLevel]
                             WithTime:[NSNumber numberWithInt:time]
                             AndCoins:[NSNumber numberWithInt:coins]
                           WithHealth:[NSNumber numberWithInt:health]];
    if (tmpBool) {
//        NSLog(@"level saved correctly");
    }
    else {
        NSLog(@"level not saved");
    }
    /*reset counters since old data is saved*/
    coins = 0;
    [self dropStatsFromCurrentLevel];
    
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

-(NSInteger) returnCurrentHealth
{
    return health;
}

- (void)addCoinDueToNotification:(NSNotification *)notification {
    if (active == true)
    {
        coins++;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"coinAddedToStats" 
                                                        object:self];
    }
}

- (void)addTimeDueToNotification:(NSNotification *)notification {
    if (active == true)
        time++;
}

- (void)changeHealthDueToNotification:(NSNotification *)notification {
    if (active == true)
    {
        int tmp = [[[notification userInfo] objectForKey:[NSString stringWithString:playerHealth]] intValue];
        if (tmp < 0)
            health = 0;
        else if (tmp > 100)
            health = 100;
        else
            health = tmp;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"healthChanged"
                                                        object:self];
    }
}

-(void) dropStatsFromCurrentLevel
{
    coins = 0;
    time = 0;
    if (health <= 0) {
        health = [dataAdapter returnLatestHealth];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"healthChanged"
                                                        object:self];
}


-(void) changePlayerHealth:(NSInteger)hp
{
    if (hp < 100) {
        health = hp;        
    }
}

-(void) dropStatsFromAllLevels
{
    coins = 0;
    time = 0;
    if (health <= 0) {
        health = [dataAdapter returnLatestHealth];
    }    [dataAdapter deleteStatisticsForAllLevels];
    currentLevel = [dataAdapter returnLatestLevel];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"healthChanged"
                                                        object:self];
}


@end
