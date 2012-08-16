//
//  EnemyObject.h
//  Maze
//
//  Created by ian on 8/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameObject.h"

@interface EnemyObject : GameObject
{
    
    NSMutableDictionary *objectInfo;

}

- (id)initWithSpriteFrame:(CCSpriteFrame *)frame AtLocation:(CGPoint)location;

@end
