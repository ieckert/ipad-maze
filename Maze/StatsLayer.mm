//
//  StatsLayer.m
//  Maze
//
//  Created by ian on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StatsLayer.h"
#include "Constants.h"

#define itemsInDisplay 3

@implementation StatsLayer

-(id)init {
    self = [super init];                                           // 1
    if (self != nil) {                                             // 2
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(addCoin:) 
                                                     name:@"reloadCoinLabel" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(addTime:) 
                                                     name:@"reloadTimeLabel" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(addLevel:) 
                                                     name:@"reloadLevelLabel" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(changeHealth:)
                                                     name:@"healthChanged" object:nil];
        
        statsKeeper = [StatsKeeper createSingleton];
        
        timeLabel = [CCLabelTTF labelWithString:@"Time: 0" 
                                dimensions:CGSizeMake(300.0f, 300.0f) 
                                 alignment:UITextAlignmentLeft 
                                  fontName:@"AmericanTypewriter-CondensedBold"
                                  fontSize:45.0f];
        timeLabel.position = ccp(980,578);
        [self addChild:timeLabel];
        
        coinsLabel = [CCLabelTTF labelWithString:@"Coins: 0" 
                                     dimensions:CGSizeMake(300.0f, 300.0f) 
                                      alignment:UITextAlignmentLeft 
                                       fontName:@"AmericanTypewriter-CondensedBold"
                                       fontSize:45.0f];
        coinsLabel.position = ccp(980,478);
        coinsLabel.string = [NSString stringWithFormat:@"Coins: %i", [statsKeeper returnCurrentCoinCount]];
        [self addChild:coinsLabel];
        
        levelLabel = [CCLabelTTF labelWithString:@"Level: 0"
                                      dimensions:CGSizeMake(300.0f, 300.0f)
                                       alignment:UITextAlignmentLeft
                                        fontName:@"AmericanTypewriter-CondensedBold"
                                        fontSize:45.0f];
        levelLabel.position = ccp(980,378);
        levelLabel.string = [NSString stringWithFormat:@"Level: %i", [statsKeeper returnCurrentLevel]];
        [self addChild:levelLabel];
        
        healthLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"HP: %i", [statsKeeper returnCurrentHealth]]
                                      dimensions:CGSizeMake(300.0f, 300.0f)
                                       alignment:UITextAlignmentLeft
                                        fontName:@"AmericanTypewriter-CondensedBold"
                                        fontSize:45.0f];
        healthLabel.position = ccp(980,278);
        [self addChild:healthLabel];
    }
    return self;                                                   // 7
    
}

-(void)dealloc
{    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [super dealloc];
}

- (void)addCoin:(NSNotification *)notification {
    coinsLabel.string = [NSString stringWithFormat:@"Coins: %i", [statsKeeper returnCurrentCoinCount]];
}

- (void)addTime:(NSNotification *)notification {
    timeLabel.string = [NSString stringWithFormat:@"Time: %i", [statsKeeper returnCurrentTime]];
}

- (void)addLevel:(NSNotification *)notification {
    levelLabel.string = [NSString stringWithFormat:@"Level: %i", [statsKeeper returnCurrentLevel]];
}

- (void)changeHealth:(NSNotification *)notification {
    healthLabel.string = [NSString stringWithFormat:@"HP: %i", [statsKeeper returnCurrentHealth]];
}

@end
