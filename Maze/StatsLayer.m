//
//  StatsLayer.m
//  Maze
//
//  Created by ian on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StatsLayer.h"

@implementation StatsLayer
static StatsLayer *singleton = nil;

-(id)init {
    self = [super init];                                           // 1
    if (self != nil) {                                             // 2
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(addCoin:) 
                                                     name:@"reloadCoinLabel" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(addTime:) 
                                                     name:@"reloadTimeLabel" object:nil];
        
        statsKeeper = [StatsKeeper createSingleton];
        
        CGSize screenSize = [CCDirector sharedDirector].winSize;       

        timeLabel = [CCLabelTTF labelWithString:@"Time: 0" 
                                dimensions:CGSizeMake(300.0f, 300.0f) 
                                 alignment:UITextAlignmentLeft 
                                  fontName:@"Helvetica"
                                  fontSize:45.0f];
        timeLabel.position = ccp(160,620);
        [self addChild:timeLabel];
        
        coinsLabel = [CCLabelTTF labelWithString:@"Coins: 0" 
                                     dimensions:CGSizeMake(300.0f, 300.0f) 
                                      alignment:UITextAlignmentLeft 
                                       fontName:@"Helvetica"
                                       fontSize:45.0f];
        coinsLabel.position = ccp(460,620);
        [self addChild:coinsLabel];
        [self updateCoins];
    }
    return self;                                                   // 7
    
}

+ (StatsLayer *) createSingleton
{
    @synchronized(singleton) {
        if ( !singleton || singleton==nil ) {
            singleton = [[StatsLayer alloc] init];
        }
    }
    return singleton;
}

-(void)dealloc
{
    [singleton release];
    
    [super dealloc];
}

-(void) updateCoins
{
    coinsLabel.string = [NSString stringWithFormat:@"Coins: %i", [statsKeeper returnCurrentCoinCount]];
}

-(void) updateTime: (NSInteger) time
{
    timeLabel.string = [NSString stringWithFormat:@"Time: %i", time];
}

- (void)addCoin:(NSNotification *)notification {
    coinsLabel.string = [NSString stringWithFormat:@"Coins: %i", [statsKeeper returnCurrentCoinCount]];
}

- (void)addTime:(NSNotification *)notification {
    timeLabel.string = [NSString stringWithFormat:@"Time: %i", [statsKeeper returnCurrentTime]];
}

@end
