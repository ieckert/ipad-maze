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
#import "ObjectInfoConstants.h"
@interface MazeLayer()
-(void) gameplayManager;
@end

@implementation MazeLayer
@synthesize repeatingTimer, accel;

-(void) countdownToStart:(NSString *) str
{
    CGPoint location = CGPointMake(screenSize.width/2,screenSize.height/2);
    CCLabelTTF *l1 = [CCLabelTTF labelWithString:@"" 
                                        fontName:@"AmericanTypewriter-CondensedBold"
                                        fontSize:100];                                                
    [self addChild:l1];
    [l1 setPosition:location];    
    [l1 setString:str];
    id la1 = [CCSequence actions:[CCFadeIn actionWithDuration:.75f], 
              [CCFadeOut actionWithDuration:.75f], 
              nil];
    [l1 runAction:la1];    
}

-(void) pauseGame
{
    paused = TRUE;
//pause update on time/coins/level labels
    [statsKeeper setActive:FALSE];
//send notification for all enemies to pause movement
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pauseGameObjects" 
                                                        object:self];
}

-(void) unpauseGame
{
    paused = FALSE;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"unPauseGameObjects" 
                                                        object:self];
    [statsKeeper setActive:TRUE];
}

-(void) playerDiedTransition:(NSNotification *)notification
{
    [self pauseGame];

    NSDictionary *userInfo = [[NSDictionary alloc] initWithDictionary:[notification userInfo]];
    CGPoint playerLocation;
    playerLocation.x = [[userInfo objectForKey:[NSString stringWithString:notificationUserInfoKeyPositionX]]floatValue];
    playerLocation.y = [[userInfo objectForKey:[NSString stringWithString:notificationUserInfoKeyPositionY]]floatValue];
    
    [self placeAlert:@": (" AtLocation:playerLocation WithType:[NSNumber numberWithInt:tLargeAndSpin] WithDuration:2.0f];
    [self performSelector:@selector(countdownToStart:) withObject:@"You Died" afterDelay:3.0f];
    [self performSelector:@selector(resetLevel) withObject:nil afterDelay:4.5f];
    [userInfo release];
}

-(void) restartLevelSceneTransition
{
    [self performSelector:@selector(countdownToStart:) withObject:@"READY" afterDelay:.5f];
    [self performSelector:@selector(countdownToStart:) withObject:@"GO!" afterDelay:2.0f];
    [self performSelector:@selector(unpauseGame) withObject:nil afterDelay:2.2f];
}

//transition from previous scene to this one
-(void) onEnterTransitionDidFinish
{
    mazeComplete = FALSE;
    onFinishDoor = FALSE;
    
    [self performSelector:@selector(countdownToStart:) withObject:@"READY" afterDelay:.5f];
    [self performSelector:@selector(countdownToStart:) withObject:@"GO!" afterDelay:2.0f];
    [self performSelector:@selector(unpauseGame) withObject:nil afterDelay:2.2f];
}

-(void)placeParticleEmitterAtLocation:(CGPoint)location ForObjectType:(GameObjectType)type{
    //coin collection: sun
    //end of level: fireworks
    CCParticleSystemQuad *partEmitter;

    if (type == tBall) {
        CCSprite *ballsprite = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"ball_2.png"]];
        partEmitter = [[CCParticleExplosion alloc] initWithTotalParticles:20];
        ccColor4F emitterColor = {0, 255, 0, 255};
        [partEmitter setStartColor:emitterColor];
        [partEmitter setTexture:ballsprite.texture withRect:ballsprite.textureRect];
        [partEmitter setEmitterMode:kCCParticleModeGravity];
        [partEmitter setStartSize:2.0f];
        [partEmitter setEndSize:15.0f];
        [partEmitter setDuration:.75f];
        [partEmitter setSpeed:100.0f];
    }
    else if (type == tCoin)
    {
        CCSprite *coinSprite = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"coin_1.png"]];
        partEmitter = [[CCParticleSun alloc] initWithTotalParticles:20];
        ccColor4F emitterColor = {255, 255, 0, 255};
        [partEmitter setStartColor:emitterColor];
        [partEmitter setTexture:coinSprite.texture withRect:coinSprite.textureRect];
        [partEmitter setEmitterMode:kCCParticleModeGravity];
        [partEmitter setStartSize:5.0f];
        [partEmitter setEndSize:30.0f];
        [partEmitter setDuration:1.5f];
        [partEmitter setSpeed:100.0f];
    }

    [partEmitter setPosition:location];
    
    [self addChild:partEmitter];
    [partEmitter release];
}


