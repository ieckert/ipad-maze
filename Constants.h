//  Constants.h
// Constants used in Maze

#define kMazeCols 7
#define kMazeRows 5

#define kTrueScale 3
#define kTrueMazeCols kMazeCols*kTrueScale
#define kTrueMazeRows kMazeRows*kTrueScale

#define kBallZValue 100
#define kBallTagValue 0

#define kWallZValue 100
#define kWallTagValue 1

#define kCoinZValue 100
#define kCoinTagValue 2

#define PTM_RATIO ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 100.0 : 50.0)

#define kMainMenuTagValue 10
#define kSceneMenuTagValue 20

typedef enum {
    kNoSceneUninitialized=0,
    kMainMenuScene=1,
    kOptionsScene=2,
    kBasicLevel=101
} SceneTypes;