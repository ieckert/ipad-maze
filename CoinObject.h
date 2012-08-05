//
//  CoinObject.h
//  Maze
//
//  Created by ian on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameObject.h"

@interface CoinObject : GameObject
{
    NSMutableDictionary *objectInfo;
    CCAnimation *spinningAnim;
    CCAnimation *capturedAnim;
    CCAnimation *removingAnim;

    CCAnimation *idleAnim;
    
    GameObject *ballCharacter;
    
    NSDictionary *coinInfo;
    
}
@property (nonatomic, retain) CCAnimation *spinningAnim;
@property (nonatomic, retain) CCAnimation *capturedAnim;
@property (nonatomic, retain) CCAnimation *idleAnim;
@property (nonatomic, retain) CCAnimation *removingAnim;

- (id)initWithSpriteFrame:(CCSpriteFrame *)frame AtLocation:(CGPoint)location;

@end
