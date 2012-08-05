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
        statsArr = [[NSMutableArray alloc] init];
        self.currentLevel = 0;
        currentStats = [[StatsObject alloc] init];
        [currentStats setTime:0];
        [currentStats setCoins:0];
        
        [statsArr insertObject:currentStats atIndex:currentLevel];
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
    [statsArr release];
    [currentStats release];
    
    [super dealloc];
}

-(NSInteger) nextLevel
{
//release old object
    [currentStats release];
    
//get new object
    currentStats = [[StatsObject alloc] init];
    [currentStats setTime:0];
    [currentStats setCoins:0];
    self.currentLevel++;
    [statsArr insertObject:currentStats atIndex:currentLevel];

    return self.currentLevel;
}

//-(void) addCoin
//{
//    if (active == true)
//        [[statsArr objectAtIndex:currentLevel] setCoins:[[statsArr objectAtIndex:currentLevel]coins]+1];
//}
//
//-(void) addTime
//{
//    if (active == true)
//        [[statsArr objectAtIndex:currentLevel] setTime:[[statsArr objectAtIndex:currentLevel]time]+1];
//}

-(NSInteger) returnStatFromLevel:(TrackedStats)stat :(NSInteger)level
{
    
    if ([statsArr objectAtIndex:level] == nil) {
        NSLog(@"that level does not exist!");
        return -1;
    }
    
    NSInteger num = 0;
    
    switch (stat) {
        case statCoin:
            num = [[statsArr objectAtIndex:level]coins];
            break;
        case statTime:
            num = [[statsArr objectAtIndex:level]time];
        default:
            break;
    }
    return num;
}

-(NSInteger) returnCurrentCoinCount
{
    return [[statsArr objectAtIndex:currentLevel]coins];
}

-(NSInteger) returnCurrentTime
{
    return [[statsArr objectAtIndex:currentLevel]time];
}

-(NSInteger) returnCurrentLevel
{
    return currentLevel;
}

- (void)addCoinDueToNotification:(NSNotification *)notification {
    if (active == true)
        [[statsArr objectAtIndex:currentLevel] setCoins:[[statsArr objectAtIndex:currentLevel]coins]+1];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"coinAddedToStats" 
                                                        object:self];
}

- (void)addTimeDueToNotification:(NSNotification *)notification {
    if (active == true)
        [[statsArr objectAtIndex:currentLevel] setTime:[[statsArr objectAtIndex:currentLevel]time]+1];
}

-(void) dropStatsFromCurrentLevel
{
    [[statsArr objectAtIndex:currentLevel] setCoins:0];
    [[statsArr objectAtIndex:currentLevel] setTime:0];
}


@end
