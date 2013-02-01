//
//  ObjectBuilder.m
//  Maze
//
//  Created by ian on 1/24/13.
//
//

#import "ObjectBuilder.h"
#import "Pool.h"
#import "MazeObject.h"

@implementation ObjectBuilder
static ObjectBuilder *singleton = nil;

-(id) init {
    if( (self = [super init]) ){
        poolSizeLookup = [[NSMutableArray alloc] initWithCapacity:G_NUM_OBJECT_TYPES];
        objectCreationLookup = [[NSMutableArray alloc] initWithCapacity:G_NUM_OBJECT_TYPES];
        for (int i=0; i<G_NUM_OBJECT_TYPES; i++) {
            [poolSizeLookup addObject:[NSNumber numberWithInt:0]];
            [objectCreationLookup addObject:[NSNumber numberWithInt:0]];
        }

        [self buildObjectCreationLookup];
        [self buildPoolSizeLookup];
    }
    return self;
}

+ (ObjectBuilder *) createSingleton
{
    @synchronized(singleton) {
        if ( !singleton || singleton==nil ) {
            singleton = [[ObjectBuilder alloc] init];
        }
    }
    return singleton;
}

- (void) dealloc{
    [poolSizeLookup release];
    [objectCreationLookup release];
    [super dealloc];
}

-(void)buildPoolSizeLookup
{
    [poolSizeLookup replaceObjectAtIndex:G_MAZE withObject:[NSNumber numberWithInt:C_POOL_SIZE_MAZE]];
    [poolSizeLookup replaceObjectAtIndex:G_OBJET withObject:[NSNumber numberWithInt:C_POOL_SIZE_OBJECT]];
}

-(void)buildObjectCreationLookup
{
    [objectCreationLookup replaceObjectAtIndex:G_OBJET withObject:^{return [[GameObject alloc] init];}];
    [objectCreationLookup replaceObjectAtIndex:G_MAZE withObject:^{return [[MazeObject alloc] init];}];
    [objectCreationLookup replaceObjectAtIndex:G_PLAYER withObject:^{return nil;}];
    [objectCreationLookup replaceObjectAtIndex:G_ENEMY withObject:^{return nil;}];
    [objectCreationLookup replaceObjectAtIndex:G_ENEMY_SHOOTING withObject:^{return nil;}];
    [objectCreationLookup replaceObjectAtIndex:G_WALL withObject:^{return nil;}];
    [objectCreationLookup replaceObjectAtIndex:G_COIN withObject:^{return nil;}];
    [objectCreationLookup replaceObjectAtIndex:G_DOOR withObject:^{return nil;}];    
}

-(NSInteger)checkRange:(ObjectType)poolType
{
    return (poolType < 0 || poolType > G_NUM_OBJECT_TYPES) ? C_POOL_SIZE : [[poolSizeLookup objectAtIndex:poolType] integerValue];
}

-(Pool*) buildPool:(ObjectType)poolType
{
    NSInteger size = [self checkRange:poolType];
    return [[Pool alloc] initWithObjectType:poolType Size:size];
}

-(GameObject*)buildObject:(ObjectType)objectType
{
    GameObject* (^objectCreation)(ObjectType) = [objectCreationLookup objectAtIndex:objectType];
    return objectCreation(objectType);
}

@end