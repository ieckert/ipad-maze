//
//  HelloWorldLayer.m
//  Maze
//
//  Created by ian on 6/24/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// Import the interfaces
#import "MazeLayer.h"
#import "StatsLayer.h"

#define kUpdateFrequency	60.0

@implementation MazeLayer
@synthesize repeatingTimer, accel;

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
    
	// 'layer' is an autorelease object.
	MazeLayer *layer = [MazeLayer node];
    
	// add layer as a child to scene
	[scene addChild: layer];
    
	// return the scene
	return scene;
}


- (void)setupWorld {
    b2Vec2 gravity = b2Vec2(0.0f, -10.0f);
    bool doSleep = true;
    world = new b2World(gravity, doSleep);
}

- (void)setupDebugDraw {
    debugDraw = new GLESDebugDraw(PTM_RATIO*
                                  [[CCDirector sharedDirector] contentScaleFactor]);
    world->SetDebugDraw(debugDraw);
    debugDraw->SetFlags(b2DebugDraw::e_shapeBit);
}

-(void) draw {
    glDisable(GL_TEXTURE_2D);
    glDisableClientState(GL_COLOR_ARRAY);
    glDisableClientState(GL_TEXTURE_COORD_ARRAY);
    
    if (world) {
        world->DrawDebugData();
    }
    
    glEnable(GL_TEXTURE_2D);
    glEnableClientState(GL_COLOR_ARRAY);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
}

- (void)accelerometer:(UIAccelerometer *)accelerometer 
        didAccelerate:(UIAcceleration *)acceleration
{
//    NSLog(@"x: %f y: %f", acceleration.x, acceleration.y);
    b2Vec2 gravity(-acceleration.y * 4, acceleration.x * 4);
    world->SetGravity(gravity);
}

#pragma mark -
#pragma mark Update Method
-(void) update:(ccTime)deltaTime
{
    int32 velocityIterations = 3;
    int32 positionIterations = 2;
    world->Step(deltaTime, velocityIterations, positionIterations);
    
        if ( [statsKeeper returnCurrentCoinCount] == 5 ) {
            [self endingDuties];
            
        }
    
    for(b2Body *b=world->GetBodyList(); b!=NULL; b=b->GetNext()) {
        if (b->GetUserData() != NULL) {
            Box2DSprite *sprite = (Box2DSprite *) b->GetUserData();
            sprite.position = ccp(b->GetPosition().x * PTM_RATIO,
                                  b->GetPosition().y * PTM_RATIO);
            sprite.rotation =
            CC_RADIANS_TO_DEGREES(b->GetAngle() * -1);
        }
    }
    
    CCArray *listOfGameObjects =
    [sceneSpriteBatchNode children];                     
    for (GameObject *tempObject in listOfGameObjects) {         
        [tempObject updateStateWithDeltaTime:deltaTime andListOfGameObjects:
         listOfGameObjects]; 

    }
    
}


-(void)createObjectOfType:(GameObjectType)objectType
               atLocation:(CGPoint)spawnLocation
               withZValue:(int)ZValue {
    
    if (objectType == tBall) {
        BallObject *ball = [[BallObject alloc] initWithWorld:world
                                      atLocation:spawnLocation
                                 withSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]
                                                  spriteFrameByName:@"ball_2.png"]];
        [sceneSpriteBatchNode addChild:ball
                                     z:ZValue
                                   tag:kBallTagValue];  
        [ball release];
    }
    else if (objectType == tCoin) {
        CoinObject *coin = [[CoinObject alloc] initWithSpriteFrameName:
                            @"coin_1.png"];
        [coin setPosition:spawnLocation];
        [sceneSpriteBatchNode addChild:coin
                                     z:ZValue
                                   tag:kCoinTagValue];
        [coin release];
    }
    else if (objectType == tWall) {
        WallObject *wall = [[WallObject alloc] initWithWorld:world
                                                  atLocation:spawnLocation
                                             withSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]
                                                              spriteFrameByName:@"wall_4.png"]];
        [sceneSpriteBatchNode addChild:wall
                                     z:ZValue
                                   tag:kWallTagValue];  
        [wall release];
    }
    else {
        NSLog(@"trying to create something that doesn't exist");
    }
    
}

