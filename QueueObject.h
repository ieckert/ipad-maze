//
//  AnimationContainer.h
//  Maze
//
//  Created by ian on 8/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameObject.h"

@interface QueueObject : GameObject
{
    QueueObject *m_next;
    id object;
}

@property (readwrite, retain) QueueObject *m_next;
@property (readwrite, retain) id object;
@end
