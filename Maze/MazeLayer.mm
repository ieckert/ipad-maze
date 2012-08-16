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
    [statsKeeper setActive:FALSE];
}

-(void) unpauseGame
{
    paused = FALSE;
    [statsKeeper setActive:TRUE];
}

//transition from previous scene to this one
-(void) onEnterTransitionDidFinish
{
/*    
    [self performSelector:@selector(countdownToStart:) withObject:[NSString stringWithString:@"3"] afterDelay:.5f];
    [self performSelector:@selector(countdownToStart:) withObject:[NSString stringWithString:@"2"] afterDelay:2.0f];
    [self performSelector:@selector(countdownToStart:) withObject:[NSString stringWithString:@"1"] afterDelay:3.5f];
    [self performSelector:@selector(countdownToStart:) withObject:[NSString stringWithString:@"GO!"] afterDelay:5.0f];
    [self performSelector:@selector(unpauseGame) withObject:nil afterDelay:5.2f];
*/
    [self performSelector:@selector(countdownToStart:) withObject:[NSString stringWithString:@"READY"] afterDelay:.5f];
    [self performSelector:@selector(countdownToStart:) withObject:[NSString stringWithString:@"GO!"] afterDelay:2.0f];
    [self performSelector:@selector(unpauseGame) withObject:nil afterDelay:2.2f];


}

-(void)placeParticleEmitterAtLocation:(CGPoint)location{
    //coin collection: sun
    //end of level: fireworks
    CCSprite *coinSprite = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"coin_1.png"]];
    ccColor4F emitterColor = {255, 255, 0, 255};

    CCParticleSystemQuad *partEmitter = [[CCParticleSun alloc] initWithTotalParticles:20];
    [partEmitter setTexture:coinSprite.texture withRect:coinSprite.textureRect];
    
    [partEmitter setEmitterMode:kCCParticleModeGravity];
    [partEmitter setStartSize:5.0f];
    [partEmitter setEndSize:30.0f];
    [partEmitter setDuration:1.5f];
    [partEmitter setSpeed:100.0f];
    [partEmitter setStartColor:emitterColor];
    [partEmitter setPosition:location];
    
    [self addChild:partEmitter];
    [partEmitter release];
}


-(void) itemCapturedHandler:(NSNotification *)notification
{
    NSDictionary *userInfo = [[NSDictionary alloc] initWithDictionary:[notification userInfo]];
    
    CGPoint coinPosition;
    coinPosition.x = [[userInfo objectForKey:[NSString stringWithString:notificationUserInfoKeyPositionX]]floatValue];
    coinPosition.y = [[userInfo objectForKey:[NSString stringWithString:notificationUserInfoKeyPositionY]]floatValue];
    NSLog(@"coinPosition x: %f y: %f", coinPosition.x, coinPosition.y);
    [self placeParticleEmitterAtLocation:coinPosition];
    [userInfo release];
}

