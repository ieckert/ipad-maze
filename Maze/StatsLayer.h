//
//  StatsLayer.h
//  Maze
//
//  Created by ian on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CCLayer.h"
#import "StatsKeeper.h"
#import "cocos2d.h"

@interface StatsLayer : CCLayer {
    StatsKeeper *statsKeeper;
    
    CCLabelTTF *timeLabel;
    CCLabelTTF *coinsLabel;
    
    
}
+(StatsLayer *) createSingleton;

-(void) updateTime: (NSInteger)time;
-(void) updateCoins;

@end
