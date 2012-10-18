//
//  MainMenuScene.m
//  Maze
//
//  Created by ian on 7/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainMenuScene.h"

@implementation MainMenuScene
-(id)init {
    self = [super init];
    if (self != nil) {
        mainMenuLayer = [MainMenuLayer node];
        [self addChild:mainMenuLayer z:10];
        mainMenuSettingsLayer = [MainMenuSettingsLayer node];
    }
    return self;
}
@end