-(void) placeAlert:(NSString*)alert AtLocation:(CGPoint)location WithType:(NSNumber*)transitionCode WithDuration:(ccTime)duration
{
    CCLabelTTF *l1 = [CCLabelTTF labelWithString:alert
                                        fontName:@"AmericanTypewriter-CondensedBold"
                                        fontSize:25];
    id la1 = nil;
    switch ([transitionCode intValue]) {
        case tJumpUp:
            la1 = [CCSequence actions:[CCScaleTo actionWithDuration:duration scale:3.0],
                      [CCFadeOut actionWithDuration:duration],
                      nil];
            break;
        case tLargeAndSpin:
            la1 = [CCSpawn actions:[CCRotateBy actionWithDuration:duration angle:360], [CCScaleBy actionWithDuration:duration scale:5], [CCFadeOut actionWithDuration:duration], nil];
            break;
        default:
            break;
    }
    
    [self addChild:l1];
    [l1 setPosition:location];    
    
    if (la1 != nil) {
        [l1 runAction:la1];
    }
}

//hacked work around to have a selector call the above function
//couldn't do it because the selector can only pass objects, not enums
-(void) itemCapturedHandler:(NSNotification *)notification
{
    NSDictionary *userInfo = [[NSDictionary alloc] initWithDictionary:[notification userInfo]];
    CGPoint itemLocation;
    itemLocation.x = [[userInfo objectForKey:[NSString stringWithString:notificationUserInfoKeyPositionX]]floatValue];
    itemLocation.y = [[userInfo objectForKey:[NSString stringWithString:notificationUserInfoKeyPositionY]]floatValue];
    
//    NSLog(@"in item captured handler X:%f Y:%f Item:%i", itemLocation.x, itemLocation.y, [[userInfo objectForKey:notificationUserInfoObjectType] intValue]);
    
    if ([[userInfo objectForKey:notificationUserInfoObjectType] intValue] == tCoin) {
        [self placeParticleEmitterAtLocation:itemLocation ForObjectType:tCoin];
    }
    else if ([[userInfo objectForKey:notificationUserInfoObjectType] intValue] == tEnemy) {
        [self placeAlert:@"!" AtLocation:itemLocation WithType:[NSNumber numberWithInt:tJumpUp] WithDuration:1.0];
    }
    else if ([[userInfo objectForKey:notificationUserInfoObjectType] intValue] == tBall) {
        NSLog(@"placing emitter for ball");
        [self placeParticleEmitterAtLocation:itemLocation ForObjectType:tBall];
    }
    [userInfo release];
    
}

-(void) playerAtDoorHandler:(NSNotification *)notification
{
    NSDictionary *userInfo = [[NSDictionary alloc] initWithDictionary:[notification userInfo]];
    
    CGPoint doorPosition;
    doorPosition.x = [[userInfo objectForKey:[NSString stringWithString:notificationUserInfoKeyPositionX]]floatValue];
    doorPosition.y = [[userInfo objectForKey:[NSString stringWithString:notificationUserInfoKeyPositionY]]floatValue];
//    NSLog(@"doorPosition x: %f y: %f", doorPosition.x, doorPosition.y);
    if ([[userInfo objectForKey:[NSString stringWithString:notificationUserInfoObjectType]] intValue] == tFinish ) {
        onFinishDoor = true;
    }
    
    //[self placeParticleEmitterAtLocation:doorPosition];
    [userInfo release];
}


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

