//
//  MainMenuLayer.m
//  Maze
//
//  Created by ian on 7/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainMenuLayer.h"
#import "ObjectInfoConstants.h"
#import "Queue.h"


@interface MainMenuLayer()
-(void)displayMainMenu;
-(void)displaySceneSelection;
@end

@implementation MainMenuLayer
@synthesize accel;


-(void) screenRotationTapped: (id) sender
{
    NSLog(@"Settings - ScreenRotation button tapped!, %i", [sender tag]);
    screenRotationToggle.tag = ([sender tag] == 1) ? 0 : [sender tag]+1;

    switch (screenRotationToggle.tag) {
        case rLandscape:
            [dataAdapter changeSettings:[NSNumber numberWithInt:rLandscape]];
            break;
        case rPortrait:
            [dataAdapter changeSettings:[NSNumber numberWithInt:rPortrait]];
            break;
        default:
            break;
    }
}

-(void)displaySettingsMenu {
    if (mainMenu != nil) {
        [mainMenu removeFromParentAndCleanup:YES];
        mainMenu = nil;
    }
    
    CCMenuItemFont *screenRotation1 = [CCMenuItemFont itemFromString:@"portrait" target:nil selector:nil];
    screenRotation1.fontName = @"AmericanTypewriter-CondensedBold";
    screenRotation1.fontSize = 45;
    CCMenuItemFont *screenRotation2 = [CCMenuItemFont itemFromString:@"landscape" target:nil selector:nil];
    screenRotation2.fontName = @"AmericanTypewriter-CondensedBold";
    screenRotation2.fontSize = 45;
    
    if ([[dataAdapter returnSettings].screenRotation intValue] == rPortrait) {
        screenRotationToggle = [CCMenuItemToggle itemWithTarget:self
                                                       selector:@selector(screenRotationTapped:)
                                                          items:screenRotation1, screenRotation2, nil];
    } else {
        screenRotationToggle = [CCMenuItemToggle itemWithTarget:self
                                                       selector:@selector(screenRotationTapped:)
                                                          items:screenRotation2, screenRotation1, nil];
    }

    [screenRotationToggle setTag:[[dataAdapter returnSettings].screenRotation intValue]];
    
    CCMenuItemFont *backButton = [CCMenuItemFont itemFromString:@"Back"
                                                         target:self
                                                       selector:@selector(displayMainMenu)];
    backButton.fontName = @"AmericanTypewriter-CondensedBold";
    backButton.fontSize = 45;
    
    
    settingsMenu = [CCMenu
                    menuWithItems:screenRotationToggle, backButton, nil];
    [settingsMenu alignItemsVerticallyWithPadding:
     screenSize.height * 0.059f];
    [settingsMenu setPosition:
     ccp(screenSize.width * 2,
         screenSize.height / 2)];
    id moveAction;
    if (screenRotation == rPortrait) {
        moveAction =
        [CCMoveTo actionWithDuration:1.2f
                            position:ccp(screenSize.width * 0.80f,
                                         screenSize.height/2)];
    } else {
        moveAction =
        [CCMoveTo actionWithDuration:1.2f
                            position:ccp(screenSize.width * 0.85f,
                                         screenSize.height/2)];
    }
    id moveEffect = [CCEaseIn actionWithAction:moveAction rate:1.0f];
    [settingsMenu runAction:moveEffect];
    [self addChild:settingsMenu z:0 tag:kMainMenuTagValue];
}


