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
#import "MazeRequirements.h"
#import "StatsLayer.h"
#import "StatsKeeper.h"

#import "Constants.h"
#import "CommonProtocols.h"
#import "GameManager.h"

#import "WallObject.h"
#import "BallObject.h"
#import "CoinObject.h"

@interface MazeLayer : CCLayer <UIAccelerometerDelegate>
{
    MazeMaker *mazeMaker;
    StatsKeeper *statsKeeper;
    MazeRequirements *requirements;
    
    b2World *world;
    GLESDebugDraw *debugDraw;
    b2Body *groundBody;

    CCSpriteBatchNode *sceneSpriteBatchNode;
    
    NSTimer *repeatingTimer;
    
    MazeContents mazeGrid[kTrueMazeCols * kTrueMazeRows];

}

@property (nonatomic, assign) NSTimer *repeatingTimer;
@property (nonatomic, assign) UIAccelerometer *accel;

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

-(void)filterSelect;
- (void) setTimer;
- (void) timerDuties;

@end