- (void)createGround {
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    float32 margin = 0.0f;
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

- (void)accelerometer:(UIAccelerometer *)accelerometer 
        didAccelerate:(UIAcceleration *)acceleration
{
//    NSLog(@"x: %f y: %f", acceleration.x, acceleration.y);
        b2Vec2 gravity(-acceleration.y * accelNum, acceleration.x * accelNum);
        world->SetGravity(gravity);
}

-(void) endingTransition
{
    NSLog(@"playing ending transition");
    [statsKeeper setActive:FALSE];
    
    NSNumber *tmp = [NSNumber numberWithInt:kProgressNextLevel];
    [self performSelector:@selector(pauseGame) withObject:nil afterDelay:2.0f];
    [self performSelector:@selector(endingDuties:) withObject:tmp afterDelay:5.0f];
    
    CCArray *listOfGameObjects =
    [sceneSpriteBatchNode children];                     
    for (GameObject *tempObject in listOfGameObjects) {
        if ([tempObject isActive] == true)
            [tempObject runAction:[CCFadeOut actionWithDuration:5.0f]];        
    }
    
    for(b2Body *b=world->GetBodyList(); b!=NULL; b=b->GetNext()) {
        if (b->GetUserData() != NULL) {
            b->SetType(b2_dynamicBody);
            b->ApplyForce(b2Vec2(arc4random()%50, arc4random()%50), b->GetWorldCenter() );
        }
    }
}

#pragma mark -
#pragma mark Update Method
-(void) update:(ccTime)deltaTime
{
    if (world == nil) {
        NSLog(@"got no world to go back to :(");
        return;
    }
        int32 velocityIterations = 3;
        int32 positionIterations = 2;
        world->Step(deltaTime, velocityIterations, positionIterations);
        
        CCArray *listOfGameObjects =
        [sceneSpriteBatchNode children];                     
        for (GameObject *tempObject in listOfGameObjects) { 
            [tempObject updateStateWithDeltaTime:deltaTime andListOfGameObjects:
                 listOfGameObjects];
            b2Body *b = [tempObject body];
            if (b!=NULL) {
                //the if statement below prevents the ball from moving while the 3..2..1..GO! is visible                
                if (tempObject.gameObjectType == tBall && paused) {
                    b->SetAwake(FALSE);
                }
                else if (tempObject.gameObjectType == tBall && !paused) {
                    b->SetAwake(TRUE);
                }
                
                tempObject.position = ccp(b->GetPosition().x * PTM_RATIO,
                                      b->GetPosition().y * PTM_RATIO);
                tempObject.rotation =
                CC_RADIANS_TO_DEGREES(b->GetAngle() * -1);
            }
        }
    
        if ( /* [statsKeeper returnCurrentCoinCount] == [requirements numCoins] 
            && */ 
            paused == FALSE
            && mazeComplete == FALSE
            && onFinishDoor == TRUE) {
            onFinishDoor = FALSE;
            //prevents this from being called over and over while update still works
            mazeComplete = TRUE;
            [self endingTransition];
        }
}

- (void) drawMaze
{
    int x, y, mazeSize;
    Pair *tmpCoords = [[Pair alloc] initWithRequirements:0 :0];
    CGPoint tmpLocation;
    mazeSize = rows*cols;
    for(int i = 0; i < mazeSize; i++)
    {
        tmpCoords = [mazeMaker translateLargeArrayIndexToXY:i];
        x = tmpCoords.num1;
        y = tmpCoords.num2;

//for objectFactory returnObjectDimensions - num1 is height - num2 is width
        tmpLocation.x = [objectFactory returnObjectDimensions:tWall].num2*x+kMazeScreenOffset;
        tmpLocation.y = [objectFactory returnObjectDimensions:tWall].num2*y+kMazeScreenOffset;
        
        if ([[mazeGrid objectAtIndex:i] intValue] == tWall) {
            [objectFactory createObjectOfType:tWall
                                   atLocation:tmpLocation
                                   withZValue:kWallZValue
                                      inWorld:world
                    addToSceneSpriteBatchNode:sceneSpriteBatchNode];
        }
        else if ([[mazeGrid objectAtIndex:i] intValue] == tCoin){
            //create coin as GameObject:
            [objectFactory createObjectOfType:tCoin
                                   atLocation:tmpLocation
                                   withZValue:kCoinZValue
                                      inWorld:world
                    addToSceneSpriteBatchNode:sceneSpriteBatchNode];
        }
        else if ([[mazeGrid objectAtIndex:i] intValue] == tEnemy) {
            [objectFactory createEnemyOfType:tEnemy
                                  atLocation:tmpLocation
                                  withZValue:kCoinZValue
                                     inWorld:world
                   addToSceneSpriteBatchNode:sceneSpriteBatchNode
                         withKnowledgeOfMaze:mazeMaker];
        }
        else if ([[mazeGrid objectAtIndex:i] intValue] == tStart) {
            NSLog(@"starting position at: %i", i);
            [objectFactory createObjectOfType:tStart
                                   atLocation:tmpLocation
                                   withZValue:kDoorZValue
                                      inWorld:world
                    addToSceneSpriteBatchNode:sceneSpriteBatchNode];
            
            [objectFactory createObjectOfType:tBall 
                                   atLocation:tmpLocation 
                                   withZValue:kBallZValue
                                      inWorld:world
                    addToSceneSpriteBatchNode:sceneSpriteBatchNode];
        }
        else if ([[mazeGrid objectAtIndex:i] intValue] == tFinish) {
            NSLog(@"ending position at: %i", i);
            [objectFactory createObjectOfType:tFinish
                                   atLocation:tmpLocation
                                   withZValue:kDoorZValue
                                      inWorld:world
                    addToSceneSpriteBatchNode:sceneSpriteBatchNode];
        }
        else {
            //empty location
            [mazeInterface addPoint:tmpLocation];
        }
        
    }
    
//    [tmpCoords release];
}

- (void) resetLevel
{
//pause game
    [self pauseGame];
    [self unschedule:@selector(update:)];

    CCArray *listOfGameObjects =
    [sceneSpriteBatchNode children];
    for (GameObject *tempObject in listOfGameObjects) {
        b2Body *b = [tempObject body];
        if (b!=NULL) {
            world->DestroyBody(b);
        }
    }
//remove all objects
    [sceneSpriteBatchNode removeAllChildrenWithCleanup:YES];

    [self drawMaze];
//reset labels
    [statsKeeper dropStatsFromCurrentLevel];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadTimeLabel" object:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadCoinLabel" object:self];

//bring back number of enemies / special areas to spawn
    totalNumSpecialAreas = kNumberSpecialAreas;
    
//unpause game
    [self schedule:@selector(update:)];
    [self restartLevelSceneTransition];
}

