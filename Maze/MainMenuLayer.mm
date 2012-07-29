//
//  MainMenuLayer.m
//  Maze
//
//  Created by ian on 7/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainMenuLayer.h"
@interface MainMenuLayer()
-(void)displayMainMenu;
-(void)displaySceneSelection;
@end

@implementation MainMenuLayer
@synthesize accel;

//change this later - from kMainMenuScene
-(void)playScene:(CCMenuItemFont*)itemPassedIn {
    [[UIAccelerometer sharedAccelerometer] setDelegate:nil];

    if ([itemPassedIn tag] == 1) {
        CCLOG(@"Tag 1 found, Scene 1");
        [[GameManager sharedGameManager] runSceneWithID:kBasicLevel];
    } else {
        CCLOG(@"Tag was: %d", [itemPassedIn tag]);
        CCLOG(@"Placeholder for next chapters");
    }
}

-(void)displayMainMenu {
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    if (sceneSelectMenu != nil) {
        [sceneSelectMenu removeFromParentAndCleanup:YES];
    }
    // Main Menu
    
    CCMenuItemFont *cont = [CCMenuItemFont itemFromString:@"Continue" 
                                                   target:self 
                                                 selector:@selector(startFromCurrentLevel)];
    cont.fontName = [NSString stringWithString:@"AmericanTypewriter-CondensedBold"];
    cont.fontSize = 45;
    
    CCMenuItemFont *level = [CCMenuItemFont itemFromString:@"Choose Level" 
                                                   target:self 
                                                 selector:@selector(displaySceneSelection)];
    level.fontName = [NSString stringWithString:@"AmericanTypewriter-CondensedBold"];
    level.fontSize = 45;
    
    CCMenuItemFont *options = [CCMenuItemFont itemFromString:@"Options" 
                                                   target:self 
                                                 selector:@selector(displayOptions)];
    options.fontName = [NSString stringWithString:@"AmericanTypewriter-CondensedBold"];
    options.fontSize = 45;
    
    
    mainMenu = [CCMenu
                menuWithItems:cont, level, options, nil];
    [mainMenu alignItemsVerticallyWithPadding:
     screenSize.height * 0.059f];
    [mainMenu setPosition:
     ccp(screenSize.width * 2,
         screenSize.height / 2)];
    id moveAction =
    [CCMoveTo actionWithDuration:1.2f
                        position:ccp(screenSize.width * 0.85f,
                                     screenSize.height/2)];
    id moveEffect = [CCEaseIn actionWithAction:moveAction rate:1.0f];
    [mainMenu runAction:moveEffect];
    [self addChild:mainMenu z:0 tag:kMainMenuTagValue];
}

-(void)startFromCurrentLevel {

}

-(void)displayOptions {
    CCLOG(@"Show the Options screen");
    [[GameManager sharedGameManager] runSceneWithID:kOptionsScene];
}

