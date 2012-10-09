//
//  SpecialArea.h
//  Maze
//
//  Created by  on 10/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameObject.h"
#import "MazeMaker.h"
#import "MazeInterface.h"

@interface SpecialArea : GameObject
{
    
    CCAnimation *activeAnim;
    NSInteger activeAnimDuration;
    NSInteger activeAnimDurationMax;
    NSInteger activeAnimDurationMin;
    
    CCAnimation *chargingAnim;
    NSInteger chargingAnimDuration;
    NSInteger chargingAnimDurationMax;
    NSInteger chargingAnimDurationMin;
    
    b2World *world;
    
    MazeInterface *mazeInterface;

//shit i dont think im using goes here:
    MazeMaker *handleOnMaze;

}
@property (readwrite) NSInteger chargingAnimDurationMax;
@property (readwrite) NSInteger chargingAnimDurationMin;
@property (readwrite) NSInteger activeAnimDurationMax;
@property (readwrite) NSInteger activeAnimDurationMin;
@property (nonatomic, retain) CCAnimation *activeAnim;
@property (nonatomic, retain) CCAnimation *chargingAnim;


- (id)initWithWorld:(b2World *)theWorld 
         atLocation:(CGPoint)location 
    withSpriteFrame:(CCSpriteFrame *)frame
      WithKnowledgeOfMaze:(MazeMaker*)maze;

- (void)changeLocation;

@end
