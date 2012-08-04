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
/*
[[Director sharedDirector] replaceScene: 
[ZoomFlipXTransition transitionWithDuration:1.2f scene:nextScene]];
*/        
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
//    b2Vec2 gravity(-acceleration.y * 4, acceleration.x * 4);
    b2Vec2 gravity(-acceleration.y * accelNum, acceleration.x * accelNum);

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

- (void) debugManager: (CCMenuItemFont*)option
{
    switch ([option tag]) {
        case 0:
            NSLog(@"accelUp");
            accelNum++;
            break;
            
        case 1:
            NSLog(@"accelDown");
            accelNum--;
            break;
            
        case 2:
            NSLog(@"angDampUp");
            angDamp+=0.1;

            for(b2Body *b=world->GetBodyList(); b!=NULL; b=b->GetNext()) {
                if (b->GetUserData() != NULL) {
                    b->SetAngularDamping(angDamp);
                }
            }
            break;
            
        case 3:
            NSLog(@"angDampDown");
            angDamp-=0.1;
            for(b2Body *b=world->GetBodyList(); b!=NULL; b=b->GetNext()) {
                if (b->GetUserData() != NULL) {
                    b->SetAngularDamping(angDamp);
                }
            }
            break;
            
        case 4:
            NSLog(@"GUp");
            gravityScale++;
            
            for(b2Body *b=world->GetBodyList(); b!=NULL; b=b->GetNext()) {
                if (b->GetUserData() != NULL) {
                    
                }
            }
            break;
            
        case 5:
            NSLog(@"GDown");
            gravityScale--;
            for(b2Body *b=world->GetBodyList(); b!=NULL; b=b->GetNext()) {
                if (b->GetUserData() != NULL) {

                }
            }
            break;
            
        default:
            NSLog(@"when opening in-game menu -> found unidentified case: %i", [option tag]);
            break;
    }
    angDampLabel.string = [NSString stringWithFormat:@"AD: %2.2f", angDamp];
    accelLabel.string = [NSString stringWithFormat:@"Accel: %i", accelNum];

    
}

-(void)setupDebugLayer
{
    CGSize screenSize = [CCDirector sharedDirector].winSize;

    //labels to see the values    
    accelLabel = [CCLabelTTF labelWithString:@"Accel: 0" 
                                  dimensions:CGSizeMake(300.0f, 300.0f) 
                                   alignment:UITextAlignmentLeft 
                                    fontName:@"AmericanTypewriter-CondensedBold"
                                    fontSize:45.0f];
    accelLabel.position = ccp(screenSize.width*.2,screenSize.height*.8);
    accelLabel.string = [NSString stringWithFormat:@"Accel: %i", accelNum];
    [self addChild:accelLabel];

    angDampLabel = [CCLabelTTF labelWithString:@"AD: 0" 
                                  dimensions:CGSizeMake(300.0f, 300.0f) 
                                   alignment:UITextAlignmentLeft 
                                    fontName:@"AmericanTypewriter-CondensedBold"
                                    fontSize:45.0f];
    angDampLabel.position = ccp(screenSize.width*.4,screenSize.height*.8);
    angDampLabel.string = [NSString stringWithFormat:@"AD: %2.2f", angDamp];
    [self addChild:angDampLabel];
    
    gravityScaleLabel = [CCLabelTTF labelWithString:@"G: 0" 
                                    dimensions:CGSizeMake(300.0f, 300.0f) 
                                     alignment:UITextAlignmentLeft 
                                      fontName:@"AmericanTypewriter-CondensedBold"
                                      fontSize:45.0f];
    gravityScaleLabel.position = ccp(screenSize.width*.6,screenSize.height*.8);
    gravityScaleLabel.string = [NSString stringWithFormat:@"G: %2.2f", angDamp];
    [self addChild:gravityScaleLabel];
    
//controls for options to change
    CCMenuItemFont *accelUp = [CCMenuItemFont itemFromString:@"accelUp" 
                                                     target:self 
                                                   selector:@selector(debugManager:)];
    accelUp.fontName = [NSString stringWithString:@"AmericanTypewriter-CondensedBold"];
    accelUp.fontSize = 35;
    [accelUp setTag:0];
    
    CCMenuItemFont *accelDown = [CCMenuItemFont itemFromString:@"accelDown" 
                                                       target:self 
                                                     selector:@selector(debugManager:)];
    accelDown.fontName = [NSString stringWithString:@"AmericanTypewriter-CondensedBold"];
    accelDown.fontSize = 35;
    [accelDown setTag:1];
    
    CCMenuItemFont *angDampUp = [CCMenuItemFont itemFromString:@"ADUp" 
                                                     target:self 
                                                   selector:@selector(debugManager:)];
    angDampUp.fontName = [NSString stringWithString:@"AmericanTypewriter-CondensedBold"];
    angDampUp.fontSize = 35;
    [angDampUp setTag:2];
    
    CCMenuItemFont *angDampDown = [CCMenuItemFont itemFromString:@"ADDown" 
                                                       target:self 
                                                     selector:@selector(debugManager:)];
    angDampDown.fontName = [NSString stringWithString:@"AmericanTypewriter-CondensedBold"];
    angDampDown.fontSize = 35;
    [angDampDown setTag:3];
    
    CCMenuItemFont *gravityScaleUp = [CCMenuItemFont itemFromString:@"GUp" 
                                                        target:self 
                                                      selector:@selector(debugManager:)];
    gravityScaleUp.fontName = [NSString stringWithString:@"AmericanTypewriter-CondensedBold"];
    gravityScaleUp.fontSize = 35;
    [gravityScaleUp setTag:4];
    
    CCMenuItemFont *gravityScaleDown = [CCMenuItemFont itemFromString:@"GDown" 
                                                          target:self 
                                                        selector:@selector(debugManager:)];
    gravityScaleDown.fontName = [NSString stringWithString:@"AmericanTypewriter-CondensedBold"];
    gravityScaleDown.fontSize = 35;
    [gravityScaleDown setTag:5];
    
    debugMenu = [CCMenu menuWithItems:accelUp, accelDown, angDampUp, angDampDown, gravityScaleUp, gravityScaleDown, nil];
    
    [debugMenu alignItemsHorizontallyWithPadding:
     screenSize.width * 0.059f];
    [debugMenu setPosition:
     ccp(screenSize.width*.5,screenSize.height*.1)];
    [self addChild:debugMenu z:1 tag:kSceneMenuTagValue];        
}

-(id)init {
    self = [super init];
    if (self != nil) {   
        NSLog(@"MainMenuLayer Init");

//start debug        
        gravityScale = 0;
        angDamp = kAngularDamp;
        accelNum = kAccelerometerConstant;
//        [self setupDebugLayer];


//end debug
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