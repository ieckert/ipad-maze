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
    CCDirector *tmpDirector;

    CCLabelTTF *timeLabel;
    CCLabelTTF *coinsLabel;
    CCLabelTTF *levelLabel;
    CCLabelTTF *healthLabel;
    
}

@end
