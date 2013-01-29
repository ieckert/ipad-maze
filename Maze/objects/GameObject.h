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
#import "WorldObject.h"

@interface GameObject : CCSprite {
    b2Body *body;
    WorldObject *worldObject;
    
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

-(CCAnimation*)loadPlistForAnimationWithName:(NSString*)animationName
                                andClassName:(NSString*)className;
-(void)updateStateWithDeltaTime:(ccTime)deltaTime
           andListOfGameObjects:(CCArray*)listOfGameObjects;
-(CGRect)adjustedBoundingBox;

/*Location*/

/*Visual*/
-(void)activate;
-(void)deactivate;
-(void)changeSkin:(NSString*)image;
-(void)show;
-(void)hide;

/*Data*/
-(void)removeFromPool;
-(void)printDebugStats;


@end
