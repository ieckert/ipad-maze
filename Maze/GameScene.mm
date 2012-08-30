//
//  GameScene.m
//  Maze
//
//  Created by ian on 6/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene
-(id)init {
    self = [super init];
    if (self != nil) {
//        BackgroundLayer *backgroundLayer = [BackgroundLayer node];
//        [self addChild:backgroundLayer z:0];                       
        MazeLayer *gameplayLayer = [MazeLayer node];       
        [self addChild:gameplayLayer z:5];        
        
        StatsLayer *statsLayer = [StatsLayer node];       
        [self addChild:statsLayer z:10];  
    }
    return self;
}
@end
