//
//  GameObject.h
//  Maze
//
//  Created by ian on 1/21/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "Constants.h"

@interface GameObject : CCSprite {
    b2Body *body;
    
    /*Location*/
    
    /*Visual*/
    BOOL active;
    
    /*Data*/
    ObjectType type;
    NSInteger health;
}
@property (assign) b2Body *body;
@property (readwrite) ObjectType type;
@property (readwrite) NSInteger health;

/*Location*/
-(void)placeAtLocation:(CGPoint)location;

/*Visual*/
-(void)changeSkin;
-(void)display;
-(void)removeFromDisplay;

/*Data*/
-(void)removeFromPool;
-(void)printDebugStats;


@end
