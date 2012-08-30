//
//  DoorObject.h
//  Maze
//
//  Created by ian on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameObject.h"

@interface DoorObject : GameObject
{
    NSMutableDictionary *objectInfo;
    
    CCAnimation *interactAnim;    
    CCAnimation *idleAnim;
            
}
@property (nonatomic, retain) CCAnimation *interactAnim;
@property (nonatomic, retain) CCAnimation *idleAnim;

- (id)initWithSpriteFrame:(CCSpriteFrame *)frame AtLocation:(CGPoint)location WithType:(GameObjectType)doorType;

@end
