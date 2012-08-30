//
//  GameManager.m
//  Maze
//
//  Created by ian on 7/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameManager.h"
#import "GameScene.h"
#import "MainMenuScene.h"
#import "CCTransition.h"

@implementation GameManager
static GameManager* _sharedGameManager = nil;                      
@synthesize isMusicON;
@synthesize isSoundEffectsON;
@synthesize hasPlayerDied;

+(GameManager*)sharedGameManager {
    @synchronized([GameManager class])                             
    {
        if(!_sharedGameManager)                                    
            [[self alloc] init];
        return _sharedGameManager;                                 
    }
    return nil;
}

+(id)alloc
{
@synchronized ([GameManager class])                            
{
    NSAssert(_sharedGameManager == nil,
    @"Attempted to allocate a second instance of the Game Manager singleton");                                               
    _sharedGameManager = [super alloc];
    
    return _sharedGameManager;                                 
}
return nil;
}
                 
-(id)init {                                                        
    self = [super init];
    if (self != nil) {
        // Game Manager initialized
        CCLOG(@"Game Manager Singleton, init");
        isMusicON = YES;
        isSoundEffectsON = YES;
        hasPlayerDied = NO;
        currentScene = kNoSceneUninitialized;
        
        statsKeeper = [StatsKeeper createSingleton];
        objectFactory = [ObjectFactory createSingleton];
        dataAdapter = [DataAdapter createSingleton];
    }
    return self;
}

-(void)dealloc
{
    [statsKeeper release];
    [objectFactory release];
    [dataAdapter release];
    [super dealloc];
}
           
-(void)runSceneWithID:(SceneTypes)sceneID {
    
    SceneTypes oldScene = currentScene;
    currentScene = sceneID;
    id sceneToRun = nil;
    switch (sceneID) {
        case kMainMenuScene:
            sceneToRun = [MainMenuScene node];
            break;
        case kOptionsScene:

            break;
        case kNormalLevel:
            if (oldScene == kBonusLevel || oldScene == kNormalLevel) {
                NSLog(@"game manager - moving to next level");
                [statsKeeper nextLevel];
                /*for debugging*/
                [dataAdapter printAllLevelStats];
            }
            sceneToRun = [GameScene node];
            break;
        default:
            CCLOG(@"Unknown ID, cannot switch scenes");
            return;
            break;
    }
    
    if (sceneToRun == nil) {
        // Revert back, since no new scene was found
        currentScene = oldScene;
        return;
    }
    
    // Menu Scenes have a value of < 100
    if (sceneID < 100) {
        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
            CGSize screenSize =
            [CCDirector sharedDirector].winSizeInPixels;
            if (screenSize.width == 960.0f) {
                // iPhone 4 Retina
                [sceneToRun setScaleX:0.9375f];
                [sceneToRun setScaleY:0.8333f];
                CCLOG(@"GM:Scaling for iPhone 4 (retina)");
                
            } else {
                [sceneToRun setScaleX:0.4688f];
                [sceneToRun setScaleY:0.4166f];
                CCLOG(@"GM:Scaling for iPhone 3G(non-retina)");
            }
        }
    }
    
    if ([[CCDirector sharedDirector] runningScene] == nil) {
        [[CCDirector sharedDirector] runWithScene:sceneToRun];
        
    } else {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFlipAngular transitionWithDuration:3 
                                                                                           scene:sceneToRun]];

    }
}

@end
                 