-(void) loadBatchNode
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [[CCSpriteFrameCache sharedSpriteFrameCache]
         addSpriteFramesWithFile:@"atlas1.plist"];           // 1
        sceneSpriteBatchNode =
        [CCSpriteBatchNode batchNodeWithFile:@"atlas1.png"]; // 2
    } else {
        [[CCSpriteFrameCache sharedSpriteFrameCache]
         addSpriteFramesWithFile:@"atlas1.plist"];     // 1
        sceneSpriteBatchNode =
        [CCSpriteBatchNode
         batchNodeWithFile:@"atlas1.png"];             // 2
    }
}

-(void) setupAccelerometer
{
    [[UIAccelerometer sharedAccelerometer] setDelegate:self];
    [[UIAccelerometer sharedAccelerometer] setUpdateInterval:1.0f/60.0f];
}

-(id) init
{
	if( (self=[super init])) {   
        NSLog(@"MazeLayer Init");
        screenSize = [CCDirector sharedDirector].winSize;
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(itemCapturedHandler:) 
                                                     name:@"positionOfItemToPlace" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(playerAtDoorHandler:) 
                                                     name:@"doorEntered" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(itemCapturedHandler:) 
                                                     name:@"playerTouchedEnemy" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerDiedTransition:)
                                                     name:@"playerDied" object:nil];
        
        angDamp = kAngularDamp;
        accelNum = kAccelerometerConstant;
        
        [self loadBatchNode];
        
        [self addChild:sceneSpriteBatchNode z:0];                  // 3
        
        objectFactory = [ObjectFactory createSingleton];
        
        /*find the offset used for displaying things to the screen*/
        /*based off the scene type*/
        if ([mazeMaker mazeForScene] == kMainMenuScene) {
            screenOffset = kMenuMazeScreenOffset;
        }
        else if ([mazeMaker mazeForScene] == kNormalLevel) {
            screenOffset = kMazeScreenOffset;
        }
        else {
            screenOffset = 0;
        }
        
        mazeInterface = [MazeInterface createSingleton];
        [mazeInterface removeAllOpenPoints];