-(void) playerAtDoorHandler:(NSNotification *)notification
{
    NSDictionary *userInfo = [[NSDictionary alloc] initWithDictionary:[notification userInfo]];
    
    CGPoint doorPosition;
    doorPosition.x = [[userInfo objectForKey:[NSString stringWithString:notificationUserInfoKeyPositionX]]floatValue];
    doorPosition.y = [[userInfo objectForKey:[NSString stringWithString:notificationUserInfoKeyPositionY]]floatValue];
    NSLog(@"doorPosition x: %f y: %f", doorPosition.x, doorPosition.y);
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

#pragma mark -
#pragma mark Update Method
-(void) update:(ccTime)deltaTime
{
    if (world == nil) {
        NSLog(@"got no world to go back to :(");
    }
        int32 velocityIterations = 3;
        int32 positionIterations = 2;
        world->Step(deltaTime, velocityIterations, positionIterations);
        
        for(b2Body *b=world->GetBodyList(); b!=NULL; b=b->GetNext()) {
            if (b->GetUserData() != NULL) {
                Box2DSprite *sprite = (Box2DSprite *) b->GetUserData();
//the if statement below prevents the ball from moving while the 3..2..1..GO! is visible                
                if (sprite.gameObjectType == tBall && paused) {
                    b->SetAwake(FALSE);
                }
                else if (sprite.gameObjectType == tBall && !paused) {
                    b->SetAwake(TRUE);
                }
                
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
    
        if ( [statsKeeper returnCurrentCoinCount] == [requirements numCoins] 
            && mazeComplete == FALSE
            && onFinishDoor == TRUE) {
            //prevents this from being called over and over while update still works
            mazeComplete = TRUE;
            [self endingTransition];
        }
        else {
            onFinishDoor = false;
        }
}

-(void)calculateMazeDimensions:(float) windowHeight: (float) windowWidth
{
//for objectFactory returnObjectDimensions - num1 is height - num2 is width
    cols = windowWidth / [objectFactory returnObjectDimensions:tWall].num2 / kTrueScale;
    colsRemainder = windowWidth - (cols*kTrueScale*[objectFactory returnObjectDimensions:tWall].num2);
    rows = windowHeight / [objectFactory returnObjectDimensions:tWall].num2 / kTrueScale;
    rowsRemainder = windowHeight - (rows*kTrueScale*[objectFactory returnObjectDimensions:tWall].num2);
    NSLog(@"cols: %i, colsR: %f, rows: %i, rowsR: %f", cols, colsRemainder, rows, rowsRemainder);

}

-(id) init
{
	if( (self=[super init])) {   
        NSLog(@"MazeLayer Init");
        screenSize = [CCDirector sharedDirector].winSize;
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(itemCapturedHandler:) 
                                                     name:@"positionOfCapturedCoin" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(playerAtDoorHandler:) 
                                                     name:@"doorEntered" object:nil];
        
        angDamp = kAngularDamp;
        accelNum = kAccelerometerConstant;
        mazeComplete = FALSE;
        onFinishDoor = false;
        
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
        
        [self addChild:sceneSpriteBatchNode z:0];                  // 3
        
        objectFactory = [ObjectFactory createSingleton];
//calculate depends on objectFactory width/height for walls - so call after objectFactory's init
        [self calculateMazeDimensions:screenSize.height :screenSize.width];

        [self setupWorld];
        [self setupDebugDraw];
        [self createGround];
        
        statsKeeper = [StatsKeeper createSingleton];
        [statsKeeper setActive:TRUE];

        //setup accelerometer     
        [[UIAccelerometer sharedAccelerometer] setDelegate:self];
        [[UIAccelerometer sharedAccelerometer] setUpdateInterval:1.0f/60.0f];
        
        //setup basic window-size and touch
        self.isTouchEnabled = YES;
        
        //begin creating the maze
        mazeGrid = [[NSMutableArray alloc] init];
        requirements = [[MazeRequirements alloc] initWithRequirements:25 
                                                                     :0 
                                                                     :FALSE
                                                                     :5
                                                                     :((rows-1)*cols)
                                                                     :cols-1];
        
        mazeMaker = [[MazeMaker alloc] initWithSizeAndRequirements:rows 
                                                                  :cols
                                                                  :requirements
                                                                  :mazeGrid];
        [mazeMaker createMaze];           

        [objectFactory createObjectOfType:tBall 
                               atLocation:ccp([objectFactory returnObjectDimensions:tWall].num2+30, [objectFactory returnObjectDimensions:tWall].num2 * ((rows*kTrueScale)-1)-10) 
                               withZValue:kBallZValue
                                  inWorld:world
                addToSceneSpriteBatchNode:sceneSpriteBatchNode];

        //for objectFactory returnObjectDimensions - num1 is height - num2 is width
        int x, y, num, mazeSize;
        Pair *tmpCoords = [[Pair alloc] initWithRequirements:0 :0];
        mazeSize = [mazeGrid count];
        for(int i = 0; i < mazeSize; i++)
        {
            tmpCoords = [mazeMaker translateLargeArrayIndexToXY:i];
            x = tmpCoords.num1;
            y = tmpCoords.num2;
            num = i;
            
            int num = y * (kTrueScale*cols) + x;
            if ([[mazeGrid objectAtIndex:num] intValue] == tWall) {
                [objectFactory createObjectOfType:tWall
                                       atLocation:ccp([objectFactory returnObjectDimensions:tWall].num2*x+25, [objectFactory returnObjectDimensions:tWall].num2*y+25)
                                       withZValue:kWallZValue
                                          inWorld:world
                        addToSceneSpriteBatchNode:sceneSpriteBatchNode];
            }
            else if ([[mazeGrid objectAtIndex:num] intValue] == tCoin){
                //create coin as GameObject:
                [objectFactory createObjectOfType:tCoin
                                       atLocation:ccp([objectFactory returnObjectDimensions:tWall].num2*x+25, [objectFactory returnObjectDimensions:tWall].num2*y+25)
                                       withZValue:kCoinZValue
                                          inWorld:world
                        addToSceneSpriteBatchNode:sceneSpriteBatchNode];
            }
            else if ([[mazeGrid objectAtIndex:num] intValue] == tStart) {
                NSLog(@"starting position at: %i", num);
                [objectFactory createObjectOfType:tStart
                                       atLocation:ccp([objectFactory returnObjectDimensions:tWall].num2*x+25, [objectFactory returnObjectDimensions:tWall].num2*y+25)
                                       withZValue:kDoorZValue
                                          inWorld:world
                        addToSceneSpriteBatchNode:sceneSpriteBatchNode];
            }
            else if ([[mazeGrid objectAtIndex:num] intValue] == tFinish) {
                NSLog(@"ending position at: %i", num);
                [objectFactory createObjectOfType:tFinish
                                       atLocation:ccp([objectFactory returnObjectDimensions:tWall].num2*x+25, [objectFactory returnObjectDimensions:tWall].num2*y+25)
                                       withZValue:kDoorZValue
                                          inWorld:world
                        addToSceneSpriteBatchNode:sceneSpriteBatchNode];
            }
        }
        [tmpCoords release];
        [self pauseGame];
        [self scheduleUpdate];                                    
        [self setTimer];
    }
	return self;
}

-(void) endingTransition
{
    NSLog(@"playing ending transition");
    [statsKeeper setActive:FALSE];

    NSNumber *tmp = [NSNumber numberWithInt:kProgressNextLevel];

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

- (void) endingDuties: (NSNumber*)option
{    
    switch ([option intValue]) {
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
            
        case kProgressNextLevel:
            NSLog(@"moving to next level");
            [statsKeeper nextLevel];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadLevelLabel" 
                                                                object:self];
            NSLog(@"going to level: %i", [statsKeeper currentLevel]);
            [statsKeeper setActive:FALSE];
            
            [repeatingTimer invalidate];
            
            [[UIAccelerometer sharedAccelerometer] setDelegate:nil];
/*
 [[Director sharedDirector] replaceScene: 
 [ZoomFlipXTransition transitionWithDuration:1.2f scene:nextScene]];
*/
/*
            CCArray *listOfGameObjects =
            [sceneSpriteBatchNode children];                 
            for (GameObject *tempObject in listOfGameObjects) {
                NSLog(@"cleaning up gameObjects");
                [sceneSpriteBatchNode removeChild:tempObject cleanup:YES];
            }
*/            
            [[GameManager sharedGameManager]
             runSceneWithID:kBasicLevel];
            break;
            
        default:
//            NSLog(@"when in ending duties -> found unidentified case: %i", option);
            break;
        
//        for (CCSprite *monster in _monsters) {
//            [_batchNode removeChild:monster cleanup:YES];
//        }    
        
        
    }
    
    }

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
    NSLog(@"MazeLayer Dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [requirements release];
    [mazeMaker release];
    [mazeGrid release];
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
    if ([statsKeeper active] == TRUE) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"statsKeeperAddTime" object:self];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadTimeLabel" object:self];
    }
}

- (void) menuManager: (CCMenuItemFont*)option
{
    NSNumber *tmp;
    switch ([option tag]) {
        case kInGameMenuHome:
            NSLog(@"chose main menu");
            //need to save off game data here!!
            tmp = [NSNumber numberWithInt:kInGameMenuHome];
            [self endingDuties:tmp];
            break;
        
        case kInGameMenuReloadLevel:
            NSLog(@"chose reload");
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
    
//the if statement prevents the user from tapping multiple times and having the game crash
    if (paused == FALSE && mazeComplete == FALSE) {
        [self pauseGame];
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