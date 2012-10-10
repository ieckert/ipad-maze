//
//  MazeLayer.h
//  Maze
//
//  Created by ian on 6/24/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

#import "Box2D.h"
#import "GLES-Render.h"

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

#import "MazeMaker.h"
#import "MazeInterface.h"
#import "MazeRequirements.h"
#import "StatsLayer.h"
#import "StatsKeeper.h"

#import "Constants.h"
#import "CommonProtocols.h"
#import "GameManager.h"

#import "WallObject.h"
#import "BallObject.h"
#import "CoinObject.h"
#import "Pair.h"
#import "ObjectFactory.h"

@interface MazeLayer : CCLayer <UIAccelerometerDelegate>
{
    MazeMaker *mazeMaker;
    MazeInterface *mazeInterface;
    MazeRequirements *requirements;
    StatsKeeper *statsKeeper;
    ObjectFactory *objectFactory;
    NSInteger screenOffset;
    
    CCMenu *pausedMenu;

    b2World *world;
    GLESDebugDraw *debugDraw;
    b2Body *groundBody;

    CCSpriteBatchNode *sceneSpriteBatchNode;
    
    NSTimer *repeatingTimer;
    float timerCounter;
    NSInteger gameplayManagerUpdateInterval;
    
    NSInteger totalNumSpecialAreas;
    
    NSMutableArray *mazeGrid;
    Pair *mazeDimensions;

    BOOL paused;
    BOOL mazeComplete;
    BOOL onFinishDoor;
    
    float angDamp;
    int accelNum;
    
    int rows;
    int cols;
    float rowsRemainder;
    float colsRemainder;
    
    CGSize screenSize;

}

@property (nonatomic, assign) NSTimer *repeatingTimer;
@property (nonatomic, assign) UIAccelerometer *accel;

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

- (void) setTimer;
- (void) timerDuties;
- (void) drawMaze;
- (void) resetLevel;
- (void) loadBatchNode;

@end
