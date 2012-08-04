//  Constants.h
// Constants used in Maze

#define kMazeCols 7
#define kMazeRows 5

#define kTrueScale 3
#define kTrueMazeCols kMazeCols*kTrueScale
#define kTrueMazeRows kMazeRows*kTrueScale

#define kMenuMazeCols 4
#define kMenuMazeRows 3

#define kTrueMenuMazeCols kMenuMazeCols*kTrueScale
#define kTrueMenuMazeRows kMenuMazeRows*kTrueScale

#define kBallZValue 100
#define kBallTagValue 0

#define kWallZValue 100
#define kWallTagValue 1

#define kCoinZValue 100
#define kCoinTagValue 2

#define PTM_RATIO ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 100.0 : 50.0)

#define kMainMenuTagValue 10
#define kSceneMenuTagValue 20

#define kAngularDamp 3
#define kAccelerometerConstant 13

typedef enum {
    kNoSceneUninitialized=0,
    kMainMenuScene=1,
    kOptionsScene=2,
    kBasicLevel=101
} SceneTypes;

typedef enum {
    kInGameMenuHome=0,
    kInGameMenuReloadLevel=1,
    kInGameMenuCancel=2,
    kProgressNextLevel=3
} inGameMenuOptions;


