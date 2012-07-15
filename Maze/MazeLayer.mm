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
#import "AccelerometerFilter.h"

#define kUpdateFrequency	60.0

@implementation MazeLayer

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

- (void)createGround {
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    float32 margin = 10.0f;
    b2Vec2 lowerLeft = b2Vec2(margin/PTM_RATIO, margin/PTM_RATIO);
    b2Vec2 lowerRight = b2Vec2((winSize.width-margin)/PTM_RATIO,
                               margin/PTM_RATIO);
    b2Vec2 upperRight = b2Vec2((winSize.width-margin)/PTM_RATIO,
                               (winSize.height-margin)/PTM_RATIO);
    b2Vec2 upperLeft = b2Vec2(margin/PTM_RATIO,
                              (winSize.height-margin)/PTM_RATIO);
    
    b2BodyDef groundBodyDef;
    groundBodyDef.type = b2_staticBody;
    groundBodyDef.position.Set(0, 0);
    groundBody = world->CreateBody(&groundBodyDef);
    
    b2PolygonShape groundShape;
    b2FixtureDef groundFixtureDef;
    groundFixtureDef.shape = &groundShape;
    groundFixtureDef.density = 0.0;
    
    groundShape.SetAsEdge(lowerLeft, lowerRight);
    groundBody->CreateFixture(&groundFixtureDef);
    groundShape.SetAsEdge(lowerRight, upperRight);
    groundBody->CreateFixture(&groundFixtureDef);
    groundShape.SetAsEdge(upperRight, upperLeft);
    groundBody->CreateFixture(&groundFixtureDef);
    groundShape.SetAsEdge(upperLeft, lowerLeft);
    groundBody->CreateFixture(&groundFixtureDef);
}

-(void)changeFilter:(Class)filterClass
{
	// Ensure that the new filter class is different from the current one...
	if(filterClass != [filter class])
	{
		// And if it is, release the old one and create a new one.
		[filter release];
		filter = [[filterClass alloc] initWithSampleRate:kUpdateFrequency cutoffFrequency:5.0];
	}
}

-(void)filterSelect
{
    [self changeFilter:[LowpassFilter class]];
}

- (void)accelerometer:(UIAccelerometer *)accelerometer 
        didAccelerate:(UIAcceleration *)acceleration
{
//    [filter addAcceleration:acceleration];
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
 
//    if ( [statsKeeper returnCurrentCoinCount] == 1 ) {
//        [[GameManager sharedGameManager]
//         runSceneWithID:kMainMenuScene];
//    }
    
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
        ball = [[BallObject alloc] initWithWorld:world
                                      atLocation:spawnLocation
                                 withSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]
                                                  spriteFrameByName:@"ball_2.png"]];
        [sceneSpriteBatchNode addChild:ball
                                     z:kBallZValue
                                   tag:kBallTagValue];  
         [ball release];
    }
    else if (objectType == tCoin) {
        NSLog(@"Creating a coin");
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
                                     z:kWallZValue
                                   tag:kWallTagValue];  
        [wall release];

/*
        NSLog(@"Creating a wall");
        CCSprite *wallImage;
        wallImage = [CCSprite
                     spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] 
                                            spriteFrameByName:@"wall_4.png"]];
        [wallImage setPosition:spawnLocation];
        [self addChild:wallImage z:kWallZValue tag:kWallTagValue]; 
 */   
 }
    else {
        NSLog(@"trying to create something that doesn't exist");
    }
    
}

// on "init" you need to initialize your instance
-(id) init
{
	if( (self=[super init])) {   
        
        [self setupWorld];
        [self setupDebugDraw];
//        [self createGround];
        
        statsKeeper = [StatsKeeper createSingleton];
//setup accelerometer and data filter     
        UIAccelerometer *accel = [UIAccelerometer sharedAccelerometer];
        accel.delegate         = self;
        accel.updateInterval   = 1.0f / 60.0f;
//        [self changeFilter:[LowpassFilter class]];

//setup basic window-size and touch
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        self.isTouchEnabled = YES;

//begin creating the maze
        requirements = [[MazeRequirements alloc] initWithRequirements:5 
                                                                     :0 
                                                                     :NO 
                                                                     :CGPointMake(1, kTrueMazeCols-1)];
        mazeMaker = [[MazeMaker alloc] initWithSizeAndRequirements:kMazeRows 
                                                                  :kMazeCols
                                                                  :requirements
                                                                  :mazeGrid];
        [mazeMaker createMaze];
        //        [mazeMaker release];
        
        srandom(time(NULL)); // Seeds the random number generator
        
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
                                  withZValue:10];   
                }
                else if (mazeGrid[num] == cCoin){
                    //create coin as GameObject:
                    [self createObjectOfType:tCoin
                                  atLocation:ccp(48*x+25, 48*y+25)
                                  withZValue:10];   
                }
                
                
            }
            
        }
        
        
    }
    [self scheduleUpdate];                                    
    [self setTimer];
    
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
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


@end