// on "init" you need to initialize your instance
-(id) init
{
	if( (self=[super init])) {   
        NSLog(@"MazeLayer Init");

        [self setupWorld];
        [self setupDebugDraw];
        
        statsKeeper = [StatsKeeper createSingleton];
        [statsKeeper setActive:TRUE];
        //setup accelerometer     
        [[UIAccelerometer sharedAccelerometer] setDelegate:self];
        [[UIAccelerometer sharedAccelerometer] setUpdateInterval:1.0f/60.0f];
        
        //setup basic window-size and touch
        self.isTouchEnabled = YES;
        
        //begin creating the maze
        requirements = [[MazeRequirements alloc] initWithRequirements:5 
                                                                     :0 
                                                                     :FALSE 
                                                                     :CGPointMake(1, kTrueMazeCols-1)];
        
        mazeMaker = [[MazeMaker alloc] initWithSizeAndRequirements:kMazeRows 
                                                                  :kMazeCols
                                                                  :requirements
                                                                  :mazeGrid];
        [mazeMaker createMaze2
         ];
        
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            [[CCSpriteFrameCache sharedSpriteFrameCache]
             addSpriteFramesWithFile:@"atlas2.plist"];           // 1
            sceneSpriteBatchNode =
            [CCSpriteBatchNode batchNodeWithFile:@"atlas2.png"]; // 2
        } else {
            [[CCSpriteFrameCache sharedSpriteFrameCache]
             addSpriteFramesWithFile:@"atlas2.plist"];     // 1
            sceneSpriteBatchNode =
            [CCSpriteBatchNode
             batchNodeWithFile:@"atlas2.png"];             // 2
        }
        
        [self addChild:sceneSpriteBatchNode z:0];                  // 3
        
        [self createObjectOfType:tBall
                      atLocation:ccp(48+30, 48*(kTrueMazeRows-1)-10)
                      withZValue:kBallZValue]; 
        
        for(int y = 0; y < kTrueMazeRows; y++)
        {
            for(int x = 0; x < kTrueMazeCols; x++)
            {
                int num = y * kTrueMazeCols + x;
                if (mazeGrid[num] == cWall) {
                    [self createObjectOfType:tWall
                                  atLocation:ccp(48*x+25, 48*y+25)
                                  withZValue:kWallZValue];   
                }
                else if (mazeGrid[num] == cCoin){
                    //create coin as GameObject:
                    [self createObjectOfType:tCoin
                                  atLocation:ccp(48*x+25, 48*y+25)
                                  withZValue:kCoinZValue];   
                }
            }
        }
        
    }
    [self scheduleUpdate];                                    
    [self setTimer];
    
	return self;
}

- (void) endingDuties
{
    NSLog(@"endingDuties reached");
    [statsKeeper nextLevel];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadLevelLabel" 
                                                        object:self];
    NSLog(@"going to level: %i", [statsKeeper currentLevel]);
    [statsKeeper setActive:FALSE];

    [repeatingTimer invalidate];

    /*
    CCArray *listOfGameObjects =
    [sceneSpriteBatchNode children];                 
    
    for (GameObject *tempObject in listOfGameObjects) {       
        id action = [CCMoveTo actionWithDuration:5.0f position:ccp(500,500)];
        [tempObject runAction:action];
    }
    */
    
    [[UIAccelerometer sharedAccelerometer] setDelegate:nil];
    
    [[GameManager sharedGameManager]
     runSceneWithID:kBasicLevel];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
    NSLog(@"MazeLayer Dealloc");

    [requirements release];
    [mazeMaker release];
    
    //might need to remove all things in the world first!
    delete world;
    world = NULL;
    delete debugDraw;

	[super dealloc];
}

-(void) setTimer
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                      target:self selector:@selector(timerDuties)
                                                    userInfo:nil repeats:YES];
    repeatingTimer = timer;    
}

-(void) timerDuties
{  
    [[NSNotificationCenter defaultCenter] postNotificationName:@"statsKeeperAddTime" object:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadTimeLabel" object:self];
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"stop touchin mah screen");
    
}


@end