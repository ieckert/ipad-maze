//
//  Pool.m
//  Maze
//
//  Created by ian on 1/22/13.
//
//

#import "Pool.h"

@implementation Pool

@synthesize poolType;

-(id)initWithList:(NSString *)list Image:(NSString *)image ObjectType:(ObjectType)objectType Size:(NSInteger)size;
{
    if( (self = [super init]) ){
        activeObjects = [[NSMutableArray alloc] init];
        inactiveObjects = [[NSMutableArray alloc] init];
        objectBuilder = [ObjectBuilder createSingleton];
        poolType = objectType;
        [self setAtlasList:list AndAtlasImage:image AndRebuildObjects:size];
    }
    return self;
}

-(id)initWithObjectType:(ObjectType)objectType Size:(NSInteger)size;
{
    if( (self = [super init]) ){
        return [self initWithList:C_ATLAS_IMAGE_DEFAULT
                            Image:C_ATLAS_LIST_DEFAULT
                   ObjectType:objectType
                             Size:size];
    }
    return self;
}

-(id) init {
    if( (self = [super init]) ){
        return [self initWithList:C_ATLAS_IMAGE_DEFAULT
                            Image:C_ATLAS_LIST_DEFAULT
                       ObjectType:G_OBJET
                             Size:C_POOL_SIZE];
    }
    return self;
}

- (void) dealloc {
    [activeObjects release];
    [inactiveObjects release];
    [self emptyPool];
    [super dealloc];
}

-(void)printStats
{
    NSLog(@"Pool: \n\t image: %@ \n\t list: %@ \n\t active: %d \n\t inactive: %d \n\t total:%d", p_atlasImage, p_atlasList, [self countActiveObjects], [self countInactiveObjects], [self countAllObjects] );
}

-(void)buildObjects:(NSInteger)count
{
    while (count--) {
        [self buildObject];
    }
}

-(GameObject *)buildObject
{
    GameObject *r_object = [objectBuilder buildObject:poolType];
    [p_spriteBatchNode addChild:r_object];
    [inactiveObjects addObject:r_object];
    return r_object;
}

-(void)setAtlasList:(NSString*)list AndAtlasImage:(NSString*)image AndRebuildObjects:(NSInteger)count
{
    [self emptyPool];
    p_atlasList = list;
    p_atlasImage = image;
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"atlas1.plist"];
    p_spriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"atlas1.png" capacity:C_BATCH_NODE_CAPACITY];
    [self buildObjects:count];
}

-(void)emptyPool
{
    [p_spriteBatchNode removeAllChildrenWithCleanup:TRUE];
}

-(NSInteger)countActiveObjects
{
    return [activeObjects count];
}

-(NSInteger)countInactiveObjects
{
    return [inactiveObjects count];
}

-(NSInteger)countAllObjects
{
    return [[p_spriteBatchNode children] count];
}

-(CCArray *)getActiveObjects
{
    return [CCArray arrayWithNSArray:activeObjects];
}

-(GameObject *)getObject
{
    GameObject *r_object = nil;
    for (GameObject *object in inactiveObjects) {
        r_object = object;
    }
    if (r_object == nil)
        r_object = [self buildObject];
    
    [activeObjects addObject:r_object];
    [inactiveObjects removeObject:r_object];
    return r_object;
}

-(CCSpriteBatchNode *)getBatchNode
{
    return p_spriteBatchNode;
}

-(BOOL)returnObject:(GameObject**)gameObject
{
    BOOL r_return = FALSE;
    [(*gameObject) deactivate];
    [inactiveObjects addObject:*gameObject];
    [activeObjects removeObject:*gameObject];
    if ([inactiveObjects containsObject:*gameObject] && ![activeObjects containsObject:*gameObject])
        r_return = TRUE;
    *gameObject = nil;
    return r_return;
}

@end