//calculate depends on objectFactory width/height for walls - so call after objectFactory's init

        [self setupWorld];
//        [self setupDebugDraw];
        [self createGround];
        
        statsKeeper = [StatsKeeper createSingleton];
        [statsKeeper setActive:TRUE];

        //setup accelerometer     
        [self setupAccelerometer];
        
        //setup basic window-size and touch
        self.isTouchEnabled = YES;
        
        //begin creating the maze
        mazeGrid = [[NSMutableArray alloc] init];
        
        requirements = [[MazeRequirements alloc] initWithCoins:25
                                                       Enemies:2
                                                  SpecialAreas:0
                                            AllowableStraights:NO
                                               NumberOfCircles:5];
        totalNumSpecialAreas = kNumberSpecialAreas;
        
        mazeGrid = [[NSMutableArray alloc] init];
        
        mazeMaker = [[MazeMaker alloc] initWithHeight:screenSize.height
                                                Width:(screenSize.width - 150)
                                       WallDimensions:[objectFactory returnObjectDimensions:tWall]
                                         Requirements:requirements
                                                 Maze:mazeGrid
                                             ForScene:kNormalLevel];
        
        mazeDimensions = [[Pair alloc] initWithRequirements:0 :0];
        mazeDimensions = [mazeMaker createMaze];
        rows = mazeDimensions.num1;
        cols = mazeDimensions.num2;
        [mazeDimensions release];

        [self drawMaze];
        [self scheduleUpdate];
        gameplayManagerUpdateInterval = kGameplayManagerUpdateInterval;
        [self setTimer];
        [self pauseGame];
    }
	return self;
}

- (void) endingDuties: (NSNumber*)option
{    
    switch ([option intValue]) {
        case kInGameMenuHome:
            NSLog(@"chose main menu");

            [[UIAccelerometer sharedAccelerometer] setDelegate:nil];
            
            [statsKeeper setActive:FALSE];
            [statsKeeper dropStatsFromCurrentLevel];
            
            [repeatingTimer invalidate];
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            
            [[GameManager sharedGameManager]
             runSceneWithID:kMainMenuScene];
            break;
            
        case kInGameMenuReloadLevel:
            NSLog(@"chose reload");
            break;
            
        case kProgressNextLevel:
            [[UIAccelerometer sharedAccelerometer] setDelegate:nil];
            
            [statsKeeper setActive:FALSE];
            
            [repeatingTimer invalidate];
            [[NSNotificationCenter defaultCenter] removeObserver:self];

            [[GameManager sharedGameManager]
             runSceneWithID:kNormalLevel];
            break;
            
        default:
            NSLog(@"when in ending duties -> found unidentified case: %i", [option intValue] );
            break;
        
    }
    
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
    NSLog(@"MazeLayer Dealloc");

    [requirements release];
    [mazeMaker release];
    [mazeGrid release];
    
    //might need to remove all things in the world first!
    delete world;
    world = NULL;
    delete debugDraw;
    
    [sceneSpriteBatchNode removeAllChildrenWithCleanup:YES];
    [sceneSpriteBatchNode removeFromParentAndCleanup:YES];

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
    if ([statsKeeper active] == TRUE && !paused) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"statsKeeperAddTime" object:self];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadTimeLabel" object:self];
        timerCounter += [repeatingTimer timeInterval];
        if ( (int)timerCounter % gameplayManagerUpdateInterval == 0) {
            [self gameplayManager];
        }
    }
}

- (void) menuManager: (CCMenuItemFont*)option
{
    NSNumber *tmp;
    switch ([option tag]) {
        case kInGameMenuHome:
            NSLog(@"chose main menu");
            tmp = [NSNumber numberWithInt:kInGameMenuHome];
            [self endingDuties:tmp];
            break;
        
        case kInGameMenuReloadLevel:
            NSLog(@"chose reload");
            if (pausedMenu != nil) {
                [self resetLevel];
                [pausedMenu removeFromParentAndCleanup:YES];
            }
            break;
        
        case kInGameMenuCancel:
            NSLog(@"chose cancel");
            if (pausedMenu != nil) {
                [pausedMenu removeFromParentAndCleanup:YES];
                [self unpauseGame];
            }
            break;
        
        default:
            NSLog(@"when opening in-game menu -> found unidentified case: %i", [option tag]);
            break;
    }
}

