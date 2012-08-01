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
    NSLog(@"x: %f y: %f", acceleration.x, acceleration.y);
    b2Vec2 gravity(-acceleration.y * 4, acceleration.x * 4);
    world->SetGravity(gravity);
}
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

-(void)randomlyPlaceItem:(GameObjectType)item
{
    int randX, randY, randNum;
    while (1) {
        randX = arc4random()%kTrueMenuMazeCols;
        randY = arc4random()%kTrueMenuMazeRows;
        randNum = randY * kTrueMenuMazeCols + randX;
        if (menuMaze[randNum] == tNone) {
            menuMaze[randNum] = item;
            [objectFactory createObjectOfType:item
                                   atLocation:ccp(48*randX+150, 48*randY+150)
                                   withZValue:item
                                      inWorld:world
                    addToSceneSpriteBatchNode:sceneSpriteBatchNode];
        }
    }
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
        objectFactory = [ObjectFactory createSingleton];
        //begin creating the maze
        requirements = [[MazeRequirements alloc] initWithRequirements:5 
                                                                     :0 
                                                                     :NO 
                                                                     :CGPointMake(1, kTrueMenuMazeCols-1)];
       
        mazeMaker = [[MazeMaker alloc] initWithSizeAndRequirements:kMenuMazeRows 
                                                                  :kMenuMazeCols
                                                                  :requirements
                                                                  :menuMaze];
        [mazeMaker createMaze];
        
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
         
        [objectFactory createObjectOfType:tBall
                               atLocation:ccp(48+150, (48*(kTrueMazeRows-1)-30)-150) 
                               withZValue:kBallZValue 
                                  inWorld:world 
                addToSceneSpriteBatchNode:sceneSpriteBatchNode]; 
        
        for(int y = 0; y < kTrueMenuMazeRows; y++)
        {
            for(int x = 0; x < kTrueMenuMazeCols; x++)
            {
                int num = y * kTrueMenuMazeCols + x;
                if (menuMaze[num] == tWall) {
                    [objectFactory createObjectOfType:tWall 
                                           atLocation:ccp(48*x+150, 48*y+150) 
                                           withZValue:kWallZValue 
                                              inWorld:world 
                            addToSceneSpriteBatchNode:sceneSpriteBatchNode];
                }
                else if (menuMaze[num] == tCoin){
                    //create coin as GameObject:
                    [objectFactory createObjectOfType:tCoin
                                           atLocation:ccp(48*x+150, 48*y+150)
                                           withZValue:kCoinZValue 
                                              inWorld:world 
                            addToSceneSpriteBatchNode:sceneSpriteBatchNode];
                }
            }
        }
        [self scheduleUpdate];                                    
        [self displayMainMenu];

        
    }
    return self;
}

@end