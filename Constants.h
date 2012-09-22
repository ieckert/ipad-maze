//  Constants.h
// Constants used in Maze

#define kMazeCols 7
#define kMazeRows 5
#define kMazeScreenOffset 25

#define kTrueScale 2
#define kTrueMazeCols kMazeCols*kTrueScale
#define kTrueMazeRows kMazeRows*kTrueScale

#define kMenuMazeCols 4
#define kMenuMazeRows 3
#define kMenuMazeScreenOffset 150

#define kTrueMenuMazeCols kMenuMazeCols*kTrueScale
#define kTrueMenuMazeRows kMenuMazeRows*kTrueScale

#define kBallZValue 100
#define kBallTagValue 0

#define kWallZValue 25
#define kWallTagValue 1

#define kCoinZValue 100
#define kCoinTagValue 2

#define kDoorZValue 25
#define kDoorTagValue 3

#define PTM_RATIO ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 100.0 : 50.0)

#define kMainMenuTagValue 10
#define kSceneMenuTagValue 20

#define kAngularDamp 3
#define kAccelerometerConstant 13

#define kEnemyHearingMultiplier 10
#define kEnemyVisionMultiplier 20
#define kEnemyPeripheralVisionMultiplier 3

typedef enum {
    kEnemyWanderInMaze=0,
    kEnemyGoToPlayer=1,
    kEnemyShootPlayer=2,
    kEnemyChargePlayer=3
} EnemyLogic;

typedef enum {
    kEnemySense=0,
    kEnemyHearing=1,
    kEnemySight=2
} EnemySense;

typedef enum {
    kNoSceneUninitialized=0,
    kMainMenuScene=1,
    kOptionsScene=2,
    kNormalLevel=3,
    kBonusLevel=4
} SceneTypes;

typedef enum {
    kInGameMenuHome=0,
    kInGameMenuReloadLevel=1,
    kInGameMenuCancel=2,
    kProgressNextLevel=3
} inGameMenuOptions;

typedef enum {
    tNone=0,
    tWall=1,
    tBall=2,
    tCoin=3,
    tStart=4,
    tFinish=5,
    tEnemy=6
} GameObjectType;

typedef enum {
    sNewState=0,
    sBallRolling=1,
    sBallIdle=2,
    sBallColliding=3,
    sWallColliding=4,
    sWallIdle=5,
    sCoinSpinning=6,
    sCoinCaptured=7,
    sCoinIdle=8,
    sCoinRemoving=9,
    sDoorIdle=10,
    sDoorInteracting=11,
    sEnemyPatrol=12,
    sEnemyPathFinding=13,
    sEnemyAggressive=14,
    sEnemySleeping=15,
    sEnemyReloading=16,
    sEnemyShooting=17
} CharacterStates;