-(void)displaySceneSelection {
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    if (mainMenu != nil) {
        [mainMenu removeFromParentAndCleanup:YES];
    }
    
//OLD MENU
//    CCLabelBMFont *playScene1Label =
//    [CCLabelBMFont labelWithString:@"Ole Awakes!"
//                           fntFile:@"VikingSpeechFont64.fnt"];
//    CCMenuItemLabel *playScene1 =
//    [CCMenuItemLabel itemWithLabel:playScene1Label target:self
//                          selector:@selector(playScene:)];
//    [playScene1 setTag:1];
    
    CCMenuItemFont *level1 = [CCMenuItemFont itemFromString:@"Level 1" 
                                                   target:self 
                                                 selector:@selector(playScene:)];
    level1.fontName = [NSString stringWithString:@"AmericanTypewriter-CondensedBold"];
    level1.fontSize = 45;
    [level1 setTag:1];
    
    CCMenuItemFont *backButton = [CCMenuItemFont itemFromString:@"Back" 
                                                     target:self 
                                                   selector:@selector(displayMainMenu)];
    backButton.fontName = [NSString stringWithString:@"AmericanTypewriter-CondensedBold"];
    backButton.fontSize = 45;

    sceneSelectMenu = [CCMenu menuWithItems:level1, backButton, nil];
    
    [sceneSelectMenu alignItemsVerticallyWithPadding:
     screenSize.height * 0.059f];
    [sceneSelectMenu setPosition:
     ccp(screenSize.width * 2,
         screenSize.height / 2)];
    id moveAction =
    [CCMoveTo actionWithDuration:1.2f
                        position:ccp(screenSize.width * 0.85f,
                                     screenSize.height/2)];
    id moveEffect = [CCEaseIn actionWithAction:moveAction rate:1.0f];
    [sceneSelectMenu runAction:moveEffect];
    [self addChild:sceneSelectMenu z:1 tag:kSceneMenuTagValue];
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
    NSLog(@"x: %f y: %f", acceleration.x, acceleration.y);
    b2Vec2 gravity(-acceleration.y * 4, acceleration.x * 4);
    world->SetGravity(gravity);
}
-(void) update:(ccTime)deltaTime
{
    int32 velocityIterations = 3;
    int32 positionIterations = 2;
    world->Step(deltaTime, velocityIterations, positionIterations);
    
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
                                     z:ZValue
                                   tag:kWallTagValue];  
        [wall release];
         
    }
    else {
        NSLog(@"trying to create something that doesn't exist");
    }
    
}

- (void) dealloc
{
    NSLog(@"MainMenuLayer Dealloc");
    [requirements release];
    [mazeMaker release];

//might need to remove all things in the world first!
    delete world;
    world = NULL;
    delete debugDraw;

	[super dealloc];
}

-(void) onExit
{
    NSLog(@"MainMenuLayer onExit");
    

}

-(id)init {
    self = [super init];
    if (self != nil) {   
        NSLog(@"MainMenuLayer Init");

//        CCSprite *background =
//        [CCSprite spriteWithFile:@"MainMenuBackground.png"];
//        [background setPosition:ccp(screenSize.width/2,
//                                    screenSize.height/2)];
//        [self addChild:background];
        
        [self setupWorld];
        [self setupDebugDraw];
        
        //begin creating the maze
        requirements = [[MazeRequirements alloc] initWithRequirements:5 
                                                                     :0 
                                                                     :NO 
                                                                     :CGPointMake(1, kTrueMenuMazeCols-1)];
       
        mazeMaker = [[MazeMaker alloc] initWithSizeAndRequirements:kMenuMazeRows 
                                                                  :kMenuMazeCols
                                                                  :requirements
                                                                  :menuMaze];
        [mazeMaker createMaze2];
        
        //setup accelerometer and data filter     
        [[UIAccelerometer sharedAccelerometer] setDelegate:self];
        [[UIAccelerometer sharedAccelerometer] setUpdateInterval:1.0f/60.0f];
        
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
                      atLocation:ccp(48+150, (48*(kTrueMazeRows-1)-30)-150)
                      withZValue:kBallZValue]; 
        
        for(int y = 0; y < kTrueMenuMazeRows; y++)
        {
            for(int x = 0; x < kTrueMenuMazeCols; x++)
            {
                int num = y * kTrueMenuMazeCols + x;
                if (menuMaze[num] == cWall) {
                    [self createObjectOfType:tWall
                                  atLocation:ccp(48*x+150, 48*y+150)
                                  withZValue:kWallZValue];   
                }
                else if (menuMaze[num] == cCoin){
                    //create coin as GameObject:
                    [self createObjectOfType:tCoin
                                  atLocation:ccp(48*x+150, 48*y+150)
                                  withZValue:kCoinZValue];   
                }
                
                
            }
            
        }
        [self scheduleUpdate];                                    
        [self displayMainMenu];

        
    }
    return self;
}

@end