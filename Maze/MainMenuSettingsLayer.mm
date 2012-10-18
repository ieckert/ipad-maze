//
//  MainMenuSettingsLayer.m
//  Maze
//
//  Created by  on 10/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainMenuSettingsLayer.h"

@implementation MainMenuSettingsLayer

-(void) screenRotationTapped: (id) sender
{
	NSLog(@"Settings - ScreenRotation button tapped!");
}

-(void)displayMainMenu {
    if (settingsMenu != nil) {
        [settingsMenu removeFromParentAndCleanup:YES];
    }
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    CCMenuItemFont *screenRotation1 = [CCMenuItemFont itemFromString:@"Left" target:nil selector:nil];
    CCMenuItemFont *screenRotation2 = [CCMenuItemFont itemFromString:@"Right" target:nil selector:nil];
    CCMenuItemFont *screenRotation3 = [CCMenuItemFont itemFromString:@"Up" target:nil selector:nil];
    CCMenuItemFont *screenRotation4 = [CCMenuItemFont itemFromString:@"Down" target:nil selector:nil];
    
    CCMenuItemToggle *screenRotationToggle = [CCMenuItemToggle itemWithTarget:self
                                                                selector:@selector(screenRotationTapped:)
                                                                   items:screenRotation1, screenRotation2, screenRotation3, screenRotation4, nil];

    
    settingsMenu = [CCMenu
                menuWithItems:screenRotationToggle, nil];
    [settingsMenu alignItemsVerticallyWithPadding:
     screenSize.height * 0.059f];
    [settingsMenu setPosition:
     ccp(screenSize.width * 2,
         screenSize.height / 2)];
    id moveAction =
    [CCMoveTo actionWithDuration:1.2f
                        position:ccp(screenSize.width * 0.85f,
                                     screenSize.height/2)];
    id moveEffect = [CCEaseIn actionWithAction:moveAction rate:1.0f];
    [settingsMenu runAction:moveEffect];
    [self addChild:settingsMenu z:0 tag:kMainMenuTagValue];
}

-(void) onEnterTransitionDidFinish {
    NSLog(@"Settings - in onEnterTransitionDidFinish");
    [self displayMainMenu];
    
    
}

-(id) init {
    self = [super init];
    if (self != nil) {
        NSLog(@"Settings - in init");
        
        dataAdapter = [DataAdapter createSingleton];        
    }
    return self;
}

@end