-(void)displayMainMenu {
    if (settingsMenu != nil) {
        [settingsMenu removeFromParentAndCleanup:YES];
        settingsMenu = nil;
    }
    if (sceneSelectMenu != nil) {
        [sceneSelectMenu removeFromParentAndCleanup:YES];
        sceneSelectMenu = nil;
    }
    // Main Menu
    
    CCMenuItemFont *cont = [CCMenuItemFont itemFromString:@"Continue" 
                                                   target:self 
                                                 selector:@selector(startFromCurrentLevel)];
    cont.fontName = @"AmericanTypewriter-CondensedBold";
    cont.fontSize = 45;
    
    CCMenuItemFont *level = [CCMenuItemFont itemFromString:@"Choose Level" 
                                                   target:self 
                                                 selector:@selector(displaySceneSelection)];
    level.fontName = @"AmericanTypewriter-CondensedBold";
    level.fontSize = 45;
    
    CCMenuItemFont *options = [CCMenuItemFont itemFromString:@"Options" 
                                                   target:self 
                                                 selector:@selector(displayOptions)];
    options.fontName = @"AmericanTypewriter-CondensedBold";
    options.fontSize = 45;
    
    
    mainMenu = [CCMenu
                menuWithItems:cont, level, options, nil];
    [mainMenu alignItemsVerticallyWithPadding:
     screenSize.height * 0.059f];
    
    [mainMenu setPosition:
     ccp(screenSize.width * 2,
         screenSize.height / 2)];
    
    id moveAction;
    if (screenRotation == rPortrait) {
        moveAction =
        [CCMoveTo actionWithDuration:1.2f
                            position:ccp(screenSize.width * 0.80f,
                                         screenSize.height/2)];
    } else {
        moveAction =
        [CCMoveTo actionWithDuration:1.2f
                            position:ccp(screenSize.width * 0.85f,
                                         screenSize.height/2)];
    }
    
    
    id moveEffect = [CCEaseIn actionWithAction:moveAction rate:1.0f];
    [mainMenu runAction:moveEffect];
    [self addChild:mainMenu z:0 tag:kMainMenuTagValue];
}

-(void)playScene:(CCMenuItemFont*)itemPassedIn {
    [[UIAccelerometer sharedAccelerometer] setDelegate:nil];
    
    if ([itemPassedIn tag] == 1) {
        CCLOG(@"Tag 1 found, Scene 1");
        
        [[GameManager sharedGameManager] runSceneWithID:kNormalLevel];
    } else {
        CCLOG(@"Tag was: %d", [itemPassedIn tag]);
        CCLOG(@"Placeholder for next chapters");
    }
}

-(void)startFromCurrentLevel {

}

-(void)displayOptions {
    CCLOG(@"Show the Options screen");
    [self displaySettingsMenu];
}

-(void)displaySceneSelection {
    if (mainMenu != nil) {
        [mainMenu removeFromParentAndCleanup:YES];
        mainMenu = nil;
    }
    
    CCMenuItemFont *level1 = [CCMenuItemFont itemFromString:@"Level 1" 
                                                   target:self 
                                                 selector:@selector(playScene:)];
    level1.fontName = @"AmericanTypewriter-CondensedBold";
    level1.fontSize = 45;
    [level1 setTag:1];
    
    CCMenuItemFont *backButton = [CCMenuItemFont itemFromString:@"Back" 
                                                     target:self 
                                                   selector:@selector(displayMainMenu)];
    backButton.fontName = @"AmericanTypewriter-CondensedBold";
    backButton.fontSize = 45;

    sceneSelectMenu = [CCMenu menuWithItems:level1, backButton, nil];
    
    [sceneSelectMenu alignItemsVerticallyWithPadding:
     screenSize.height * 0.059f];
    [sceneSelectMenu setPosition:
     ccp(screenSize.width * 2,
         screenSize.height / 2)];
    id moveAction;
    if (screenRotation == rPortrait) {
        moveAction =
        [CCMoveTo actionWithDuration:1.2f
                            position:ccp(screenSize.width * 0.80f,
                                         screenSize.height/2)];
    } else {
        moveAction =
        [CCMoveTo actionWithDuration:1.2f
                            position:ccp(screenSize.width * 0.85f,
                                         screenSize.height/2)];
    }
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
//    NSLog(@"x: %f y: %f", acceleration.x, acceleration.y);
//    b2Vec2 gravity(-acceleration.y * 4, acceleration.x * 4);
    b2Vec2 gravity;
    if (screenRotation==rPortrait) {
        gravity.Set(acceleration.x * accelNum, acceleration.y * accelNum);
    }
    else {
        gravity.Set(-acceleration.y * accelNum, acceleration.x * accelNum);
    }
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
    
    CCArray *listOfGameObjects =
    [sceneSpriteBatchNode children];                     
    for (GameObject *tempObject in listOfGameObjects) {         
        b2Body *b = [tempObject body];
        if (b != NULL) {
            tempObject.position = ccp(b->GetPosition().x * PTM_RATIO,
                                      b->GetPosition().y * PTM_RATIO);
            tempObject.rotation =
            CC_RADIANS_TO_DEGREES(b->GetAngle() * -1);
        }    
            [tempObject updateStateWithDeltaTime:deltaTime andListOfGameObjects:
             listOfGameObjects];
        
        
    }
    
}

