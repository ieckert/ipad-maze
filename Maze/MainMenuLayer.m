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

-(void)showOptions {
    CCLOG(@"Show the Options screen");
    [[GameManager sharedGameManager] runSceneWithID:kOptionsScene];
}

//change this later - from kMainMenuScene
-(void)playScene:(CCMenuItemFont*)itemPassedIn {
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
    CCMenuItemImage *playGameButton = [CCMenuItemImage
                                       itemFromNormalImage:@"PlayGameButtonNormal.png"
                                       selectedImage:@"PlayGameButtonSelected.png"
                                       disabledImage:nil
                                       target:self
                                       selector:@selector(displaySceneSelection)];
    
    CCMenuItemImage *optionsButton = [CCMenuItemImage
                                      itemFromNormalImage:@"OptionsButtonNormal.png"
                                      selectedImage:@"OptionsButtonSelected.png"
                                      disabledImage:nil
                                      target:self
                                      selector:@selector(showOptions)];
    
    mainMenu = [CCMenu
                menuWithItems:playGameButton,optionsButton,nil];
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

-(void)displaySceneSelection {
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    if (mainMenu != nil) {
        [mainMenu removeFromParentAndCleanup:YES];
    }
    
    CCLabelBMFont *playScene1Label =
    [CCLabelBMFont labelWithString:@"Ole Awakes!"
                           fntFile:@"VikingSpeechFont64.fnt"];
    CCMenuItemLabel *playScene1 =
    [CCMenuItemLabel itemWithLabel:playScene1Label target:self
                          selector:@selector(playScene:)];
    [playScene1 setTag:1];

    CCLabelBMFont *backButtonLabel =
    [CCLabelBMFont labelWithString:@"Back"
                           fntFile:@"VikingSpeechFont64.fnt"];
    CCMenuItemLabel *backButton =
    [CCMenuItemLabel itemWithLabel:backButtonLabel target:self
                          selector:@selector(displayMainMenu)];
    
    sceneSelectMenu = [CCMenu menuWithItems:playScene1,backButton,nil];
    [sceneSelectMenu alignItemsVerticallyWithPadding:
     screenSize.height * 0.059f];
    [sceneSelectMenu setPosition:ccp(screenSize.width * 2,
                                     screenSize.height / 2)];
    
    id moveAction = [CCMoveTo actionWithDuration:0.5f
                                        position:ccp(screenSize.width * 0.75f,
                                                     screenSize.height/2)];
    id moveEffect = [CCEaseIn actionWithAction:moveAction rate:1.0f];
    [sceneSelectMenu runAction:moveEffect];
    [self addChild:sceneSelectMenu z:1 tag:kSceneMenuTagValue];
}

-(id)init {
    self = [super init];
    if (self != nil) {
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        
        CCSprite *background =
        [CCSprite spriteWithFile:@"MainMenuBackground.png"];
        [background setPosition:ccp(screenSize.width/2,
                                    screenSize.height/2)];
        [self addChild:background];
        [self displayMainMenu];
        
        CCSprite *viking =
        [CCSprite spriteWithFile:@"VikingFloating.png"];
        [viking setPosition:ccp(screenSize.width * 0.35f,
                                screenSize.height * 0.45f)];
        [self addChild:viking];
        
        id rotateAction = [CCEaseElasticInOut actionWithAction:
                           [CCRotateBy actionWithDuration:5.5f
                                                    angle:360]];
        
        id scaleUp = [CCScaleTo actionWithDuration:2.0f scale:1.5f];
        id scaleDown = [CCScaleTo actionWithDuration:2.0f scale:0.5f];
        
        [viking runAction:[CCRepeatForever actionWithAction:
                           [CCSequence
                            actions:scaleUp,scaleDown,nil]]];
        
        [viking runAction:
         [CCRepeatForever actionWithAction:rotateAction]];
    }
    return self;
}

@end