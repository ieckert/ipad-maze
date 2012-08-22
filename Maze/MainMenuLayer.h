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
#import "Pair.h"
#import "ObjectFactory.h"

@interface MainMenuLayer : CCLayer <UIAccelerometerDelegate>
{
    CCMenu *mainMenu;
    CCMenu *sceneSelectMenu;
    
    b2World *world;
    GLESDebugDraw *debugDraw;

    CCSpriteBatchNode *sceneSpriteBatchNode;
    
    NSMutableArray *menuMaze;
    MazeMaker *mazeMaker;
    MazeRequirements *requirements;
    ObjectFactory *objectFactory;    
    
    //for debugging
    CCMenu *debugMenu;
    CCLabelTTF *accelLabel;
    CCLabelTTF *angDampLabel;
    CCLabelTTF *gravityScaleLabel;
    
    float gravityScale;
    float angDamp;
    int accelNum;
    
    int rows;
    int cols;
    Pair *mazeDimensions;
    
    CGSize screenSize;
    
}

@property (nonatomic, assign) UIAccelerometer *accel;

@end