- (void) dealloc
{
    NSLog(@"MainMenuLayer Dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [menuMaze release];
    [requirements release];
    
    [sceneSpriteBatchNode removeAllChildrenWithCleanup:YES];
    [sceneSpriteBatchNode removeFromParentAndCleanup:YES];
    
    [mazeMaker release];
    
    //might need to remove all things in the world first!
    delete world;
    world = NULL;
    delete debugDraw;
    
	[super dealloc];
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

-(void)randomlyPlaceItem:(NSInteger)item
{   
    /*
    NSLog(@"placing item");
    int randX, randY, randNum;
    BOOL emptyMazePositionFound = false;
    randX = 0;
    randY = 0;
    randNum = 0;
    while (emptyMazePositionFound == false) {
        NSLog(@"placing item1");
        randX = arc4random()%(kTrueMenuMazeCols);
        randY = arc4random()%(kTrueMenuMazeRows);
        randNum = (randY * (kTrueMenuMazeCols)) + randX;
        NSLog(@"x: %i, y: %i rand: %i", randX, randY, randNum);
        
        if (menuMaze[randNum] != tWall && menuMaze[randNum] != tCoin) {
            NSLog(@"placing item2");
            menuMaze[randNum] = item;
            [objectFactory createObjectOfType:item
                                   atLocation:ccp(48*randX+150, 48*randY+150)
                                   withZValue:10
                                      inWorld:world
                    addToSceneSpriteBatchNode:sceneSpriteBatchNode];
            emptyMazePositionFound = true;
        }
        else if (menuMaze[randNum] == tCoin) {
            NSLog(@"too bad, coin in the way");
        }
        else if (menuMaze[randNum] == tWall) {
            NSLog(@"too bad, wall in the way");

        }
            
    }
*/
}

-(void) placeAlertAtLocation:(CGPoint)location
{
    CCLabelTTF *l1 = [CCLabelTTF labelWithString:@"!" 
                                        fontName:@"AmericanTypewriter-CondensedBold"
                                        fontSize:25];                                                
    [self addChild:l1];
    [l1 setPosition:location];    
    id la1 = [CCSequence actions:[CCScaleTo actionWithDuration:1.0 scale:3.0], 
              [CCFadeOut actionWithDuration:1.0], 
              nil];
    [l1 runAction:la1];      
    
}

//hacked work around to have a selector call the above function
//couldn't do it because the selector can only pass objects, not enums
-(void) itemCapturedHandler:(NSNotification *)notification
{
    NSDictionary *userInfo = [[NSDictionary alloc] initWithDictionary:[notification userInfo]];
    CGPoint itemLocation;
    itemLocation.x = [[userInfo objectForKey:[NSString stringWithString:notificationUserInfoKeyPositionX]]floatValue];
    itemLocation.y = [[userInfo objectForKey:[NSString stringWithString:notificationUserInfoKeyPositionY]]floatValue];
    
    if ([[userInfo objectForKey:notificationUserInfoObjectType] intValue] == tCoin) {
        [self placeParticleEmitterAtLocation:itemLocation];
        [self randomlyPlaceItem:tCoin];
    }
    else if ([[userInfo objectForKey:notificationUserInfoObjectType] intValue] == tEnemy) {
        [self placeAlertAtLocation:itemLocation];
    }
    [userInfo release];

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
        dataAdapter = [DataAdapter createSingleton];
        tmpDirector = [CCDirector sharedDirector];
        if ([[[dataAdapter returnSettings] screenRotation] intValue] == rPortrait) {
            screenRotation = rPortrait;
            [tmpDirector setDeviceOrientation:kCCDeviceOrientationPortrait];
        }
        else {
            screenRotation = rLandscape;
            [tmpDirector setDeviceOrientation:kCCDeviceOrientationLandscapeLeft];

        }
        screenSize = [CCDirector sharedDirector].winSize;
        
        //will respawn a coin right when one is grabbed        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(itemCapturedHandler:) 
                                                     name:@"positionOfItemToPlace" object:nil];

//start debug
        gravityScale = 0;
        angDamp = kAngularDamp;
        accelNum = kAccelerometerConstant;
        
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
        requirements = [[MazeRequirements alloc] initWithCoins:5
                                                       Enemies:0
                                                  SpecialAreas:0
                                            AllowableStraights:NO
                                               NumberOfCircles:2];

        menuMaze = [[NSMutableArray alloc] init];
        tmpDirector = [CCDirector sharedDirector];
        if ([tmpDirector deviceOrientation] == kCCDeviceOrientationPortrait) {
            mazeMaker = [[MazeMaker alloc] initWithHeight:800
                                                    Width:400
                                           WallDimensions:[objectFactory returnObjectDimensions:tWall]
                                             Requirements:requirements
                                                     Maze:menuMaze
                                                 ForScene:kMainMenuScene];
        }
        else {
            mazeMaker = [[MazeMaker alloc] initWithHeight:500
                                                    Width:600
                                           WallDimensions:[objectFactory returnObjectDimensions:tWall]
                                             Requirements:requirements
                                                     Maze:menuMaze
                                                 ForScene:kMainMenuScene];
        }
        
        
        Pair* mazeDimensions = [[Pair alloc] initWithRequirements:0 :0];
        mazeDimensions = [mazeMaker createMaze];
        rows = mazeDimensions.num1;
        cols = mazeDimensions.num2;
        [mazeDimensions release];
        
        mazeInterface = [MazeInterface createSingleton];
        [mazeInterface removeAllOpenPoints];
        
        [[UIAccelerometer sharedAccelerometer] setDelegate:self];
        [[UIAccelerometer sharedAccelerometer] setUpdateInterval:1.0f/60.0f];
        
        //for objectFactory returnObjectDimensions - num1 is height - num2 is width
        int x, y, mazeSize;
        Pair *tmpCoords = [[Pair alloc] initWithRequirements:0 :0];
        CGPoint tmpLocation;
        mazeSize = rows*cols;
        for(int i = 0; i < mazeSize; i++)
        {            
            tmpCoords = [mazeMaker translateLargeArrayIndexToXY:i];
            x = tmpCoords.num1;
            y = tmpCoords.num2;
            tmpLocation.x = [objectFactory returnObjectDimensions:tWall].num2*x+kMenuMazeScreenOffset;
            tmpLocation.y = [objectFactory returnObjectDimensions:tWall].num2*y+kMenuMazeScreenOffset;
            
            NSLog(@"obj x:%f y:%f", tmpLocation.x, tmpLocation.y);
            
            if ([[menuMaze objectAtIndex:i] intValue] == tWall) {
                [objectFactory createObjectOfType:tWall
                                       atLocation:tmpLocation
                                       withZValue:kWallZValue
                                          inWorld:world
                        addToSceneSpriteBatchNode:sceneSpriteBatchNode];
            }
            else if ([[menuMaze objectAtIndex:i] intValue] == tCoin){
                //create coin as GameObject:
                [mazeInterface addPoint:tmpLocation];
                [objectFactory createObjectOfType:tCoin
                                       atLocation:tmpLocation
                                       withZValue:kCoinZValue
                                          inWorld:world
                        addToSceneSpriteBatchNode:sceneSpriteBatchNode];
            }
            else if ([[menuMaze objectAtIndex:i] intValue] == tEnemy) {
                [mazeInterface addPoint:tmpLocation];
                [objectFactory createEnemyOfType:tEnemy
                                      atLocation:tmpLocation
                                      withZValue:kCoinZValue
                                         inWorld:world
                       addToSceneSpriteBatchNode:sceneSpriteBatchNode
                             withKnowledgeOfMaze:mazeMaker];
            }
            else if ([[menuMaze objectAtIndex:i] intValue] == tStart) {
                [objectFactory createObjectOfType:tBall 
                                       atLocation:tmpLocation 
                                       withZValue:kBallZValue
                                          inWorld:world
                        addToSceneSpriteBatchNode:sceneSpriteBatchNode];
            }
            else if ([[menuMaze objectAtIndex:i] intValue] == tFinish) {
            
            }
            else {
                //empty location
                [mazeInterface addPoint:tmpLocation];
            }
            
        }
        
        [tmpCoords release];
        
        [self scheduleUpdate];                                    
        [self displayMainMenu];
    }
    return self;
}

@end