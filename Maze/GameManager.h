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
#import "MazeInterface.h"
#import "ObjectFactory.h"
#import "DataAdapter.h"

@interface GameManager : NSObject {
    BOOL isMusicON;
    BOOL isSoundEffectsON;
    BOOL hasPlayerDied;
    
    SceneTypes currentScene;
    
    MazeInterface *mazeInterface;
    StatsKeeper *statsKeeper;
    ObjectFactory *objectFactory;
    DataAdapter *dataAdapter;
}

@property (readwrite) BOOL isMusicON;
@property (readwrite) BOOL isSoundEffectsON;
@property (readwrite) BOOL hasPlayerDied;

+(GameManager*)sharedGameManager;
-(void)runSceneWithID:(SceneTypes)sceneID;

@end