//
//  MainMenuLayer.h
//  Maze
//
//  Created by ian on 7/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "MazeMaker.h"
#import "MazeRequirements.h"

#import "cocos2d.h"
#import "Constants.h"
#import "GameManager.h"
#import "Box2D.h"
#import "GLES-Render.h"

#import "WallObject.h"
#import "BallObject.h"
#import "CoinObject.h"

#import "ObjectFactory.h"

@interface MainMenuLayer : CCLayer <UIAccelerometerDelegate>
{
    CCMenu *mainMenu;
    CCMenu *sceneSelectMenu;
    
    b2World *world;
    GLESDebugDraw *debugDraw;

    CCSpriteBatchNode *sceneSpriteBatchNode;
    
    GameObjectType menuMaze[kTrueMenuMazeCols * kTrueMenuMazeRows];
    MazeMaker *mazeMaker;
    MazeRequirements *requirements;
    ObjectFactory *objectFactory;
}

@property (nonatomic, assign) UIAccelerometer *accel;

@end