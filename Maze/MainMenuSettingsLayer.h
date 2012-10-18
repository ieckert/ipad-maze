//
//  MainMenuSettingsLayer.h
//  Maze
//
//  Created by  on 10/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "GLES-Render.h"
#import "cocos2d.h"

#import "Constants.h"
#import "GameManager.h"
#import "DataAdapter.h"

@interface MainMenuSettingsLayer : CCLayer <UIAccelerometerDelegate>
{
    CCMenu *settingsMenu;
    DataAdapter *dataAdapter;
    
}


@end
