//
//  PoolManager.h
//  Maze
//
//  Created by ian on 1/22/13.
//
//

#import <Foundation/Foundation.h>
#import "Pool.h"
#import "Constants.h"
#import "ObjectBuilder.h"

@interface PoolManager : NSObject
{
    NSMutableArray *pools;
    ObjectBuilder *objectBuilder;
}
+(PoolManager *) createSingleton;

-(void)printPoolStats:(ObjectType)type;
-(void)printAllPoolStats;

-(GameObject*)getObject:(ObjectType)objectType;                         //get an inactive object to use
-(void)buildObjects:(NSInteger)count OfType:(ObjectType)objectType;     //build more objects to be held in a pool
-(BOOL)returnObject:(GameObject**)gameObject;                           //move an "active" object to "inactive"

-(Pool*)getPool:(ObjectType)objectType;
-(CCArray *)getActiveObjects;
-(NSMutableArray *)getAllBatchNodes;

-(NSInteger)countPools;
-(NSInteger)countAllObjectsInPool:(ObjectType)type;
-(NSInteger)countActiveObjectsInPool:(ObjectType)type;
-(NSInteger)countInactiveObjectsInPool:(ObjectType)type;

-(void)emptyPools;

@end
