//
//  PoolManager.m
//  Maze
//
//  Created by ian on 1/22/13.
//
//

#import "PoolManager.h"
#import "ObjectBuilder.h"

@implementation PoolManager

-(id) init {
    if( (self = [super init]) ){
        pools = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) dealloc{
    [pools release];
    [super dealloc];
}

-(void)printPoolStats:(ObjectType)type
{
    for (Pool* pool in pools) {
        if (pool.poolType == type) {
            [pool printStats];
            return;
        }
    }
}

-(void)printAllPoolStats
{
    for (Pool* pool in pools) {
        [pool printStats];
    }
}

-(Pool*)buildPool:(ObjectType)objectType
{
    return [ObjectBuilder buildPool:objectType];
}

-(void)buildObjects:(NSInteger)count OfType:(ObjectType)objectType;
{
    Pool *pool = [self getPool:objectType];
    [pool buildObjects:count];
}

-(GameObject*)getObject:(ObjectType)objectType
{
    Pool *pool = [self getPool:objectType];
    return [pool getObject];
}

-(CCArray *)getActiveObjects
{
    
}

-(BOOL)returnObject:(GameObject**)gameObject;
{
    BOOL r_return = FALSE;
    Pool* pool = [self getPool:(*gameObject).type];
    r_return = [pool returnObject:gameObject];
    return r_return;
}

-(Pool*)getPool:(ObjectType)objectType;
{
    Pool *r_pool = nil;
    for (Pool* pool in pools) {
        if (pool.poolType == objectType) {
            r_pool = pool;
            break;
        }
    }
    
    if (r_pool == nil) {
        r_pool = [self buildPool:objectType];
        [pools addObject:r_pool];
    }
    return r_pool;
}

-(NSInteger)countPools
{
    return [pools count];
}

-(NSInteger)countActiveObjectsInPool:(ObjectType)type
{
    NSInteger r_size = 0;
    Pool *pool = [self getPool:type];
    if (pool != nil)
        r_size = [pool countActiveObjects];
    return r_size;
}

-(NSInteger)countInactiveObjectsInPool:(ObjectType)type
{
    NSInteger r_size = 0;
    Pool *pool = [self getPool:type];
    if (pool != nil)
        r_size = [pool countInactiveObjects];
    return r_size;
}

-(NSInteger)countAllObjectsInPool:(ObjectType)type
{
    NSInteger r_size = 0;
    Pool *pool = [self getPool:type];
    if (pool != nil)
        r_size = [pool countAllObjects];
    return r_size;
}

-(void)fillPools
{
    for (Pool* pool in pools) {
        [pool fillPool];
    }
}

-(void)emptyPools
{
    for (Pool* pool in pools) {
        [pool emptyPool];
    }
}

@end
