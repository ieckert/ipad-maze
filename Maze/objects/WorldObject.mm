//
//  WorldObject.m
//  Maze
//
//  Created by ian on 1/27/13.
//
//

#import "WorldObject.h"

@implementation WorldObject
static WorldObject *singleton = nil;

- (id)init
{
    if (self = [super init]) {
        [self setupWorld];
        [self setupDebugDraw];
    }
    return self;
}

+ (WorldObject *) createSingleton
{
    @synchronized(singleton) {
        if ( !singleton || singleton==nil ) {
            singleton = [[WorldObject alloc] init];
        }
    }
    return singleton;
}

-(void)dealloc
{
    // in case you have something to dealloc, do it in this method
	delete world;
	world = NULL;
	
	delete m_debugDraw;
    [super dealloc];
}

-(b2World *)getWorld
{
    return world;
}

- (void)setupWorld {
    b2Vec2 gravity = b2Vec2(0.0f, -10.0f);
    bool doSleep = false;
    world = new b2World(gravity, doSleep);
    world->SetContinuousPhysics(true);
}

-(void)setupDebugDraw
{
    // Debug Draw functions
    m_debugDraw = new GLESDebugDraw( PTM_RATIO );
    world->SetDebugDraw(m_debugDraw);
    
    uint32 flags = 0;
    flags += b2DebugDraw::e_shapeBit;
    //		flags += b2DebugDraw::e_jointBit;
    //		flags += b2DebugDraw::e_aabbBit;
    //		flags += b2DebugDraw::e_pairBit;
    //		flags += b2DebugDraw::e_centerOfMassBit;
    m_debugDraw->SetFlags(flags);    
}

@end
