//
//  StatsLayer.m
//  Maze
//
//  Created by ian on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StatsLayer.h"

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
        
        statsKeeper = [StatsKeeper createSingleton];
        
        timeLabel = [CCLabelTTF labelWithString:@"Time: 0" 
                                dimensions:CGSizeMake(300.0f, 300.0f) 
                                 alignment:UITextAlignmentLeft 
                                  fontName:@"AmericanTypewriter-CondensedBold"
                                  fontSize:45.0f];
        timeLabel.position = ccp(180,620);
        [self addChild:timeLabel];
        
        coinsLabel = [CCLabelTTF labelWithString:@"Coins: 0" 
                                     dimensions:CGSizeMake(300.0f, 300.0f) 
                                      alignment:UITextAlignmentLeft 
                                       fontName:@"AmericanTypewriter-CondensedBold"
                                       fontSize:45.0f];
        coinsLabel.position = ccp(580,620);
        coinsLabel.string = [NSString stringWithFormat:@"Coins: %i", [statsKeeper returnCurrentCoinCount]];
        [self addChild:coinsLabel];
        
        levelLabel = [CCLabelTTF labelWithString:@"Level: 0" 
                                      dimensions:CGSizeMake(300.0f, 300.0f) 
                                       alignment:UITextAlignmentLeft 
                                        fontName:@"AmericanTypewriter-CondensedBold"
                                        fontSize:45.0f];
        levelLabel.position = ccp(980,620);
        levelLabel.string = [NSString stringWithFormat:@"Level: %i", [statsKeeper returnCurrentLevel]];
        [self addChild:levelLabel];
    }
    return self;                                                   // 7
    
}

-(void)dealloc
{    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reloadCoinLabel" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reloadTimeLabel" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reloadLevelLabel" object:nil];

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

@end
