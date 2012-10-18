//
//  MainMenuScene.h
//  Maze
//
//  Created by ian on 7/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "MainMenuLayer.h"
#import "MainMenuSettingsLayer.h"

@interface MainMenuScene : CCScene {
    MainMenuLayer *mainMenuLayer;
    MainMenuSettingsLayer *mainMenuSettingsLayer;

}
@end
