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
    CCAnimation *spinningAnim;
    CCAnimation *capturedAnim;
    CCAnimation *removingAnim;

    CCAnimation *idleAnim;
    
    GameObject *ballCharacter;
    
}
@property (nonatomic, retain) CCAnimation *spinningAnim;
@property (nonatomic, retain) CCAnimation *capturedAnim;
@property (nonatomic, retain) CCAnimation *idleAnim;
@property (nonatomic, retain) CCAnimation *removingAnim;


@end