-(void)pausedAnimation
{
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
    [pausedLabel setPosition:ccp(screenSize.width/2, screenSize.height/2)];
    
    [self addChild:pausedLabel];                                    
    id labelAction = [CCSpawn actions:
                      [CCRotateBy actionWithDuration:2.0f angle:angle],
                      [CCScaleBy actionWithDuration:2.0f scale:2.0],
                      [CCFadeOut actionWithDuration:2.0f],
                      nil];                                          
    [pausedLabel runAction:labelAction];
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"world grav: %f, %f ", world->GetGravity().x, world->GetGravity().y);
//'paused' prevents the user from tapping multiple times and having the game crash
//'mazeComplete' prevents the user from tapping the screen when the ending transition is active
    if (paused == FALSE && mazeComplete == FALSE) {
        [self pauseGame];
        [self pausedAnimation];
        CCMenuItemFont *home = [CCMenuItemFont itemFromString:@"Main Menu" 
                                                         target:self 
                                                       selector:@selector(menuManager:)];
        home.fontName = @"AmericanTypewriter-CondensedBold";
        home.fontSize = 45;
        [home setTag:kInGameMenuHome];
        
        CCMenuItemFont *restart = [CCMenuItemFont itemFromString:@"Re-Start" 
                                                             target:self 
                                                           selector:@selector(menuManager:)];
        restart.fontName = @"AmericanTypewriter-CondensedBold";
        restart.fontSize = 45;
        [restart setTag:kInGameMenuReloadLevel];
        
        CCMenuItemFont *cancel = [CCMenuItemFont itemFromString:@"Cancel" 
                                                       target:self 
                                                     selector:@selector(menuManager:)];
        cancel.fontName = @"AmericanTypewriter-CondensedBold";
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

-(CGPoint) locationOnScreen:(NSInteger)currentIndex
{
    //    NSLog(@"in locationOnScreen");
    
    /*takes an index in the mazeArray and places it on the screen*/
    CGPoint screenLocation;
    screenLocation.x = ([objectFactory returnObjectDimensions:tWall].num2*[mazeMaker translateLargeArrayIndexToXY:currentIndex].num1)+screenOffset;
    screenLocation.y = ([objectFactory returnObjectDimensions:tWall].num2*[mazeMaker translateLargeArrayIndexToXY:currentIndex].num2)+screenOffset;
    //    NSLog(@"exiting locationOnScreen");
    
    return screenLocation;
}

-(NSInteger) locationInMaze:(CGPoint)currentLocation
{
    //    NSLog(@"in locationInMaze");
    
    /*takes a single location on the screen and translates it to an index in the mazeArray*/
    /*only works with enemys because they move along a track*/
    NSInteger location;
    NSInteger wallHeight = [[objectFactory returnObjectDimensions:tWall]num2];
    NSInteger wallWidth = [[objectFactory returnObjectDimensions:tWall]num2];
    //    NSLog(@"in locationInMaze currentLocation: %f %f screenOffset:%i wallSize:%i", currentLocation.x, currentLocation.y, screenOffset, wallWidth);
    
    
    int tmpX = ceil(((currentLocation.x-screenOffset)/wallHeight));
    int tmpY = ceil(((currentLocation.y-screenOffset)/wallWidth));
    
    location = [mazeMaker translateLargeXYToArrayIndex:tmpX :tmpY];
    //    NSLog(@"exiting locationInMaze");
    
    return location;
}

-(void) gameplayManager
{
    NSLog(@"in gameplay manager");
    if (totalNumSpecialAreas > 0) {
        totalNumSpecialAreas--;
        NSLog(@"trying to place special areas");
        CGPoint location = [self locationOnScreen:[mazeMaker returnEmptySlotInMaze]];
        [objectFactory createEnemyOfType:tArea
                              atLocation:location 
                              withZValue:kAreaZValue 
                                 inWorld:world
               addToSceneSpriteBatchNode:sceneSpriteBatchNode
                     withKnowledgeOfMaze:mazeMaker];    
    }
    
}


@end