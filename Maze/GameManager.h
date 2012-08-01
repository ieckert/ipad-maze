//
//  GameManager.h
//  Maze
//
//  Created by ian on 7/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "StatsKeeper.h"
#import "ObjectFactory.h"

@interface GameManager : NSObject {
    BOOL isMusicON;
    BOOL isSoundEffectsON;
    BOOL hasPlayerDied;
    SceneTypes currentScene;
    
    StatsKeeper *statsKeeper;
    ObjectFactory *objectFactory;
    
}
@property (readwrite) BOOL isMusicON;
@property (readwrite) BOOL isSoundEffectsON;
@property (readwrite) BOOL hasPlayerDied;

+(GameManager*)sharedGameManager;                                  // 1
-(void)runSceneWithID:(SceneTypes)sceneID;                         // 2
@end