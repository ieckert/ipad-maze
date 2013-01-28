//
//  WorldObject.h
//  Maze
//
//  Created by ian on 1/27/13.
//
//

#import <Foundation/Foundation.h>
#import "Box2D.h"
#import "Constants.h"
#import "GLES-Render.h"

@interface WorldObject : NSObject
{
    b2World *world;
    GLESDebugDraw *m_debugDraw;

}
+(WorldObject *) createSingleton;

-(b2World *)getWorld;

@end
