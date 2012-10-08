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

#define kBallBasicHealth 100
#define kEnemyBasicDamage 25

typedef enum {
    kEnemyWanderInMaze=0,
    kEnemyGoToPlayer=1,
    kEnemyShootPlayer=2,
    kEnemyChargePlayer=3
} EnemyLogic;

typedef enum {
    kEnemySense=0,
    kEnemyHearing=1,
    kEnemySightFront=2,
    kEnemySightSide=3
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
    tJumpUp=0,
    tLargeAndSpin=1
} TransitionCode;

typedef enum {
    sNewState=0,
    sBallRolling=1,
    sBallIdle=2,
    sBallColliding=3,
    sBallInvulnerable=4,
    sWallColliding=5,
    sWallIdle=6,
    sCoinSpinning=7,
    sCoinCaptured=8,
    sCoinIdle=9,
    sCoinRemoving=10,
    sDoorIdle=11,
    sDoorInteracting=12,
    sEnemyPatrol=13,
    sEnemyPathFinding=14,
    sEnemyAggressive=15,
    sEnemySleeping=16,
    sEnemyReloading=17,
    sEnemyShooting=18,
    sBallHurt=19,
    sCharacterDead=20
} CharacterStates;


