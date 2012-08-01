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
    bool doSleep = false;
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
    if (world == nil) {
        NSLog(@"got no world to go back to :(");
    }
    if (paused) {
        [statsKeeper setActive:FALSE];
    }
    else {
        [statsKeeper setActive:TRUE];

        int32 velocityIterations = 3;
        int32 positionIterations = 2;
        world->Step(deltaTime, velocityIterations, positionIterations);
        
            if ( [statsKeeper returnCurrentCoinCount] == 5 ) {
                [self endingDuties:kProgressNextLevel];
                
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
}

-(id) init
{
	if( (self=[super init])) {   
        NSLog(@"MazeLayer Init");

        paused = FALSE;
        objectFactory = [ObjectFactory createSingleton];
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
        [mazeMaker createMaze];
        
        
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
        
        [objectFactory createObjectOfType:tBall 
                               atLocation:ccp(48+30, 48*(kTrueMazeRows-1)-10) 
                               withZValue:kBallZValue
                                  inWorld:world
                addToSceneSpriteBatchNode:sceneSpriteBatchNode];
        
        for(int y = 0; y < kTrueMazeRows; y++)
        {
            for(int x = 0; x < kTrueMazeCols; x++)
            {
                int num = y * kTrueMazeCols + x;
                if (mazeGrid[num] == tWall) {
                    [objectFactory createObjectOfType:tWall
                                           atLocation:ccp(48*x+25, 48*y+25)
                                           withZValue:kWallZValue
                                              inWorld:world
                            addToSceneSpriteBatchNode:sceneSpriteBatchNode];
                }
                else if (mazeGrid[num] == tCoin){
                    //create coin as GameObject:
                    [objectFactory createObjectOfType:tCoin
                                           atLocation:ccp(48*x+25, 48*y+25)
                                           withZValue:kCoinZValue
                                              inWorld:world
                            addToSceneSpriteBatchNode:sceneSpriteBatchNode];
                }
            }
        }
        
    }
    [self scheduleUpdate];                                    
    [self setTimer];
    
	return self;
}

- (void) endingDuties: (NSInteger)option
{
    switch (option) {
        case kInGameMenuHome:
            NSLog(@"chose main menu");
            [statsKeeper setActive:FALSE];
            [repeatingTimer invalidate];
            
            [[UIAccelerometer sharedAccelerometer] setDelegate:nil];
            [statsKeeper dropStatsFromCurrentLevel];

            [[GameManager sharedGameManager]
             runSceneWithID:kMainMenuScene];
            break;
            
        case kInGameMenuReloadLevel:
            NSLog(@"chose reload");
            break;
            
        case kInGameMenuCancel:
            NSLog(@"chose cancel");
            if (pausedMenu != nil) {
                [pausedMenu removeFromParentAndCleanup:YES];
                paused = FALSE;
            }
            break;
        case kProgressNextLevel:
            NSLog(@"moving to next level");
            [statsKeeper nextLevel];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadLevelLabel" 
                                                                object:self];
            NSLog(@"going to level: %i", [statsKeeper currentLevel]);
            [statsKeeper setActive:FALSE];
            
            [repeatingTimer invalidate];
            
            [[UIAccelerometer sharedAccelerometer] setDelegate:nil];
            
            [[GameManager sharedGameManager]
             runSceneWithID:kBasicLevel];
            break;
            
        default:
            NSLog(@"when in ending duties -> found unidentified case: %i", option);
            break;
            
        /*
         CCArray *listOfGameObjects =
         [sceneSpriteBatchNode children];                 
         
         for (GameObject *tempObject in listOfGameObjects) {       
         id action = [CCMoveTo actionWithDuration:5.0f position:ccp(500,500)];
         [tempObject runAction:action];
         }
         */
    }
    
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

- (void) menuManager: (CCMenuItemFont*)option
{
    switch ([option tag]) {
        case kInGameMenuHome:
            NSLog(@"chose main menu");
            //need to save off game data here!!
            [self endingDuties:kInGameMenuHome];
            break;
        
        case kInGameMenuReloadLevel:
            NSLog(@"chose reload");
            break;
        
        case kInGameMenuCancel:
            NSLog(@"chose cancel");
            if (pausedMenu != nil) {
                [pausedMenu removeFromParentAndCleanup:YES];
                paused = FALSE;
            }
            break;
        
        default:
            NSLog(@"when opening in-game menu -> found unidentified case: %i", [option tag]);
            break;
    }
}

-(void)pausedAnimation
{
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    int randNum = arc4random() % 4; 
    int angle = 0;
    switch (randNum) {
        case 0:
            angle = 45;
            break;
        case 1:
            angle = 90;
            break;
        case 2:
            angle = -45;
            break;
        case 3:
            angle = -90;
            break;
        default:
            NSLog(@"unexpected number generated for random paused menu angle");
            break;
    }
    CCLabelTTF *pausedLabel =
    [CCLabelTTF labelWithString:@"PAUSED!" fontName:@"AmericanTypewriter-CondensedBold"
                       fontSize:64];                                                
    [pausedLabel setPosition:ccp(screenSize.width/2,screenSize.height/2)];
    
    [self addChild:pausedLabel];                                    
    id labelAction = [CCSpawn actions:
                      [CCRotateBy actionWithDuration:2.0f angle:angle],
                      [CCScaleBy actionWithDuration:2.0f scale:2.0],
                      [CCFadeOut actionWithDuration:2.0f],
                      nil];                                          
    [pausedLabel runAction:labelAction];
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    
//the if statement prevents the user from tapping multiple times and having the game crash
    if (paused == FALSE) {
        paused = TRUE;
        [self pausedAnimation];
        CCMenuItemFont *home = [CCMenuItemFont itemFromString:@"Main Menu" 
                                                         target:self 
                                                       selector:@selector(menuManager:)];
        home.fontName = [NSString stringWithString:@"AmericanTypewriter-CondensedBold"];
        home.fontSize = 45;
        [home setTag:kInGameMenuHome];
        
        CCMenuItemFont *restart = [CCMenuItemFont itemFromString:@"Re-Start" 
                                                             target:self 
                                                           selector:@selector(menuManager:)];
        restart.fontName = [NSString stringWithString:@"AmericanTypewriter-CondensedBold"];
        restart.fontSize = 45;
        [restart setTag:kInGameMenuReloadLevel];
        
        CCMenuItemFont *cancel = [CCMenuItemFont itemFromString:@"Cancel" 
                                                       target:self 
                                                     selector:@selector(menuManager:)];
        cancel.fontName = [NSString stringWithString:@"AmericanTypewriter-CondensedBold"];
        cancel.fontSize = 45;
        [cancel setTag:kInGameMenuCancel];

        
        pausedMenu = [CCMenu menuWithItems:home, restart, cancel, nil];
        
        [pausedMenu alignItemsVerticallyWithPadding:
         screenSize.height * 0.059f];
        [pausedMenu setPosition:
         ccp(screenSize.width/2,
             screenSize.height*-2)];
        id moveAction =
        [CCMoveTo actionWithDuration:1.2f
                            position:ccp(screenSize.width/2,
                                         screenSize.height/2)];
        id moveEffect = [CCEaseIn actionWithAction:moveAction rate:1.0f];
        [pausedMenu runAction:moveEffect];
        [self addChild:pausedMenu z:1 tag:kSceneMenuTagValue];
    }
}


@end